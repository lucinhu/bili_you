import 'package:bili_you/pages/bili_video/widgets/bili_video_player/view.dart';
import 'package:get/get.dart';

class BiliVideoController extends GetxController {
  BiliVideoController({required this.bvid, required this.cid}) {
    biliVideoPlayerPage = BiliVideoPlayerPage(bvid: bvid, cid: cid);
  }
  final String bvid;
  int cid;
  late BiliVideoPlayerPage biliVideoPlayerPage;

  changeVideoPart(int cid) {
    this.cid = cid;
    biliVideoPlayerPage.controller.disposeAllControllers();
    biliVideoPlayerPage.controller.changePart(cid);
  }

  _initData() async {
    update(["bili_video_play"]);
  }

  void onTap() {}

  @override
  void onReady() {
    super.onReady();

    _initData();
  }
}
