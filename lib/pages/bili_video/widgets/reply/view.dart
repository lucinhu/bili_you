import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:bili_you/common/widget/simple_easy_refresher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ReplyPage extends StatefulWidget {
  const ReplyPage({
    Key? key,
    required this.replyId,
    required this.replyType,
  })  : tag = "ReplyPage:$replyId",
        super(key: key);
  final String replyId;
  final ReplyType replyType;
  final String tag;

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage>
    with AutomaticKeepAliveClientMixin {
  _ReplyPageState();
  @override
  bool get wantKeepAlive => true;
  late ReplyController controller;

  @override
  void initState() {
    controller = Get.put(
        ReplyController(
          bvid: widget.replyId,
          replyType: widget.replyType,
        ),
        tag: widget.tag);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // 主视图
  Widget _buildView(ReplyController controller) {
    return SimpleEasyRefresher(
      childBuilder: (context, physics) => ListView.builder(
        controller: controller.scrollController,
        physics: physics,
        padding: const EdgeInsets.all(0),
        itemCount: controller.replyList.length,
        itemBuilder: (context, index) {
          return controller.replyList[index];
        },
      ),
      onLoad: controller.onReplyLoad,
      onRefresh: controller.onReplyRefresh,
      easyRefreshController: controller.refreshController,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildView(controller);
  }
}
