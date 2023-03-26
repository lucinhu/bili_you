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

  // 主视图
  Widget _buildView(BuildContext context, RecommendController controller) {
    return EasyRefresh.builder(
      refreshOnStart: true,
      onLoad: controller.onLoad,
      onRefresh: controller.onRefresh,
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
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: controller.recommendColumnCount,
            mainAxisExtent: (MediaQuery.of(context).size.width /
                        controller.recommendColumnCount) *
                    9 /
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
    return GetBuilder<RecommendController>(
      init: RecommendController(),
      id: "recommend",
      builder: (controller) {
        return _buildView(context, controller);
      },
    );
  }
}
