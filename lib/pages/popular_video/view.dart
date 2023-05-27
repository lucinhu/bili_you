import 'package:bili_you/common/values/hero_tag_id.dart';
import 'package:bili_you/common/widget/simple_easy_refresher.dart';
import 'package:bili_you/index.dart';
import 'package:bili_you/pages/bili_video/view.dart';
import 'package:bili_you/pages/popular_video/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularVideoPage extends StatefulWidget {
  const PopularVideoPage({super.key});

  @override
  State<PopularVideoPage> createState() => _PopularVideoPageState();
}

class _PopularVideoPageState extends State<PopularVideoPage>
    with AutomaticKeepAliveClientMixin {
  late PopularVideoController controller;

  @override
  void initState() {
    controller = Get.put(PopularVideoController());
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
      childBuilder: (context, physics) => ListView.builder(
        padding: const EdgeInsets.all(12),
        controller: controller.scrollController,
        itemCount: controller.infoList.length,
        physics: physics,
        itemBuilder: (context, index) {
          var i = controller.infoList[index];
          var heroTagId = HeroTagId.id++;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: VideoTileItem.fromVideoTileInfo(i,
                cacheManager: CacheUtils.relatedVideosItemCoverCacheManager,
                heroTagId: heroTagId, onTap: (context) {
              HeroTagId.lastId = heroTagId;
              Navigator.of(context).push(GetPageRoute(
                page: () => BiliVideoPage(
                  key: ValueKey("BiliVideoPage:${i.bvid}"),
                  bvid: i.bvid,
                  cid: i.cid,
                ),
              ));
            }),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
