import 'dart:convert';

class RecommendVideoResponse {
  RecommendVideoResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  RecommendVideoResponseData? data;

  factory RecommendVideoResponse.fromRawJson(String str) =>
      RecommendVideoResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecommendVideoResponse.fromJson(Map<String, dynamic> json) =>
      RecommendVideoResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null
            ? null
            : RecommendVideoResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class RecommendVideoResponseData {
  RecommendVideoResponseData({
    this.item,
    this.businessCard,
    this.floorInfo,
    this.userFeature,
    this.preloadExposePct,
    this.preloadFloorExposePct,
    this.mid,
  });

  List<RecommendVideoResponseItem>? item;
  dynamic businessCard;
  dynamic floorInfo;
  dynamic userFeature;
  double? preloadExposePct;
  double? preloadFloorExposePct;
  int? mid;

  factory RecommendVideoResponseData.fromRawJson(String str) =>
      RecommendVideoResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecommendVideoResponseData.fromJson(Map<String, dynamic> json) =>
      RecommendVideoResponseData(
        item: json["item"] == null
            ? []
            : List<RecommendVideoResponseItem>.from(json["item"]!
                .map((x) => RecommendVideoResponseItem.fromJson(x))),
        businessCard: json["business_card"],
        floorInfo: json["floor_info"],
        userFeature: json["user_feature"],
        preloadExposePct: json["preload_expose_pct"]?.toDouble(),
        preloadFloorExposePct: json["preload_floor_expose_pct"]?.toDouble(),
        mid: json["mid"],
      );

  Map<String, dynamic> toJson() => {
        "item": item == null
            ? []
            : List<dynamic>.from(item!.map((x) => x.toJson())),
        "business_card": businessCard,
        "floor_info": floorInfo,
        "user_feature": userFeature,
        "preload_expose_pct": preloadExposePct,
        "preload_floor_expose_pct": preloadFloorExposePct,
        "mid": mid,
      };
}

class RecommendVideoResponseItem {
  RecommendVideoResponseItem({
    this.id,
    this.bvid,
    this.cid,
    this.goto,
    this.uri,
    this.pic,
    this.title,
    this.duration,
    this.pubdate,
    this.owner,
    this.stat,
    this.avFeature,
    this.isFollowed,
    this.rcmdReason,
    this.showInfo,
    this.trackId,
    this.pos,
    this.roomInfo,
    this.ogvInfo,
    this.businessInfo,
    this.isStock,
  });

  int? id;
  String? bvid;
  int? cid;
  String? goto;
  String? uri;
  String? pic;
  String? title;
  int? duration;
  int? pubdate;
  Owner? owner;
  Stat? stat;
  dynamic avFeature;
  int? isFollowed;
  RcmdReason? rcmdReason;
  int? showInfo;
  String? trackId;
  int? pos;
  dynamic roomInfo;
  dynamic ogvInfo;
  dynamic businessInfo;
  int? isStock;

  factory RecommendVideoResponseItem.fromRawJson(String str) =>
      RecommendVideoResponseItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecommendVideoResponseItem.fromJson(Map<String, dynamic> json) =>
      RecommendVideoResponseItem(
        id: json["id"],
        bvid: json["bvid"],
        cid: json["cid"],
        goto: json["goto"],
        uri: json["uri"],
        pic: json["pic"],
        title: json["title"],
        duration: json["duration"],
        pubdate: json["pubdate"],
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
        stat: json["stat"] == null ? null : Stat.fromJson(json["stat"]),
        avFeature: json["av_feature"],
        isFollowed: json["is_followed"],
        rcmdReason: json["rcmd_reason"] == null
            ? null
            : RcmdReason.fromJson(json["rcmd_reason"]),
        showInfo: json["show_info"],
        trackId: json["track_id"],
        pos: json["pos"],
        roomInfo: json["room_info"],
        ogvInfo: json["ogv_info"],
        businessInfo: json["business_info"],
        isStock: json["is_stock"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bvid": bvid,
        "cid": cid,
        "goto": goto,
        "uri": uri,
        "pic": pic,
        "title": title,
        "duration": duration,
        "pubdate": pubdate,
        "owner": owner?.toJson(),
        "stat": stat?.toJson(),
        "av_feature": avFeature,
        "is_followed": isFollowed,
        "rcmd_reason": rcmdReason?.toJson(),
        "show_info": showInfo,
        "track_id": trackId,
        "pos": pos,
        "room_info": roomInfo,
        "ogv_info": ogvInfo,
        "business_info": businessInfo,
        "is_stock": isStock,
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

class RcmdReason {
  RcmdReason({
    this.content,
    this.reasonType,
  });

  String? content;
  int? reasonType;

  factory RcmdReason.fromRawJson(String str) =>
      RcmdReason.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RcmdReason.fromJson(Map<String, dynamic> json) => RcmdReason(
        content: json["content"],
        reasonType: json["reason_type"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "reason_type": reasonType,
      };
}

class Stat {
  Stat({
    this.view,
    this.like,
    this.danmaku,
  });

  int? view;
  int? like;
  int? danmaku;

  factory Stat.fromRawJson(String str) => Stat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        view: json["view"],
        like: json["like"],
        danmaku: json["danmaku"],
      );

  Map<String, dynamic> toJson() => {
        "view": view,
        "like": like,
        "danmaku": danmaku,
      };
}
