import 'dart:developer';

import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_danmaku.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_video_player.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_video_player_panel.dart';
import 'package:get/get.dart';

class BiliVideoController extends GetxController {
  BiliVideoController({required this.bvid, required this.cid});
  final String bvid;
  int cid;
  late BiliVideoPlayer biliVideoPlayer;
  late BiliVideoPlayerController biliVideoPlayerController;

  changeVideoPart(int cid) {
    this.cid = cid;
    biliVideoPlayerController.changeCid(cid);
  }

  void onTap() {}
  @override
  void onInit() {
    biliVideoPlayerController = BiliVideoPlayerController(
      bvid: bvid,
      cid: cid,
    );
    biliVideoPlayer = BiliVideoPlayer(
      biliVideoPlayerController,
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
