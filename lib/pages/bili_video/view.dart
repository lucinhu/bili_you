import 'package:bili_you/pages/bili_video/widgets/introduction/index.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'index.dart';

class BiliVideoPage extends StatefulWidget {
  const BiliVideoPage({
    Key? key,
    required this.bvid,
    required this.cid,
    this.isBangumi = false,
    this.ssid,
  })  : tag = "BiliVideoPage:$bvid",
        super(key: key);
  final String bvid;
  final int cid;
  final int? ssid;
  final bool isBangumi;
  final String tag;

  @override
  State<BiliVideoPage> createState() => _BiliVideoPageState();
}

class _BiliVideoPageState extends State<BiliVideoPage> {
  // 主视图
  Widget _player(BiliVideoController controller) {
    return controller.biliVideoPlayer;
  }

  Widget _buildView(context, BiliVideoController controller) {
    return Column(
      children: [
        TabBar(
            controller: controller.tabController,
            splashFactory: NoSplash.splashFactory,
            tabs: const [
              Tab(
                text: "简介",
              ),
              Tab(text: "评论")
            ]),
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: [
              IntroductionPage(
                changePartCallback: controller.changeVideoPart,
                pauseVideoCallback: controller.biliVideoPlayerController.pause,
                refreshReply: controller.refreshReply,
                bvid: controller.bvid,
                cid: controller.cid,
                ssid: controller.ssid,
                isBangumi: controller.isBangumi,
              ),
              Builder(builder: (context) {
                //Builder可以让ReplyPage在TabBarView显示到它的时候才取controller.bvid
                return ReplyPage(
                  bvid: controller.bvid,
                  pauseVideoCallback:
                      controller.biliVideoPlayerController.pause,
                );
              })
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light),
        child: GetBuilder(
          init: BiliVideoController(
              bvid: widget.bvid,
              cid: widget.cid,
              ssid: widget.ssid,
              isBangumi: widget.isBangumi),
          tag: widget.tag,
          builder: (controller) => Scaffold(
              body: Column(
            children: [
              _player(controller),
              Expanded(child: _buildView(context, controller)),
            ],
          )),
        ));
  }
}
