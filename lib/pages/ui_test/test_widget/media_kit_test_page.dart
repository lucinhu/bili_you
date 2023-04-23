import 'package:bili_you/common/index.dart';
import 'package:bili_you/common/utils/bvid_avid_util.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class BiliVideoPlayer extends StatefulWidget {
  const BiliVideoPlayer({super.key});

  @override
  State<BiliVideoPlayer> createState() => _BiliVideoPlayerState();
}

class _BiliVideoPlayerState extends State<BiliVideoPlayer> {
  final Player videopPlayer = Player();
  final Player audioPlayer = Player();
  VideoController? controller;
  VideoAudioController? vcontroller;
  @override
  void initState() {
    Future.microtask(() async {
      String bvid = BvidAvidUtil.av2Bvid(170001);
      var videoPlayerInfo = await VideoPlayApi.getVideoPlay(
          bvid: bvid, cid: await VideoInfoApi.getFirstCid(bvid: bvid));
      // const String name = 'http-header-fields';
      // var kvArray = [];
      // VideoPlayApi.videoPlayerHttpHeaders
      //     .forEach((key, value) => kvArray.add('$key: $value'));
      // final data = kvArray.join(',');
      // if (videopPlayer.platform is libmpvPlayer) {
      //   await (videopPlayer.platform as libmpvPlayer).setProperty(name, data);
      // }
      // if (audioPlayer.platform is libmpvPlayer) {
      //   await (audioPlayer.platform as libmpvPlayer).setProperty(name, data);
      // }

      // controller = await VideoController.create(
      //   videopPlayer,
      // );
      // await videopPlayer.open(Media(
      //   videoPlayerInfo.videos.first.urls.first,
      // ));
      // videopPlayer.streams.track.listen((event) {
      //   audioPlayer.setAudioTrack(event.audio);
      // });
      // await audioPlayer.open(Media(
      //   videoPlayerInfo.audios.first.urls.first,
      // ));
      vcontroller = VideoAudioController(
          videoUrl: videoPlayerInfo.videos.first.urls.first,
          audioUrl: videoPlayerInfo.audios.first.urls.first,
          videoHeaders: VideoPlayApi.videoPlayerHttpHeaders,
          audioHeaders: VideoPlayApi.videoPlayerHttpHeaders,
          initStart: true);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    Future.microtask(() async {
      // await videopPlayer.dispose();
      // await audioPlayer.dispose();
      await vcontroller?.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return vcontroller == null
        ? const SizedBox()
        : VideoAudioPlayer(vcontroller!);
  }
}
