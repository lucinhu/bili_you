import 'dart:developer';

import 'package:bili_you/common/api/video_reply_api.dart';
import 'package:bili_you/common/models/reply/reply.dart';
import 'package:easy_refresh/easy_refresh.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bili_you/common/models/reply/reply_item.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/widgets/reply_item.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/widgets/reply_reply_page.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReplyController extends GetxController {
  ReplyController({required this.bvid});
  final String bvid;
  // RefreshController refreshController = RefreshController(initialRefresh: true);
  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  ReplyModel? replyResponse;
  List<Widget> replyList = <Widget>[];
  int pageNum = 1;

  _initData() {
    update(["reply"]);
  }

//添加评论条目到控件列表
  addReplyItemWidget(List<Widget> list, ReplyItemModel i,
      {bool isTop = false}) {
    Widget? subReplies;
    if (replyList.isNotEmpty || list.isNotEmpty) {
      list.add(Divider(
        color: Theme.of(Get.context!).colorScheme.secondaryContainer,
        thickness: 1,
      ));
    }
    if (i.replies.isNotEmpty) {
      List<Widget> preSubReplies = []; //预显示在外的楼中楼
      for (var j in i.replies) {
        //添加预显示在外楼中楼评论条目
        preSubReplies.add(Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${j.member.uname}: ",
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
                  ReplyReplyPage(bvid: i.oid.toString(), rootId: i.rpid),
                  backgroundColor: Theme.of(Get.context!).cardColor,
                  clipBehavior: Clip.antiAlias);
            },
          ));
    }
    //添加评论条目
    list.add(ReplyItemWidget(
      face: i.member.avatar,
      name: i.member.uname,
      content: i.content,
      like: i.like,
      timeStamp: i.ctime,
      bottomWidget: subReplies,
      location: i.replyControl.location,
      isTop: isTop,
      cardLabels: i.cardLabel,
      isUp: int.parse(i.member.mid) == replyResponse!.data.upper.mid,
    ));
  }

//加载评论区控件条目
  Future<bool> _addReplyItems() async {
    try {
      replyResponse =
          await VideoReplyApi.requestVideoReply(bvid: bvid, pageNum: pageNum);

      if (replyResponse!.code != 0) {
        log(replyResponse!.code.toString());
        log(replyResponse!.message);
        return false;
      }
      if (pageNum <= replyResponse!.data.page.count) {
        if (replyList.isEmpty) {
          //当第一次时
          //添加置顶评论(如果有的话)
          for (var i in replyResponse!.data.topReplies) {
            addReplyItemWidget(replyList, i, isTop: true);
          }
        }
        //添加常规评论
        for (var i in replyResponse!.data.replies) {
          addReplyItemWidget(
            replyList,
            i,
          );
        }
        pageNum++;
      }
      return true;
    } catch (e) {
      log("评论区加载失败${e.toString()}");
      return false;
    }
  }

  //评论区刷新中
  onReplyRefresh() async {
    pageNum = 1;
    replyList.clear();
    update(["reply"]);
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
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
