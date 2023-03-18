import 'dart:developer';
import 'package:bili_you/common/api/reply_api.dart';
import 'package:bili_you/common/models/local/reply/reply_info.dart';
import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/values/cache_keys.dart';
import 'package:bili_you/pages/user_space/view.dart';
import 'package:easy_refresh/easy_refresh.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/widgets/reply_item.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/widgets/reply_reply_page.dart';

class ReplyController extends GetxController {
  ReplyController({required this.bvid, required this.pauseVideoCallback});
  String bvid;
  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  ScrollController scrollController = ScrollController();
  List<Widget> replyList = <Widget>[];
  int pageNum = 1;
  RxString sortTypeText = "按热度".obs;
  RxString sortInfoText = "热门评论".obs;
  ReplySort _replySort = ReplySort.like;
  final Function() pauseVideoCallback;

  //切换排列方式
  void toggleSort() {
    if (_replySort == ReplySort.like) {
      sortTypeText.value = "按时间";
      sortInfoText.value = "最新评论";
      //切换为按时间排列
      _replySort = ReplySort.time;
    } else {
      sortTypeText.value = "按热度";
      sortInfoText.value = "热门评论";
      //切换为按热度排列
      _replySort = ReplySort.like;
    }
    //刷新评论
    refreshController.callRefresh();
  }

//添加评论条目到控件列表
  addReplyItemWidget(List<Widget> list, ReplyInfo replyInfo, ReplyItem i,
      {bool frontDivider = true, bool isTop = false}) {
    Widget? subReplies;
    if (frontDivider) {
      list.add(Divider(
        color: Theme.of(Get.context!).colorScheme.secondaryContainer,
        thickness: 1,
      ));
    }
    if (i.preReplies.isNotEmpty) {
      List<Widget> preSubReplies = []; //预显示在外的楼中楼
      for (var j in i.preReplies) {
        //添加预显示在外楼中楼评论条目
        preSubReplies.add(Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${j.member.name}: ",
                  ),
                  ReplyItemWidget.buildReplyItemContent(j.content)
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )));
      }
      //预显示在外楼中楼控件
      subReplies = Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(Get.context!).colorScheme.surfaceVariant),
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: GestureDetector(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: preSubReplies,
            ),
            onTap: () {
              //楼中楼点击后弹出详细楼中楼
              Get.bottomSheet(
                  ReplyReplyPage(
                    bvid: i.oid.toString(),
                    rootId: i.rpid,
                    pauseVideoCallback: pauseVideoCallback,
                  ),
                  backgroundColor: Theme.of(Get.context!).cardColor,
                  clipBehavior: Clip.antiAlias);
            },
          ));
    }
    //添加评论条目
    list.add(ReplyItemWidget(
      face: i.member.avatarUrl,
      name: i.member.name,
      content: i.content,
      like: i.likeCount,
      timeStamp: i.replyTime,
      bottomWidget: subReplies,
      location: i.location,
      isTop: isTop,
      tags: i.tags,
      isUp: i.member.mid == replyInfo.upperMid,
      onTapUser: (context) {
        pauseVideoCallback();
        Get.to(
          () => UserSpacePage(mid: i.member.mid),
        );
      },
    ));
  }

//加载评论区控件条目
  Future<bool> _addReplyItems() async {
    late ReplyInfo replyInfo;
    try {
      replyInfo = await ReplyApi.getReply(
          oid: bvid, pageNum: pageNum, type: ReplyType.video, sort: _replySort);
    } catch (e) {
      log("评论区加载失败,_addReplyItems:$e");
      return false;
    }
    if (replyList.isEmpty) {
      //当第一次时
      //添加排列方式按钮
      replyList.add(
        Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Obx(
                  () => Text(
                      "${sortInfoText.value} ${StringFormatUtils.numFormat(replyInfo.replyCount)}"),
                )),
            const Spacer(),
            //排列方式按钮
            MaterialButton(
              child: Row(
                children: [
                  Icon(Icons.sort_rounded,
                      size: 16, color: Get.textTheme.bodyMedium!.color),
                  Obx(
                    () => Text(
                      sortTypeText.value,
                      style: TextStyle(color: Get.textTheme.bodyMedium!.color),
                    ),
                  )
                ],
              ),
              //点击切换评论排列方式
              onPressed: () {
                toggleSort();
              },
            ),
          ],
        ),
      );
      //添加置顶评论
      for (var i in replyInfo.topReplies) {
        addReplyItemWidget(replyList, replyInfo, i,
            frontDivider: false, isTop: true);
      }
    }
    //添加普通评论
    for (var i in replyInfo.replies) {
      addReplyItemWidget(replyList, replyInfo, i,
          frontDivider: replyList.length != 1);
    }
    pageNum++;
    return true;
  }

  //评论区刷新中
  onReplyRefresh() async {
    pageNum = 1;
    replyList.clear();
    // update(["reply"]);
    await _addReplyItems().then((value) {
      if (value) {
        refreshController.finishRefresh();
      } else {
        refreshController.finishRefresh(IndicatorResult.fail);
      }
      update(["reply"]);
    });
  }

  //评论加载中
  onReplyLoad() async {
    await _addReplyItems().then((value) {
      if (value) {
        refreshController.finishLoad();
        refreshController.resetFooter();
      } else {
        refreshController.finishLoad(IndicatorResult.fail);
      }
      update(["reply"]);
    });
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onClose() {
    //清理其他用户头像的缓存
    CacheManager(Config(CacheKeys.othersFaceKey)).emptyCache();
    super.onClose();
  }
}
