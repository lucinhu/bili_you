import 'dart:convert';

class VideoInfoResponse {
  VideoInfoResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  VideoInfoResponseData? data;

  factory VideoInfoResponse.fromRawJson(String str) =>
      VideoInfoResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VideoInfoResponse.fromJson(Map<String, dynamic> json) =>
      VideoInfoResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null
            ? null
            : VideoInfoResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class VideoInfoResponseData {
  VideoInfoResponseData({
    this.bvid,
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
    this.descV2,
    this.state,
    this.duration,
    this.rights,
    this.owner,
    this.stat,
    this.dataDynamic,
    this.cid,
    this.dimension,
    this.premiere,
    this.teenageMode,
    this.isChargeableSeason,
    this.isStory,
    this.noCache,
    this.pages,
    this.subtitle,
    this.isSeasonDisplay,
    this.userGarb,
    this.honorReply,
    this.likeIcon,
    this.needJumpBv,
  });

  String? bvid;
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
  List<DescV2>? descV2;
  int? state;
  int? duration;
  Map<String, int>? rights;
  Owner? owner;
  Stat? stat;
  String? dataDynamic;
  int? cid;
  Dimension? dimension;
  dynamic premiere;
  int? teenageMode;
  bool? isChargeableSeason;
  bool? isStory;
  bool? noCache;
  List<Page>? pages;
  Subtitle? subtitle;
  bool? isSeasonDisplay;
  UserGarb? userGarb;
  HonorReply? honorReply;
  String? likeIcon;
  bool? needJumpBv;

  factory VideoInfoResponseData.fromRawJson(String str) =>
      VideoInfoResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VideoInfoResponseData.fromJson(Map<String, dynamic> json) =>
      VideoInfoResponseData(
        bvid: json["bvid"],
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
        descV2: json["desc_v2"] == null
            ? []
            : List<DescV2>.from(
                json["desc_v2"]!.map((x) => DescV2.fromJson(x))),
        state: json["state"],
        duration: json["duration"],
        rights: Map.from(json["rights"]!)
            .map((k, v) => MapEntry<String, int>(k, v)),
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
        stat: json["stat"] == null ? null : Stat.fromJson(json["stat"]),
        dataDynamic: json["dynamic"],
        cid: json["cid"],
        dimension: json["dimension"] == null
            ? null
            : Dimension.fromJson(json["dimension"]),
        premiere: json["premiere"],
        teenageMode: json["teenage_mode"],
        isChargeableSeason: json["is_chargeable_season"],
        isStory: json["is_story"],
        noCache: json["no_cache"],
        pages: json["pages"] == null
            ? []
            : List<Page>.from(json["pages"]!.map((x) => Page.fromJson(x))),
        subtitle: json["subtitle"] == null
            ? null
            : Subtitle.fromJson(json["subtitle"]),
        isSeasonDisplay: json["is_season_display"],
        userGarb: json["user_garb"] == null
            ? null
            : UserGarb.fromJson(json["user_garb"]),
        honorReply: json["honor_reply"] == null
            ? null
            : HonorReply.fromJson(json["honor_reply"]),
        likeIcon: json["like_icon"],
        needJumpBv: json["need_jump_bv"],
      );

  Map<String, dynamic> toJson() => {
        "bvid": bvid,
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
        "desc_v2": descV2 == null
            ? []
            : List<dynamic>.from(descV2!.map((x) => x.toJson())),
        "state": state,
        "duration": duration,
        "rights":
            Map.from(rights!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "owner": owner?.toJson(),
        "stat": stat?.toJson(),
        "dynamic": dataDynamic,
        "cid": cid,
        "dimension": dimension?.toJson(),
        "premiere": premiere,
        "teenage_mode": teenageMode,
        "is_chargeable_season": isChargeableSeason,
        "is_story": isStory,
        "no_cache": noCache,
        "pages": pages == null
            ? []
            : List<dynamic>.from(pages!.map((x) => x.toJson())),
        "subtitle": subtitle?.toJson(),
        "is_season_display": isSeasonDisplay,
        "user_garb": userGarb?.toJson(),
        "honor_reply": honorReply?.toJson(),
        "like_icon": likeIcon,
        "need_jump_bv": needJumpBv,
      };
}

class DescV2 {
  DescV2({
    this.rawText,
    this.type,
    this.bizId,
  });

  String? rawText;
  int? type;
  int? bizId;

  factory DescV2.fromRawJson(String str) => DescV2.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DescV2.fromJson(Map<String, dynamic> json) => DescV2(
        rawText: json["raw_text"],
        type: json["type"],
        bizId: json["biz_id"],
      );

  Map<String, dynamic> toJson() => {
        "raw_text": rawText,
        "type": type,
        "biz_id": bizId,
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

class HonorReply {
  HonorReply({
    this.honor,
  });

  List<Honor>? honor;

  factory HonorReply.fromRawJson(String str) =>
      HonorReply.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HonorReply.fromJson(Map<String, dynamic> json) => HonorReply(
        honor: json["honor"] == null
            ? []
            : List<Honor>.from(json["honor"]!.map((x) => Honor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "honor": honor == null
            ? []
            : List<dynamic>.from(honor!.map((x) => x.toJson())),
      };
}

class Honor {
  Honor({
    this.aid,
    this.type,
    this.desc,
    this.weeklyRecommendNum,
  });

  int? aid;
  int? type;
  String? desc;
  int? weeklyRecommendNum;

  factory Honor.fromRawJson(String str) => Honor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Honor.fromJson(Map<String, dynamic> json) => Honor(
        aid: json["aid"],
        type: json["type"],
        desc: json["desc"],
        weeklyRecommendNum: json["weekly_recommend_num"],
      );

  Map<String, dynamic> toJson() => {
        "aid": aid,
        "type": type,
        "desc": desc,
        "weekly_recommend_num": weeklyRecommendNum,
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

class Page {
  Page({
    this.cid,
    this.page,
    this.from,
    this.pagePart,
    this.duration,
    this.vid,
    this.weblink,
    this.dimension,
    this.firstFrame,
  });

  int? cid;
  int? page;
  String? from;
  String? pagePart;
  int? duration;
  String? vid;
  String? weblink;
  Dimension? dimension;
  String? firstFrame;

  factory Page.fromRawJson(String str) => Page.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Page.fromJson(Map<String, dynamic> json) => Page(
        cid: json["cid"],
        page: json["page"],
        from: json["from"],
        pagePart: json["part"],
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
        "part": pagePart,
        "duration": duration,
        "vid": vid,
        "weblink": weblink,
        "dimension": dimension?.toJson(),
        "first_frame": firstFrame,
      };
}

class Stat {
  Stat({
    this.aid,
    this.view,
    this.danmaku,
    this.reply,
    this.favorite,
    this.coin,
    this.share,
    this.nowRank,
    this.hisRank,
    this.like,
    this.dislike,
    this.evaluation,
    this.argueMsg,
  });

  int? aid;
  int? view;
  int? danmaku;
  int? reply;
  int? favorite;
  int? coin;
  int? share;
  int? nowRank;
  int? hisRank;
  int? like;
  int? dislike;
  String? evaluation;
  String? argueMsg;

  factory Stat.fromRawJson(String str) => Stat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        aid: json["aid"],
        view: json["view"],
        danmaku: json["danmaku"],
        reply: json["reply"],
        favorite: json["favorite"],
        coin: json["coin"],
        share: json["share"],
        nowRank: json["now_rank"],
        hisRank: json["his_rank"],
        like: json["like"],
        dislike: json["dislike"],
        evaluation: json["evaluation"],
        argueMsg: json["argue_msg"],
      );

  Map<String, dynamic> toJson() => {
        "aid": aid,
        "view": view,
        "danmaku": danmaku,
        "reply": reply,
        "favorite": favorite,
        "coin": coin,
        "share": share,
        "now_rank": nowRank,
        "his_rank": hisRank,
        "like": like,
        "dislike": dislike,
        "evaluation": evaluation,
        "argue_msg": argueMsg,
      };
}

class Subtitle {
  Subtitle({
    this.allowSubmit,
    this.list,
  });

  bool? allowSubmit;
  List<dynamic>? list;

  factory Subtitle.fromRawJson(String str) =>
      Subtitle.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subtitle.fromJson(Map<String, dynamic> json) => Subtitle(
        allowSubmit: json["allow_submit"],
        list: json["list"] == null
            ? []
            : List<dynamic>.from(json["list"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "allow_submit": allowSubmit,
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x)),
      };
}

class UserGarb {
  UserGarb({
    this.urlImageAniCut,
  });

  String? urlImageAniCut;

  factory UserGarb.fromRawJson(String str) =>
      UserGarb.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserGarb.fromJson(Map<String, dynamic> json) => UserGarb(
        urlImageAniCut: json["url_image_ani_cut"],
      );

  Map<String, dynamic> toJson() => {
        "url_image_ani_cut": urlImageAniCut,
      };
}
