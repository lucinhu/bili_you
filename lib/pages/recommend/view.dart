import 'package:easy_refresh/easy_refresh.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'index.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({Key? key}) : super(key: key);

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late RecommendController controller;
  @override
  void initState() {
    controller = Get.put(RecommendController());
    super.initState();
  }

  @override
  void dispose() {
    controller.onClose();
    controller.onDelete();
    super.dispose();
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return EasyRefresh.builder(
      refreshOnStart: true,
      onLoad: () async {
        await controller.onLoad();
        setState(() {});
      },
      onRefresh: () async {
        await controller.onRefresh();
        setState(() {});
      },
      header: const ClassicHeader(
        processedDuration: Duration.zero,
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
      childBuilder: (context, physics) => GridView.builder(
        controller: controller.scrollController,
        physics: physics,
        padding: const EdgeInsets.all(4),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: controller.recommendColumnCount,
            mainAxisExtent: (MediaQuery.of(context).size.width /
                        controller.recommendColumnCount) *
                    10 /
                    16 +
                20 +
                58),
        itemCount: controller.recommendViewList.length,
        itemBuilder: (context, index) {
          return controller.recommendViewList[index];
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildView(context);
  }
}
