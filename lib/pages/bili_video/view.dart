import 'dart:developer';

import 'package:bili_you/pages/bili_video/widgets/reply/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'index.dart';

class BiliVideoPage extends StatefulWidget {
  const BiliVideoPage(
      {Key? key,
      required this.bvid,
      required this.cid,
      required this.introductionBuilder})
      : super(key: key);
  final String bvid;
  final int cid;
  final Widget Function(
      Function(String bvid, int cid) changePartCallback,
      Function() pauseVideoCallback,
      Function() refreshReply) introductionBuilder;

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
      introductionBuilder: widget.introductionBuilder,
      tabController: tabController,
    );
  }
}

class _BiliVideoPage extends GetView<BiliVideoController> {
  _BiliVideoPage(
      {Key? key,
      required this.bvid,
      required this.cid,
      required this.introductionBuilder,
      required this.tabController})
      : super(key: key);
  final String bvid;
  final int cid;
  final TabController tabController;
  final Widget Function(
      Function(String bvid, int cid) changePartCallback,
      Function() pauseVideoCallback,
      Function() refreshReply) introductionBuilder;
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
              introductionBuilder(
                  controller.changeVideoPart,
                  controller.biliVideoPlayerController.pause,
                  controller.refreshReply),
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
    return GetBuilder<BiliVideoController>(
      dispose: (state) {
        _tagId--;
        log(_tagId.toString());
      },
      tag: tag,
      init: BiliVideoController(bvid: bvid, cid: cid),
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
    );
  }
}
