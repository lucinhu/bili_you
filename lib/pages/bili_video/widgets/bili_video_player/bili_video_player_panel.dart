import 'dart:developer';
import 'dart:math' as math;

import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/widget/video_audio_player.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  final panelDecoration = const BoxDecoration(boxShadow: [
    BoxShadow(color: Colors.black45, blurRadius: 15, spreadRadius: 5)
  ]);
  static const Color textColor = Colors.white;
  static const Color iconColor = Colors.white;

  void playStateChangedCallback(VideoAudioPlayerValue value) {
    widget.controller._isPlayerPlaying = value.isPlaying;
    widget.controller._isPlayerEnd = value.isEnd;
    widget.controller._isPlayerBuffering = value.isBuffering;
    playButtonKey.currentState?.setState(() {});
  }

  void playerListenerCallback() async {
    if (!widget.controller._isSliderDraging) {
      widget.controller._position =
          await widget.controller._biliVideoPlayerController.position;
    }
    widget.controller._fartherestBuffed =
        widget.controller._biliVideoPlayerController.fartherestBuffered;
    sliderKey.currentState?.setState(() {});
    durationTextKey.currentState?.setState(() {});
  }

  void toggleFullScreen() {
    widget.controller._biliVideoPlayerController.toggleFullScreen();
  }

  void toggleDanmaku() {
    bool opened = !widget.controller._danmakuOpened;
    // log("toggleDanmaku:$opened");
    widget.controller._biliVideoPlayerController.biliDanmakuController!
        .visible = opened;
    danmakuCheckBoxKey.currentState!.setState(() {
      widget.controller._danmakuOpened = opened;
    });
  }

  @override
  void initState() {
    widget.controller._isPlayerPlaying =
        widget.controller._biliVideoPlayerController.isPlaying;
    widget.controller._duration =
        widget.controller._biliVideoPlayerController.duration;
    widget.controller.asepectRatio =
        widget.controller._biliVideoPlayerController.videoAspectRatio;
    widget.controller._biliVideoPlayerController
        .addStateChangedListener(playStateChangedCallback);
    widget.controller._biliVideoPlayerController
        .addListener(playerListenerCallback);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller._biliVideoPlayerController
        .removeStateChangedListener(playStateChangedCallback);
    widget.controller._biliVideoPlayerController
        .removeListener(playerListenerCallback);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.controller._biliVideoPlayerController.isFullScreen) {
          toggleFullScreen();
          return false;
        } else {
          return true;
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          //手势识别层
          GestureDetector(
            onTap: () {
              //点击显示面板
              setState(() {
                widget.controller._show = !(widget.controller._show);
              });
            },
            onDoubleTap: () {
              //双击暂停/播放
              if (widget.controller._isPlayerPlaying) {
                widget.controller._biliVideoPlayerController.pause();
              } else {
                widget.controller._biliVideoPlayerController.play();
              }
            },
            onLongPress: () {
              widget.controller._selectingSpeed =
                  widget.controller._biliVideoPlayerController.speed;
              //长按2倍速度
              widget.controller._biliVideoPlayerController.setPlayBackSpeed(
                  math.max(widget.controller._selectingSpeed, 2));
              //振动
              HapticFeedback.selectionClick();
            },
            onLongPressEnd: (details) {
              //长按结束时恢复本来的速度
              widget.controller._biliVideoPlayerController
                  .setPlayBackSpeed(widget.controller._selectingSpeed);
            },
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
                          const BackButton(
                            color: Colors.white,
                          ),
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
                                                .controller._danmakuOpened,
                                            onChanged: (value) {
                                              if (value != null &&
                                                  value !=
                                                      widget.controller
                                                          ._danmakuOpened) {
                                                toggleDanmaku();
                                              }
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  padding: EdgeInsets.zero,
                                  value: "播放速度",
                                  child: Row(
                                    children: const [
                                      Padding(
                                          padding: EdgeInsets.all(12),
                                          child: Icon(
                                            Icons.speed_rounded,
                                            size: 24,
                                          )),
                                      Text("播放速度")
                                    ],
                                  ),
                                )
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
                                    builder: (context) => StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text("播放速度"),
                                        content: IntrinsicHeight(
                                          child: Slider(
                                            min: 0.25,
                                            max: 2.50,
                                            divisions: 9,
                                            label:
                                                "${widget.controller._selectingSpeed}X",
                                            value: widget
                                                .controller._selectingSpeed,
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  widget.controller
                                                      ._selectingSpeed = value;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                widget.controller
                                                        ._selectingSpeed =
                                                    widget
                                                        .controller
                                                        ._biliVideoPlayerController
                                                        .speed;
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "取消",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .hintColor),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                widget.controller
                                                    ._biliVideoPlayerController
                                                    .setPlayBackSpeed(widget
                                                        .controller
                                                        ._selectingSpeed);
                                                Navigator.pop(context);
                                              },
                                              child: const Text("确定")),
                                        ],
                                      );
                                    }),
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
                                    onPressed: () {
                                      setState(
                                        () {
                                          if (widget
                                              .controller._isPlayerPlaying) {
                                            widget.controller
                                                ._biliVideoPlayerController
                                                .pause();
                                          } else {
                                            if (widget
                                                .controller
                                                ._biliVideoPlayerController
                                                .hasError) {
                                              //如果是出错状态, 重新加载
                                              widget.controller
                                                  ._biliVideoPlayerController
                                                  .reloadWidget();
                                            } else {
                                              //不是出错状态, 就继续播放
                                              widget.controller
                                                  ._biliVideoPlayerController
                                                  .play();
                                            }
                                          }
                                          widget.controller._isPlayerPlaying =
                                              !widget
                                                  .controller._isPlayerPlaying;
                                        },
                                      );
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
                                      .controller._duration.inMilliseconds
                                      .toDouble(),
                                  value: (math.min(
                                          widget.controller._position
                                              .inMilliseconds,
                                          widget.controller._duration
                                              .inMilliseconds))
                                      .toDouble(),
                                  secondaryTrackValue: widget.controller
                                      ._fartherestBuffed.inMilliseconds
                                      .toDouble(),
                                  onChanged: (value) {
                                    if (widget.controller._isSliderDraging) {
                                      widget.controller._position =
                                          Duration(milliseconds: value.toInt());
                                    } else {
                                      widget
                                          .controller._biliVideoPlayerController
                                          .seekTo(Duration(
                                              milliseconds: value.toInt()));
                                    }
                                  },
                                  onChangeStart: (value) {
                                    widget.controller._isSliderDraging = true;
                                  },
                                  onChangeEnd: (value) {
                                    if (widget.controller._isSliderDraging) {
                                      widget
                                          .controller._biliVideoPlayerController
                                          .seekTo(Duration(
                                              milliseconds: value.toInt()));
                                      widget.controller._isSliderDraging =
                                          false;
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
                              "${StringFormatUtils.timeLengthFormat(widget.controller._position.inSeconds)}/${StringFormatUtils.timeLengthFormat(widget.controller._duration.inSeconds)}",
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
      ),
    );
  }
}

class BiliVideoPlayerPanelController {
  BiliVideoPlayerPanelController(this._biliVideoPlayerController);
  bool _show = false;
  bool _danmakuOpened = true;
  bool _isPlayerPlaying = false;
  bool _isPlayerEnd = false;
  bool _isPlayerBuffering = false;
  bool _isSliderDraging = false;
  // bool isFullScreen = false;
  double asepectRatio = 1;
  double _selectingSpeed = 1;
  late Duration _duration;
  Duration _position = Duration.zero;
  Duration _fartherestBuffed = Duration.zero;
  final BiliVideoPlayerController _biliVideoPlayerController;
  BiliVideoPlayerController get biliVideoPlayerController =>
      _biliVideoPlayerController;
}
