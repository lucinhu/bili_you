import 'package:bili_you/common/models/local/video/video_play_info.dart';

class BiliMediaContent extends VideoPlayInfo {
  BiliMediaContent(
      {required super.supportVideoQualities,
      required super.supportAudioQualities,
      required super.timeLength,
      required super.videos,
      required super.audios,
      required super.lastPlayCid,
      required super.lastPlayTime,
      required super.minBufferTime});
}
