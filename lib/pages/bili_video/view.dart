import 'dart:developer';

import 'package:bili_you/pages/bili_video/widgets/introduction/index.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'index.dart';

class BiliVideoPage extends StatefulWidget {
  const BiliVideoPage(
      {Key? key,
      required this.bvid,
      required this.cid,
      this.ssid,
      this.isBangumi = false})
      : super(key: key);
  final String bvid;
  final int cid;
  final int? ssid;
  final bool isBangumi;

  @override
  State<BiliVideoPage> createState() => _BiliVideoPageState();
}

class _BiliVideoPageState extends State<BiliVideoPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final TabController tabController = TabController(
        length: 2,
        vsync: this,
        animationDuration: const Duration(milliseconds: 200));
    return _BiliVideoPage(
      bvid: widget.bvid,
      cid: widget.cid,
      isBangumi: widget.isBangumi,
      tabController: tabController,
      ssid: widget.ssid,
    );
  }
}

class _BiliVideoPage extends GetView<BiliVideoController> {
  _BiliVideoPage(
      {Key? key,
      required this.bvid,
      required this.cid,
      required this.isBangumi,
      this.ssid,
      required this.tabController})
      : super(key: key);
  final String bvid;
  final int cid;
  final int? ssid;
  final bool isBangumi;
  final TabController tabController;

  static int _tagId = 0;
  final _tag = "BiliVideoPage:${_tagId++}";
  @override
  String? get tag => _tag;

  // 主视图
  Widget _player() {
    return controller.biliVideoPlayer;
  }

  Widget _buildView(context) {
    return Column(
      children: [
        TabBar(
            controller: tabController,
            splashFactory: NoSplash.splashFactory,
            tabs: const [
              Tab(
                text: "简介",
              ),
              Tab(text: "评论")
            ]),
        Expanded(
          child: TabBarView(
            controller: tabController,
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
        child: GetBuilder<BiliVideoController>(
          dispose: (state) {
            _tagId--;
            log(_tagId.toString());
          },
          tag: tag,
          init: BiliVideoController(
              bvid: bvid, cid: cid, ssid: ssid, isBangumi: isBangumi),
          id: "bili_video_play",
          builder: (_) {
            return Scaffold(
                body: Column(
              children: [
                _player(),
                Expanded(child: _buildView(context)),
              ],
            ));
          },
        ));
  }
}
