import 'dart:developer';

import 'package:bili_you/common/api/video_reply_api.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/widgets/reply_item.dart';
import 'package:easy_refresh/easy_refresh.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplyReplyPage extends StatefulWidget {
  const ReplyReplyPage({
    super.key,
    required this.bvid,
    required this.rootId,
  });
  final String bvid;
  final int rootId;

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
    try {
      var data = await VideoReplyApi.requestReplyReply(
          bvid: widget.bvid, rootId: widget.rootId, pageNum: _pageNum.value);
      if (data.code != 0) {
        return false;
      }
      if (_pageNum.value <= data.data.page.count) {
        _rootReply = ReplyItemWidget(
          face: data.data.root.member.avatar,
          name: data.data.root.member.uname,
          message: data.data.root.content.message,
          timeStamp: data.data.root.ctime,
          like: data.data.root.like,
          location: data.data.root.replyControl.location,
          isUp: int.parse(data.data.root.member.mid) == data.data.upper.mid,
        );

        for (var i in data.data.replies) {
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
            face: i.member.avatar,
            name: i.member.uname,
            message: i.content.message,
            timeStamp: i.ctime,
            like: i.like,
            location: i.replyControl.location,
            isUp: int.parse(i.member.mid) == data.data.upper.mid,
          ));
        }
        _pageNum.value++;
      }

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
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
                header: const ClassicHeader(
                  processedDuration: Duration.zero,
                  safeArea: false,
                  showMessage: false,
                  processingText: "正在刷新...",
                  readyText: "正在刷新...",
                  armedText: "释放以刷新",
                  dragText: "下拉刷新",
                  processedText: "刷新成功",
                  failedText: "刷新失败",
                ),
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
