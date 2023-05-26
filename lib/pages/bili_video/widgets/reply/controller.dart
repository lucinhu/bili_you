import 'dart:developer';
import 'package:bili_you/common/api/reply_api.dart';
import 'package:bili_you/common/models/local/reply/reply_info.dart';
import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/add_reply_util.dart';
import 'package:easy_refresh/easy_refresh.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplyController extends GetxController {
  ReplyController({
    required this.bvid,
    required this.replyType,
  });
  String bvid;
  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  ScrollController scrollController = ScrollController();
  List<ReplyItem> replyItems = [];
  List<ReplyItem> topReplyItems = [];
  List<ReplyItem> newReplyItems = []; //新增的评论
  int upperMid = 0;
  int replyCount = 0;
  int pageNum = 1;
  final ReplyType replyType;
  RxString sortTypeText = "按热度".obs;
  RxString sortInfoText = "热门评论".obs;
  ReplySort _replySort = ReplySort.like;
  Function()? updateWidget;

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

//加载评论区控件条目
  Future<bool> _addReplyItems() async {
    late ReplyInfo replyInfo;
    try {
      replyInfo = await ReplyApi.getReply(
          oid: bvid, pageNum: pageNum, type: replyType, sort: _replySort);
      replyCount = replyInfo.replyCount;
      upperMid = replyInfo.upperMid;
    } catch (e) {
      log("评论区加载失败,_addReplyItems:$e");
      return false;
    }
    //更新页码
    //如果当前页不为空的话，下一次加载就进入下一页
    if (replyInfo.replies.isNotEmpty) {
      pageNum++;
    } else {
      //如果为空的话，下一次加载就返回上一页
      pageNum--;
    }
    //删除重复项
    final int minIndex = replyItems.length -
        replyInfo.replies.length; //必须要先求n,因为replyInfo.replies是动态删除的,长度会变
    for (var i = replyItems.length - 1; i >= minIndex; i--) {
      if (i < 0) break;
      replyInfo.replies.removeWhere((element) {
        if (element.rpid == replyItems[i].rpid) {
          log('same${replyInfo.replies.length}');
          return true;
        } else {
          return false;
        }
      });
    }
    if (topReplyItems.isEmpty) {
      topReplyItems.addAll(replyInfo.topReplies);
    }
    replyItems.addAll(replyInfo.replies);
    return true;
  }

  //评论区刷新中
  onReplyRefresh() async {
    pageNum = 1;
    replyItems.clear();
    newReplyItems.clear();
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
    newReplyItems.clear();
    await _addReplyItems().then((value) {
      if (value) {
        refreshController.finishLoad();
        refreshController.resetFooter();
      } else {
        refreshController.finishLoad(IndicatorResult.fail);
      }
    });
  }

  showAddReplySheet() async {
    await AddReplyUtil.showAddReplySheet(
        replyType: replyType,
        oid: bvid,
        newReplyItems: newReplyItems,
        updateWidget: updateWidget,
        scrollController: scrollController);
  }
}
