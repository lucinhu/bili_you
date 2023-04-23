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
  GlobalKey visibilityKey = GlobalKey();
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
    _findPositionIndex(position.inMilliseconds);
  }

  void videoPlayerListenerCallback() {
    () async {
      if (!isListenerLocked && widget.controller._isInitialized) {
        isListenerLocked = true;
        var currentPosition =
            (widget.controller.biliVideoPlayerController.position)
                .inMilliseconds;
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
            if (delta >= 0) {
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
                    color: Color.fromARGB(
                        255,
                        (element.color << 8) >> 24,
                        (element.color << 16) >> 24,
                        (element.color << 24) >> 24),
                    time: element.progress,
                    type: type)
              ]);
              widget.controller.currentIndex++;
            }
          } else {
            //换下一节
            widget.controller.currentIndex = 0;
            widget.controller.currentSegmentIndex++;
          }
        }
        // updateWidget();
        danmakuController?.updateOption(DanmakuOption(
            area: 0.5,
            duration: 5 / widget.controller.biliVideoPlayerController.speed));
        isListenerLocked = false;
      }
    }();
  }

  Future<void> _requestDanmaku() async {
    widget.controller.segmentCount =
        (widget.controller.biliVideoPlayerController.videoPlayInfo!.timeLength /
                (60 * 6))
            .ceil();
    for (int segmentIndex = 1;
        segmentIndex <= widget.controller.segmentCount;
        segmentIndex++) {
      log(widget.controller.biliVideoPlayerController.cid.toString());
      var response = await DanmakuApi.requestDanmaku(
          cid: widget.controller.biliVideoPlayerController.cid,
          segmentIndex: segmentIndex);
      response.elems.sort((a, b) {
        return a.progress - b.progress;
      });
      widget.controller.dmSegList.add(response);
      widget.controller._isInitialized = true;
      _findPositionIndex(
          widget.controller.biliVideoPlayerController.position.inMilliseconds);
    }
  }

  void _findPositionIndex(int videoPosition) {
    //使用二分查找法查距离最近的弹幕的位置
    var controller = widget.controller;
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
    if (BiliYouStorage.settings
        .get(SettingsStorageKeys.defaultShowDanmaku, defaultValue: true)) {
      controller._visible = true;
    } else {
      controller._visible = false;
    }
    addAllListeners();
    controller.updateWidget = () {
      danmakuController?.clear();
      danmakuController = null;
      setState(() {});
    };
    controller.refreshDanmaku = () {
      controller._isInitialized = false;
      controller.currentIndex = 0;
      controller.currentSegmentIndex = 0;
      controller.dmSegList.clear();
      controller.segmentCount = 0;
      controller.updateWidget();
    };

    super.initState();
  }

  @override
  void dispose() {
    danmakuController?.clear();
    danmakuController = null;
    removeAllListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        key: visibilityKey,
        visible: widget.controller._visible,
        child: DanmakuView(
          createdController: (danmakuController) async {
            // if (widget.controller.dmSegList.isEmpty &&
            //     widget.controller._visible) {
            //如果弹幕列表还是空的话，而且是可见的，就进行请求获取弹幕
            await _requestDanmaku();
            // }
            this.danmakuController = danmakuController;
          },
          option: DanmakuOption(area: 0.5),
          statusChanged: (isPlaying) {
            this.isPlaying = isPlaying;
          },
        ));
  }
}

class BiliDanmakuController {
  BiliDanmakuController(this.biliVideoPlayerController);
  final BiliVideoPlayerController biliVideoPlayerController;
  int segmentCount = 1;
  int currentIndex = 0;
  int currentSegmentIndex = 0;
  List<DmSegMobileReply> dmSegList = [];
  bool _isInitialized = false;

  late void Function() updateWidget;
  late void Function() refreshDanmaku;

  bool _visible = true;
  bool get visible => _visible;
  set visible(bool visible) {
    _visible = visible;
    updateWidget();
  }
}
