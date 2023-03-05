import 'package:bili_you/pages/user_space/controller.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSpacePage extends StatefulWidget {
  const UserSpacePage({super.key, required this.mid});
  final int mid;

  @override
  State<UserSpacePage> createState() => _UserSpacePageState();
}

class _UserSpacePageState extends State<UserSpacePage>
    with AutomaticKeepAliveClientMixin {
  late UserSpacePageController controller;
  GlobalKey refreshKey = GlobalKey();
  @override
  void initState() {
    controller = Get.put(
        UserSpacePageController(mid: widget.mid, refreshKey: refreshKey),
        tag: "userSpacePageController:${widget.mid}");
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text("用户投稿")),
      body: EasyRefresh.builder(
        key: refreshKey,
        refreshOnStart: true,
        onLoad: controller.onLoad,
        onRefresh: controller.onRefresh,
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
          physics: physics,
          itemCount: controller.searchItemWidgetList.length,
          itemBuilder: (context, index) {
            return controller.searchItemWidgetList[index];
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
