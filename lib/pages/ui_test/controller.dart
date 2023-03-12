import 'package:bili_you/pages/about/about_page.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_danmaku.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_video_player_panel.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/index.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_video_player.dart';
import 'package:bili_you/pages/user_space/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UiTestController extends GetxController {
  UiTestController();

  List<ListTile> listTiles = [];
  BiliVideoPlayerController biliVideoPlayerController =
      BiliVideoPlayerController(bvid: "170001", cid: 279786);

  //测试名称,页面对应表
  late Map<String, Widget> _testPages;

  _buildListTiles() {
    _testPages.forEach((text, page) {
      listTiles.add(ListTile(
        title: Text(text),
        onTap: () => Get.to(() => Scaffold(
              appBar: AppBar(title: Text(text)),
              body: page,
            )),
      ));
    });
  }

  _initData() {
    // update(["ui_test"]);
  }

  void onTap() {}

  @override
  void onInit() {
    _testPages = {
      "评论测试": ReplyPage(
        bvid: "170001",
        pauseVideoCallback: () {},
      ),
      "许可": const LicensePage(
        applicationIcon: ImageIcon(
          AssetImage("assets/icon/bili.png"),
          size: 200,
        ),
        applicationName: "Bili You",
      ),
      "关于": const AboutPage(),
      "视频": AspectRatio(
        aspectRatio: 16 / 9,
        child: BiliVideoPlayer(
          biliVideoPlayerController,
          buildDanmaku: (context, biliVideoPlayerController) {
            return BiliDanmaku(
                controller: BiliDanmakuController(biliVideoPlayerController));
          },
          buildControllPanel: (context, biliVideoPlayerController) {
            return BiliVideoPlayerPanel(
                BiliVideoPlayerPanelController(biliVideoPlayerController));
          },
        ),
      ),
      "用户投稿": const UserSpacePage(
        mid: 16752607,
      )
    };
    //初始化构建测试页面项列表
    _buildListTiles();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    biliVideoPlayerController.dispose();
    super.onClose();
  }
}
