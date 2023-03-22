import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class VideoAudioPlayer extends StatefulWidget {
  const VideoAudioPlayer(this.controller, {super.key});
  final VideoAudioController controller;
  @override
  State<VideoAudioPlayer> createState() => _VideoAudioPlayerState();
}

class _VideoAudioPlayerState extends State<VideoAudioPlayer> {
  @override
  Widget build(BuildContext context) {
    return VideoPlayer(widget.controller._videoPlayerController!);
  }
}

class VideoAudioController {
  VideoAudioController(
      {required this.videoUrl,
      required this.audioUrl,
      Map<String, String>? videoHeaders,
      Map<String, String>? audioHeaders,
      this.autoWakelock = false})
      : _videoHeaders = videoHeaders ?? {},
        _audioHeaders = audioHeaders ?? {} {
    _init();
  }
  final String videoUrl;
  final Map<String, String> _videoHeaders;
  final String audioUrl;
  final Map<String, String> _audioHeaders;
  bool autoWakelock; //可以读写操作
  VideoAudioPlayerValue value = VideoAudioPlayerValue();
  final VideoAudioPlayerValue _lastValue = VideoAudioPlayerValue();
  VideoPlayerController? _videoPlayerController;
  VideoPlayerController? _audioPlayerController;
  VideoPlayerController? get videoPlayerController => _videoPlayerController;
  VideoPlayerController? get audioPlayerController => _audioPlayerController;
  final List<Function(VideoAudioPlayerValue)> _stateChangedListeners = [];
  final List<VoidCallback> _listeners = [];
  final List<Function(Duration position)> _seekToListeners = [];
  late Timer timer;
  Future<Duration> get position async =>
      await _audioPlayerController?.position ?? Duration.zero;
  bool get hasError {
    if ((_videoPlayerController?.value.hasError ?? false) ||
        (_audioPlayerController?.value.hasError ?? false)) {
      return true;
    } else {
      return false;
    }
  }

  bool _isPlayPauseLocked = false;
  bool _isInitializedLocked = false;

  bool _toPlay = false;
  bool _toPause = false;

  void _videoPlayerControllerCallback() {
    //检查是否播放到结尾了
    if (_videoPlayerController!.value.position ==
        _videoPlayerController!.value.duration) {
      value.isPlaying = false;
      if (_videoPlayerController!.value.isPlaying) {
        _videoPlayerController!.pause();
      }
      if (_audioPlayerController!.value.isPlaying) {
        _audioPlayerController!.pause();
      }
      value.isEnd = true;
    } else {
      if (value.isEnd) {
        _callSeekToListeners(Duration.zero);
        value.isEnd = false;
      }
    }
    value.buffered = _videoPlayerController!.value.buffered;
  }

  void _audioPlayerControllerCallback() {}

  void autoWakelockCallback(VideoAudioPlayerValue value) {
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

  void _init() async {
    _videoPlayerController ??= VideoPlayerController.network(videoUrl,
        httpHeaders: _videoHeaders,
        videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true, allowBackgroundPlayback: true));

    _audioPlayerController ??= VideoPlayerController.network(audioUrl,
        httpHeaders: _audioHeaders,
        videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true, allowBackgroundPlayback: true));
    _videoPlayerController!.setVolume(0);
    _videoPlayerController!.addListener(_videoPlayerControllerCallback);
    _audioPlayerController!.addListener(_audioPlayerControllerCallback);
    addStateChangedListener(autoWakelockCallback);

    timer = Timer.periodic(const Duration(milliseconds: 17), (timer) {
      if (value.isInitialized) {
        () async {
          if (!_isPlayPauseLocked) {
            _isPlayPauseLocked = true;
            if (_toPlay) {
              if (value.isEnd) {
                value.isEnd = false;
                await _videoPlayerController!.seekTo(Duration.zero);
                await _audioPlayerController!.seekTo(Duration.zero);
              } else {
                await _videoPlayerController!.play();
                await _audioPlayerController!.play();
                value.isPlaying = true;
                _toPlay = false;
              }
            } else if (_toPause) {
              await _videoPlayerController!.pause();
              await _audioPlayerController!.pause();
              _toPause = false;
            } else if (value.isPlaying) {
              var isVideoPlaying = _videoPlayerController!.value.isPlaying;
              var isVideoBuffering = _videoPlayerController!.value.isBuffering;
              var isAudioPlaying = _audioPlayerController!.value.isPlaying;
              var isAudioBuffering = _audioPlayerController!.value.isBuffering;
              // var videoDuration = _videoPlayerController.value.duration;
              // var audioDuration = _audioPlayerController.value.duration;
              var videoPos = (await _videoPlayerController!.position)!;
              var audioPos = (await _audioPlayerController!.position)!;
              if (value.isPlaying) {
                if (isVideoPlaying &&
                    isVideoBuffering &&
                    isAudioPlaying &&
                    isAudioBuffering) {
                  //缓冲状态
                  value.isBuffering = true;
                } else if (isVideoPlaying &&
                    isVideoBuffering &&
                    isAudioPlaying &&
                    !isAudioBuffering) {
                  //声音暂停等待视频缓冲
                  await _audioPlayerController!.pause();
                  value.isBuffering = true;
                } else if (isVideoPlaying &&
                    !isVideoBuffering &&
                    isAudioPlaying &&
                    isAudioBuffering) {
                  //视频暂停等待声音缓冲
                  await _videoPlayerController!.pause();
                  value.isBuffering = true;
                } else if (isVideoPlaying &&
                    !isVideoBuffering &&
                    isAudioPlaying &&
                    !isAudioBuffering) {
                  await () async {
                    //变速同步
                    if ((videoPos.inMilliseconds - audioPos.inMilliseconds) >
                        17) {
                      await _videoPlayerController!
                          .setPlaybackSpeed(value.speed - 0.25);
                      // log('video sync: changed speed to ${value.speed - 0.25}');
                    } else if ((videoPos.inMilliseconds -
                            audioPos.inMilliseconds) <
                        -17) {
                      await _videoPlayerController!
                          .setPlaybackSpeed(value.speed + 0.25);
                      // log('video sync: changed speed to ${value.speed + 0.25}');
                    } else if (_videoPlayerController!.value.playbackSpeed !=
                        1) {
                      await _videoPlayerController!
                          .setPlaybackSpeed(value.speed);
                      // log('video sync: changed speed to ${value.speed}');
                    }
                  }();
                } else if (isVideoPlaying &&
                    !isVideoBuffering &&
                    !isAudioPlaying) {
                  //视频缓冲完成,声音继续播放
                  await _audioPlayerController!.play();
                  value.isBuffering = false;
                } else if (isAudioPlaying &&
                    !isAudioBuffering &&
                    !isVideoPlaying) {
                  //声音缓冲完成,视频继续播放
                  await _videoPlayerController!.play();
                  value.isBuffering = false;
                } else if (!isVideoPlaying && !isAudioPlaying) {
                  //视频因外部原因暂停
                  value.isPlaying = false;
                  value.isBuffering = false;
                }
              } else {
                //视频暂停
                await _videoPlayerController!.pause();
                await _audioPlayerController!.pause();
                value.isBuffering = false;
              }
            }
            //检测状态变化并调用相应的监听器回调
            if (value.isBuffering != _lastValue.isBuffering) {
              _lastValue.isBuffering = value.isBuffering;
              _callStateChangedListeners();
              // log("isBuffering changed");
            }
            if (value.isPlaying != _lastValue.isPlaying) {
              _lastValue.isPlaying = value.isPlaying;
              _callStateChangedListeners();
              // log("isPlaying changed");
            }
            if (value.isEnd != _lastValue.isEnd) {
              _lastValue.isEnd = value.isEnd;
              _callStateChangedListeners();
              // log("isEnd changed");
            }
            // log("isPlaying:${value.isPlaying}");
            // log("isEnd:${value.isEnd}");
            _callListeners();
            _isPlayPauseLocked = false;
          }
        }();
      }
    });
  }

//listen when isPlaying or isBuffering changed
  void addStateChangedListener(Function(VideoAudioPlayerValue value) listener) {
    _stateChangedListeners.add(listener);
  }

  void removeStateChangedListener(
      Function(VideoAudioPlayerValue value) listener) {
    _stateChangedListeners.remove(listener);
  }

  void addSeekToListener(Function(Duration position) listener) {
    _seekToListeners.add(listener);
  }

  void removeSeekToListener(Function(Duration position) listener) {
    _seekToListeners.remove(listener);
  }

  void _callSeekToListeners(Duration position) {
    for (var i in _seekToListeners) {
      i(position);
    }
  }

  void _callStateChangedListeners() {
    for (var i in _stateChangedListeners) {
      i(value);
    }
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _callListeners() {
    for (var i in _listeners) {
      i();
    }
  }

  Future<void> ensureInitialized() async {
    if (!_isInitializedLocked) {
      _isInitializedLocked = true;
      if (!value.isInitialized) {
        if (!_videoPlayerController!.value.isInitialized) {
          await _videoPlayerController!.initialize();
        }
        value.duration = _videoPlayerController!.value.duration;
        value._aspectRatio = _videoPlayerController!.value.aspectRatio;
        if (!_audioPlayerController!.value.isInitialized) {
          await _audioPlayerController!.initialize();
        }
        value.isInitialized = true;
        _audioPlayerController!.seekTo(Duration.zero);
        _videoPlayerController!.seekTo(Duration.zero);
      }
    }
    _isInitializedLocked = false;
  }

  Future<void> pause() async {
    if (_isPlayPauseLocked) {
      _toPlay = false;
      _toPause = true;
    } else {
      await _videoPlayerController!.pause();
      await _audioPlayerController!.pause();
    }
    value.isPlaying = false;
  }

  Future<void> play() async {
    if (_isPlayPauseLocked) {
      _toPause = false;
      _toPlay = true;
    } else {
      await _videoPlayerController?.play();
      await _audioPlayerController?.play();
      value.isPlaying = true;
    }
  }

  Future<void> seekTo(Duration position) async {
    await _videoPlayerController?.seekTo(position);
    await _audioPlayerController?.seekTo(position);
    value.position = position;
    _callSeekToListeners(position);
  }

  Future<void> setPlayBackSpeed(double speed) async {
    await _videoPlayerController?.setPlaybackSpeed(speed);
    await _audioPlayerController?.setPlaybackSpeed(speed);
    value.speed = speed;
  }

  Future<void> dispose() async {
    timer.cancel();
    value.isPlaying = false;
    value.isBuffering = false;
    _videoPlayerController?.removeListener(_videoPlayerControllerCallback);
    _audioPlayerController?.removeListener(_audioPlayerControllerCallback);
    removeStateChangedListener(autoWakelockCallback);
    _stateChangedListeners.clear();
    _listeners.clear();
    await _videoPlayerController?.pause();
    await _audioPlayerController?.pause();
    await _videoPlayerController?.dispose();
    _videoPlayerController = null;
    await _audioPlayerController?.dispose();
    _audioPlayerController = null;
  }
}

class VideoAudioPlayerValue {
  bool isInitialized = false;
  bool isPlaying = false;
  bool isBuffering = false;
  bool isEnd = false;
  double _aspectRatio = 1;
  double get aspectRatio => _aspectRatio;
  double speed = 1;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  List<DurationRange> buffered = [];
}
