import 'dart:convert';

class DefaultSearchWordResponse {
  DefaultSearchWordResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  DefaultSearchWordResponseData? data;

  factory DefaultSearchWordResponse.fromRawJson(String str) =>
      DefaultSearchWordResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DefaultSearchWordResponse.fromJson(Map<String, dynamic> json) =>
      DefaultSearchWordResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null
            ? null
            : DefaultSearchWordResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class DefaultSearchWordResponseData {
  DefaultSearchWordResponseData({
    this.seid,
    this.id,
    this.type,
    this.showName,
    this.name,
    this.gotoType,
    this.gotoValue,
    this.url,
  });

  String? seid;
  double? id;
  int? type;
  String? showName;
  String? name;
  int? gotoType;
  String? gotoValue;
  String? url;

  factory DefaultSearchWordResponseData.fromRawJson(String str) =>
      DefaultSearchWordResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DefaultSearchWordResponseData.fromJson(Map<String, dynamic> json) =>
      DefaultSearchWordResponseData(
        seid: json["seid"],
        id: json["id"]?.toDouble(),
        type: json["type"],
        showName: json["show_name"],
        name: json["name"],
        gotoType: json["goto_type"],
        gotoValue: json["goto_value"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "seid": seid,
        "id": id,
        "type": type,
        "show_name": showName,
        "name": name,
        "goto_type": gotoType,
        "goto_value": gotoValue,
        "url": url,
      };
}
