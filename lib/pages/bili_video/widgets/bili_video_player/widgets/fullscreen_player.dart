import 'dart:developer';

import 'package:bili_you/common/models/proto/danmaku/danmaku.pb.dart';
import 'package:bili_you/common/utils/fullscreen.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/controller.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/widgets/controll_pannel.dart';
import 'package:fanjiao_danmu/fanjiao_danmu/adapter/fanjiao_danmu_adapter.dart';
import 'package:fanjiao_danmu/fanjiao_danmu/fanjiao_danmu.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

///全屏播放
class BiliVideoPlayerFullScreenPage extends StatefulWidget {
  const BiliVideoPlayerFullScreenPage({Key? key, required this.controller})
      : super(key: key);

  ///和普通播放器BiliVideoPlayer共用的控制器
  final BiliVideoPlayerController controller;

  @override
  State<BiliVideoPlayerFullScreenPage> createState() =>
      _BiliVideoPlayerFullScreenPageState();
}

class _BiliVideoPlayerFullScreenPageState
    extends State<BiliVideoPlayerFullScreenPage> {
  late DanmuController _fanjiaoDanmuController;

  syncDanmakuByVideo() async {
    widget.controller.syncDanmakuByVideo(_fanjiaoDanmuController);
  }

  syncDanmakuByAudio() async {
    widget.controller.syncDanmakuByAudio(_fanjiaoDanmuController);
  }

  @override
  void initState() {
    _fanjiaoDanmuController = DanmuController(
        maxSize: widget.controller.fanjiaoDanmuController.maxSize,
        adapter: FanjiaoDanmuAdapter());
    widget.controller.initDanmakuController(_fanjiaoDanmuController);
    widget.controller.videoPlayerController!.addListener(syncDanmakuByVideo);
    widget.controller.audioPlayerController!.addListener(syncDanmakuByAudio);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.controller.addDanmaku(
          DanmakuElem(
              progress: 0, content: ' ', mode: 1, color: 0, fontsize: 1),
          _fanjiaoDanmuController);
      _fanjiaoDanmuController.progress =
          widget.controller.fanjiaoDanmuController.progress;
      widget.controller.whenDanmakuEmpty(_fanjiaoDanmuController);
      _fanjiaoDanmuController.start();
      log('start');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio:
                  widget.controller.videoPlayerController!.value.aspectRatio,
              child: VideoPlayer(widget.controller.videoPlayerController!),
            ),
          ),
          Builder(
            builder: (context) {
              Size size;
              if (widget.controller.videoPlayerController!.value.aspectRatio >=
                  1) {
                if (MediaQuery.of(context).size.aspectRatio >= 1) {
                  size = MediaQuery.of(context).size;
                } else {
                  size = MediaQuery.of(context).size.flipped;
                }
              } else {
                if (MediaQuery.of(context).size.aspectRatio < 1) {
                  size = MediaQuery.of(context).size;
                } else {
                  size = MediaQuery.of(context).size.flipped;
                }
              }
              return DanmuWidget(
                  size: size, danmuController: _fanjiaoDanmuController);
            },
          ),
          SafeArea(
            child: VideoControllPannel(controller: widget.controller),
          )
        ],
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    widget.controller.videoPlayerController!.removeListener(syncDanmakuByVideo);
    widget.controller.audioPlayerController!.removeListener(syncDanmakuByAudio);
    widget.controller.isFullScreen = false;
    await portraitUp();
    await exitFullScreen();
  }
}
