import 'dart:async';
import 'dart:developer';
import 'dart:io';

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
  Player? player;
  int count = 0;
  bool _isPlayerReady = false;
  StreamSubscription<bool>? bufferingListen;
  StreamSubscription<bool>? playingListen;
  StreamSubscription<bool>? completedListen;
  StreamSubscription<Duration>? positionListen;
  StreamSubscription<double>? rateListen;
  StreamSubscription<Duration>? bufferListen;
  StreamSubscription? errorListen;
  StreamSubscription<Duration>? durationListen;
  StreamSubscription<int>? widthListen;
  StreamSubscription<int>? heightListen;

  Future<void> cancelSubscriptions() async {
    await bufferingListen?.cancel();
    await playingListen?.cancel();
    await completedListen?.cancel();
    await positionListen?.cancel();
    await rateListen?.cancel();
    await bufferListen?.cancel();
    await errorListen?.cancel();
    await durationListen?.cancel();
    await widthListen?.cancel();
    await heightListen?.cancel();
  }

  void pauseSubscriptions() {
    bufferingListen?.pause();
    playingListen?.pause();
    completedListen?.pause();
    positionListen?.pause();
    rateListen?.pause();
    bufferListen?.pause();
    errorListen?.pause();
    durationListen?.pause();
    widthListen?.pause();
    heightListen?.pause();
  }

  void resumeSubscriptions() {
    bufferingListen?.resume();
    playingListen?.resume();
    completedListen?.resume();
    positionListen?.resume();
    rateListen?.resume();
    bufferListen?.resume();
    errorListen?.resume();
    durationListen?.resume();
    widthListen?.resume();
    heightListen?.resume();
  }

  void initSubscriptions() {
    bufferingListen = player?.streams.buffering.listen((e) {});
    playingListen = player?.streams.playing.listen((e) {});
    completedListen = player?.streams.completed.listen((e) {});
    positionListen = player?.streams.position.listen((e) {});
    rateListen = player?.streams.rate.listen((e) {});
    bufferListen = player?.streams.buffer.listen((e) {});
    errorListen = player?.streams.error.listen((e) {});
    durationListen = player?.streams.duration.listen((e) {});
    widthListen = player?.streams.width.listen((event) {});
    heightListen = player?.streams.height.listen((event) {});
  }

  Future<void> init() async {
    if (player == null && videoController == null) {
      player = Player(
          configuration: PlayerConfiguration(
        ready: () => _isPlayerReady = true,
      ));
      await cancelSubscriptions();
      initSubscriptions();
      videoController = await VideoController.create(player!,
          enableHardwareAcceleration: SettingsUtil.getValue(
              SettingsStorageKeys.isHardwareDecode,
              defaultValue: true));
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        if (_isPlayerReady) {
          return false;
        }
        return true;
      });
    }
  }

  Future<void> dispose() async {
    await videoController?.dispose();
    videoController = null;
    await player?.dispose();
    player = null;
    _isPlayerReady = false;
    count = 0;
  }
}

class VideoAudioController {
  VideoAudioController({
    this.videoUrl = '',
    this.audioUrl = '',
    this.headers,
    this.autoWakelock = false,
    this.initStart = false,
    this.initSpeed = 1,
    this.initDuration = Duration.zero,
  });
  String videoUrl;
  String audioUrl;
  final Map<String, String>? headers;
  bool autoWakelock;
  final bool initStart;
  final double initSpeed;
  final Duration initDuration;

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
      await PlayersSingleton().player?.setRate(initSpeed);
    }
    _initialized = true;
  }

  // 刷新播放器数据
  // 如果还需要换音视频源的话，还需要在调用前改变videoUrl,audioUrl
  Future<void> refresh() async {
    //重置几个值
    state.isBuffering = false;
    state.buffered = Duration.zero;
    state.hasError = false;
    var lastPosition =
        state.position >= Duration.zero ? state.position : Duration.zero;
    var lastIsPlaying = state.isPlaying;
    PlayersSingleton().pauseSubscriptions();
    //播放器单例引用
    var player = PlayersSingleton().player!;
    //设置header
    {
      var name = 'http-header-fields';
      var kvArray = <String>[];
      if (headers != null) {
        kvArray = [];
        headers!.forEach((key, value) => kvArray.add('$key: $value'));
        if (player.platform is libmpvPlayer) {
          await (player.platform as libmpvPlayer)
              .setProperty(name, kvArray.join(','));
        }
      }
    }
    //设置音频源
    if (audioUrl.isNotEmpty) {
      await (player.platform as libmpvPlayer).setProperty(
          'audio-files',
          Platform.isWindows
              ? audioUrl.replaceAll(';', '\\;')
              : audioUrl.replaceAll(':', '\\:'));
    }
    //设置视频源
    await player.open(Media(videoUrl), play: false);
    //设置监听
    _setStreamListener();
    PlayersSingleton().resumeSubscriptions();
    await player.pause();
    //如果已经初始化了,就恢复播放状态
    if (_initialized) {
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        //等到position变为0时才是加载完成,此时才能进行调整进度,或播放/暂停
        if (state.position.inMilliseconds == 0) {
          state.isPlaying = false;
          state.isBuffering = false;
          log('lastPosition:${lastPosition.inMilliseconds}');
          if (lastPosition.inMilliseconds != state.position.inMilliseconds) {
            await player.seek(lastPosition);
          }
          //如果之前的state是播放，就播放
          if (lastIsPlaying && !state.isEnd) {
            await player.play();
          }
          return false;
        } else {
          return true;
        }
      });
    }
  }

  void _setStreamListener() {
    // 进度监听
    PlayersSingleton().positionListen!.onData((event) async {
      log('position:$event');
      state.position = event >= Duration.zero ? event : Duration.zero;
      for (var element in _listeners) {
        element();
      }
    });
    // 播放/暂停监听
    PlayersSingleton().playingListen!.onData((event) async {
      log('play:$event');
      if (!state.isBuffering) {
        state.isPlaying = event;
      }
      if (state.speed != PlayersSingleton().player?.state.rate) {
        PlayersSingleton().player?.setRate(state.speed);
      }
      _callStateChangeListeners();
    });
    // 缓冲状态
    PlayersSingleton().bufferingListen!.onData((event) async {
      log('buffering:$event');
      state.isBuffering = event;
      _callStateChangeListeners();
    });
    // 播放完成监听
    PlayersSingleton().completedListen!.onData((event) async {
      log('complete:$event');
      state.isEnd = event;
      _callStateChangeListeners();
    });
    // 倍速监听
    PlayersSingleton().rateListen!.onData((event) => state.speed = event);
    // 缓冲监听
    PlayersSingleton().bufferListen!.onData((event) {
      state.buffered = event;
      _callStateChangeListeners();
    });
    // 错误监听
    PlayersSingleton().errorListen!.onData((event) {
      state.hasError = event.code == 0;
      _callStateChangeListeners();
    });
    // 时长监听
    PlayersSingleton()
        .durationListen!
        .onData((event) => state.duration = event);
    //宽高监听
    PlayersSingleton().widthListen!.onData((event) => state.width = event);
    PlayersSingleton().heightListen!.onData((event) => state.height = event);
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
    await PlayersSingleton().player?.play();
  }

  Future<void> pause() async {
    state.isPlaying = false;
    await PlayersSingleton().player?.pause();
  }

  Future<void> seekTo(Duration position) async {
    await PlayersSingleton().player?.seek(position);
    state.position = position;
    for (var element in _seekToListeners) {
      element(position);
    }
  }

  Future<void> setPlayBackSpeed(double speed) async {
    state.speed = speed;
    await PlayersSingleton().player?.setRate(speed);
  }

  Future<void> dispose() async {
    await pause();
    PlayersSingleton().count--;
  }

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

  void changeCanvasScale(double scale) {
    state.canvasScale = scale.clamp(0.25, 4);
    PlayersSingleton().videoController?.setSize(
        width:
            (PlayersSingleton().videoController?.width ?? 1 * state.canvasScale)
                .toInt(),
        height: (PlayersSingleton().videoController?.height ??
                1 * state.canvasScale)
            .toInt());
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
  double canvasScale = 1;
}
