import 'dart:convert';

class PostSmsRequireResponse {
  PostSmsRequireResponse({
    this.code,
    this.message,
    this.data,
  });

  int? code;
  String? message;
  PostSmsRequireResponseData? data;

  factory PostSmsRequireResponse.fromRawJson(String str) =>
      PostSmsRequireResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSmsRequireResponse.fromJson(Map<String, dynamic> json) =>
      PostSmsRequireResponse(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : PostSmsRequireResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}

class PostSmsRequireResponseData {
  PostSmsRequireResponseData({
    this.captchaKey,
  });

  String? captchaKey;

  factory PostSmsRequireResponseData.fromRawJson(String str) =>
      PostSmsRequireResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSmsRequireResponseData.fromJson(Map<String, dynamic> json) =>
      PostSmsRequireResponseData(
        captchaKey: json["captcha_key"],
      );

  Map<String, dynamic> toJson() => {
        "captcha_key": captchaKey,
      };
}
