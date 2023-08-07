import 'dart:developer';
import 'dart:math' as math;

import 'package:bili_you/common/models/local/video/audio_play_item.dart';
import 'package:bili_you/common/models/local/video/video_play_item.dart';
import 'package:bili_you/common/utils/index.dart';
import 'package:bili_you/common/widget/slider_dialog.dart';
import 'package:bili_you/common/widget/video_audio_player.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BiliVideoPlayerPanel extends StatefulWidget {
  const BiliVideoPlayerPanel(this.controller, {super.key});
  final BiliVideoPlayerPanelController controller;
  @override
  State<BiliVideoPlayerPanel> createState() => _BiliVideoPlayerPanelState();
}

class _BiliVideoPlayerPanelState extends State<BiliVideoPlayerPanel> {
  GlobalKey danmakuCheckBoxKey = GlobalKey();
  GlobalKey playButtonKey = GlobalKey();
  GlobalKey sliderKey = GlobalKey();
  GlobalKey durationTextKey = GlobalKey();
  late double tempSpeed;
  bool isHorizontalGestureInProgress = false;
  bool isVerticalGestureInProgress = false;
  static const gestureEdgeDeadZone = 0.1;
  var isInDeadZone = (x, bound) =>
      math.min<double>(x, bound - x) < gestureEdgeDeadZone * bound;

  final panelDecoration = const BoxDecoration(boxShadow: [
    BoxShadow(color: Colors.black45, blurRadius: 15, spreadRadius: 5)
  ]);
  static const Color textColor = Colors.white;
  static const Color iconColor = Colors.white;

  void playStateChangedCallback(VideoAudioState value) {
    widget.controller._isPlayerPlaying = value.isPlaying;
    widget.controller._isPlayerEnd = value.isEnd;
    widget.controller._isPlayerBuffering = value.isBuffering;
    playButtonKey.currentState?.setState(() {});
  }

  void playerListenerCallback() async {
    if (!widget.controller._isSliderDraging) {
      widget.controller._position =
          widget.controller._biliVideoPlayerController.position;
    }
    widget.controller._fartherestBuffed =
        widget.controller._biliVideoPlayerController.fartherestBuffered;
    sliderKey.currentState?.setState(() {});
    durationTextKey.currentState?.setState(() {});
  }

  void toggleFullScreen() {
    if (widget.controller._biliVideoPlayerController.isFullScreen) {
      Navigator.of(context).pop();
    }
    widget.controller._biliVideoPlayerController.toggleFullScreen();
  }

  void toggleDanmaku() {
    widget.controller._biliVideoPlayerController.biliDanmakuController!
        .toggleDanmaku();
    //保持弹幕状态
    if (SettingsUtil.getValue(SettingsStorageKeys.rememberDanmakuSwitch,
            defaultValue: false) ==
        true) {
      SettingsUtil.setValue(
          SettingsStorageKeys.defaultShowDanmaku,
          widget.controller._biliVideoPlayerController.biliDanmakuController!
              .isDanmakuOpened);
    }
    danmakuCheckBoxKey.currentState!.setState(() {});
  }

  @override
  void initState() {
    if (!widget.controller._isInitializedState) {
      widget.controller._isPlayerPlaying =
          widget.controller._biliVideoPlayerController.isPlaying;
      //进入视频时如果没有在播放就显示
      widget.controller._show = !widget.controller._isPlayerPlaying;
      widget.controller.asepectRatio =
          widget.controller._biliVideoPlayerController.videoAspectRatio;
    }
    widget.controller._isInitializedState = true;
    widget.controller._biliVideoPlayerController
        .addStateChangedListener(playStateChangedCallback);
    widget.controller._biliVideoPlayerController
        .addListener(playerListenerCallback);
    initControl();
    super.initState();
  }

  Future<void> initControl() async {
    widget.controller._volume = await VolumeController().getVolume();
    widget.controller._brightness = await ScreenBrightness().current;
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller._biliVideoPlayerController
        .removeStateChangedListener(playStateChangedCallback);
    widget.controller._biliVideoPlayerController
        .removeListener(playerListenerCallback);
    ScreenBrightness().resetScreenBrightness();
    super.dispose();
  }

  ///视频画质radio列表
  List<RadioListTile> buildVideoQualityTiles() {
    List<RadioListTile> list = [];
    for (var i
        in widget.controller._biliVideoPlayerController.videoPlayInfo!.videos) {
      list.add(RadioListTile(
        title: Text(i.quality.description),
        subtitle: Text(i.codecs),
        value: i,
        groupValue: widget.controller._biliVideoPlayerController.videoPlayItem,
        onChanged: (value) {
          widget.controller._biliVideoPlayerController.changeVideoItem(value);
          Navigator.of(context).pop();
        },
      ));
    }
    return list;
  }

  //音质radio列表
  List<RadioListTile> buildAudioQualityTiles() {
    List<RadioListTile> list = [];
    for (var i
        in widget.controller._biliVideoPlayerController.videoPlayInfo!.audios) {
      list.add(RadioListTile(
        title: Text(i.quality.description),
        subtitle: Text(i.codecs),
        value: i,
        groupValue: widget.controller._biliVideoPlayerController.audioPlayItem,
        onChanged: (value) {
          widget.controller._biliVideoPlayerController.changeAudioItem(value);
          Navigator.of(context).pop();
        },
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        //手势识别层
        GestureDetector(
          onTap: () {
            //点击显示面板
            widget.controller._show = !(widget.controller._show);
            setState(() {});
          },
          onDoubleTap: () {
            //双击暂停/播放
            if (widget.controller._isPlayerPlaying) {
              widget.controller._biliVideoPlayerController.pause();
              widget.controller._show = true;
            } else {
              widget.controller._biliVideoPlayerController.play();
              widget.controller._show = false;
            }
            setState(() {});
          },
          onLongPress: () {
            tempSpeed = widget.controller._biliVideoPlayerController.speed;
            //长按2倍速度
            widget.controller._biliVideoPlayerController
                .setPlayBackSpeed(tempSpeed * 2);
            //振动
            HapticFeedback.selectionClick();
            //顯示Toat(二倍速播放)
            Fluttertoast.showToast(
              msg: "正在二倍速播放",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: const Color.fromARGB(185, 0, 0, 0),
              textColor: Colors.white,
              fontSize: 16.0
            );
          },
          onLongPressEnd: (details) {
            //长按结束时恢复本来的速度
            widget.controller._biliVideoPlayerController
                .setPlayBackSpeed(tempSpeed);
                //强制清除所有Toast
                Fluttertoast.cancel();
                //顯示Toast(已回到初始播放速度)
                Fluttertoast.showToast(
                  msg: "已回到初始播放速度",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color.fromARGB(185, 0, 0, 0),
                  textColor: Colors.white,
                  fontSize: 16.0
            );
          },
          onHorizontalDragStart: (details) {
            if (isInDeadZone(
                details.globalPosition.dx, MediaQuery.of(context).size.width)) {
              return;
            }
            isHorizontalGestureInProgress = true;
            widget.controller._isPreviousShow = widget.controller._show;
            widget.controller._isPreviousPlaying =
                widget.controller._isPlayerPlaying;
            widget.controller._show = true;
            widget.controller._biliVideoPlayerController.pause();
            widget.controller._isSliderDraging = true;
            setState(() {});
          },
          onHorizontalDragUpdate: (details) {
            if (!isHorizontalGestureInProgress) {
              return;
            }
            double scale = 60000 / MediaQuery.of(context).size.width;
            Duration pos = widget.controller._position +
                Duration(milliseconds: (details.delta.dx * scale).round());
            widget.controller._position = Duration(
                milliseconds: pos.inMilliseconds.clamp(
                    0,
                    widget.controller._biliVideoPlayerController.duration
                        .inMilliseconds));
            setState(() {});
          },
          onHorizontalDragEnd: (details) {
            if (!isHorizontalGestureInProgress) {
              return;
            }
            isHorizontalGestureInProgress = false;
            widget.controller.biliVideoPlayerController
                .seekTo(widget.controller._position);
            if (widget.controller._isPreviousPlaying) {
              widget.controller._biliVideoPlayerController.play();
            }
            if (!widget.controller._isPreviousShow) {
              widget.controller._show = false;
            }
            widget.controller._isSliderDraging = false;
            setState(() {});
          },
          onVerticalDragStart: (details) {
            isVerticalGestureInProgress = !isInDeadZone(
                details.globalPosition.dy, MediaQuery.of(context).size.height);
          },
          onVerticalDragUpdate: (details) {
            if (!isVerticalGestureInProgress) {
              return;
            }
            var add = details.delta.dy / 500;
            if (details.localPosition.dx > context.size!.width / 2) {
              widget.controller._volume -= add;
              widget.controller._volume = widget.controller._volume.clamp(0, 1);
              VolumeController().setVolume(widget.controller._volume);
            } else {
              widget.controller._brightness -= add;
              widget.controller._brightness =
                  widget.controller._brightness.clamp(0, 1);
              ScreenBrightness()
                  .setScreenBrightness(widget.controller._brightness);
            }
          },
          onVerticalDragEnd: (details) {
            isVerticalGestureInProgress = false;
          },
          // onScaleUpdate: (details) {
          //   widget.controller._biliVideoPlayerController
          //       .changeCanvasScale(details.scale);
          // },
        ),
        //面板层
        Visibility(
            visible: widget.controller._show,
            child: SafeArea(
              top: false,
              bottom: false,
              child: Column(
                children: [
                  //上面板(返回,菜单...)
                  Container(
                    decoration: panelDecoration,
                    child: Row(
                      children: [
                        //返回按钮
                        const BackButton(
                          color: Colors.white,
                        ),
                        //主页面按钮
                        IconButton(
                            onPressed: () {
                              //回到主页面
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            },
                            icon: const Icon(
                              Icons.home_outlined,
                              color: Colors.white,
                            )),
                        const Spacer(),
                        PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            color: iconColor,
                          ),
                          itemBuilder: (context) {
                            return <PopupMenuEntry<String>>[
                              PopupMenuItem(
                                padding: EdgeInsets.zero,
                                value: "弹幕",
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Icon(
                                        Icons.format_list_bulleted,
                                        size: 24,
                                      ),
                                    ),
                                    const Text("弹幕"),
                                    const Spacer(),
                                    StatefulBuilder(
                                      key: danmakuCheckBoxKey,
                                      builder: (context, setState) {
                                        return Checkbox(
                                          value: widget
                                                  .controller
                                                  .biliVideoPlayerController
                                                  .biliDanmakuController
                                                  ?.isDanmakuOpened ??
                                              false,
                                          onChanged: (value) {
                                            if (value != null) {
                                              toggleDanmaku();
                                            }
                                          },
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                padding: EdgeInsets.zero,
                                value: "播放速度",
                                child: Row(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.speed_rounded,
                                          size: 24,
                                        )),
                                    Text("播放速度")
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                  value: "画质",
                                  child: Text(
                                      "画质: ${widget.controller._biliVideoPlayerController.videoPlayItem!.quality.description ?? "未知"}")),
                              PopupMenuItem(
                                  value: "音质",
                                  child: Text(
                                      "音质: ${widget.controller._biliVideoPlayerController.audioPlayItem!.quality.description ?? "未知"}")),
                              const PopupMenuItem(
                                  value: "弹幕字体大小", child: Text("弹幕字体大小")),
                              const PopupMenuItem(
                                  value: "弹幕不透明度", child: Text("弹幕不透明度")),
                              const PopupMenuItem(
                                  value: "弹幕速度", child: Text("弹幕速度"))
                            ];
                          },
                          onSelected: (value) {
                            switch (value) {
                              case "弹幕":
                                toggleDanmaku();
                                break;
                              case "播放速度":
                                showDialog(
                                    context: context,
                                    builder: (context) => SliderDialog(
                                          title: "播放速度",
                                          initValue: widget.controller
                                              ._biliVideoPlayerController.speed,
                                          min: 0.25,
                                          max: 4.00,
                                          divisions: 15,
                                          onOk: (value) {
                                            widget.controller
                                                ._biliVideoPlayerController
                                                .setPlayBackSpeed(value);
                                          },
                                          buildLabel: (selectingValue) =>
                                              "${selectingValue}X",
                                        ));

                                break;
                              case "画质":
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      scrollable: true,
                                      title: const Text("选择画质"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "取消",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                            )),
                                      ],
                                      content: Column(
                                        children: buildVideoQualityTiles(),
                                      ),
                                    );
                                  },
                                );
                                break;
                              case "音质":
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      scrollable: true,
                                      title: const Text("选择音质"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "取消",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                            )),
                                      ],
                                      content: Column(
                                        children: buildAudioQualityTiles(),
                                      ),
                                    );
                                  },
                                );
                                break;
                              case '弹幕字体大小':
                                showDialog(
                                  context: context,
                                  builder: (context) => SliderDialog(
                                    title: '弹幕字体大小',
                                    initValue: widget
                                        .controller
                                        ._biliVideoPlayerController
                                        .biliDanmakuController!
                                        .fontScale,
                                    showCancelButton: false,
                                    min: 0.25,
                                    max: 4,
                                    divisions: 100,
                                    buildLabel: (selectingValue) =>
                                        "${selectingValue.toStringAsFixed(2)}X",
                                    onChanged: (selectingValue) {
                                      widget
                                          .controller
                                          ._biliVideoPlayerController
                                          .biliDanmakuController!
                                          .fontScale = selectingValue;
                                      if (SettingsUtil.getValue(
                                          SettingsStorageKeys
                                              .rememberDanmakuSettings,
                                          defaultValue: true)) {
                                        SettingsUtil.setValue(
                                            SettingsStorageKeys
                                                .defaultDanmakuScale,
                                            selectingValue);
                                      }
                                    },
                                  ),
                                );
                                break;
                              case '弹幕不透明度':
                                showDialog(
                                  context: context,
                                  builder: (context) => SliderDialog(
                                    title: '弹幕不透明度',
                                    initValue: widget
                                        .controller
                                        ._biliVideoPlayerController
                                        .biliDanmakuController!
                                        .fontOpacity,
                                    showCancelButton: false,
                                    min: 0.01,
                                    max: 1.0,
                                    divisions: 100,
                                    buildLabel: (selectingValue) =>
                                        "${(selectingValue * 100).toStringAsFixed(0)}%",
                                    onChanged: (selectingValue) {
                                      widget
                                          .controller
                                          ._biliVideoPlayerController
                                          .biliDanmakuController!
                                          .fontOpacity = selectingValue;
                                      if (SettingsUtil.getValue(
                                          SettingsStorageKeys
                                              .rememberDanmakuSettings,
                                          defaultValue: true)) {
                                        SettingsUtil.setValue(
                                            SettingsStorageKeys
                                                .defaultDanmakuOpacity,
                                            selectingValue);
                                      }
                                    },
                                  ),
                                );
                                break;
                              case '弹幕速度':
                                showDialog(
                                  context: context,
                                  builder: (context) => SliderDialog(
                                    title: '弹幕速度',
                                    initValue: widget
                                        .controller
                                        ._biliVideoPlayerController
                                        .biliDanmakuController!
                                        .speed,
                                    showCancelButton: false,
                                    min: 0.25,
                                    max: 4,
                                    divisions: 15,
                                    buildLabel: (selectingValue) =>
                                        "${selectingValue}X",
                                    onChanged: (selectingValue) {
                                      widget
                                          .controller
                                          ._biliVideoPlayerController
                                          .biliDanmakuController!
                                          .speed = selectingValue;
                                      if (SettingsUtil.getValue(
                                          SettingsStorageKeys
                                              .rememberDanmakuSettings,
                                          defaultValue: true)) {
                                        SettingsUtil.setValue(
                                            SettingsStorageKeys
                                                .defaultDanmakuSpeed,
                                            selectingValue);
                                      }
                                    },
                                  ),
                                );
                                break;
                              default:
                                log(value);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  //中间留空
                  const Spacer(),
                  //下面板(播放按钮,进度条...)
                  Container(
                    decoration: panelDecoration,
                    child: Row(children: [
                      StatefulBuilder(
                        key: playButtonKey,
                        builder: (context, setState) {
                          late final IconData iconData;
                          if (widget.controller._isPlayerEnd) {
                            iconData = Icons.refresh_rounded;
                          } else if (widget.controller._isPlayerPlaying) {
                            iconData = Icons.pause_rounded;
                          } else {
                            iconData = Icons.play_arrow_rounded;
                          }
                          return //播放按钮
                              IconButton(
                                  color: iconColor,
                                  onPressed: () async {
                                    if (widget.controller
                                        ._biliVideoPlayerController.isPlaying) {
                                      await widget
                                          .controller._biliVideoPlayerController
                                          .pause();
                                    } else {
                                      if (widget
                                          .controller
                                          ._biliVideoPlayerController
                                          .hasError) {
                                        //如果是出错状态, 重新加载
                                        await widget.controller
                                            ._biliVideoPlayerController
                                            .reloadWidget();
                                      } else {
                                        //不是出错状态, 就继续播放
                                        await widget.controller
                                            ._biliVideoPlayerController
                                            .play();
                                      }
                                    }
                                    widget.controller._isPlayerPlaying =
                                        !widget.controller._isPlayerPlaying;
                                    setState(() {});
                                  },
                                  icon: Icon(iconData));
                        },
                      ),
                      //进度条
                      Expanded(
                        child: StatefulBuilder(
                            key: sliderKey,
                            builder: (context, setState) {
                              return Slider(
                                min: 0,
                                max: widget
                                    .controller
                                    ._biliVideoPlayerController
                                    .duration
                                    .inMilliseconds
                                    .toDouble(),
                                value: clampDouble(
                                    widget.controller._position.inMilliseconds
                                        .toDouble(),
                                    0,
                                    widget.controller._biliVideoPlayerController
                                        .duration.inMilliseconds
                                        .toDouble()),
                                secondaryTrackValue: clampDouble(
                                    widget.controller._fartherestBuffed
                                        .inMilliseconds
                                        .toDouble(),
                                    0,
                                    widget.controller._biliVideoPlayerController
                                        .duration.inMilliseconds
                                        .toDouble()),
                                onChanged: (value) {
                                  if (widget.controller._isSliderDraging) {
                                    widget.controller._position =
                                        Duration(milliseconds: value.toInt());
                                  }
                                },
                                onChangeStart: (value) {
                                  widget.controller._isSliderDraging = true;
                                },
                                onChangeEnd: (value) {
                                  if (widget.controller._isSliderDraging) {
                                    widget.controller._biliVideoPlayerController
                                        .seekTo(Duration(
                                            milliseconds: value.toInt()));
                                    widget.controller._isSliderDraging = false;
                                  }
                                },
                              );
                            }),
                      ),
                      //时长
                      StatefulBuilder(
                        key: durationTextKey,
                        builder: (context, setState) {
                          return Text(
                            "${StringFormatUtils.timeLengthFormat(widget.controller._position.inSeconds)}/${StringFormatUtils.timeLengthFormat(widget.controller._biliVideoPlayerController.duration.inSeconds)}",
                            style: const TextStyle(color: textColor),
                          );
                        },
                      ),
                      // 全屏按钮
                      IconButton(
                          onPressed: () {
                            // log("full:${widget.controller.isFullScreen}");
                            toggleFullScreen();
                          },
                          icon: const Icon(
                            Icons.fullscreen_rounded,
                            color: iconColor,
                          ))
                    ]),
                  )
                ],
              ),
            ))
      ],
    );
  }
}

class BiliVideoPlayerPanelController {
  BiliVideoPlayerPanelController(this._biliVideoPlayerController);
  bool _isInitializedState = false;
  bool _show = false;
  bool _isPlayerPlaying = false;
  bool _isPlayerEnd = false;
  bool _isPlayerBuffering = false;
  bool _isSliderDraging = false;
  bool _isPreviousPlaying = false;
  bool _isPreviousShow = false;
  // bool isFullScreen = false;
  double asepectRatio = 1;
  Duration _position = Duration.zero;
  double _volume = 0;
  double _brightness = 0;
  Duration _fartherestBuffed = Duration.zero;
  final BiliVideoPlayerController _biliVideoPlayerController;
  BiliVideoPlayerController get biliVideoPlayerController =>
      _biliVideoPlayerController;
}
