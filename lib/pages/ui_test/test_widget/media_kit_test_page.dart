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
  final Player videopPlayer =
      Player(configuration: const PlayerConfiguration());
  VideoController? controller;
  @override
  void initState() {
    Future.microtask(() async {
      String bvid = BvidAvidUtil.av2Bvid(170001);
      var videoPlayerInfo = await VideoPlayApi.getVideoPlay(
          bvid: bvid, cid: await VideoInfoApi.getFirstCid(bvid: bvid));
      const String name = 'http-header-fields';
      var kvArray = [];
      VideoPlayApi.videoPlayerHttpHeaders
          .forEach((key, value) => kvArray.add('$key: $value'));
      final data = kvArray.join(',');
      if (videopPlayer.platform is libmpvPlayer) {
        await (videopPlayer.platform as libmpvPlayer).setProperty(name, data);
        await (videopPlayer.platform as libmpvPlayer).setProperty('audio-files',
            videoPlayerInfo.audios.first.urls.first.replaceAll(':', '\\:'));
        await videopPlayer.setVolume(100);
        await videopPlayer.open(Media(videoPlayerInfo.videos.first.urls.first));
      }
      controller = VideoController(
        videopPlayer,
      );
      await videopPlayer.play();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    Future.microtask(() async {
      await videopPlayer.dispose();
      // controller?.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Video(controller: controller!);
  }
}
