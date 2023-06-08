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
import 'package:get/get.dart';

class BiliVideoPlayerWidget extends StatefulWidget {
  const BiliVideoPlayerWidget(this.controller,
      {super.key,
      this.buildDanmaku,
      this.buildControllPanel,
      required this.heroTagId});
  final BiliVideoPlayerController controller;
  final BiliDanmaku Function()? buildDanmaku;
  final Widget Function()? buildControllPanel;
  final int heroTagId;

  @override
  State<BiliVideoPlayerWidget> createState() => _BiliVideoPlayerWidgetState();
}

class _BiliVideoPlayerWidgetState extends State<BiliVideoPlayerWidget> {
  BiliDanmaku? danmaku;
  Widget? controllPanel;

  updateWidget() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    danmaku = widget.buildDanmaku?.call();
    controllPanel = widget.buildControllPanel?.call();
    if (!widget.controller._isInitializedState) {
      //是否进入时即播放
      widget.controller._playWhenInitialize = SettingsUtil.getValue(
          SettingsStorageKeys.autoPlayOnInit,
          defaultValue: true);
      widget.controller.buildDanmaku = widget.buildDanmaku;
      widget.controller.biliDanmakuController = danmaku!.controller;
      widget.controller.buildControllPanel = widget.buildControllPanel;
    }
    widget.controller._isInitializedState = true;
    super.initState();
  }

  @override
  void dispose() async {
    if (widget.controller.isFullScreen) {
      await widget.controller.toggleFullScreen();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.updateWidget = updateWidget;
    return Hero(
      tag: widget.heroTagId,
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        color: Colors.black,
        child: AspectRatio(
            aspectRatio: 16 / 9,
            child: FutureBuilder(
              future: widget.controller
                  .initPlayer(widget.controller.bvid, widget.controller.cid),
              builder: (context, snapshot) {
                late Widget centrolWidget;
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == true) {
                    centrolWidget = VideoAudioPlayer(
                      widget.controller._videoAudioController!,
                      asepectRatio:
                          (widget.controller.videoPlayItem!.width.toDouble() /
                                  widget.controller.videoPlayItem!.height
                                      .toDouble()) *
                              widget.controller.videoPlayItem!.sar,
                    );
                  } else {
                    //加载失败,重试按钮
                    centrolWidget = IconButton(
                        onPressed: () async {
                          await widget.controller._videoAudioController?.play();
                          setState(() {});
                        },
                        icon: const Icon(Icons.refresh_rounded));
                  }
                  return Stack(fit: StackFit.expand, children: [
                    Center(
                      child: centrolWidget,
                    ),
                    Center(
                      child: danmaku,
                    ),
                    Center(
                      child: controllPanel,
                    ),
                  ]);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )),
      ),
    );
  }
}

class BiliVideoPlayerController {
  BiliVideoPlayerController(
      {required this.bvid,
      required this.cid,
      this.initVideoPosition = Duration.zero});
  String bvid;
  int cid;
  bool _isInitializedState = false;
  bool isFullScreen = false;
  bool _playWhenInitialize = true;
  //初始进度
  Duration initVideoPosition;

  late Function() updateWidget;
  late BiliDanmaku Function()? buildDanmaku;
  late Widget Function()? buildControllPanel;
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

  Future<void> reloadWidget() async {
    updateWidget();
    await _videoAudioController?.refresh();
    biliDanmakuController?.reloadDanmaku?.call();
  }

  Future<void> changeCid(String bvid, int cid) async {
    videoPlayInfo = null;
    _videoPlayItem = null;
    _audioPlayItem = null;
    initVideoPosition = Duration.zero;
    this.bvid = bvid;
    this.cid = cid;
    await loadVideoInfo(bvid, cid);
    _videoAudioController?.audioUrl = audioPlayItem!.urls.first;
    _videoAudioController?.videoUrl = videoPlayItem!.urls.first;
    _videoAudioController?.state.position = Duration.zero;
    await reloadWidget();
  }

  Future<bool> loadVideoInfo(String bvid, int cid) async {
    if (videoPlayInfo == null) {
      try {
        //加载视频播放信息
        videoPlayInfo = await VideoPlayApi.getVideoPlay(bvid: bvid, cid: cid);
      } catch (e) {
        log("bili_video_player.loadVideo:$e");
        return false;
      }
    }
    if (_videoPlayItem == null) {
      //根据偏好选择画质
      List<VideoPlayItem> tempMatchVideos = [];
      //先匹配编码
      for (var i in videoPlayInfo!.videos) {
        if (i.codecs.contains(SettingsUtil.getValue(
            SettingsStorageKeys.preferVideoCodec,
            defaultValue: 'hev'))) {
          tempMatchVideos.add(i);
        }
      }
      //如果编码没有匹配上，就只能不匹配编码了
      if (tempMatchVideos.isEmpty) {
        tempMatchVideos = videoPlayInfo!.videos;
      }
      //根据VideoQuality下标判断最接近的画质
      var matchedVideo = tempMatchVideos.isNotEmpty
          ? tempMatchVideos.first
          : VideoPlayItem.zero;
      var preferVideoQualityIndex = SettingsUtil.getPreferVideoQuality().index;
      for (var i in tempMatchVideos) {
        if ((i.quality.index - preferVideoQualityIndex).abs() <
            (matchedVideo.quality.index - preferVideoQualityIndex).abs()) {
          matchedVideo = i;
        }
      }
      _videoPlayItem = matchedVideo;
    }
    if (_audioPlayItem == null) {
      //根据偏好选择音质
      //根据AudioQuality下标判断最接近的音质
      var matchedAudio = videoPlayInfo!.audios.isNotEmpty
          ? videoPlayInfo!.audios.first
          : AudioPlayItem.zero;
      var preferAudioQualityIndex = SettingsUtil.getPreferAudioQuality().index;
      for (var i in videoPlayInfo!.audios) {
        if ((i.quality.index - preferAudioQualityIndex).abs() <
            (matchedAudio.quality.index - preferAudioQualityIndex).abs()) {
          matchedAudio = i;
        }
      }
      _audioPlayItem = matchedAudio;
    }
    return true;
  }

  Future<bool> initPlayer(String bvid, int cid) async {
    //如果不是第一次的话就跳过
    if (_videoAudioController != null) {
      return true;
    }
    //加载视频播放信息
    if (await loadVideoInfo(bvid, cid) == false) return false;
    //获取视频，音频的url
    String videoUrl =
        _videoPlayItem!.urls.isNotEmpty ? _videoPlayItem!.urls.first : '';
    String audioUrl =
        _audioPlayItem!.urls.isNotEmpty ? _audioPlayItem!.urls.first : '';
    //创建播放器
    _videoAudioController = VideoAudioController(
        videoUrl: videoUrl,
        audioUrl: audioUrl,
        headers: VideoPlayApi.videoPlayerHttpHeaders,
        autoWakelock: true,
        initStart: _playWhenInitialize,
        initSpeed: SettingsUtil.getValue(
            SettingsStorageKeys.defaultVideoPlaybackSpeed,
            defaultValue: 1.0),
        initDuration: initVideoPosition);

    await _videoAudioController!.init();

    //是否进入就全屏
    bool isFullScreenPlayOnEnter = SettingsUtil.getValue(
        SettingsStorageKeys.fullScreenPlayOnEnter,
        defaultValue: false);
    if (isFullScreenPlayOnEnter) {
      isFullScreen = false;
      toggleFullScreen();
    }
    var lastTime = DateTime.now().millisecondsSinceEpoch;
    addListener(() async {
      //每帧更新历史播放进度
      //限制一秒更新进度一次，防止频繁更新
      if (DateTime.now().millisecondsSinceEpoch - lastTime >= 1000) {
        await _reportHistory();
        lastTime = DateTime.now().millisecondsSinceEpoch;
      }
    });
    //当播放状态改变时更新历史播放进度
    addStateChangedListener((state) async {
      await _reportHistory();
    });
    return true;
  }

  ///切换视频播放源/视频画质
  void changeVideoItem(VideoPlayItem videoPlayItem) {
    _videoPlayItem = videoPlayItem;
    _videoAudioController!.videoUrl = videoPlayItem.urls.first;
    _videoAudioController!.refresh();
    // reloadWidget();
  }

  ///切换音频播放源/音质
  void changeAudioItem(AudioPlayItem audioPlayItem) {
    _audioPlayItem = audioPlayItem;
    _videoAudioController!.audioUrl = audioPlayItem.urls.first;
    _videoAudioController!.refresh();
    // reloadWidget();
  }

  //汇报一次历史记录
  Future<void> _reportHistory() async {
    try {
      if (_videoAudioController!.state.isEnd) {
        //看完时
        await VideoPlayApi.reportHistory(bvid: bvid, cid: cid, playedTime: -1);
      } else {
        //未看完时
        await VideoPlayApi.reportHistory(
            bvid: bvid, cid: cid, playedTime: position.inSeconds);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> refreshPlayer() async {
    await _videoAudioController?.refresh();
  }

  Future<void> toggleFullScreen() async {
    if (isFullScreen) {
      //退出全屏
      isFullScreen = false;
      await exitFullScreen();
      await portraitUp();
    } else {
      //进入全屏
      isFullScreen = true;
      await enterFullScreen();
      if (videoAspectRatio >= 1) {
        await landScape();
      } else {
        await portraitUp();
      }
      showDialog(
        context: Get.context!,
        useSafeArea: false,
        builder: (context) => Dialog.fullscreen(
            backgroundColor: Colors.black,
            child: BiliVideoPlayerWidget(
              this,
              heroTagId: -1,
              buildControllPanel: buildControllPanel,
              buildDanmaku: buildDanmaku,
            )),
      );
    }
  }

  void addListener(VoidCallback listener) {
    _videoAudioController?.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    _videoAudioController?.removeListener(listener);
  }

  void addStateChangedListener(Function(VideoAudioState state) listener) {
    _videoAudioController?.addStateChangedListener(listener);
  }

  void removeStateChangedListener(Function(VideoAudioState state) listener) {
    _videoAudioController?.removeStateChangedListener(listener);
  }

  void addSeekToListener(Function(Duration position) listener) {
    _videoAudioController?.addSeekToListener(listener);
  }

  void removeSeekToListener(Function(Duration position) listener) {
    _videoAudioController?.addSeekToListener(listener);
  }

  Future<void> dispose() async {
    await _videoAudioController?.dispose();
  }

  Duration get position {
    return _videoAudioController?.state.position ?? Duration.zero;
  }

  Duration get duration {
    return _videoAudioController?.state.duration ?? Duration.zero;
  }

  double get speed => _videoAudioController?.state.speed ?? 1;

  double get videoAspectRatio =>
      (_videoAudioController?.state.width ?? 1) /
      (_videoAudioController?.state.height ?? 1);

  bool get isPlaying {
    return _videoAudioController?.state.isPlaying ?? false;
  }

  bool get isBuffering {
    return _videoAudioController?.state.isBuffering ?? false;
  }

  bool get hasError {
    return _videoAudioController?.state.hasError ?? false;
  }

  Duration get fartherestBuffered {
    if (_videoAudioController == null) {
      return Duration.zero;
    }

    return _videoAudioController!.state.buffered;
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
