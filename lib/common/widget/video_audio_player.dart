import 'dart:async';
import 'dart:developer';

import 'package:bili_you/common/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:wakelock/wakelock.dart';

class VideoAudioPlayer extends StatefulWidget {
  const VideoAudioPlayer(this.controller,
      {super.key,
      this.width,
      this.height,
      this.asepectRatio,
      this.fit = BoxFit.contain});
  final VideoAudioController controller;
  final double? width;
  final double? height;
  final double? asepectRatio;
  final BoxFit fit;

  @override
  State<VideoAudioPlayer> createState() => _VideoAudioPlayerState();
}

class _VideoAudioPlayerState extends State<VideoAudioPlayer> {
  @override
  void initState() {
    Future.microtask(() async {
      await widget.controller.init();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Video(
      controller: PlayersSingleton().videoController,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      aspectRatio: widget.asepectRatio,
    );
  }
}

class PlayersSingleton {
  static final PlayersSingleton _instance = PlayersSingleton._internal();
  factory PlayersSingleton() => _instance;
  PlayersSingleton._internal();
  VideoController? videoController;
  Player? videoPlayer;
  Player? audioPlayer;
  int count = 0;
  bool _isVideoReady = false;
  bool _isAudioReady = false;
  StreamSubscription<bool>? audioBufferingListen;
  StreamSubscription<bool>? audioPlayingListen;
  StreamSubscription<bool>? audioCompletedListen;
  StreamSubscription<Duration>? audioPositionListen;
  StreamSubscription<double>? audioRateListen;
  StreamSubscription<Duration>? audioBufferListen;
  StreamSubscription? audioErrorListen;
  StreamSubscription<Duration>? audioDurationListen;
  StreamSubscription<bool>? videoBufferingListen;
  StreamSubscription<Duration>? videoPositionListen;
  StreamSubscription<int>? videoWidthListen;
  StreamSubscription<int>? videoHeightListen;

  Future<void> cancelSubscriptions() async {
    await audioBufferingListen?.cancel();
    await audioPlayingListen?.cancel();
    await audioCompletedListen?.cancel();
    await audioPositionListen?.cancel();
    await audioRateListen?.cancel();
    await audioBufferListen?.cancel();
    await audioErrorListen?.cancel();
    await audioDurationListen?.cancel();
    await videoBufferingListen?.cancel();
    await videoPositionListen?.cancel();
    await videoWidthListen?.cancel();
    await videoHeightListen?.cancel();
  }

  void pauseSubscriptions() {
    audioBufferingListen?.pause();
    audioPlayingListen?.pause();
    audioCompletedListen?.pause();
    audioPositionListen?.pause();
    audioRateListen?.pause();
    audioBufferListen?.pause();
    audioErrorListen?.pause();
    audioDurationListen?.pause();
    videoBufferingListen?.pause();
    videoPositionListen?.pause();
    videoWidthListen?.pause();
    videoHeightListen?.pause();
  }

  void resumeSubscriptions() {
    audioBufferingListen?.resume();
    audioPlayingListen?.resume();
    audioCompletedListen?.resume();
    audioPositionListen?.resume();
    audioRateListen?.resume();
    audioBufferListen?.resume();
    audioErrorListen?.resume();
    audioDurationListen?.resume();
    videoBufferingListen?.resume();
    videoPositionListen?.resume();
    videoWidthListen?.resume();
    videoHeightListen?.resume();
  }

  void initSubscriptions() {
    audioBufferingListen = audioPlayer?.streams.buffering.listen((e) {});
    audioPlayingListen = audioPlayer?.streams.playing.listen((e) {});
    audioCompletedListen = audioPlayer?.streams.completed.listen((e) {});
    audioPositionListen = audioPlayer?.streams.position.listen((e) {});
    audioRateListen = audioPlayer?.streams.rate.listen((e) {});
    audioBufferListen = audioPlayer?.streams.buffer.listen((e) {});
    audioErrorListen = audioPlayer?.streams.error.listen((e) {});
    audioDurationListen = audioPlayer?.streams.duration.listen((e) {});
    videoBufferingListen = videoPlayer?.streams.buffering.listen((e) {});
    videoPositionListen = videoPlayer?.streams.position.listen((e) {});
    videoWidthListen = videoPlayer?.streams.width.listen((e) {});
    videoHeightListen = videoPlayer?.streams.height.listen((e) {});
  }

  Future<void> init() async {
    if (videoPlayer == null && audioPlayer == null && videoController == null) {
      videoPlayer = Player(
          configuration: PlayerConfiguration(
        ready: () => _isVideoReady = true,
      ));
      audioPlayer = Player(
          configuration: PlayerConfiguration(
        ready: () => _isAudioReady = true,
      ));
      await cancelSubscriptions();
      initSubscriptions();
      // 显示的是视频
      videoController = await VideoController.create(videoPlayer!,
          enableHardwareAcceleration: BiliYouStorage.settings
              .get(SettingsStorageKeys.isHardwareDecode, defaultValue: true));
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        if (_isVideoReady && _isAudioReady) {
          return false;
        }
        return true;
      });
    }
  }

  Future<void> dispose() async {
    await videoController?.dispose();
    videoController = null;
    await videoPlayer?.dispose();
    videoPlayer = null;
    await audioPlayer?.dispose();
    audioPlayer = null;
    _isAudioReady = false;
    _isVideoReady = false;
    count = 0;
  }
}

class VideoAudioController {
  VideoAudioController({
    this.videoUrl = '',
    this.audioUrl = '',
    this.videoHeaders,
    this.audioHeaders,
    this.autoWakelock = false,
    this.initStart = false,
  });
  String videoUrl;
  String audioUrl;
  final Map<String, String>? videoHeaders;
  final Map<String, String>? audioHeaders;
  bool autoWakelock;
  final bool initStart;

  final VideoAudioState state = VideoAudioState();
  bool _initialized = false;

  final List<Function(VideoAudioState state)> _stateChangedListeners = [];
  final List<VoidCallback> _listeners = [];
  final List<Function(Duration position)> _seekToListeners = [];

  Future<void> init() async {
    if (_initialized) {
      log('当前播放器控制器已经初始化过了');
      return;
    }
    //如果还没有播放器实例就创建
    if (PlayersSingleton().count == 0) {
      await PlayersSingleton().init();
    }
    //每初始化一次计数就加1
    PlayersSingleton().count++;
    await refresh();
    if (initStart) {
      await play();
    }
    _initialized = true;
  }

  // 刷新播放器数据
  // 如果还需要换音视频源的话，还需要在调用前改变videoUrl,audioUrl
  Future<void> refresh() async {
    //重置几个值
    // state.isEnd = false;
    state.isBuffering = false;
    state.buffered = Duration.zero;
    state.hasError = false;
    var lastPosition =
        state.position >= Duration.zero ? state.position : Duration.zero;
    var lastIsPlaying = state.isPlaying;
    PlayersSingleton().pauseSubscriptions();
    //播放器单例引用
    var videoPlayer = PlayersSingleton().videoPlayer!;
    var audioPlayer = PlayersSingleton().audioPlayer!;
    //设置header
    {
      var name = 'http-header-fields';
      var kvArray = <String>[];
      if (videoHeaders != null) {
        videoHeaders!.forEach((key, value) => kvArray.add('$key: $value'));
        if (videoPlayer.platform is libmpvPlayer) {
          await (videoPlayer.platform as libmpvPlayer)
              .setProperty(name, kvArray.join(','));
        }
      }
      if (audioHeaders != null) {
        kvArray = [];
        audioHeaders!.forEach((key, value) => kvArray.add('$key: $value'));
        if (audioPlayer.platform is libmpvPlayer) {
          await (audioPlayer.platform as libmpvPlayer)
              .setProperty(name, kvArray.join(','));
        }
      }
    }

    //打开当前链接
    await videoPlayer.open(Media(videoUrl), play: false);
    await audioPlayer.open(Media(audioUrl), play: false);
    // 视频缓冲监听
    PlayersSingleton().videoBufferingListen!.onData((event) async {
      //如果视频变为缓冲状态，而声音在播放时且不为缓冲时，暂停声音
      if (event && audioPlayer.state.playing && !audioPlayer.state.buffering) {
        await audioPlayer.pause();
        state.isBuffering = true;
        state.isPlaying = true;
      }
      // 如果视频不再缓冲且正在播放，而声音暂停时，可以认为缓冲结束了
      if (!state.isEnd &&
          !event &&
          videoPlayer.state.playing &&
          !audioPlayer.state.playing) {
        await audioPlayer.play(); // 继续播放声音
        state.isBuffering = false;
        state.isPlaying = true;
      }
    });
    // PlayersSingleton().videoPositionListen!.onData((event) async {
    //   log('num:' + videoPlayer.state.playlist.medias.length.toString());
    //   if (state.isEnd) {
    //     await videoPlayer.seek(audioPlayer.state.position);
    //   }
    // });
    // 以音频为准，同步视频
    // 进度监听
    PlayersSingleton().audioPositionListen!.onData((event) async {
      if (state.isEnd) return;
      state.position = event >= Duration.zero ? event : Duration.zero;
      var delta = audioPlayer.state.position.inMilliseconds -
          videoPlayer.state.position.inMilliseconds;
      log(delta.toString());
      if (delta > -18 && delta < 18) {
        if (state.speed != videoPlayer.state.rate) {
          await videoPlayer.setRate(state.speed);
        }
      } else if (delta <= -18) {
        double speed = state.speed - 1 * (-delta / 300);
        if (speed < 0) speed = 0;
        if (videoPlayer.state.rate != speed) {
          await videoPlayer.setRate(speed);
        }
      } else if (18 <= delta) {
        if (videoPlayer.state.rate != state.speed + 1 * (delta / 300)) {
          await videoPlayer.setRate(state.speed + 1 * (delta / 300));
        }
      }
      for (var element in _listeners) {
        element();
      }
    });
    // 播放监听
    PlayersSingleton().audioPlayingListen!.onData((event) async {
      if (!state.isBuffering) {
        state.isPlaying = event;
      }
      _callStateChangeListeners();
    });
    // 缓冲状态
    PlayersSingleton().audioBufferingListen!.onData((event) async {
      state.isBuffering = event;
      // 声音变为缓冲状态而视频没在缓冲且在播放则暂停视频
      if (event && !videoPlayer.state.buffering && videoPlayer.state.playing) {
        await videoPlayer.pause();
        state.isBuffering = true;
        state.isPlaying = true;
      }
      // 如果声音不再缓冲且正在播放，而视频暂停时，可以认为缓冲结束了
      if (!state.isEnd &&
          !event &&
          audioPlayer.state.playing &&
          !videoPlayer.state.playing) {
        await videoPlayer.play(); // 继续播放视频
        state.isBuffering = false;
        state.isPlaying = true;
      }
      _callStateChangeListeners();
    });
    PlayersSingleton().audioCompletedListen!.onData((event) async {
      // if (event) {
      //   // await videoPlayer.seek(audioPlayer.state.position);
      //   await videoPlayer.pause();
      //   state.isEnd = true;
      // } else {
      //   state.isEnd = false;
      // }
      log(event.toString());
      state.isEnd = event;
      state.position = audioPlayer.state.duration;
      for (var i in _listeners) {
        i();
      }
      _callStateChangeListeners();
    });
    // 倍速监听
    PlayersSingleton().audioRateListen!.onData((event) => state.speed = event);
    // 缓冲监听
    PlayersSingleton()
        .audioBufferListen!
        .onData((event) => state.buffered = event);
    // 错误监听
    PlayersSingleton()
        .audioErrorListen!
        .onData((event) => state.hasError = event.code == 0);
    // 时长监听
    PlayersSingleton()
        .audioDurationListen!
        .onData((event) => state.duration = event);
    //宽高监听
    PlayersSingleton().videoWidthListen!.onData((event) => state.width = event);
    PlayersSingleton()
        .videoHeightListen!
        .onData((event) => state.height = event);
    PlayersSingleton().resumeSubscriptions();
    if (_initialized) {
      // 如果刷新时进度不是0,就跳转
      state.isPlaying = false;
      state.isBuffering = false;
      state.isEnd = false;

      Timer(const Duration(milliseconds: 600), () async {
        log('position:' + lastPosition.toString());
        await audioPlayer.pause();
        await videoPlayer.pause();
        await audioPlayer.seek(lastPosition);
        await videoPlayer.seek(lastPosition);

        //如果之前的state是播放，就播放
        if (lastIsPlaying) {
          await videoPlayer.play();
          await audioPlayer.play();
        }
      });
    }
  }

  void autoWakelockCallback(VideoAudioState value) {
    if (autoWakelock) {
      if (value.isPlaying) {
        Wakelock.enable();
      } else {
        Wakelock.disable();
      }
    } else {
      Wakelock.disable();
    }
  }

  Future<void> play() async {
    state.isPlaying = true;
    if (state.isEnd) {
      state.isEnd = false;
      state.isBuffering = false;
      log('seek');
      await PlayersSingleton().audioPlayer?.pause();
      await PlayersSingleton().videoPlayer?.pause();
      state.position = Duration.zero;
      await PlayersSingleton().audioPlayer?.seek(Duration.zero);
      await PlayersSingleton().videoPlayer?.seek(Duration.zero);
    }
    await PlayersSingleton().audioPlayer?.play();
    await PlayersSingleton().videoPlayer?.play();
  }

  Future<void> pause() async {
    state.isPlaying = false;
    if (state.isEnd) return;
    await PlayersSingleton().audioPlayer?.pause();
    await PlayersSingleton().videoPlayer?.pause();
  }

  Future<void> seekTo(Duration position) async {
    await PlayersSingleton().audioPlayer?.seek(position);
    await PlayersSingleton().videoPlayer?.seek(position);
    state.position = position;
    for (var element in _seekToListeners) {
      element(position);
    }
  }

  Future<void> setPlayBackSpeed(double speed) async {
    state.speed = speed;
    await PlayersSingleton().audioPlayer?.setRate(speed);
    await PlayersSingleton().videoPlayer?.setRate(speed);
  }

  Future<void> dispose() async {
    // if (PlayersSingleton().count == 0) {
    // state.isPlaying = false;
    await pause();
    // await PlayersSingleton().audioPlayer?.pause();
    // await PlayersSingleton().videoPlayer?.pause();
    //   await PlayersSingleton().dispose();
    // } else {
    PlayersSingleton().count--;
    // }
  }

  //listen when isPlaying or isBuffering changed
  void addStateChangedListener(Function(VideoAudioState value) listener) {
    _stateChangedListeners.add(listener);
  }

  void _callStateChangeListeners() {
    for (var element in _stateChangedListeners) {
      element(state);
    }
    autoWakelockCallback(state);
  }

  void removeStateChangedListener(Function(VideoAudioState value) listener) {
    _stateChangedListeners.remove(listener);
  }

  void addSeekToListener(Function(Duration position) listener) {
    _seekToListeners.add(listener);
  }

  void removeSeekToListener(Function(Duration position) listener) {
    _seekToListeners.remove(listener);
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
}

class VideoAudioState {
  bool isPlaying = true;
  bool isBuffering = true;
  bool isEnd = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  double speed = 1;
  Duration buffered = Duration.zero;
  bool hasError = false;
  int width = 1;
  int height = 1;
}
