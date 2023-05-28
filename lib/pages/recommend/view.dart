import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/values/hero_tag_id.dart';
import 'package:bili_you/common/widget/simple_easy_refresher.dart';
import 'package:bili_you/pages/recommend/widgets/recommend_card.dart';
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
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            crossAxisCount: controller.recommendColumnCount,
            mainAxisExtent: (MediaQuery.of(context).size.width /
                        controller.recommendColumnCount) *
                    10 /
                    16 +
                83 * MediaQuery.of(context).textScaleFactor),
        itemCount: controller.recommendItems.length,
        itemBuilder: (context, index) {
          var i = controller.recommendItems[index];
          return RecommendCard(
              key: ValueKey("${i.bvid}:RecommendCard"),
              heroTagId: HeroTagId.id++,
              cacheManager: controller.cacheManager,
              imageUrl: i.coverUrl,
              playNum: StringFormatUtils.numFormat(i.playNum),
              danmakuNum: StringFormatUtils.numFormat(i.danmakuNum),
              timeLength: StringFormatUtils.timeLengthFormat(i.timeLength),
              title: i.title,
              upName: i.upName,
              bvid: i.bvid,
              cid: i.cid);
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
