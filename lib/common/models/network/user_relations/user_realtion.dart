import 'dart:convert';

import 'package:bili_you/common/models/network/user/user_info.dart';

class UserRelation {
  int? mid;
  int? attribute;
  int? mtime;
  dynamic tag;
  int? special;
  Object? contractInfo;
  String? uname;
  String? face;
  int? faceNft;
  String? sign;
  OfficialVerify? officialVerify;
  Vip? vip;
  String? nftIcon;
  String? recReason;
  String? trackId;

  UserRelation({
    this.mid,
    this.attribute,
    this.mtime,
    this.tag,
    this.special,
    this.contractInfo,
    this.uname,
    this.face,
    this.faceNft,
    this.sign,
    this.officialVerify,
    this.vip,
    this.nftIcon,
    this.recReason,
    this.trackId,
  });

  factory UserRelation.fromRawJson(String str) => json.decode(str);
  factory UserRelation.fromJson(Map<String, dynamic> json) => UserRelation(
      mid: json["mid"],
      attribute: json["attribute"],
      mtime: json["mtime"],
      tag: json["tag"],
      special: json["special"],
      contractInfo: json["contract_info"],
      uname: json["uname"],
      face: json["face"],
      faceNft: json["face_nft"],
      sign: json["sign"],
      officialVerify: OfficialVerify.fromJson(json["official_verify"]),
      vip: Vip.fromJson(json["vip"]),
      nftIcon: json["nft_icon"],
      recReason: json["rec_reason"],
      trackId: json["track_id"]);

  Map<String, dynamic> toJson() => {
        "mid": mid,
        "attribute": attribute,
        "mtime": mtime,
        "tag": tag,
        "special": special,
        "contract_info": contractInfo,
        "uname": uname,
        "face": face,
        "face_nft": faceNft,
        "sign": sign,
        "official_verify": officialVerify?.toJson(),
        "vip": vip?.toJson(),
        "nft_icon": nftIcon,
        "rec_reason": recReason,
        "track_id": trackId,
      };

  String toRawJson() => json.encode(toJson());
}
