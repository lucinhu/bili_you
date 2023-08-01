import 'dart:convert';

import 'package:bili_you/common/models/network/user/user_info.dart';

class FollowingResponse {
  int? code;
  String? message;
  int? ttl;
  dynamic data;

  FollowingResponse({this.code, this.message, this.ttl, this.data});

  factory FollowingResponse.fromRawJson(String str) =>
      FollowingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FollowingResponse.fromJson(Map<String, dynamic> json) =>
      FollowingResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"]
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.tojson(),
      };
}

class UserRelation {
  int? mid;
  int? attribute;
  int? mtime;
  dynamic tag;
  int? special;
  Object? contract_info;
  String? uname;
  String? face;
  int? face_nft;
  String? sign;
  OfficialVerify? officialVerify;
  Vip? vip;
  String? nft_icon;
  String? rec_reason;
  String? track_id;

  UserRelation({
    this.mid,
    this.attribute,
    this.mtime,
    this.tag,
    this.special,
    this.contract_info,
    this.uname,
    this.face,
    this.face_nft,
    this.sign,
    this.officialVerify,
    this.vip,
    this.nft_icon,
    this.rec_reason,
    this.track_id,
  });

  factory UserRelation.fromRawJson(String str) => json.decode(str);
  factory UserRelation.fromJson(Map<String, dynamic> json) => UserRelation(
      mid: json["mid"],
      attribute: json["attribute"],
      mtime: json["mtime"],
      tag: json["tag"],
      special: json["special"],
      contract_info: json["contract_info"],
      uname: json["uname"],
      face: json["face"],
      face_nft: json["face_nft"],
      sign: json["sign"],
      officialVerify: OfficialVerify.fromJson(json["official_verify"]),
      vip: Vip.fromJson(json["vip"]),
      nft_icon: json["nft_icon"],
      rec_reason: json["rec_reason"],
      track_id: json["track_id"]);

  Map<String, dynamic> toJson() => {
        "mid": mid,
        "attribute": attribute,
        "mtime": mtime,
        "tag": tag,
        "special": special,
        "contract_info": contract_info,
        "uname": uname,
        "face": face,
        "face_nft": face_nft,
        "sign": sign,
        "official_verify": officialVerify?.toJson(),
        "vip": vip?.toJson(),
        "nft_icon": nft_icon,
        "rec_reason": rec_reason,
        "track_id": track_id,
      };

  String toRawJson() => json.encode(toJson());
}
