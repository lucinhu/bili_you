import 'package:fanjiao_danmu/fanjiao_danmu/fanjiao_danmu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'widgets/controll_pannel.dart';

import 'index.dart';

///视频播放器
class BiliVideoPlayerPage extends GetView<BiliVideoPlayerController> {
  BiliVideoPlayerPage({Key? key, required this.bvid, required this.cid})
      : super(key: key);

  final String bvid;
  final int cid;
  final _tag = UniqueKey().toString();
  @override
  String? get tag => _tag;

  stop() {
    controller.videoPlayerController!.pause();
    controller.audioPlayerController!.pause();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: tag,
      init: BiliVideoPlayerController(bvid: bvid, cid: cid),
      id: "bili_video_player",
      builder: (controller) => AspectRatio(
        aspectRatio: 16 / 9,
        child: FutureBuilder(
          future: controller.load(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var refreshWidget = Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back_rounded)),
                  ),
                  Center(
                    child: IconButton(
                        onPressed: () {
                          controller.update(["bili_video_player"]);
                        },
                        icon: const Icon(Icons.refresh_rounded)),
                  )
                ],
              );
              if (controller.audioPlayerController != null &&
                  controller.videoPlayerController != null) {
                controller.audioPlayerController!.play();
                controller.videoPlayerController!.play();
                return Stack(
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio:
                            controller.videoPlayerController!.value.aspectRatio,
                        child: VideoPlayer(controller.videoPlayerController!),
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (controller.isDanmakuControllerInitializing ==
                            false) {
                          controller.initDanmakuController(
                              controller.fanjiaoDanmuController);
                          controller.isDanmakuControllerInitializing = true;
                        }
                        var ret = DanmuWidget(
                            size: constraints.biggest,
                            danmuController: controller.fanjiaoDanmuController);
                        return ret;
                      },
                    ),
                    VideoControllPannel(controller: controller),
                  ],
                );
              } else {
                return refreshWidget;
              }
            } else {
              return Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back_rounded)),
                  ),
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
