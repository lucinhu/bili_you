import 'package:bili_you/common/utils/fullscreen.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_video_player.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_video_player_panel.dart';
import 'package:flutter/material.dart';

class BiliVideoPlayerFullScreen extends StatefulWidget {
  const BiliVideoPlayerFullScreen(
      {super.key,
      required this.biliVideoPlayerController,
      required this.biliVideoPlayerPanelController});

  final BiliVideoPlayerController biliVideoPlayerController;
  final BiliVideoPlayerPanelController biliVideoPlayerPanelController;

  @override
  State<BiliVideoPlayerFullScreen> createState() =>
      _BiliVideoPlayerFullScreenState();
}

class _BiliVideoPlayerFullScreenState extends State<BiliVideoPlayerFullScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BiliVideoPlayer(
      widget.biliVideoPlayerController,
      autoDispose: false,
      buildControllPanel: (context, biliVideoPlayerController) =>
          BiliVideoPlayerPanel(widget.biliVideoPlayerPanelController),
    ));
  }

  @override
  void dispose() {
    exitFullScreen();
    portraitUp();
    widget.biliVideoPlayerPanelController.isFullScreen = false;
    super.dispose();
  }
}
