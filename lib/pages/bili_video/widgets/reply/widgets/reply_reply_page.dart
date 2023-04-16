import 'dart:developer';

import 'package:bili_you/common/api/reply_api.dart';
import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:bili_you/common/models/local/reply/reply_reply_info.dart';
import 'package:bili_you/common/widget/simple_easy_refresher.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/widgets/reply_item.dart';
import 'package:easy_refresh/easy_refresh.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplyReplyPage extends StatefulWidget {
  const ReplyReplyPage({
    super.key,
    required this.replyId,
    required this.rootId,
    required this.replyType,
    required this.pauseVideoCallback,
  });
  final String replyId;
  final int rootId;
  final ReplyType replyType;
  final Function() pauseVideoCallback;

  @override
  State<ReplyReplyPage> createState() => _ReplyReplyPageState();
}

class _ReplyReplyPageState extends State<ReplyReplyPage>
    with AutomaticKeepAliveClientMixin {
  int _pageNum = 1;
  final EasyRefreshController _refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  Widget _rootReply = const SizedBox();
  final List<Widget> _replyReplies = [];
  Future<bool> _addReplyReply() async {
    late ReplyReplyInfo replyReplyInfo;
    try {
      replyReplyInfo = await ReplyApi.getReplyReply(
          type: widget.replyType,
          oid: widget.replyId,
          rootId: widget.rootId,
          pageNum: _pageNum);
    } catch (e) {
      log("_addReplyReply:$e");
      return false;
    }
    _rootReply = Column(
      children: [
        ReplyItemWidget(
          hasFrontDivider: false,
          reply: replyReplyInfo.rootReply,
          isUp: replyReplyInfo.rootReply.member.mid == replyReplyInfo.upperMid,
          pauseVideoPlayer: widget.pauseVideoCallback,
          showPreReply: false,
          officialVerifyType:
              replyReplyInfo.rootReply.member.officialVerify.type,
        ),
        Divider(
          color: Theme.of(Get.context!).colorScheme.primaryContainer,
          thickness: 2,
        )
      ],
    );
    //更新页码
    //如果当前页不为空的话，下一次加载就进入下一页
    if (replyReplyInfo.replies.isNotEmpty) {
      _pageNum++;
    } else {
      //如果为空的话，下一次加载就返回上一页
      _pageNum--;
    }
    //删除重复项
    final int minIndex = _replyReplies.length -
        replyReplyInfo
            .replies.length; //必须要先求n,因为replyReplyInfo.replies是动态删除的,长度会变
    for (var i = _replyReplies.length - 1; i >= minIndex; i--) {
      if (i < 0) break;
      if (_replyReplies[i] is! ReplyItemWidget) break;
      replyReplyInfo.replies.removeWhere((element) {
        if (element.rpid == (_replyReplies[i] as ReplyItemWidget).reply.rpid) {
          log('same${replyReplyInfo.replies.length}');
          return true;
        } else {
          return false;
        }
      });
    }
    //添加评论
    for (var i in replyReplyInfo.replies) {
      _replyReplies.add(ReplyItemWidget(
        hasFrontDivider: _replyReplies.isNotEmpty,
        reply: i,
        isUp: i.member.mid == replyReplyInfo.upperMid,
        pauseVideoPlayer: widget.pauseVideoCallback,
        showPreReply: false,
        officialVerifyType: i.member.officialVerify.type,
      ));
    }
    return true;
  }

  _onLoad() async {
    if (await _addReplyReply()) {
      _refreshController.finishLoad();
      _refreshController.resetFooter();
    } else {
      _refreshController.finishLoad(IndicatorResult.fail);
    }
  }

  _onRefresh() async {
    _replyReplies.clear();
    _pageNum = 1;

    if (await _addReplyReply()) {
      _refreshController.finishRefresh();
    } else {
      _refreshController.finishRefresh(IndicatorResult.fail);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SimpleEasyRefresher(
      easyRefreshController: _refreshController,
      onLoad: _onLoad,
      onRefresh: _onRefresh,
      childBuilder: (context, physics) => ListView.builder(
        physics: physics,
        itemCount: _replyReplies.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _rootReply,
            );
          }
          return _replyReplies[index - 1];
        },
        clipBehavior: Clip.antiAlias,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
