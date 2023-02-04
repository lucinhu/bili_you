// ignore_for_file: unused_import

import 'dart:math';

import 'package:bili_you/common/utils/fullscreen.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/index.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/widgets/video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bili_you/common/utils/string_format_utils.dart';
import 'fullscreen_player.dart';

///视频控制面板(进度条什么的)
class VideoControllPannel extends StatelessWidget {
  const VideoControllPannel({super.key, required this.controller});

  ///必须要的BiliVideoPlayerController,用来控制音频视频的
  final BiliVideoPlayerController controller;

  Widget _videoControllPannel(context) {
    return Stack(
      children: [
        MaterialButton(
          onPressed: () {
            controller.showController.value = !controller.showController.value;
          },
          child: Container(),
        ),
        Obx(() => Offstage(
              offstage: !controller.showController.value,
              child: Stack(children: [
                Container(
                  color: const Color.fromARGB(98, 0, 0, 0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white)),
                      const Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert_rounded,
                              color: Colors.white))
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      // decoration: const BoxDecoration(boxShadow: [
                      //   BoxShadow(
                      //       color: Colors.black45,
                      //       blurRadius: 15,
                      //       spreadRadius: 10)
                      // ]),
                      color: const Color.fromARGB(98, 0, 0, 0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Obx(
                              () {
                                Widget icon;
                                if (!controller.isEnd.value) {
                                  if (controller.isPlaying.value) {
                                    icon = const Icon(
                                      Icons.pause_rounded,
                                      color: Colors.white,
                                    );
                                  } else {
                                    icon = const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                    );
                                  }
                                } else {
                                  icon = const Icon(
                                    Icons.refresh_rounded,
                                    color: Colors.white,
                                  );
                                }

                                return icon;
                              },
                            ),
                            onPressed: () async {
                              if (!controller.isEnd.value) {
                                if (controller.isPlaying.value) {
                                  //停止
                                  controller.videoPlayerController?.pause();
                                  controller.audioPlayerController?.pause();
                                  controller.fanjiaoDanmuController.pause();
                                  controller.isPlaying.value = false;
                                  controller.isBufferring.value = false;
                                } else {
                                  //开始
                                  controller.videoPlayerController?.play();
                                  controller.audioPlayerController?.play();
                                  controller.fanjiaoDanmuController.start();
                                  controller.isPlaying.value = true;
                                  controller.isBufferring.value = false;
                                }
                              } else {
                                controller.videoPlayerController?.play();
                                controller.audioPlayerController?.play();
                                controller.fanjiaoDanmuController.start();
                                await controller.videoPlayerController
                                    ?.seekTo(Duration.zero);
                                await controller.audioPlayerController
                                    ?.seekTo(Duration.zero);
                                controller.fanjiaoDanmuController.progress =
                                    Duration.zero;

                                controller.isEnd.value = false;
                                controller.isPlaying.value = true;
                                controller.isBufferring.value = false;
                              }
                            },
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 10,
                              child: VideoProgressBar(
                                videoController:
                                    controller.videoPlayerController!,
                                onDragEnd: (position) {
                                  controller.audioPlayerController!
                                      .seekTo(position);
                                  controller.fanjiaoDanmuController.progress =
                                      position;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0, right: 5),
                            child: Text(
                              '${StringFormatUtils.timeLengthFormat(controller.position.value)}/${StringFormatUtils.timeLengthFormat(controller.videoPlayerController!.value.duration.inSeconds)}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                //已经是全屏了，就退出全屏
                                if (controller.isFullScreen) {
                                  controller.isFullScreen = false;
                                  Get.back();
                                } else {
                                  //进入全屏
                                  controller.isFullScreen = true;
                                  if (controller.videoPlayerController!.value
                                          .aspectRatio >=
                                      1) {
                                    await landScape();
                                  } else {
                                    await portraitUp();
                                  }
                                  await enterFullScreen();
                                  Get.to(() => BiliVideoPlayerFullScreenPage(
                                        controller: controller,
                                      ));
                                }
                              },
                              icon: const Icon(Icons.fullscreen_rounded,
                                  size: 28, color: Colors.white))
                        ],
                      ),
                    ))
              ]),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _videoControllPannel(context);
  }
}
