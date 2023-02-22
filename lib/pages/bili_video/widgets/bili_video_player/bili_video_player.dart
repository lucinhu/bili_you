import 'dart:async';
import 'dart:developer';

import 'package:bili_you/common/api/video_play_api.dart';
import 'package:bili_you/common/widget/video_audio_player.dart';
import 'package:flutter/material.dart';

class BiliVideoPlayer extends StatefulWidget {
  const BiliVideoPlayer(
    this.controller, {
    super.key,
    this.autoDispose = true,
    this.buildDanmaku,
    this.buildControllPanel,
  });
  final BiliVideoPlayerController controller;
  final Widget Function(BuildContext context,
      BiliVideoPlayerController biliVideoPlayerController)? buildDanmaku;
  final Widget Function(BuildContext context,
      BiliVideoPlayerController biliVideoPlayerController)? buildControllPanel;
  final bool autoDispose;

  @override
  State<BiliVideoPlayer> createState() => _BiliVideoPlayerState();
}

class _BiliVideoPlayerState extends State<BiliVideoPlayer> {
  Future<bool> loadVideo(String bvid, int cid) async {
    if (widget.controller._videoAudioController != null) {
      log("not null");
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
    setState(() {});
  }

  @override
  void initState() {
    widget.controller.updateWidget = updateWidget;
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      widget.controller._videoAudioController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadVideo(widget.controller.bvid, widget.controller.cid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return Stack(children: [
              Center(
                child: AspectRatio(
                  aspectRatio: widget
                      .controller._videoAudioController!.value.aspectRatio,
                  child: VideoAudioPlayer(
                      widget.controller._videoAudioController!),
                ),
              ),
              Center(
                child: widget.buildDanmaku?.call(context, widget.controller) ??
                    Container(),
              ),
              Center(
                child: widget.buildControllPanel
                        ?.call(context, widget.controller) ??
                    Container(),
              ),
            ]);
          } else {
            //加载失败,重试按钮
            return Center(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      widget.controller._videoAudioController?.dispose();
                      widget.controller._videoAudioController = null;
                    });
                  },
                  icon: const Icon(Icons.refresh_rounded)),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
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

  late Function() updateWidget;
  VideoAudioController? _videoAudioController;

  void reloadWidget() {
    _videoAudioController?.dispose();
    _videoAudioController = null;
    updateWidget();
  }

  void changeCid(int cid) {
    this.cid = cid;
    reloadWidget();
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

  Future<Duration> get position async {
    return await _videoAudioController?.position ?? Duration.zero;
  }

  Duration get duration {
    return _videoAudioController?.value.duration ?? Duration.zero;
  }

  double get speed => _videoAudioController?.value.speed ?? 1;

  double get aspectRatio => _videoAudioController?.value.aspectRatio ?? 1;

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
