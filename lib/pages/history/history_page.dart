import 'package:bili_you/common/values/hero_tag_id.dart';
import 'package:bili_you/common/widget/simple_easy_refresher.dart';
import 'package:bili_you/common/widget/video_view_history_tile.dart';
import 'package:bili_you/pages/history/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late HistoryController controller;
  @override
  void initState() {
    controller = Get.put(HistoryController());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('历史记录')),
      body: SimpleEasyRefresher(
        onLoad: controller.onLoad, //加載更多
        onRefresh: controller.onRefresh, //刷新
        easyRefreshController: controller.easyRefreshController,
        childBuilder: (context, physics) => ListView.builder(
          padding: const EdgeInsets.all(12),
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          physics: physics,
          itemCount: controller.videoViewHistoryItems.length,
          controller: controller.scrollController,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: VideoViewHistoryTile(
                videoViewHistoryItem: controller.videoViewHistoryItems[index],
                cacheManager: controller.cacheManager,
                heroTagId: HeroTagId.id++),
          ),
        ),
      ),
    );
  }
}
