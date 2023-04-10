import 'package:bili_you/common/widget/simple_easy_refresher.dart';
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
    // controller.onClose();
    // controller.onDelete();
    controller.dispose();
    super.dispose();
  }

  // 主视图
  Widget _buildView(BuildContext context) {
    return SimpleEasyRefresher(
      easyRefreshController: controller.refreshController,
      onLoad: controller.onLoad,
      onRefresh: controller.onRefresh,
      childBuilder: (context, physics) => GridView.builder(
        controller: controller.scrollController,
        physics: physics,
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            crossAxisCount: controller.recommendColumnCount,
            mainAxisExtent: (MediaQuery.of(context).size.width /
                        controller.recommendColumnCount) *
                    10 /
                    16 +
                83 * MediaQuery.of(context).textScaleFactor),
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
