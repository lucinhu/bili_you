import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_video_player.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_video_player_panel.dart';
import 'package:get/get.dart';

class BiliVideoController extends GetxController {
  BiliVideoController({required this.bvid, required this.cid});
  final String bvid;
  int cid;
  late BiliVideoPlayer biliVideoPlayerPage;
  late BiliVideoPlayerController biliVideoPageController;

  changeVideoPart(int cid) {
    this.cid = cid;
    biliVideoPageController.changeCid(cid);
  }

  _initData() {
    update(["bili_video_play"]);
  }

  void onTap() {}
  @override
  void onInit() {
    biliVideoPageController = BiliVideoPlayerController(
      bvid: bvid,
      cid: cid,
    );
    biliVideoPlayerPage = BiliVideoPlayer(biliVideoPageController,
        buildControllPanel: (context, biliVideoPlayerController) {
      return BiliVideoPlayerPanel(
        BiliVideoPlayerPanelController(biliVideoPlayerController),
      );
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    _initData();
  }
}
