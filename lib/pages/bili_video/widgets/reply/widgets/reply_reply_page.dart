import 'dart:developer';

import 'package:bili_you/common/api/reply_api.dart';
import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:bili_you/common/models/local/reply/reply_reply_info.dart';
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
  final ValueNotifier<int> _pageNum = ValueNotifier<int>(1);
  final EasyRefreshController _refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  late Widget _rootReply;
  final List<Widget> _replyReplies = [];
  Future<bool> _addReplyReply() async {
    late ReplyReplyInfo replyReplyInfo;
    try {
      replyReplyInfo = await ReplyApi.getReplyReply(
          type: widget.replyType,
          oid: widget.replyId,
          rootId: widget.rootId,
          pageNum: _pageNum.value);
    } catch (e) {
      log("_addReplyReply:$e");
      return false;
    }
    _rootReply = ReplyItemWidget(
      reply: replyReplyInfo.rootReply,
      isUp: replyReplyInfo.rootReply.member.mid == replyReplyInfo.upperMid,
      pauseVideoPlayer: widget.pauseVideoCallback,
      showPreReply: false,
    );
    for (var i in replyReplyInfo.replies) {
      if (_replyReplies.isEmpty) {
        _replyReplies.add(Divider(
          color: Theme.of(Get.context!).colorScheme.primaryContainer,
          thickness: 2,
        ));
      } else {
        _replyReplies.add(Divider(
          color: Theme.of(Get.context!).colorScheme.secondaryContainer,
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ));
      }

      _replyReplies.add(ReplyItemWidget(
        reply: i,
        isUp: i.member.mid == replyReplyInfo.upperMid,
        pauseVideoPlayer: widget.pauseVideoCallback,
        showPreReply: false,
      ));
    }
    _pageNum.value++;
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
    _pageNum.value = 1;

    if (await _addReplyReply()) {
      _refreshController.finishRefresh();
    } else {
      _refreshController.finishLoad(IndicatorResult.fail);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _addReplyReply(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ValueListenableBuilder(
            valueListenable: _pageNum,
            builder: (context, value, child) {
              return EasyRefresh.builder(
                onLoad: _onLoad,
                onRefresh: _onRefresh,
                header: const MaterialHeader(),
                footer: const ClassicFooter(
                  processedDuration: Duration.zero,
                  safeArea: false,
                  showMessage: false,
                  processingText: "加载中...",
                  processedText: "加载成功",
                  readyText: "加载中...",
                  armedText: "释放以加载更多",
                  dragText: "上拉加载",
                  failedText: "加载失败",
                  noMoreText: "没有更多内容",
                ),
                controller: _refreshController,
                childBuilder: (context, physics) => ListView.builder(
                  physics: physics,
                  itemCount: _replyReplies.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _rootReply,
                            _replyReplies[index],
                          ],
                        ),
                      );
                    }
                    return _replyReplies[index];
                  },
                  clipBehavior: Clip.antiAlias,
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
