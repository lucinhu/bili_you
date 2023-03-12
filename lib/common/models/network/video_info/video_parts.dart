import 'dart:convert';

class VideoPartsResponse {
  VideoPartsResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  List<VideoPartsResponseDatum>? data;

  factory VideoPartsResponse.fromRawJson(String str) =>
      VideoPartsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VideoPartsResponse.fromJson(Map<String, dynamic> json) =>
      VideoPartsResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null
            ? []
            : List<VideoPartsResponseDatum>.from(
                json["data"]!.map((x) => VideoPartsResponseDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class VideoPartsResponseDatum {
  VideoPartsResponseDatum({
    this.cid,
    this.page,
    this.from,
    this.datumPart,
    this.duration,
    this.vid,
    this.weblink,
    this.dimension,
    this.firstFrame,
  });

  int? cid;
  int? page;
  String? from;
  String? datumPart;
  int? duration;
  String? vid;
  String? weblink;
  Dimension? dimension;
  String? firstFrame;

  factory VideoPartsResponseDatum.fromRawJson(String str) =>
      VideoPartsResponseDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VideoPartsResponseDatum.fromJson(Map<String, dynamic> json) =>
      VideoPartsResponseDatum(
        cid: json["cid"],
        page: json["page"],
        from: json["from"],
        datumPart: json["part"],
        duration: json["duration"],
        vid: json["vid"],
        weblink: json["weblink"],
        dimension: json["dimension"] == null
            ? null
            : Dimension.fromJson(json["dimension"]),
        firstFrame: json["first_frame"],
      );

  Map<String, dynamic> toJson() => {
        "cid": cid,
        "page": page,
        "from": from,
        "part": datumPart,
        "duration": duration,
        "vid": vid,
        "weblink": weblink,
        "dimension": dimension?.toJson(),
        "first_frame": firstFrame,
      };
}

class Dimension {
  Dimension({
    this.width,
    this.height,
    this.rotate,
  });

  int? width;
  int? height;
  int? rotate;

  factory Dimension.fromRawJson(String str) =>
      Dimension.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Dimension.fromJson(Map<String, dynamic> json) => Dimension(
        width: json["width"],
        height: json["height"],
        rotate: json["rotate"],
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
        "rotate": rotate,
      };
}
