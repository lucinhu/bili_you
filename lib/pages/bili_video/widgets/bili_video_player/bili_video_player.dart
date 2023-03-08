import 'dart:async';
import 'dart:developer';

import 'package:bili_you/common/api/video_play_api.dart';
import 'package:bili_you/common/utils/fullscreen.dart';
import 'package:bili_you/common/widget/video_audio_player.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_danmaku.dart';
import 'package:flutter/material.dart';

class BiliVideoPlayer extends StatefulWidget {
  const BiliVideoPlayer(this.controller,
      {super.key, this.buildDanmaku, this.buildControllPanel, this.onDispose});
  final BiliVideoPlayerController controller;
  final BiliDanmaku Function(BuildContext context,
      BiliVideoPlayerController biliVideoPlayerController)? buildDanmaku;
  final Widget Function(BuildContext context,
      BiliVideoPlayerController biliVideoPlayerController)? buildControllPanel;
  final Function(BuildContext context,
      BiliVideoPlayerController biliVideoPlayerController)? onDispose;

  @override
  State<BiliVideoPlayer> createState() => _BiliVideoPlayerState();
}

class _BiliVideoPlayerState extends State<BiliVideoPlayer> {
  GlobalKey aspectRatioKey = GlobalKey();
  BiliDanmaku? danmaku;
  Widget? controllPanel;
  Future<bool> loadVideo(String bvid, int cid) async {
    if (widget.controller._videoAudioController != null) {
      // log("not null");
      return true;
    }
    try {
      var data = await VideoPlayApi.requestVideoPlay(
          bvid: bvid, cid: cid, qn: 0, fnval: 80);
      if (data.code != 0) {
        return false;
      }
      widget.controller._videoAudioController = VideoAudioController(
          videoUrl: data.dash.video[0].baseUrl,
          audioUrl: data.dash.audio[0].baseUrl,
          audioHeaders: VideoPlayApi.videoPlayerHttpHeaders,
          videoHeaders: VideoPlayApi.videoPlayerHttpHeaders,
          autoWakelock: true);
      await widget.controller._videoAudioController!.ensureInitialized();
      await widget.controller._videoAudioController!.play();
      return true;
    } catch (e) {
      log("bili_video_player $e");
      return false;
    }
  }

  updateWidget() {
    if (mounted) {
      setState(() {});
    }
  }

  void init() {}

  @override
  void initState() {
    danmaku = widget.buildDanmaku?.call(context, widget.controller);
    controllPanel = widget.buildControllPanel?.call(context, widget.controller);
    widget.controller._updateAsepectRatioWidget = () {
      if (aspectRatioKey.currentState?.mounted ?? false) {
        aspectRatioKey.currentState!.setState(() {});
      }
    };
    widget.controller.biliDanmakuController = danmaku?.controller;
    super.initState();
  }

  @override
  void dispose() {
    widget.onDispose?.call(context, widget.controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.updateWidget = updateWidget;
    widget.controller._size = MediaQuery.of(context).size;
    widget.controller._padding = MediaQuery.of(context).padding;
    return Hero(
      tag: "BiliVideoPlayer:${widget.controller.bvid}",
      child: Container(
        color: Colors.black,
        child: SafeArea(
            left: false,
            right: false,
            bottom: false,
            child: FutureBuilder(
              future: loadVideo(widget.controller.bvid, widget.controller.cid),
              builder: (context, snapshot) {
                return StatefulBuilder(
                    key: aspectRatioKey,
                    builder: (context, builder) {
                      return AspectRatio(
                          aspectRatio: widget.controller._aspectRatio,
                          child: Builder(
                            builder: (context) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.data == true) {
                                  return Stack(children: [
                                    Center(
                                      child: AspectRatio(
                                        aspectRatio: widget
                                            .controller
                                            ._videoAudioController!
                                            .value
                                            .aspectRatio,
                                        child: VideoAudioPlayer(widget
                                            .controller._videoAudioController!),
                                      ),
                                    ),
                                    Center(
                                      child: danmaku,
                                    ),
                                    Center(
                                      child: controllPanel,
                                    ),
                                  ]);
                                } else {
                                  //加载失败,重试按钮
                                  return Center(
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.controller
                                                ._videoAudioController
                                                ?.dispose();
                                            widget.controller
                                                ._videoAudioController = null;
                                          });
                                        },
                                        icon:
                                            const Icon(Icons.refresh_rounded)),
                                  );
                                }
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ));
                    });
              },
            )),
      ),
    );
  }
}

class BiliVideoPlayerController {
  BiliVideoPlayerController({
    required this.bvid,
    required this.cid,
  });
  String bvid;
  int cid;
  bool isFullScreen = false;
  late Size _size;
  late EdgeInsets _padding;

  late Function() updateWidget;
  late Function() _updateAsepectRatioWidget;
  VideoAudioController? _videoAudioController;
  BiliDanmakuController? biliDanmakuController;

  double _aspectRatio = 16 / 9;

  double get aspectRatio => _aspectRatio;
  set aspectRatio(double asepectRatio) {
    _aspectRatio = asepectRatio;
    _updateAsepectRatioWidget();
  }

  void reloadWidget() {
    _videoAudioController?.dispose();
    _videoAudioController = null;
    biliDanmakuController?.refreshDanmaku();
    updateWidget();
  }

  void changeCid(String bvid, int cid) {
    this.bvid = bvid;
    this.cid = cid;
    reloadWidget();
  }

  void toggleFullScreen() {
    if (isFullScreen) {
      isFullScreen = false;
      exitFullScreen();
      portraitUp().then((value) => aspectRatio = 16 / 9);
    } else {
      isFullScreen = true;
      if (videoAspectRatio >= 1) {
        landScape().then((value) => aspectRatio = _size.flipped.aspectRatio);
      } else {
        portraitUp().then((value) =>
            aspectRatio = _size.width / (_size.height - _padding.top));
      }
      enterFullScreen();
    }
  }

  void addListener(VoidCallback listener) {
    _videoAudioController?.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    _videoAudioController?.removeListener(listener);
  }

  void addStateChangedListener(Function(VideoAudioPlayerValue value) listener) {
    _videoAudioController?.addStateChangedListener(listener);
  }

  void removeStateChangedListener(
      Function(VideoAudioPlayerValue value) listener) {
    _videoAudioController?.removeStateChangedListener(listener);
  }

  void addSeekToListener(Function(Duration position) listener) {
    _videoAudioController?.addSeekToListener(listener);
  }

  void removeSeekToListener(Function(Duration position) listener) {
    _videoAudioController?.addSeekToListener(listener);
  }

  void dispose() {
    _videoAudioController?.dispose();
  }

  Future<Duration> get position async {
    return await _videoAudioController?.position ?? Duration.zero;
  }

  Duration get duration {
    return _videoAudioController?.value.duration ?? Duration.zero;
  }

  double get speed => _videoAudioController?.value.speed ?? 1;

  double get videoAspectRatio => _videoAudioController?.value.aspectRatio ?? 1;

  bool get isPlaying {
    return _videoAudioController?.value.isPlaying ?? false;
  }

  bool get isBuffering {
    return _videoAudioController?.value.isBuffering ?? false;
  }

  bool get hasError {
    return _videoAudioController?.hasError ?? false;
  }

  Duration get fartherestBuffered {
    if (_videoAudioController == null) {
      return Duration.zero;
    }
    if (_videoAudioController!.value.buffered.isNotEmpty) {
      return _videoAudioController!.value.buffered.last.end;
    } else {
      return Duration.zero;
    }
  }

  Future<void> play() async {
    await _videoAudioController?.play();
  }

  Future<void> pause() async {
    await _videoAudioController?.pause();
  }

  Future<void> seekTo(Duration position) async {
    await _videoAudioController?.seekTo(position);
  }

  Future<void> setPlayBackSpeed(double speed) async {
    await _videoAudioController?.setPlayBackSpeed(speed);
  }
}
