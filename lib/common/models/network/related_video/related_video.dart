import 'dart:convert';

import 'package:bili_you/common/models/network/home/recommend_video.dart';

class RelatedVideoResponse {
  RelatedVideoResponse({
    this.code,
    this.data,
    this.message,
  });

  int? code;
  List<RelatedVideoResponseDatum>? data;
  String? message;

  factory RelatedVideoResponse.fromRawJson(String str) =>
      RelatedVideoResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RelatedVideoResponse.fromJson(Map<String, dynamic> json) =>
      RelatedVideoResponse(
        code: json["code"],
        data: json["data"] == null
            ? []
            : List<RelatedVideoResponseDatum>.from(json["data"]!
                .map((x) => RelatedVideoResponseDatum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class RelatedVideoResponseDatum {
  RelatedVideoResponseDatum({
    this.aid,
    this.videos,
    this.tid,
    this.tname,
    this.copyright,
    this.pic,
    this.title,
    this.pubdate,
    this.ctime,
    this.desc,
    this.state,
    this.duration,
    this.missionId,
    this.rights,
    this.owner,
    this.stat,
    this.datumDynamic,
    this.cid,
    this.dimension,
    this.shortLink,
    this.shortLinkV2,
    this.bvid,
    this.seasonType,
    this.isOgv,
    this.ogvInfo,
    this.rcmdReason,
    this.upFromV2,
    this.firstFrame,
    this.pubLocation,
    this.seasonId,
  });

  int? aid;
  int? videos;
  int? tid;
  String? tname;
  int? copyright;
  String? pic;
  String? title;
  int? pubdate;
  int? ctime;
  String? desc;
  int? state;
  int? duration;
  int? missionId;
  Map<String, int>? rights;
  Owner? owner;
  Stat? stat;
  String? datumDynamic;
  int? cid;
  Dimension? dimension;
  String? shortLink;
  String? shortLinkV2;
  String? bvid;
  int? seasonType;
  bool? isOgv;
  dynamic ogvInfo;
  String? rcmdReason;
  int? upFromV2;
  String? firstFrame;
  String? pubLocation;
  int? seasonId;

  factory RelatedVideoResponseDatum.fromRawJson(String str) =>
      RelatedVideoResponseDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RelatedVideoResponseDatum.fromJson(Map<String, dynamic> json) =>
      RelatedVideoResponseDatum(
        aid: json["aid"],
        videos: json["videos"],
        tid: json["tid"],
        tname: json["tname"],
        copyright: json["copyright"],
        pic: json["pic"],
        title: json["title"],
        pubdate: json["pubdate"],
        ctime: json["ctime"],
        desc: json["desc"],
        state: json["state"],
        duration: json["duration"],
        missionId: json["mission_id"],
        rights: Map.from(json["rights"]!)
            .map((k, v) => MapEntry<String, int>(k, v)),
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
        stat: json["stat"] == null ? null : Stat.fromJson(json["stat"]),
        datumDynamic: json["dynamic"],
        cid: json["cid"],
        dimension: json["dimension"] == null
            ? null
            : Dimension.fromJson(json["dimension"]),
        shortLink: json["short_link"],
        shortLinkV2: json["short_link_v2"],
        bvid: json["bvid"],
        seasonType: json["season_type"],
        isOgv: json["is_ogv"],
        ogvInfo: json["ogv_info"],
        rcmdReason: json["rcmd_reason"],
        upFromV2: json["up_from_v2"],
        firstFrame: json["first_frame"],
        pubLocation: json["pub_location"],
        seasonId: json["season_id"],
      );

  Map<String, dynamic> toJson() => {
        "aid": aid,
        "videos": videos,
        "tid": tid,
        "tname": tname,
        "copyright": copyright,
        "pic": pic,
        "title": title,
        "pubdate": pubdate,
        "ctime": ctime,
        "desc": desc,
        "state": state,
        "duration": duration,
        "mission_id": missionId,
        "rights":
            Map.from(rights!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "owner": owner?.toJson(),
        "stat": stat?.toJson(),
        "dynamic": datumDynamic,
        "cid": cid,
        "dimension": dimension?.toJson(),
        "short_link": shortLink,
        "short_link_v2": shortLinkV2,
        "bvid": bvid,
        "season_type": seasonType,
        "is_ogv": isOgv,
        "ogv_info": ogvInfo,
        "rcmd_reason": rcmdReason,
        "up_from_v2": upFromV2,
        "first_frame": firstFrame,
        "pub_location": pubLocation,
        "season_id": seasonId,
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

class Owner {
  Owner({
    this.mid,
    this.name,
    this.face,
  });

  int? mid;
  String? name;
  String? face;

  factory Owner.fromRawJson(String str) => Owner.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        mid: json["mid"],
        name: json["name"],
        face: json["face"],
      );

  Map<String, dynamic> toJson() => {
        "mid": mid,
        "name": name,
        "face": face,
      };
}
