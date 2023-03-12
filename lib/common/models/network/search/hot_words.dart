import 'dart:convert';

class HotWordResponse {
  HotWordResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  HotWordResponseData? data;

  factory HotWordResponse.fromRawJson(String str) =>
      HotWordResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HotWordResponse.fromJson(Map<String, dynamic> json) =>
      HotWordResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null
            ? null
            : HotWordResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class HotWordResponseData {
  HotWordResponseData({
    this.trackid,
    this.list,
    this.expStr,
    this.topList,
  });

  String? trackid;
  List<ListElement>? list;
  String? expStr;
  List<TopList>? topList;

  factory HotWordResponseData.fromRawJson(String str) =>
      HotWordResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HotWordResponseData.fromJson(Map<String, dynamic> json) =>
      HotWordResponseData(
        trackid: json["trackid"],
        list: json["list"] == null
            ? []
            : List<ListElement>.from(
                json["list"]!.map((x) => ListElement.fromJson(x))),
        expStr: json["exp_str"],
        topList: json["top_list"] == null
            ? []
            : List<TopList>.from(
                json["top_list"]!.map((x) => TopList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "trackid": trackid,
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
        "exp_str": expStr,
        "top_list": topList == null
            ? []
            : List<dynamic>.from(topList!.map((x) => x.toJson())),
      };
}

class ListElement {
  ListElement({
    this.position,
    this.keyword,
    this.showName,
    this.wordType,
    this.icon,
    this.hotId,
    this.isCommercial,
  });

  int? position;
  String? keyword;
  String? showName;
  int? wordType;
  String? icon;
  int? hotId;
  String? isCommercial;

  factory ListElement.fromRawJson(String str) =>
      ListElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        position: json["position"],
        keyword: json["keyword"],
        showName: json["show_name"],
        wordType: json["word_type"],
        icon: json["icon"],
        hotId: json["hot_id"],
        isCommercial: json["is_commercial"],
      );

  Map<String, dynamic> toJson() => {
        "position": position,
        "keyword": keyword,
        "show_name": showName,
        "word_type": wordType,
        "icon": icon,
        "hot_id": hotId,
        "is_commercial": isCommercial,
      };
}

class TopList {
  TopList({
    this.callReason,
    this.heatLayer,
    this.hotId,
    this.keyword,
    this.showName,
    this.pos,
    this.wordType,
    this.statDatas,
    this.icon,
  });

  int? callReason;
  String? heatLayer;
  int? hotId;
  String? keyword;
  String? showName;
  int? pos;
  int? wordType;
  StatDatas? statDatas;
  String? icon;

  factory TopList.fromRawJson(String str) => TopList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TopList.fromJson(Map<String, dynamic> json) => TopList(
        callReason: json["call_reason"],
        heatLayer: json["heat_layer"],
        hotId: json["hot_id"],
        keyword: json["keyword"],
        showName: json["show_name"],
        pos: json["pos"],
        wordType: json["word_type"],
        statDatas: json["stat_datas"] == null
            ? null
            : StatDatas.fromJson(json["stat_datas"]),
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "call_reason": callReason,
        "heat_layer": heatLayer,
        "hot_id": hotId,
        "keyword": keyword,
        "show_name": showName,
        "pos": pos,
        "word_type": wordType,
        "stat_datas": statDatas?.toJson(),
        "icon": icon,
      };
}

class StatDatas {
  StatDatas();

  factory StatDatas.fromRawJson(String str) =>
      StatDatas.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StatDatas.fromJson(Map<String, dynamic> json) => StatDatas();

  Map<String, dynamic> toJson() => {};
}
