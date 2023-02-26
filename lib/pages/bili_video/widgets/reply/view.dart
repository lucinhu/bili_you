import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ReplyPage extends StatefulWidget {
  const ReplyPage({Key? key, required this.bvid}) : super(key: key);
  final String bvid;
  static int tagId = 0;

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final tag = "ReplyPage:${ReplyPage.tagId++}";

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _ReplyViewGetX(
      bvid: widget.bvid,
      tag: tag,
    );
  }

  @override
  void dispose() {
    ReplyPage.tagId--;
    super.dispose();
  }
}

class _ReplyViewGetX extends GetView<ReplyController> {
  const _ReplyViewGetX({Key? key, required this.bvid, required tag})
      : _tag = tag,
        super(key: key);
  final String bvid;
  final String _tag;
  @override
  String? get tag => _tag;

  // 主视图
  Widget _buildView() {
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
    return GetBuilder<ReplyController>(
      tag: tag,
      init: ReplyController(bvid: bvid),
      id: "reply",
      builder: (_) {
        return _buildView();
      },
    );
  }
}
