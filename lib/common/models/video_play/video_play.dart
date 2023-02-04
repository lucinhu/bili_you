import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(valueDecorators: VideoPlayModel.valueDecorators)
class VideoPlayModel {
  static Map<Type, ValueDecoratorFunction> valueDecorators() => {
        // typeOf<List<VideoPlayDurlModel>>(): (value) =>
        //     value.cast<VideoPlayDurlModel>(),
        typeOf<List<VideoPlaySupportFormatModel>>(): (value) =>
            value.cast<VideoPlaySupportFormatModel>(),
        typeOf<List<VideoPlayVideoAudioModel>>(): (value) =>
            value.cast<VideoPlayVideoAudioModel>(),
      };
  VideoPlayModel({
    required this.code,
    required this.message,
    required this.from,
    required this.result,
    required this.dataMessage,
    required this.quality,
    required this.format,
    required this.timelength,
    required this.acceptFormat,
    required this.acceptDescription,
    required this.acceptQuality,
    required this.videoCodecid,
    required this.seekParam,
    required this.seekType,
    // required this.durl, //durl模式
    //有分段版本到此结束
    required this.dash, //dash才有
    required this.supportFormats, //无分段版本和dash才有
    required this.lastPlayTime,
    required this.lastPlayCid,
    //以上两个，无分段版本才有
  });

  @JsonProperty(name: 'code', defaultValue: '-1')
  final int code;
  @JsonProperty(name: 'message', defaultValue: '未知错误')
  final String message;
  @JsonProperty(name: 'data/from', defaultValue: '')
  final String from;
  @JsonProperty(name: 'data/result', defaultValue: '')
  final String result;
  @JsonProperty(name: 'data/message', defaultValue: '')
  final String dataMessage;
  @JsonProperty(name: 'data/quality', defaultValue: 0)
  final int quality;
  @JsonProperty(name: 'data/format', defaultValue: '')
  final String format;
  @JsonProperty(name: 'data/timelength', defaultValue: 0)
  final int timelength;
  @JsonProperty(name: 'data/accept_format', defaultValue: '')
  final String acceptFormat;
  @JsonProperty(name: 'data/accept_description', defaultValue: [])
  final List<String> acceptDescription;
  @JsonProperty(name: 'data/accept_quality', defaultValue: [])
  final List<int> acceptQuality;
  @JsonProperty(name: 'data/video_codecid', defaultValue: 0)
  final num videoCodecid;
  @JsonProperty(name: 'seek_param', defaultValue: '')
  final String seekParam;
  @JsonProperty(name: 'seek_type', defaultValue: '')
  final String seekType;
  @JsonProperty(name: 'data/durl', defaultValue: [])
  // final List<VideoPlayDurlModel> durl;
  @JsonProperty(name: 'data/dash', defaultValue: {})
  final VideoPlayDashModel dash;
  @JsonProperty(name: 'data/support_formats', defaultValue: [])
  final List<VideoPlaySupportFormatModel> supportFormats;
  @JsonProperty(name: 'data/last_play_time', defaultValue: 0)
  final int lastPlayTime;
  @JsonProperty(name: 'data/last_play_cid', defaultValue: 0)
  final int lastPlayCid;
}

// @jsonSerializable
// class VideoPlayDurlModel {
//   VideoPlayDurlModel({
//     required this.order,
//     required this.length,
//     required this.size,
//     required this.ahead,
//     required this.vhead,
//     required this.url,
//     required this.backupUrl,
//   });
//   @JsonProperty(defaultValue: 0)
//   final int order;
//   @JsonProperty(defaultValue: 0)
//   final int length;
//   @JsonProperty(defaultValue: 0)
//   final int size;
//   @JsonProperty(defaultValue: '')
//   final String ahead;
//   @JsonProperty(defaultValue: '')
//   final String vhead;
//   @JsonProperty(defaultValue: '')
//   final String url;
//   @JsonProperty(name: 'backup_url', defaultValue: [])
//   final List<String> backupUrl;
// }

@jsonSerializable
class VideoPlayDashModel {
  VideoPlayDashModel({
    required this.duration,
    required this.minBufferTime,
    required this.dashMinBufferTime,
    required this.video,
    required this.audio,
  });
  @JsonProperty(defaultValue: 0)
  final int duration;
  @JsonProperty(name: 'min_buffer_time', defaultValue: 0)
  final num minBufferTime;
  @JsonProperty(name: 'dash_min_buffer_time', defaultValue: 0)
  final num dashMinBufferTime;
  @JsonProperty(defaultValue: <VideoPlayVideoAudioModel>[])
  final List<VideoPlayVideoAudioModel> video;
  @JsonProperty(defaultValue: <VideoPlayVideoAudioModel>[])
  final List<VideoPlayVideoAudioModel> audio;
}

@jsonSerializable
class VideoPlayVideoAudioModel {
  VideoPlayVideoAudioModel({
    required this.id,
    required this.baseUrl,
    required this.backupUrl,
    required this.bandwidth,
    // required this.mimeType,
    // required this.audioMimeType,
    required this.codecs,
    required this.width,
    required this.height,
    required this.frameRate,
    // required this.sar,
    required this.startWithSap,
    required this.segmentBase,
    required this.codecid,
  });
  @JsonProperty(defaultValue: 0)
  final int id;
  @JsonProperty(name: 'base_url', defaultValue: '')
  final String baseUrl;
  @JsonProperty(name: 'backup_url', defaultValue: [])
  final List<String> backupUrl;
  @JsonProperty(defaultValue: 0)
  final int bandwidth;
  // @JsonProperty(name: 'mime_type', defaultValue: {})
  // final MimeType mimeType;
  // @JsonProperty(name: 'audio_mime_type', defaultValue: {})
  // final MimeType audioMimeType;
  @JsonProperty(defaultValue: '')
  final String codecs;
  @JsonProperty(defaultValue: 0)
  final int width;
  @JsonProperty(defaultValue: 0)
  final int height;
  @JsonProperty(name: 'frame_rate', defaultValue: '')
  final String frameRate;
  // @JsonProperty(defaultValue: {})
  // final Sar sar;
  @JsonProperty(name: 'start_with_sap', defaultValue: 0)
  final int startWithSap;
  @JsonProperty(name: 'segment_base', defaultValue: {})
  final MVideoPlaySegmentBase segmentBase;
  @JsonProperty(defaultValue: 0)
  final int codecid;
}

// @jsonSerializable
// enum MimeType { audioMp4, videoMp4 }

@jsonSerializable
class VideoPlaySegmentBaseClassModel {
  VideoPlaySegmentBaseClassModel({
    required this.initialization,
    required this.indexRange,
  });
  @JsonProperty(defaultValue: '')
  final String initialization;
  @JsonProperty(defaultValue: '')
  final String indexRange;
}

// enum Sar { empty, the_11 }

@jsonSerializable
class MVideoPlaySegmentBase {
  MVideoPlaySegmentBase({
    required this.initialization,
    required this.indexRange,
  });
  @JsonProperty(defaultValue: '')
  final String initialization;
  @JsonProperty(defaultValue: '')
  final String indexRange;
}

@jsonSerializable
class VideoPlaySupportFormatModel {
  VideoPlaySupportFormatModel({
    required this.quality,
    required this.format,
    required this.newDescription,
    required this.displayDesc,
    required this.superscript,
  });
  @JsonProperty(defaultValue: 0)
  final int quality;
  @JsonProperty(defaultValue: '')
  final String format;
  @JsonProperty(name: 'new_description', defaultValue: '')
  final String newDescription;
  @JsonProperty(name: 'display_desc', defaultValue: '')
  final String displayDesc;
  @JsonProperty(defaultValue: '')
  final String superscript;
}
