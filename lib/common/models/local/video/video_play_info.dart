import 'package:bili_you/common/models/local/video/audio_play_item.dart';
import 'package:bili_you/common/models/local/video/video_play_item.dart';

class VideoPlayInfo {
  VideoPlayInfo(
      {
      // required this.defualtVideoQuality,
      required this.supportVideoQualities,
      required this.supportAudioQualities,
      required this.timeLength,
      required this.videos,
      required this.audios,
      required this.lastPlayCid,
      required this.lastPlayTime});
  static VideoPlayInfo get zero => VideoPlayInfo(
      supportVideoQualities: [],
      supportAudioQualities: [],
      timeLength: 0,
      videos: [],
      audios: [],
      lastPlayCid: 0,
      lastPlayTime: Duration.zero);
  // VideoQuality defualtVideoQuality ;
  ///支持的视频质量
  ///
  ///不是所有的质量都能播放，因为有一些是需要Vip的，不支持的质量在videos列表中会找不到
  List<VideoQuality> supportVideoQualities;
  // AudioQuality defualtAudioQuality ;
  ///支持的音频质量
  List<AudioQuality> supportAudioQualities;
  int timeLength;
  List<VideoPlayItem> videos;
  List<AudioPlayItem> audios;
  Duration lastPlayTime;
  int lastPlayCid;
}
