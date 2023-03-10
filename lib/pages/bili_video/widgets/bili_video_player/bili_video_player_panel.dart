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
          //???????????????
          GestureDetector(
            onTap: () {
              //??????????????????
              setState(() {
                widget.controller._show = !(widget.controller._show);
              });
            },
            onDoubleTap: () {
              //????????????/??????
              if (widget.controller._isPlayerPlaying) {
                widget.controller._biliVideoPlayerController.pause();
              } else {
                widget.controller._biliVideoPlayerController.play();
              }
            },
            onLongPress: () {
              widget.controller._selectingSpeed =
                  widget.controller._biliVideoPlayerController.speed;
              //??????2?????????
              widget.controller._biliVideoPlayerController.setPlayBackSpeed(
                  math.max(widget.controller._selectingSpeed, 2));
              //??????
              HapticFeedback.selectionClick();
            },
            onLongPressEnd: (details) {
              //????????????????????????????????????
              widget.controller._biliVideoPlayerController
                  .setPlayBackSpeed(widget.controller._selectingSpeed);
            },
          ),
          //?????????
          Visibility(
              visible: widget.controller._show,
              child: SafeArea(
                top: false,
                bottom: false,
                child: Column(
                  children: [
                    //?????????(??????,??????...)
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
                                  value: "??????",
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.format_list_bulleted,
                                          size: 24,
                                        ),
                                      ),
                                      const Text("??????"),
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
                                  value: "????????????",
                                  child: Row(
                                    children: const [
                                      Padding(
                                          padding: EdgeInsets.all(12),
                                          child: Icon(
                                            Icons.speed_rounded,
                                            size: 24,
                                          )),
                                      Text("????????????")
                                    ],
                                  ),
                                )
                              ];
                            },
                            onSelected: (value) {
                              switch (value) {
                                case "??????":
                                  toggleDanmaku();
                                  break;
                                case "????????????":
                                  showDialog(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text("????????????"),
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
                                                "??????",
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
                                              child: const Text("??????")),
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
                    //????????????
                    const Spacer(),
                    //?????????(????????????,?????????...)
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
                            return //????????????
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
                                              //?????????????????????, ????????????
                                              widget.controller
                                                  ._biliVideoPlayerController
                                                  .reloadWidget();
                                            } else {
                                              //??????????????????, ???????????????
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
                        //?????????
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
                        //??????
                        StatefulBuilder(
                          key: durationTextKey,
                          builder: (context, setState) {
                            return Text(
                              "${StringFormatUtils.timeLengthFormat(widget.controller._position.inSeconds)}/${StringFormatUtils.timeLengthFormat(widget.controller._duration.inSeconds)}",
                              style: const TextStyle(color: textColor),
                            );
                          },
                        ),
                        // ????????????
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
