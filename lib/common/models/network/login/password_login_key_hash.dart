import 'dart:convert';

class PasswordLoginKeyHashResponse {
  PasswordLoginKeyHashResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  PasswordLoginKeyHashResponseData? data;

  factory PasswordLoginKeyHashResponse.fromRawJson(String str) =>
      PasswordLoginKeyHashResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PasswordLoginKeyHashResponse.fromJson(Map<String, dynamic> json) =>
      PasswordLoginKeyHashResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null
            ? null
            : PasswordLoginKeyHashResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class PasswordLoginKeyHashResponseData {
  PasswordLoginKeyHashResponseData({
    this.hash,
    this.key,
  });

  String? hash;
  String? key;

  factory PasswordLoginKeyHashResponseData.fromRawJson(String str) =>
      PasswordLoginKeyHashResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PasswordLoginKeyHashResponseData.fromJson(
          Map<String, dynamic> json) =>
      PasswordLoginKeyHashResponseData(
        hash: json["hash"],
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "hash": hash,
        "key": key,
      };
}
