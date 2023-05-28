import 'package:bili_you/common/values/hero_tag_id.dart';
import 'package:bili_you/common/widget/live_room_card.dart';
import 'package:bili_you/common/widget/simple_easy_refresher.dart';
import 'package:bili_you/pages/live_tab_page/controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LiveTabPage extends StatefulWidget {
  const LiveTabPage({super.key});

  @override
  State<LiveTabPage> createState() => _LiveTabPageState();
}

class _LiveTabPageState extends State<LiveTabPage>
    with AutomaticKeepAliveClientMixin {
  late LiveTabPageController controller;
  @override
  void initState() {
    controller = Get.put(LiveTabPageController());
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
    return SimpleEasyRefresher(
        onRefresh: controller.onRefresh,
        onLoad: controller.onLoad,
        easyRefreshController: controller.refreshController,
        childBuilder: (context, physics) => GridView.builder(
              controller: controller.scrollController,
              physics: physics,
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  crossAxisCount: controller.columnCount,
                  mainAxisExtent: (MediaQuery.of(context).size.width /
                              controller.columnCount) *
                          10 /
                          16 +
                      45 * MediaQuery.of(context).textScaleFactor),
              itemCount: controller.infoList.length,
              itemBuilder: (context, index) => LiveRoomCard(
                  info: controller.infoList[index], heroTagId: HeroTagId.id++),
            ));
  }

  @override
  bool get wantKeepAlive => true;
}
