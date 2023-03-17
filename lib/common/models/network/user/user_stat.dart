import 'dart:convert';

class LoginUserStatResponse {
  LoginUserStatResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  UserStatResponseData? data;

  factory LoginUserStatResponse.fromRawJson(String str) =>
      LoginUserStatResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginUserStatResponse.fromJson(Map<String, dynamic> json) =>
      LoginUserStatResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null
            ? null
            : UserStatResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class UserStatResponseData {
  UserStatResponseData({
    this.following,
    this.follower,
    this.dynamicCount,
  });

  int? following;
  int? follower;
  int? dynamicCount;

  factory UserStatResponseData.fromRawJson(String str) =>
      UserStatResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserStatResponseData.fromJson(Map<String, dynamic> json) =>
      UserStatResponseData(
        following: json["following"],
        follower: json["follower"],
        dynamicCount: json["dynamic_count"],
      );

  Map<String, dynamic> toJson() => {
        "following": following,
        "follower": follower,
        "dynamic_count": dynamicCount,
      };
}
