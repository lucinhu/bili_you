import 'dart:async';
import 'dart:developer';

import 'package:bili_you/common/api/video_play_api.dart';
import 'package:bili_you/common/models/local/video/audio_play_item.dart';
import 'package:bili_you/common/models/local/video/video_play_info.dart';
import 'package:bili_you/common/models/local/video/video_play_item.dart';
import 'package:bili_you/common/utils/index.dart';
import 'package:bili_you/common/widget/video_audio_player.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_danmaku.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
  //每15秒执行一次的timer，用来更新播放记录
  late Timer heartBeat;

  Future<bool> loadVideo(String bvid, int cid) async {
    if (widget.controller._videoAudioController != null) {
      return true;
    }

    if (widget.controller.videoPlayInfo == null) {
      try {
        //加载视频播放信息
        widget.controller.videoPlayInfo =
            await VideoPlayApi.getVideoPlay(bvid: bvid, cid: cid);
      } catch (e) {
        log("bili_video_player.loadVideo:$e");
        return false;
      }
    }

    var videoPlayInfo = widget.controller.videoPlayInfo;
    if (widget.controller._videoPlayItem == null) {
      //根据偏好选择画质
      List<VideoPlayItem> tempMatchVideos = [];
      //先匹配编码
      for (var i in videoPlayInfo!.videos) {
        if (i.codecs.contains(BiliYouStorage.settings
            .get(SettingsStorageKeys.preferVideoCodec, defaultValue: 'hev'))) {
          tempMatchVideos.add(i);
        }
      }
      //如果编码没有匹配上，就只能不匹配编码了
      if (tempMatchVideos.isEmpty) {
        tempMatchVideos = videoPlayInfo.videos;
      }
      //根据VideoQuality下标判断最接近的画质
      var matchedVideo = tempMatchVideos.first;
      var preferVideoQualityIndex = SettingsUtil.getPreferVideoQuality().index;
      for (var i in tempMatchVideos) {
        if ((i.quality.index - preferVideoQualityIndex).abs() <
            (matchedVideo.quality.index - preferVideoQualityIndex).abs()) {
          matchedVideo = i;
        }
      }
      widget.controller._videoPlayItem = matchedVideo;
    }
    if (widget.controller._audioPlayItem == null) {
      //根据偏好选择音质
      //根据AudioQuality下标判断最接近的音质
      var matchedAudio = videoPlayInfo!.audios.first;
      var preferAudioQualityIndex = SettingsUtil.getPreferAudioQuality().index;
      for (var i in videoPlayInfo.audios) {
        if ((i.quality.index - preferAudioQualityIndex).abs() <
            (matchedAudio.quality.index - preferAudioQualityIndex).abs()) {
          matchedAudio = i;
        }
      }
      widget.controller._audioPlayItem = matchedAudio;
    }
    //获取视频，音频的url
    String videoUrl = widget.controller._videoPlayItem!.urls.first;
    String audioUrl = widget.controller._audioPlayItem!.urls.first;

    //创建播放器
    widget.controller._videoAudioController = VideoAudioController(
        videoUrl: videoUrl,
        audioUrl: audioUrl,
        audioHeaders: VideoPlayApi.videoPlayerHttpHeaders,
        videoHeaders: VideoPlayApi.videoPlayerHttpHeaders,
        autoWakelock: true);
    await widget.controller._videoAudioController!.ensureInitialized();
    if (widget.controller._playWhenInitialize) {
      await widget.controller._videoAudioController!.play();
    }
    widget.controller._videoAudioController!
        .seekTo(widget.controller._initVideoPosition);
    return true;
  }

  updateWidget() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    danmaku = widget.buildDanmaku?.call(context, widget.controller);
    controllPanel = widget.buildControllPanel?.call(context, widget.controller);
    widget.controller._updateAsepectRatioWidget = () {
      if (aspectRatioKey.currentState?.mounted ?? false) {
        aspectRatioKey.currentState!.setState(() {});
      }
    };
    //定时汇报历史记录
    widget.controller._reportHistory();
    heartBeat = Timer.periodic(const Duration(seconds: 15), (timer) {
      widget.controller._reportHistory();
    });
    widget.controller.biliDanmakuController = danmaku?.controller;
    super.initState();
  }

  @override
  void dispose() {
    heartBeat.cancel();
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
      transitionOnUserGestures: true,
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        color: Colors.black,
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
                                PhotoView.customChild(
                                  enableRotation: true,
                                  child: Center(
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
                                        widget.controller._videoAudioController
                                            ?.dispose();
                                        widget.controller
                                            ._videoAudioController = null;
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
                      ));
                });
          },
        ),
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
  bool _playWhenInitialize = true;
  //初始进度
  Duration _initVideoPosition = Duration.zero;
  late Size _size;
  late EdgeInsets _padding;

  late Function() updateWidget;
  late Function() _updateAsepectRatioWidget;
  VideoAudioController? _videoAudioController;
  BiliDanmakuController? biliDanmakuController;
  VideoPlayInfo? videoPlayInfo;
  //当前播放的视频信息
  VideoPlayItem? _videoPlayItem;
  //当前播放的音频信息
  AudioPlayItem? _audioPlayItem;
  // //当前的视频画质
  // VideoQuality? _videoQuality;
  // //当前的音质
  // AudioQuality? _audioQuality;

  VideoPlayItem? get videoPlayItem => _videoPlayItem;
  AudioPlayItem? get audioPlayItem => _audioPlayItem;
  // VideoQuality? get videoQuality => _videoQuality;
  // AudioQuality? get audioQuality => _audioQuality;

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
    videoPlayInfo = null;
    _videoPlayItem = null;
    _audioPlayItem = null;
    _initVideoPosition = Duration.zero;
    this.bvid = bvid;
    this.cid = cid;
    reloadWidget();
  }

  ///切换视频播放源/视频画质
  void changeVideoItem(VideoPlayItem videoPlayItem) {
    _videoPlayItem = videoPlayItem;
    // _videoQuality = videoPlayItem.quality;
    position.then(
      (value) {
        //将初始播放位置设为当前未知再刷新，这样就刷新后就能接上
        _initVideoPosition = value;
        //刷新后是否播放
        _playWhenInitialize = isPlaying;
        reloadWidget();
      },
    );
  }

  ///切换音频播放源/音质
  void changeAudioItem(AudioPlayItem audioPlayItem) {
    _audioPlayItem = audioPlayItem;
    position.then(
      (value) {
        //将初始播放位置设为当前未知再刷新，这样就刷新后就能接上
        _initVideoPosition = value;
        //刷新后是否播放
        _playWhenInitialize = isPlaying;
        reloadWidget();
      },
    );
  }

  //汇报一次历史记录
  Future<void> _reportHistory() async {
    try {
      VideoPlayApi.reportHistory(
          bvid: bvid, cid: cid, playedTime: (await position).inSeconds);
    } catch (e) {
      log(e.toString());
    }
  }

  void toggleFullScreen() {
    if (isFullScreen) {
      isFullScreen = false;
      exitFullScreen();
      portraitUp().then((value) => aspectRatio = 16 / 9);
    } else {
      isFullScreen = true;
      enterFullScreen().then((value) {
        if (videoAspectRatio >= 1) {
          landScape().then((value) => aspectRatio = _size.flipped.aspectRatio);
        } else {
          portraitUp().then((value) =>
              aspectRatio = _size.width / (_size.height - _padding.top));
        }
      });
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
    _reportHistory();
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
    _playWhenInitialize = true;
    await _videoAudioController?.play();
    _reportHistory();
  }

  Future<void> pause() async {
    _playWhenInitialize = false;
    await _videoAudioController?.pause();
    _reportHistory();
  }

  Future<void> seekTo(Duration position) async {
    await _videoAudioController?.seekTo(position);
    _reportHistory();
  }

  Future<void> setPlayBackSpeed(double speed) async {
    await _videoAudioController?.setPlayBackSpeed(speed);
  }
}
