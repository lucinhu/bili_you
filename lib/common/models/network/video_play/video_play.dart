import 'dart:convert';

class VideoPlayResponse {
  VideoPlayResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  VideoPlayResponseData? data;

  factory VideoPlayResponse.fromRawJson(String str) =>
      VideoPlayResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VideoPlayResponse.fromJson(Map<String, dynamic> json) =>
      VideoPlayResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null
            ? null
            : VideoPlayResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class VideoPlayResponseData {
  VideoPlayResponseData({
    this.from,
    this.result,
    this.message,
    this.quality,
    this.format,
    this.timelength,
    this.acceptFormat,
    this.acceptDescription,
    this.acceptQuality,
    this.videoCodecid,
    this.seekParam,
    this.seekType,
    this.dash,
    this.supportFormats,
    this.highFormat,
    this.lastPlayTime,
    this.lastPlayCid,
  });

  String? from;
  String? result;
  String? message;
  int? quality;
  String? format;
  int? timelength;
  String? acceptFormat;
  List<String>? acceptDescription;
  List<int>? acceptQuality;
  int? videoCodecid;
  String? seekParam;
  String? seekType;
  Dash? dash;
  List<SupportFormat>? supportFormats;
  dynamic highFormat;
  int? lastPlayTime;
  int? lastPlayCid;

  factory VideoPlayResponseData.fromRawJson(String str) =>
      VideoPlayResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VideoPlayResponseData.fromJson(Map<String, dynamic> json) =>
      VideoPlayResponseData(
        from: json["from"],
        result: json["result"],
        message: json["message"],
        quality: json["quality"],
        format: json["format"],
        timelength: json["timelength"],
        acceptFormat: json["accept_format"],
        acceptDescription: json["accept_description"] == null
            ? []
            : List<String>.from(json["accept_description"]!.map((x) => x)),
        acceptQuality: json["accept_quality"] == null
            ? []
            : List<int>.from(json["accept_quality"]!.map((x) => x)),
        videoCodecid: json["video_codecid"],
        seekParam: json["seek_param"],
        seekType: json["seek_type"],
        dash: json["dash"] == null ? null : Dash.fromJson(json["dash"]),
        supportFormats: json["support_formats"] == null
            ? []
            : List<SupportFormat>.from(
                json["support_formats"]!.map((x) => SupportFormat.fromJson(x))),
        highFormat: json["high_format"],
        lastPlayTime: json["last_play_time"],
        lastPlayCid: json["last_play_cid"],
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "result": result,
        "message": message,
        "quality": quality,
        "format": format,
        "timelength": timelength,
        "accept_format": acceptFormat,
        "accept_description": acceptDescription == null
            ? []
            : List<dynamic>.from(acceptDescription!.map((x) => x)),
        "accept_quality": acceptQuality == null
            ? []
            : List<dynamic>.from(acceptQuality!.map((x) => x)),
        "video_codecid": videoCodecid,
        "seek_param": seekParam,
        "seek_type": seekType,
        "dash": dash?.toJson(),
        "support_formats": supportFormats == null
            ? []
            : List<dynamic>.from(supportFormats!.map((x) => x.toJson())),
        "high_format": highFormat,
        "last_play_time": lastPlayTime,
        "last_play_cid": lastPlayCid,
      };
}

class Dash {
  Dash({
    this.duration,
    this.minBufferTime,
    this.dashMinBufferTime,
    this.video,
    this.audio,
    this.dolby,
    this.flac,
  });

  int? duration;
  double? minBufferTime;
  double? dashMinBufferTime;
  List<VideoOrAudioRaw>? video;
  List<VideoOrAudioRaw>? audio;
  Dolby? dolby;
  Flac? flac;
  factory Dash.fromRawJson(String str) => Dash.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Dash.fromJson(Map<String, dynamic> json) => Dash(
        duration: json["duration"],
        minBufferTime: json["minBufferTime"]?.toDouble(),
        dashMinBufferTime: json["min_buffer_time"]?.toDouble(),
        video: json["video"] == null
            ? []
            : List<VideoOrAudioRaw>.from(
                json["video"]!.map((x) => VideoOrAudioRaw.fromJson(x))),
        audio: json["audio"] == null
            ? []
            : List<VideoOrAudioRaw>.from(
                json["audio"]!.map((x) => VideoOrAudioRaw.fromJson(x))),
        dolby: json["dolby"] == null ? null : Dolby.fromJson(json["dolby"]),
        flac: json["flac"] == null ? null : Flac.fromJson(json["flac"]),
      );

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "minBufferTime": minBufferTime,
        "min_buffer_time": dashMinBufferTime,
        "video": video == null
            ? []
            : List<dynamic>.from(video!.map((x) => x.toJson())),
        "audio": audio == null
            ? []
            : List<dynamic>.from(audio!.map((x) => x.toJson())),
        "dolby": dolby?.toJson(),
        "flac": flac?.toJson(),
      };
}

class VideoOrAudioRaw {
  VideoOrAudioRaw({
    this.id,
    this.baseUrl,
    // this.audioBaseUrl,
    this.backupUrl,
    // this.audioBackupUrl,
    this.bandwidth,
    this.mimeType,
    // this.audioMimeType,
    this.codecs,
    this.width,
    this.height,
    this.frameRate,
    // this.audioFrameRate,
    this.sar,
    this.startWithSap,
    // this.audioStartWithSap,
    this.segmentBase,
    // this.audioSegmentBase,
    this.codecid,
  });

  int? id;
  String? baseUrl;
  // String? audioBaseUrl;
  List<String>? backupUrl;
  // List<String>? audioBackupUrl;
  int? bandwidth;
  String? mimeType;
  // String? audioMimeType;
  String? codecs;
  int? width;
  int? height;
  String? frameRate;
  // String? audioFrameRate;
  String? sar;
  int? startWithSap;
  // int? audioStartWithSap;
  SegmentBase? segmentBase;
  // SegmentBaseClass? audioSegmentBase;
  int? codecid;

  factory VideoOrAudioRaw.fromRawJson(String str) =>
      VideoOrAudioRaw.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VideoOrAudioRaw.fromJson(Map<String, dynamic> json) =>
      VideoOrAudioRaw(
        id: json["id"],
        baseUrl: json["baseUrl"],
        // audioBaseUrl: json["base_url"],
        backupUrl: json["backupUrl"] == null
            ? []
            : List<String>.from(json["backupUrl"]!.map((x) => x)),
        // audioBackupUrl: json["backup_url"] == null
        //     ? []
        //     : List<String>.from(json["backup_url"]!.map((x) => x)),
        bandwidth: json["bandwidth"],
        mimeType: json["mimeType"],
        // audioMimeType: json["mime_type"],
        codecs: json["codecs"],
        width: json["width"],
        height: json["height"],
        frameRate: json["frameRate"],
        // audioFrameRate: json["frame_rate"],
        sar: json["sar"],
        startWithSap: json["startWithSap"],
        // audioStartWithSap: json["start_with_sap"],
        segmentBase: json["SegmentBase"] == null
            ? null
            : SegmentBase.fromJson(json["SegmentBase"]),
        // audioSegmentBase: json["segment_base"] == null
        //     ? null
        //     : SegmentBaseClass.fromJson(json["segment_base"]),
        codecid: json["codecid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "baseUrl": baseUrl,
        // "base_url": audioBaseUrl,
        "backupUrl": backupUrl == null
            ? []
            : List<dynamic>.from(backupUrl!.map((x) => x)),
        // "backup_url": audioBackupUrl == null
        //     ? []
        //     : List<dynamic>.from(audioBackupUrl!.map((x) => x)),
        "bandwidth": bandwidth,
        "mimeType": mimeType,
        // "mime_type": audioMimeType,
        "codecs": codecs,
        "width": width,
        "height": height,
        "frameRate": frameRate,
        // "frame_rate": audioFrameRate,
        "sar": sar,
        "startWithSap": startWithSap,
        // "start_with_sap": audioStartWithSap,
        "SegmentBase": segmentBase?.toJson(),
        // "segment_base": audioSegmentBase?.toJson(),
        "codecid": codecid,
      };
}

class Flac {
  Flac({
    this.display,
    this.audio,
  });

  bool? display;
  VideoOrAudioRaw? audio;

  factory Flac.fromRawJson(String str) => Flac.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Flac.fromJson(Map<String, dynamic> json) => Flac(
        display: json["display"],
        audio: json["audio"] == null
            ? null
            : VideoOrAudioRaw.fromJson(json["audio"]),
      );

  Map<String, dynamic> toJson() => {
        "display": display,
        "audio": audio?.toJson(),
      };
}

class SegmentBaseClass {
  SegmentBaseClass({
    this.initialization,
    this.indexRange,
  });

  String? initialization;
  String? indexRange;

  factory SegmentBaseClass.fromRawJson(String str) =>
      SegmentBaseClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SegmentBaseClass.fromJson(Map<String, dynamic> json) =>
      SegmentBaseClass(
        initialization: json["initialization"],
        indexRange: json["index_range"],
      );

  Map<String, dynamic> toJson() => {
        "initialization": initialization,
        "index_range": indexRange,
      };
}

class SegmentBase {
  SegmentBase({
    this.initialization,
    this.indexRange,
  });

  String? initialization;
  String? indexRange;

  factory SegmentBase.fromRawJson(String str) =>
      SegmentBase.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SegmentBase.fromJson(Map<String, dynamic> json) => SegmentBase(
        initialization: json["Initialization"],
        indexRange: json["indexRange"],
      );

  Map<String, dynamic> toJson() => {
        "Initialization": initialization,
        "indexRange": indexRange,
      };
}

class Dolby {
  Dolby({
    this.type,
    this.audio,
  });

  int? type;
  List<VideoOrAudioRaw>? audio;

  factory Dolby.fromRawJson(String str) => Dolby.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Dolby.fromJson(Map<String, dynamic> json) => Dolby(
        type: json["type"],
        audio: json["audio"] == null
            ? []
            : List<VideoOrAudioRaw>.from(
                json["audio"]!.map((x) => VideoOrAudioRaw.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "audio": audio == null
            ? []
            : List<dynamic>.from(audio!.map((x) => x.toJson())),
      };
}

class SupportFormat {
  SupportFormat({
    this.quality,
    this.format,
    this.newDescription,
    this.displayDesc,
    this.superscript,
    this.codecs,
  });

  int? quality;
  String? format;
  String? newDescription;
  String? displayDesc;
  String? superscript;
  List<String>? codecs;

  factory SupportFormat.fromRawJson(String str) =>
      SupportFormat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SupportFormat.fromJson(Map<String, dynamic> json) => SupportFormat(
        quality: json["quality"],
        format: json["format"],
        newDescription: json["new_description"],
        displayDesc: json["display_desc"],
        superscript: json["superscript"],
        codecs: json["codecs"] == null
            ? []
            : List<String>.from(json["codecs"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "quality": quality,
        "format": format,
        "new_description": newDescription,
        "display_desc": displayDesc,
        "superscript": superscript,
        "codecs":
            codecs == null ? [] : List<dynamic>.from(codecs!.map((x) => x)),
      };
}
