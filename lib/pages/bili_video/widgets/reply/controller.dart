import 'dart:developer';
import 'package:bili_you/common/api/reply_api.dart';
import 'package:bili_you/common/models/local/reply/reply_info.dart';
import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/values/cache_keys.dart';
import 'package:easy_refresh/easy_refresh.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/widgets/reply_item.dart';

class ReplyController extends GetxController {
  ReplyController(
      {required this.bvid,
      required this.replyType,
      required this.pauseVideoCallback});
  String bvid;
  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  ScrollController scrollController = ScrollController();
  List<Widget> replyList = <Widget>[];
  int pageNum = 1;
  final ReplyType replyType;
  RxString sortTypeText = "按热度".obs;
  RxString sortInfoText = "热门评论".obs;
  ReplySort _replySort = ReplySort.like;
  final Function()? pauseVideoCallback;

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
    //添加评论条目
    list.add(Column(
      children: [
        if (frontDivider)
          Divider(
            color: Theme.of(Get.context!).colorScheme.secondaryContainer,
            thickness: 1,
          ),
        ReplyItemWidget(
          reply: i,
          isTop: isTop,
          isUp: i.member.mid == replyInfo.upperMid,
          pauseVideoPlayer: pauseVideoCallback,
          officialVerifyType: i.member.officialVerify.type,
        ),
      ],
    ));
  }

//加载评论区控件条目
  Future<bool> _addReplyItems() async {
    late ReplyInfo replyInfo;
    try {
      replyInfo = await ReplyApi.getReply(
          oid: bvid, pageNum: pageNum, type: replyType, sort: _replySort);
    } catch (e) {
      log("评论区加载失败,_addReplyItems:$e");
      return false;
    }
    //如果评论控件条数将会多于评论总数的话，说明有重复的，就删除重复项
    if ((replyList.length -
            1 -
            replyInfo.topReplies.length +
            replyInfo.replies.length) >
        replyInfo.replyCount) {
      int n = (replyList.length -
              1 -
              replyInfo.topReplies.length +
              replyInfo.replies.length) -
          replyInfo.replyCount;
      replyInfo.replies.removeRange(0, n);
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
    //更新页码并刷新页面
    //如果当前页不为空的话，下一次加载就进入下一页
    if (replyInfo.replies.isNotEmpty) {
      pageNum++;
    } else {
      //如果为空的话，下一次加载就返回上一页
      pageNum--;
    }
    return true;
  }

  //评论区刷新中
  onReplyRefresh() async {
    pageNum = 1;
    replyList.clear();
    await _addReplyItems().then((value) {
      if (value) {
        refreshController.finishRefresh();
      } else {
        refreshController.finishRefresh(IndicatorResult.fail);
      }
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
    //清理评论图缓存
    CacheManager(Config(CacheKeys.replyImageKey)).emptyCache();
    super.onClose();
  }
}
