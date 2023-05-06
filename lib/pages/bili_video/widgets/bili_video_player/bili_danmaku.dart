import 'dart:developer';

import 'package:bili_you/common/api/danmaku_api.dart';
import 'package:bili_you/common/models/network/proto/danmaku/danmaku.pb.dart';
import 'package:bili_you/common/utils/index.dart';
import 'package:bili_you/common/widget/video_audio_player.dart';

import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_video_player.dart';
import 'package:flutter/material.dart';
import 'package:ns_danmaku/danmaku_controller.dart';
import 'package:ns_danmaku/danmaku_view.dart';
import 'package:ns_danmaku/models/danmaku_item.dart';
import 'package:ns_danmaku/models/danmaku_option.dart';

class BiliDanmaku extends StatefulWidget {
  const BiliDanmaku({super.key, required this.controller});

  final BiliDanmakuController controller;

  @override
  State<BiliDanmaku> createState() => _BiliDanmakuState();
}

class _BiliDanmakuState extends State<BiliDanmaku> {
  DanmakuController? danmakuController;
  bool isListenerLocked = false;
  bool isPlaying = true;
  void videoPlayerStateChangedCallback(VideoAudioState value) {
    if (value.isBuffering || !value.isPlaying) {
      danmakuController?.pause();
    } else if (value.isPlaying) {
      danmakuController?.resume();
    }
  }

  void videoPlayerSeekToCallback(Duration position) {
    danmakuController?.clear();
    widget.controller._findPositionIndex(position.inMilliseconds);
  }

  void videoPlayerListenerCallback() {
    if (!widget.controller.isDanmakuOpened) {
      danmakuController?.clear();
    }
    if (!isListenerLocked &&
        widget.controller._isInitialized &&
        widget.controller.isDanmakuOpened) {
      isListenerLocked = true;
      var currentPosition =
          (widget.controller.biliVideoPlayerController.position).inMilliseconds;
      if (widget.controller.currentSegmentIndex <
          widget.controller.dmSegList.length) {
        if (widget.controller.currentIndex <
            widget.controller.dmSegList[widget.controller.currentSegmentIndex]
                .elems.length) {
          var element = widget
              .controller
              .dmSegList[widget.controller.currentSegmentIndex]
              .elems[widget.controller.currentIndex];
          var delta = currentPosition - element.progress;
          if (delta >= 0 && delta < 200) {
            late DanmakuItemType type;
            if (element.mode >= 1 && element.mode <= 3) {
              type = DanmakuItemType.scroll;
            } else if (element.mode == 4) {
              type = DanmakuItemType.bottom;
            } else if (element.mode == 5) {
              type = DanmakuItemType.top;
            }
            danmakuController?.addItems([
              DanmakuItem(element.content,
                  color: Color.fromARGB(255, (element.color << 8) >> 24,
                      (element.color << 16) >> 24, (element.color << 24) >> 24),
                  time: element.progress,
                  type: type)
            ]);
            widget.controller.currentIndex++;
          } else {
            widget.controller._findPositionIndex(widget
                .controller.biliVideoPlayerController.position.inMilliseconds);
          }
        } else {
          //换下一节
          widget.controller.currentIndex = 0;
          widget.controller.currentSegmentIndex++;
        }
      }
      // updateWidget();
      danmakuController?.updateOption(DanmakuOption(
          fontSize: 16 * widget.controller.fontScale,
          opacity: widget.controller.fontOpacity,
          area: 0.5,
          duration: widget.controller.initDuration /
              (widget.controller.biliVideoPlayerController.speed *
                  widget.controller.speed)));
      isListenerLocked = false;
    }
  }

  void addAllListeners() {
    var controller = widget.controller;
    controller.biliVideoPlayerController
        .addListener(videoPlayerListenerCallback);
    controller.biliVideoPlayerController
        .addStateChangedListener(videoPlayerStateChangedCallback);
    controller.biliVideoPlayerController
        .addSeekToListener(videoPlayerSeekToCallback);
  }

  void removeAllListeners() {
    var controller = widget.controller;
    controller.biliVideoPlayerController
        .removeListener(videoPlayerListenerCallback);
    controller.biliVideoPlayerController
        .removeSeekToListener(videoPlayerSeekToCallback);
    controller.biliVideoPlayerController
        .removeStateChangedListener(videoPlayerStateChangedCallback);
  }

  @override
  void initState() {
    var controller = widget.controller;
    if (!controller._isInitializedState) {
      if (SettingsUtil.getValue(SettingsStorageKeys.defaultShowDanmaku,
          defaultValue: true)) {
        controller._isDanmakuOpened = true;
      } else {
        controller._isDanmakuOpened = false;
      }
      widget.controller.reloadDanmaku = () {
        widget.controller._isInitialized = false;
        widget.controller.currentIndex = 0;
        widget.controller.currentSegmentIndex = 0;
        widget.controller.dmSegList.clear();
        widget.controller.segmentCount = 0;
        if (mounted) {
          setState(() {});
        }
      };
      widget.controller.refreshDanmaku = () {
        if (mounted) setState(() {});
      };
    }
    widget.controller._isInitializedState = true;

    addAllListeners();
    super.initState();
  }

  @override
  void dispose() {
    if (!widget.controller.biliVideoPlayerController.isFullScreen) {
      danmakuController?.clear();
      danmakuController = null;
    }
    removeAllListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      widget.controller.initDuration = box.maxWidth / 80;
      return DanmakuView(
        createdController: (danmakuController) async {
          widget.controller.initDanmaku();
          this.danmakuController = danmakuController;
        },
        option: DanmakuOption(
            fontSize: 16 * widget.controller.fontScale,
            opacity: widget.controller.fontOpacity,
            area: 0.5,
            duration: widget.controller.initDuration /
                (widget.controller.biliVideoPlayerController.speed *
                    widget.controller.speed)),
        statusChanged: (isPlaying) {
          this.isPlaying = isPlaying;
        },
      );
    });
  }
}

class BiliDanmakuController {
  BiliDanmakuController(this.biliVideoPlayerController);
  final BiliVideoPlayerController biliVideoPlayerController;
  int segmentCount = 1;
  int currentIndex = 0;
  int currentSegmentIndex = 0;
  double initDuration = 0;
  List<DmSegMobileReply> dmSegList = [];
  bool _isInitializedState = false;
  bool _isInitialized = false;

  ///字体缩放
  double fontScale = 1.0;

  ///字体不透明度
  double fontOpacity = 1.0;

  ///弹幕速度
  double speed = 1.0;

  void Function()? clearAllDanmaku;
  void Function()? reloadDanmaku;
  void Function()? refreshDanmaku;

  bool _isDanmakuOpened = true;
  bool get isDanmakuOpened => _isDanmakuOpened;

  Future<void> _requestDanmaku() async {
    dmSegList.clear();
    segmentCount =
        (biliVideoPlayerController.videoPlayInfo!.timeLength / (60 * 6)).ceil();
    for (int segmentIndex = 1; segmentIndex <= segmentCount; segmentIndex++) {
      log(biliVideoPlayerController.cid.toString());
      var response = await DanmakuApi.requestDanmaku(
          cid: biliVideoPlayerController.cid, segmentIndex: segmentIndex);
      response.elems.sort((a, b) {
        return a.progress - b.progress;
      });
      dmSegList.add(response);
      _isInitialized = true;
      _findPositionIndex(biliVideoPlayerController.position.inMilliseconds);
    }
  }

  void _findPositionIndex(int videoPosition) {
    //使用二分查找法查距离最近的弹幕的位置
    var controller = this;
    int segIndex = (videoPosition / 360000).ceil() - 1;
    if (segIndex < 0) segIndex = 0;
    if (segIndex < controller.dmSegList.length) {
      int left = 0;
      int right = controller.dmSegList[segIndex].elems.length;
      while (left < right) {
        int mid = (right + left) ~/ 2;
        var midPosition = controller.dmSegList[segIndex].elems[mid].progress;
        if (midPosition >= videoPosition) {
          right = mid;
        } else {
          left = mid + 1;
        }
      }
      controller.currentSegmentIndex = segIndex;
      controller.currentIndex = right;
    } else {
      //如果还没加载好这部分的内容,则设index为0
      controller.currentSegmentIndex = segIndex;
      controller.currentIndex = 0;
    }
  }

  void initDanmaku() {
    if (!_isInitialized && dmSegList.isEmpty && isDanmakuOpened) {
      //如果弹幕列表还是空的话，而且是可见的，就进行请求获取弹幕
      _requestDanmaku();
      speed = SettingsUtil.getValue(SettingsStorageKeys.defaultDanmakuSpeed,
          defaultValue: 1.0);
      fontScale = SettingsUtil.getValue(SettingsStorageKeys.defaultDanmakuScale,
          defaultValue: 1.0);
      fontOpacity = SettingsUtil.getValue(
          SettingsStorageKeys.defaultDanmakuOpacity,
          defaultValue: 0.6);
    } else {
      _findPositionIndex(biliVideoPlayerController.position.inMilliseconds);
    }
  }

  void toggleDanmaku() {
    _isDanmakuOpened = !_isDanmakuOpened;
    clearAllDanmaku?.call();
    refreshDanmaku?.call();
    initDanmaku();
  }
}
