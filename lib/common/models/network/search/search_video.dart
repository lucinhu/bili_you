import 'dart:convert';

class SearchVideoResponse {
  SearchVideoResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  SearchVideoResponseData? data;

  factory SearchVideoResponse.fromRawJson(String str) =>
      SearchVideoResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchVideoResponse.fromJson(Map<String, dynamic> json) =>
      SearchVideoResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null
            ? null
            : SearchVideoResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class SearchVideoResponseData {
  SearchVideoResponseData({
    this.seid,
    this.page,
    this.pagesize,
    this.numResults,
    this.numPages,
    this.suggestKeyword,
    this.rqtType,
    this.costTime,
    this.expList,
    this.eggHit,
    this.result,
    this.showColumn,
    this.inBlackKey,
    this.inWhiteKey,
  });

  String? seid;
  int? page;
  int? pagesize;
  int? numResults;
  int? numPages;
  String? suggestKeyword;
  String? rqtType;
  CostTime? costTime;
  Map<String, bool>? expList;
  int? eggHit;
  List<Result>? result;
  int? showColumn;
  int? inBlackKey;
  int? inWhiteKey;

  factory SearchVideoResponseData.fromRawJson(String str) =>
      SearchVideoResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchVideoResponseData.fromJson(Map<String, dynamic> json) =>
      SearchVideoResponseData(
        seid: json["seid"],
        page: json["page"],
        pagesize: json["pagesize"],
        numResults: json["numResults"],
        numPages: json["numPages"],
        suggestKeyword: json["suggest_keyword"],
        rqtType: json["rqt_type"],
        costTime: json["cost_time"] == null
            ? null
            : CostTime.fromJson(json["cost_time"]),
        expList: Map.from(json["exp_list"]!)
            .map((k, v) => MapEntry<String, bool>(k, v)),
        eggHit: json["egg_hit"],
        result: json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
        showColumn: json["show_column"],
        inBlackKey: json["in_black_key"],
        inWhiteKey: json["in_white_key"],
      );

  Map<String, dynamic> toJson() => {
        "seid": seid,
        "page": page,
        "pagesize": pagesize,
        "numResults": numResults,
        "numPages": numPages,
        "suggest_keyword": suggestKeyword,
        "rqt_type": rqtType,
        "cost_time": costTime?.toJson(),
        "exp_list":
            Map.from(expList!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "egg_hit": eggHit,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
        "show_column": showColumn,
        "in_black_key": inBlackKey,
        "in_white_key": inWhiteKey,
      };
}

class CostTime {
  CostTime({
    this.paramsCheck,
    this.isRiskQuery,
    this.illegalHandler,
    this.asResponseFormat,
    this.asRequest,
    this.saveCache,
    this.deserializeResponse,
    this.asRequestFormat,
    this.total,
    this.mainHandler,
  });

  String? paramsCheck;
  String? isRiskQuery;
  String? illegalHandler;
  String? asResponseFormat;
  String? asRequest;
  String? saveCache;
  String? deserializeResponse;
  String? asRequestFormat;
  String? total;
  String? mainHandler;

  factory CostTime.fromRawJson(String str) =>
      CostTime.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CostTime.fromJson(Map<String, dynamic> json) => CostTime(
        paramsCheck: json["params_check"],
        isRiskQuery: json["is_risk_query"],
        illegalHandler: json["illegal_handler"],
        asResponseFormat: json["as_response_format"],
        asRequest: json["as_request"],
        saveCache: json["save_cache"],
        deserializeResponse: json["deserialize_response"],
        asRequestFormat: json["as_request_format"],
        total: json["total"],
        mainHandler: json["main_handler"],
      );

  Map<String, dynamic> toJson() => {
        "params_check": paramsCheck,
        "is_risk_query": isRiskQuery,
        "illegal_handler": illegalHandler,
        "as_response_format": asResponseFormat,
        "as_request": asRequest,
        "save_cache": saveCache,
        "deserialize_response": deserializeResponse,
        "as_request_format": asRequestFormat,
        "total": total,
        "main_handler": mainHandler,
      };
}

class Result {
  Result({
    this.type,
    this.id,
    this.author,
    this.mid,
    this.typeid,
    this.typename,
    this.arcurl,
    this.aid,
    this.bvid,
    this.title,
    this.description,
    this.arcrank,
    this.pic,
    this.play,
    this.videoReview,
    this.favorites,
    this.tag,
    this.review,
    this.pubdate,
    this.senddate,
    this.duration,
    this.badgepay,
    this.hitColumns,
    this.viewType,
    this.isPay,
    this.isUnionVideo,
    this.recTags,
    this.newRecTags,
    this.rankScore,
    this.like,
    this.upic,
    this.corner,
    this.cover,
    this.desc,
    this.url,
    this.recReason,
    this.danmaku,
    this.bizData,
  });

  String? type;
  int? id;
  String? author;
  int? mid;
  String? typeid;
  String? typename;
  String? arcurl;
  int? aid;
  String? bvid;
  String? title;
  String? description;
  String? arcrank;
  String? pic;
  int? play;
  int? videoReview;
  int? favorites;
  String? tag;
  int? review;
  int? pubdate;
  int? senddate;
  String? duration;
  bool? badgepay;
  List<String>? hitColumns;
  String? viewType;
  int? isPay;
  int? isUnionVideo;
  dynamic recTags;
  List<dynamic>? newRecTags;
  int? rankScore;
  int? like;
  String? upic;
  String? corner;
  String? cover;
  String? desc;
  String? url;
  String? recReason;
  int? danmaku;
  dynamic bizData;

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        type: json["type"],
        id: json["id"],
        author: json["author"],
        mid: json["mid"],
        typeid: json["typeid"],
        typename: json["typename"],
        arcurl: json["arcurl"],
        aid: json["aid"],
        bvid: json["bvid"],
        title: json["title"],
        description: json["description"],
        arcrank: json["arcrank"],
        pic: json["pic"],
        play: json["play"],
        videoReview: json["video_review"],
        favorites: json["favorites"],
        tag: json["tag"],
        review: json["review"],
        pubdate: json["pubdate"],
        senddate: json["senddate"],
        duration: json["duration"],
        badgepay: json["badgepay"],
        hitColumns: json["hit_columns"] == null
            ? []
            : List<String>.from(json["hit_columns"]!.map((x) => x)),
        viewType: json["view_type"],
        isPay: json["is_pay"],
        isUnionVideo: json["is_union_video"],
        recTags: json["rec_tags"],
        newRecTags: json["new_rec_tags"] == null
            ? []
            : List<dynamic>.from(json["new_rec_tags"]!.map((x) => x)),
        rankScore: json["rank_score"],
        like: json["like"],
        upic: json["upic"],
        corner: json["corner"],
        cover: json["cover"],
        desc: json["desc"],
        url: json["url"],
        recReason: json["rec_reason"],
        danmaku: json["danmaku"],
        bizData: json["biz_data"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "author": author,
        "mid": mid,
        "typeid": typeid,
        "typename": typename,
        "arcurl": arcurl,
        "aid": aid,
        "bvid": bvid,
        "title": title,
        "description": description,
        "arcrank": arcrank,
        "pic": pic,
        "play": play,
        "video_review": videoReview,
        "favorites": favorites,
        "tag": tag,
        "review": review,
        "pubdate": pubdate,
        "senddate": senddate,
        "duration": duration,
        "badgepay": badgepay,
        "hit_columns": hitColumns == null
            ? []
            : List<dynamic>.from(hitColumns!.map((x) => x)),
        "view_type": viewType,
        "is_pay": isPay,
        "is_union_video": isUnionVideo,
        "rec_tags": recTags,
        "new_rec_tags": newRecTags == null
            ? []
            : List<dynamic>.from(newRecTags!.map((x) => x)),
        "rank_score": rankScore,
        "like": like,
        "upic": upic,
        "corner": corner,
        "cover": cover,
        "desc": desc,
        "url": url,
        "rec_reason": recReason,
        "danmaku": danmaku,
        "biz_data": bizData,
      };
}
