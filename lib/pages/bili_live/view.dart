import 'package:bili_you/common/index.dart';
import 'package:bili_you/common/models/local/live/live_room_card_info.dart';
import 'package:bili_you/pages/bili_live/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';

class BiliLivePage extends StatefulWidget {
  const BiliLivePage({super.key, required this.info});
  final LiveRoomCardInfo info;

  @override
  State<BiliLivePage> createState() => _BiliLivePageState();
}

class _BiliLivePageState extends State<BiliLivePage> {
  late final BiliLivePageController controller;
  @override
  void initState() {
    controller = Get.put(BiliLivePageController(roomId: widget.info.roomId));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.info.title),
        ),
        body: Center(
            child: FutureBuilder(
          future: controller.init(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Video(
                controller: VideoController(
                  PlayersSingleton().player!,
                  configuration: VideoControllerConfiguration(
                      enableHardwareAcceleration: SettingsUtil.getValue(
                          SettingsStorageKeys.isHardwareDecode,
                          defaultValue: true)),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        )));
  }
}
