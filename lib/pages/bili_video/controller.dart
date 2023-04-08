import 'package:bili_you/common/values/hero_tag_id.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_danmaku.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_video_player.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_video_player_panel.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BiliVideoController extends GetxController
    with GetTickerProviderStateMixin {
  BiliVideoController({
    required this.bvid,
    required this.cid,
    this.ssid,
    this.progress,
    required this.isBangumi,
  });
  String bvid;
  late String oldBvid;
  int cid;
  int? ssid;
  int? progress;
  bool isBangumi;
  late BiliVideoPlayer biliVideoPlayer;
  late BiliVideoPlayerController biliVideoPlayerController;
  late final TabController tabController;

  changeVideoPart(String bvid, int cid) {
    this.cid = cid;
    this.bvid = bvid;
    biliVideoPlayerController.bvid = bvid;
    biliVideoPlayerController.changeCid(bvid, cid);
  }

  refreshReply() {
    Get.find<ReplyController>(tag: 'ReplyPage:$oldBvid').bvid = bvid;
    Get.find<ReplyController>(tag: 'ReplyPage:$oldBvid')
        .refreshController
        .callRefresh();
  }

  void onTap() {}
  @override
  void onInit() {
    oldBvid = bvid;
    tabController = TabController(
        length: 2,
        vsync: this,
        animationDuration: const Duration(milliseconds: 200));
    biliVideoPlayerController = BiliVideoPlayerController(
        bvid: bvid,
        cid: cid,
        initVideoPosition:
            progress != null ? Duration(seconds: progress!) : Duration.zero);
    biliVideoPlayer = BiliVideoPlayer(
      biliVideoPlayerController,
      heroTagId: HeroTagId.lastId,
      buildControllPanel: (context, biliVideoPlayerController) {
        return BiliVideoPlayerPanel(
          BiliVideoPlayerPanelController(biliVideoPlayerController),
        );
      },
      buildDanmaku: (context, biliVideoPlayerController) {
        return BiliDanmaku(
            controller: BiliDanmakuController(biliVideoPlayerController));
      },
    );
    super.onInit();
  }

  @override
  void onClose() {
    biliVideoPlayerController.dispose();
    super.onClose();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }
}
