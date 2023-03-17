import 'dart:convert';

class BangumiSearchResponse {
  BangumiSearchResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  Data? data;

  factory BangumiSearchResponse.fromRawJson(String str) =>
      BangumiSearchResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BangumiSearchResponse.fromJson(Map<String, dynamic> json) =>
      BangumiSearchResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
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
  List<SearchBangumiResponseResultItem>? result;
  int? showColumn;
  int? inBlackKey;
  int? inWhiteKey;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
            : List<SearchBangumiResponseResultItem>.from(json["result"]!
                .map((x) => SearchBangumiResponseResultItem.fromJson(x))),
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

class SearchBangumiResponseResultItem {
  SearchBangumiResponseResultItem({
    this.type,
    this.mediaId,
    this.title,
    this.orgTitle,
    this.mediaType,
    this.cv,
    this.staff,
    this.seasonId,
    this.isAvid,
    this.hitColumns,
    this.hitEpids,
    this.seasonType,
    this.seasonTypeName,
    this.selectionStyle,
    this.epSize,
    this.url,
    this.buttonText,
    this.isFollow,
    this.isSelection,
    this.eps,
    this.badges,
    this.cover,
    this.areas,
    this.styles,
    this.gotoUrl,
    this.desc,
    this.pubtime,
    this.mediaMode,
    this.fixPubtimeStr,
    this.mediaScore,
    this.displayInfo,
    this.pgcSeasonId,
    this.corner,
    this.indexShow,
  });

  String? type;
  int? mediaId;
  String? title;
  String? orgTitle;
  int? mediaType;
  String? cv;
  String? staff;
  int? seasonId;
  bool? isAvid;
  List<String>? hitColumns;
  String? hitEpids;
  int? seasonType;
  String? seasonTypeName;
  String? selectionStyle;
  int? epSize;
  String? url;
  String? buttonText;
  int? isFollow;
  int? isSelection;
  List<Ep>? eps;
  List<Badge>? badges;
  String? cover;
  String? areas;
  String? styles;
  String? gotoUrl;
  String? desc;
  int? pubtime;
  int? mediaMode;
  String? fixPubtimeStr;
  MediaScore? mediaScore;
  List<Badge>? displayInfo;
  int? pgcSeasonId;
  int? corner;
  String? indexShow;

  factory SearchBangumiResponseResultItem.fromRawJson(String str) =>
      SearchBangumiResponseResultItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchBangumiResponseResultItem.fromJson(Map<String, dynamic> json) =>
      SearchBangumiResponseResultItem(
        type: json["type"],
        mediaId: json["media_id"],
        title: json["title"],
        orgTitle: json["org_title"],
        mediaType: json["media_type"],
        cv: json["cv"],
        staff: json["staff"],
        seasonId: json["season_id"],
        isAvid: json["is_avid"],
        hitColumns: json["hit_columns"] == null
            ? []
            : List<String>.from(json["hit_columns"]!.map((x) => x)),
        hitEpids: json["hit_epids"],
        seasonType: json["season_type"],
        seasonTypeName: json["season_type_name"],
        selectionStyle: json["selection_style"],
        epSize: json["ep_size"],
        url: json["url"],
        buttonText: json["button_text"],
        isFollow: json["is_follow"],
        isSelection: json["is_selection"],
        eps: json["eps"] == null
            ? []
            : List<Ep>.from(json["eps"]!.map((x) => Ep.fromJson(x))),
        badges: json["badges"] == null
            ? []
            : List<Badge>.from(json["badges"]!.map((x) => Badge.fromJson(x))),
        cover: json["cover"],
        areas: json["areas"],
        styles: json["styles"],
        gotoUrl: json["goto_url"],
        desc: json["desc"],
        pubtime: json["pubtime"],
        mediaMode: json["media_mode"],
        fixPubtimeStr: json["fix_pubtime_str"],
        mediaScore: json["media_score"] == null
            ? null
            : MediaScore.fromJson(json["media_score"]),
        displayInfo: json["display_info"] == null
            ? []
            : List<Badge>.from(
                json["display_info"]!.map((x) => Badge.fromJson(x))),
        pgcSeasonId: json["pgc_season_id"],
        corner: json["corner"],
        indexShow: json["index_show"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "media_id": mediaId,
        "title": title,
        "org_title": orgTitle,
        "media_type": mediaType,
        "cv": cv,
        "staff": staff,
        "season_id": seasonId,
        "is_avid": isAvid,
        "hit_columns": hitColumns == null
            ? []
            : List<dynamic>.from(hitColumns!.map((x) => x)),
        "hit_epids": hitEpids,
        "season_type": seasonType,
        "season_type_name": seasonTypeName,
        "selection_style": selectionStyle,
        "ep_size": epSize,
        "url": url,
        "button_text": buttonText,
        "is_follow": isFollow,
        "is_selection": isSelection,
        "eps":
            eps == null ? [] : List<dynamic>.from(eps!.map((x) => x.toJson())),
        "badges": badges == null
            ? []
            : List<dynamic>.from(badges!.map((x) => x.toJson())),
        "cover": cover,
        "areas": areas,
        "styles": styles,
        "goto_url": gotoUrl,
        "desc": desc,
        "pubtime": pubtime,
        "media_mode": mediaMode,
        "fix_pubtime_str": fixPubtimeStr,
        "media_score": mediaScore?.toJson(),
        "display_info": displayInfo == null
            ? []
            : List<dynamic>.from(displayInfo!.map((x) => x.toJson())),
        "pgc_season_id": pgcSeasonId,
        "corner": corner,
        "index_show": indexShow,
      };
}

class Badge {
  Badge({
    this.text,
    this.textColor,
    this.textColorNight,
    this.bgColor,
    this.bgColorNight,
    this.borderColor,
    this.borderColorNight,
    this.bgStyle,
  });

  String? text;
  String? textColor;
  String? textColorNight;
  String? bgColor;
  String? bgColorNight;
  String? borderColor;
  String? borderColorNight;
  int? bgStyle;

  factory Badge.fromRawJson(String str) => Badge.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
        text: json["text"],
        textColor: json["text_color"],
        textColorNight: json["text_color_night"],
        bgColor: json["bg_color"],
        bgColorNight: json["bg_color_night"],
        borderColor: json["border_color"],
        borderColorNight: json["border_color_night"],
        bgStyle: json["bg_style"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "text_color": textColor,
        "text_color_night": textColorNight,
        "bg_color": bgColor,
        "bg_color_night": bgColorNight,
        "border_color": borderColor,
        "border_color_night": borderColorNight,
        "bg_style": bgStyle,
      };
}

class Ep {
  Ep({
    this.id,
    this.cover,
    this.title,
    this.url,
    this.releaseDate,
    this.badges,
    this.indexTitle,
    this.longTitle,
  });

  int? id;
  String? cover;
  String? title;
  String? url;
  String? releaseDate;
  List<Badge>? badges;
  String? indexTitle;
  String? longTitle;

  factory Ep.fromRawJson(String str) => Ep.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ep.fromJson(Map<String, dynamic> json) => Ep(
        id: json["id"],
        cover: json["cover"],
        title: json["title"],
        url: json["url"],
        releaseDate: json["release_date"],
        badges: json["badges"] == null
            ? []
            : List<Badge>.from(json["badges"]!.map((x) => Badge.fromJson(x))),
        indexTitle: json["index_title"],
        longTitle: json["long_title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cover": cover,
        "title": title,
        "url": url,
        "release_date": releaseDate,
        "badges": badges == null
            ? []
            : List<dynamic>.from(badges!.map((x) => x.toJson())),
        "index_title": indexTitle,
        "long_title": longTitle,
      };
}

class MediaScore {
  MediaScore({
    this.score,
    this.userCount,
  });

  double? score;
  int? userCount;

  factory MediaScore.fromRawJson(String str) =>
      MediaScore.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaScore.fromJson(Map<String, dynamic> json) => MediaScore(
        score: json["score"]?.toDouble(),
        userCount: json["user_count"],
      );

  Map<String, dynamic> toJson() => {
        "score": score,
        "user_count": userCount,
      };
}
