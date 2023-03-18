import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ReplyPage extends StatefulWidget {
  const ReplyPage({
    Key? key,
    required this.bvid,
    required this.pauseVideoCallback,
  })  : tag = "ReplyPage:$bvid",
        super(key: key);
  final String bvid;
  final String tag;
  final Function() pauseVideoCallback;

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage>
    with AutomaticKeepAliveClientMixin {
  _ReplyPageState();
  @override
  bool get wantKeepAlive => true;

  // 主视图
  Widget _buildView(ReplyController controller) {
    return EasyRefresh.builder(
        refreshOnStart: true,
        onLoad: controller.onReplyLoad,
        onRefresh: controller.onReplyRefresh,
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
        controller: controller.refreshController,
        childBuilder: (context, physics) => ListView.builder(
              shrinkWrap: true,
              controller: controller.scrollController,
              padding: const EdgeInsets.all(0),
              physics: physics,
              itemCount: controller.replyList.length,
              itemBuilder: (context, index) {
                return controller.replyList[index];
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder(
      init: ReplyController(
          bvid: widget.bvid, pauseVideoCallback: widget.pauseVideoCallback),
      tag: widget.tag,
      builder: (controller) => _buildView(controller),
      id: 'reply',
    );
  }
}
