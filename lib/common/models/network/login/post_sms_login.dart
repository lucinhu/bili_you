import 'dart:convert';

class PostSmsLoginResponse {
  PostSmsLoginResponse({
    this.code,
    this.message,
    this.data,
  });

  int? code;
  String? message;
  PostSmsLoginResponseData? data;

  factory PostSmsLoginResponse.fromRawJson(String str) =>
      PostSmsLoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSmsLoginResponse.fromJson(Map<String, dynamic> json) =>
      PostSmsLoginResponse(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : PostSmsLoginResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}

class PostSmsLoginResponseData {
  PostSmsLoginResponseData({
    this.isNew,
    this.status,
  });

  bool? isNew;
  int? status;

  factory PostSmsLoginResponseData.fromRawJson(String str) =>
      PostSmsLoginResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSmsLoginResponseData.fromJson(Map<String, dynamic> json) =>
      PostSmsLoginResponseData(
        isNew: json["is_new"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "is_new": isNew,
        "status": status,
      };
}
