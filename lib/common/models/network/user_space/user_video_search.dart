import 'dart:convert';

//用户视频投稿/查询
class UserVideoSearchResponse {
  UserVideoSearchResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  UserVideoSearchData? data;

  factory UserVideoSearchResponse.fromRawJson(String str) =>
      UserVideoSearchResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserVideoSearchResponse.fromJson(Map<String, dynamic> json) =>
      UserVideoSearchResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null
            ? null
            : UserVideoSearchData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class UserVideoSearchData {
  UserVideoSearchData({
    this.list,
    this.page,
    this.episodicButton,
    this.isRisk,
    this.gaiaResType,
    this.gaiaData,
  });

  ListClass? list;
  Page? page;
  EpisodicButton? episodicButton;
  bool? isRisk;
  int? gaiaResType;
  dynamic gaiaData;

  factory UserVideoSearchData.fromRawJson(String str) =>
      UserVideoSearchData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserVideoSearchData.fromJson(Map<String, dynamic> json) =>
      UserVideoSearchData(
        list: json["list"] == null ? null : ListClass.fromJson(json["list"]),
        page: json["page"] == null ? null : Page.fromJson(json["page"]),
        episodicButton: json["episodic_button"] == null
            ? null
            : EpisodicButton.fromJson(json["episodic_button"]),
        isRisk: json["is_risk"],
        gaiaResType: json["gaia_res_type"],
        gaiaData: json["gaia_data"],
      );

  Map<String, dynamic> toJson() => {
        "list": list?.toJson(),
        "page": page?.toJson(),
        "episodic_button": episodicButton?.toJson(),
        "is_risk": isRisk,
        "gaia_res_type": gaiaResType,
        "gaia_data": gaiaData,
      };
}

class EpisodicButton {
  EpisodicButton({
    this.text,
    this.uri,
  });

  String? text;
  String? uri;

  factory EpisodicButton.fromRawJson(String str) =>
      EpisodicButton.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EpisodicButton.fromJson(Map<String, dynamic> json) => EpisodicButton(
        text: json["text"],
        uri: json["uri"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "uri": uri,
      };
}

class ListClass {
  ListClass({
    this.tlist,
    this.vlist,
  });

  Map<String, Tlist>? tlist;
  List<Vlist>? vlist;

  factory ListClass.fromRawJson(String str) =>
      ListClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListClass.fromJson(Map<String, dynamic> json) => ListClass(
        tlist: json["tlist"] == null
            ? {}
            : Map.from(json["tlist"]!)
                .map((k, v) => MapEntry<String, Tlist>(k, Tlist.fromJson(v))),
        vlist: json["vlist"] == null
            ? []
            : List<Vlist>.from(json["vlist"]!.map((x) => Vlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tlist": Map.from(tlist!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "vlist": vlist == null
            ? []
            : List<dynamic>.from(vlist!.map((x) => x.toJson())),
      };
}

class Tlist {
  Tlist({
    this.tid,
    this.count,
    this.name,
  });

  int? tid;
  int? count;
  String? name;

  factory Tlist.fromRawJson(String str) => Tlist.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tlist.fromJson(Map<String, dynamic> json) => Tlist(
        tid: json["tid"],
        count: json["count"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "tid": tid,
        "count": count,
        "name": name,
      };
}

class Vlist {
  Vlist({
    this.comment,
    this.typeid,
    this.play,
    this.pic,
    this.subtitle,
    this.description,
    this.copyright,
    this.title,
    this.review,
    this.author,
    this.mid,
    this.created,
    this.length,
    this.videoReview,
    this.aid,
    this.bvid,
    this.hideClick,
    this.isPay,
    this.isUnionVideo,
    this.isSteinsGate,
    this.isLivePlayback,
    this.meta,
    this.isAvoided,
    this.attribute,
  });

  int? comment;
  int? typeid;
  int? play;
  String? pic;
  String? subtitle;
  String? description;
  String? copyright;
  String? title;
  int? review;
  String? author;
  int? mid;
  int? created;
  String? length;
  int? videoReview;
  int? aid;
  String? bvid;
  bool? hideClick;
  int? isPay;
  int? isUnionVideo;
  int? isSteinsGate;
  int? isLivePlayback;
  dynamic meta;
  int? isAvoided;
  int? attribute;

  factory Vlist.fromRawJson(String str) => Vlist.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Vlist.fromJson(Map<String, dynamic> json) => Vlist(
        comment: json["comment"],
        typeid: json["typeid"],
        play: json["play"],
        pic: json["pic"],
        subtitle: json["subtitle"],
        description: json["description"],
        copyright: json["copyright"],
        title: json["title"],
        review: json["review"],
        author: json["author"],
        mid: json["mid"],
        created: json["created"],
        length: json["length"],
        videoReview: json["video_review"],
        aid: json["aid"],
        bvid: json["bvid"],
        hideClick: json["hide_click"],
        isPay: json["is_pay"],
        isUnionVideo: json["is_union_video"],
        isSteinsGate: json["is_steins_gate"],
        isLivePlayback: json["is_live_playback"],
        meta: json["meta"],
        isAvoided: json["is_avoided"],
        attribute: json["attribute"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "typeid": typeid,
        "play": play,
        "pic": pic,
        "subtitle": subtitle,
        "description": description,
        "copyright": copyright,
        "title": title,
        "review": review,
        "author": author,
        "mid": mid,
        "created": created,
        "length": length,
        "video_review": videoReview,
        "aid": aid,
        "bvid": bvid,
        "hide_click": hideClick,
        "is_pay": isPay,
        "is_union_video": isUnionVideo,
        "is_steins_gate": isSteinsGate,
        "is_live_playback": isLivePlayback,
        "meta": meta,
        "is_avoided": isAvoided,
        "attribute": attribute,
      };
}

class Page {
  Page({
    this.pn,
    this.ps,
    this.count,
  });

  int? pn;
  int? ps;
  int? count;

  factory Page.fromRawJson(String str) => Page.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Page.fromJson(Map<String, dynamic> json) => Page(
        pn: json["pn"],
        ps: json["ps"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "pn": pn,
        "ps": ps,
        "count": count,
      };
}
