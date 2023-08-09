import 'dart:async';
import 'dart:io';

import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/models/local/video/video_play_info.dart';
import 'package:bili_you/pages/bili_video1/bili_media_content.dart';
import 'package:bili_you/pages/bili_video1/bili_media_content_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class PlayerSingleton {
  static final PlayerSingleton _instance = PlayerSingleton._internal();
  factory PlayerSingleton() => _instance;
  PlayerSingleton._internal() {
    player = Player();
    videoController = VideoController(player);
  }

  late final Player player;
  late final VideoController videoController;
}

//播放器状态
class BiliVideoPlayerState {
  BiliVideoPlayerState() {
    player = PlayerSingleton().player;
    videoController = PlayerSingleton().videoController;
  }
  late final Player player;
  late final VideoController videoController;
  StreamSubscription<bool>? _completedSubsciption;
  bool isLoop = false;
}

//播放器逻辑
class BiliVideoPlayerCubit extends Cubit<BiliVideoPlayerState> {
  BiliVideoPlayerCubit(super.initialState);

  void playMedia(String videoUrl, String audioUrl) async {
    await state.player.stop();
    await Future.delayed(const Duration(milliseconds: 10));
    await state.player.open(
        Media(videoUrl, httpHeaders: VideoPlayApi.videoPlayerHttpHeaders),
        play: true);
    await state.player.setPlaylistMode(PlaylistMode.none);
    await Future.delayed(const Duration(milliseconds: 10));
    await state.player.setAudioTrack(AudioTrack.uri(audioUrl));
    //防止上一个subsciption还没有释放掉
    if (state._completedSubsciption != null) {
      state._completedSubsciption!.cancel();
      state._completedSubsciption = null;
    }
    state._completedSubsciption =
        state.player.stream.completed.listen((event) async {
      if (event) {
        await state.player.seek(Duration.zero); //结束后回到起点
        await Future.delayed(const Duration(milliseconds: 20));
        if (state.isLoop) {
          await state.player.play();
        } else {
          await state.player.pause();
        }
      }
    });
  }

  @override
  Future<void> close() async {
    await state.player.stop();
    await state._completedSubsciption?.cancel();
    state._completedSubsciption = null;
    await Future.delayed(const Duration(milliseconds: 10));
    return super.close();
  }
}

//播放器界面
class BiliVideoPlayer extends StatelessWidget {
  const BiliVideoPlayer({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BiliVideoPlayerCubit, BiliVideoPlayerState>(
        builder: (context, playerState) =>
            BlocBuilder<BiliMediaContentCubit, BiliMediaContent>(
                builder: (context, playInfo) {
              context.read<BiliVideoPlayerCubit>().playMedia(
                  playInfo.videos.first.urls.first,
                  playInfo.audios.first.urls.first);
              if (Platform.isAndroid || Platform.isIOS) {
                var materialThemeData = const MaterialVideoControlsThemeData(
                  volumeGesture: true,
                  topButtonBar: [
                    SafeArea(
                      bottom: false,
                      left: false,
                      right: false,
                      child: BackButton(
                        color: Colors.white,
                      ),
                    ),
                    Spacer()
                  ],
                  brightnessGesture: true,
                  seekOnDoubleTap: false,
                );
                return MaterialVideoControlsTheme(
                    normal: materialThemeData,
                    fullscreen: materialThemeData,
                    child: Video(
                      controller: playerState.videoController,
                      controls: (state) {
                        return AdaptiveVideoControls(state);
                      },
                    ));
              } else {
                var materialDesktopThemeData =
                    const MaterialDesktopVideoControlsThemeData(
                  topButtonBar: [
                    SafeArea(
                      bottom: false,
                      left: false,
                      right: false,
                      child: BackButton(
                        color: Colors.white,
                      ),
                    ),
                    Spacer()
                  ],
                );
                return MaterialDesktopVideoControlsTheme(
                    normal: materialDesktopThemeData,
                    fullscreen: materialDesktopThemeData,
                    child: Video(
                      controller: playerState.videoController,
                      controls: (state) {
                        return AdaptiveVideoControls(state);
                      },
                    ));
              }
            }));
  }
}
