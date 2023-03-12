import 'dart:convert';

class PostPasswordLoginResponse {
  PostPasswordLoginResponse({
    this.code,
    this.message,
    this.data,
  });

  int? code;
  String? message;
  PostPasswordLoginResponseData? data;

  factory PostPasswordLoginResponse.fromRawJson(String str) =>
      PostPasswordLoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostPasswordLoginResponse.fromJson(Map<String, dynamic> json) =>
      PostPasswordLoginResponse(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : PostPasswordLoginResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}

class PostPasswordLoginResponseData {
  PostPasswordLoginResponseData({
    this.status,
  });

  int? status;

  factory PostPasswordLoginResponseData.fromRawJson(String str) =>
      PostPasswordLoginResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostPasswordLoginResponseData.fromJson(Map<String, dynamic> json) =>
      PostPasswordLoginResponseData(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
