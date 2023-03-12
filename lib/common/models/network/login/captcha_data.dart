import 'dart:convert';

class CaptchaDataResponse {
  CaptchaDataResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  CaptchaDataResponseData? data;

  factory CaptchaDataResponse.fromRawJson(String str) =>
      CaptchaDataResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CaptchaDataResponse.fromJson(Map<String, dynamic> json) =>
      CaptchaDataResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null
            ? null
            : CaptchaDataResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class CaptchaDataResponseData {
  CaptchaDataResponseData({
    this.type,
    this.token,
    this.geetest,
    this.tencent,
  });

  String? type;
  String? token;
  Geetest? geetest;
  Tencent? tencent;

  factory CaptchaDataResponseData.fromRawJson(String str) =>
      CaptchaDataResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CaptchaDataResponseData.fromJson(Map<String, dynamic> json) =>
      CaptchaDataResponseData(
        type: json["type"],
        token: json["token"],
        geetest:
            json["geetest"] == null ? null : Geetest.fromJson(json["geetest"]),
        tencent:
            json["tencent"] == null ? null : Tencent.fromJson(json["tencent"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "token": token,
        "geetest": geetest?.toJson(),
        "tencent": tencent?.toJson(),
      };
}

class Geetest {
  Geetest({
    this.challenge,
    this.gt,
  });

  String? challenge;
  String? gt;

  factory Geetest.fromRawJson(String str) => Geetest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Geetest.fromJson(Map<String, dynamic> json) => Geetest(
        challenge: json["challenge"],
        gt: json["gt"],
      );

  Map<String, dynamic> toJson() => {
        "challenge": challenge,
        "gt": gt,
      };
}

class Tencent {
  Tencent({
    this.appid,
  });

  String? appid;

  factory Tencent.fromRawJson(String str) => Tencent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tencent.fromJson(Map<String, dynamic> json) => Tencent(
        appid: json["appid"],
      );

  Map<String, dynamic> toJson() => {
        "appid": appid,
      };
}
