import 'dart:convert';

class LoginUserInfoResponse {
  LoginUserInfoResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  UserInfoResponseData? data;

  factory LoginUserInfoResponse.fromRawJson(String str) =>
      LoginUserInfoResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginUserInfoResponse.fromJson(Map<String, dynamic> json) =>
      LoginUserInfoResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null
            ? null
            : UserInfoResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class UserInfoResponseData {
  UserInfoResponseData({
    this.isLogin,
    // this.emailVerified,
    this.face,
    // this.faceNft,
    // this.faceNftType,
    this.levelInfo,
    this.mid,
    // this.mobileVerified,
    // this.money,
    // this.moral,
    this.official,
    this.officialVerify,
    this.pendant,
    // this.scores,
    this.uname,
    // this.vipDueDate,
    // this.vipStatus,
    // this.vipType,
    // this.vipPayType,
    // this.vipThemeType,
    this.vipLabel,
    // this.vipAvatarSubscript,
    // this.vipNicknameColor,
    this.vip,
    this.wallet,
    this.hasShop,
    this.shopUrl,
    // this.allowanceCount,
    // this.answerStatus,
    // this.isSeniorMember,
    this.wbiImg,
    this.isJury,
  });

  bool? isLogin;
  // int? emailVerified;
  String? face;
  // int? faceNft;
  // int? faceNftType;
  LevelInfo? levelInfo;
  int? mid;
  // int? mobileVerified;
  // int? money;
  // int? moral;
  Official? official;
  OfficialVerify? officialVerify;
  Pendant? pendant;
  // int? scores;
  String? uname;
  // int? vipDueDate;
  // int? vipStatus;
  // int? vipType;
  // int? vipPayType;
  // int? vipThemeType;
  Label? vipLabel;
  // int? vipAvatarSubscript;
  // String? vipNicknameColor;
  Vip? vip;
  Wallet? wallet;
  bool? hasShop;
  String? shopUrl;
  // int? allowanceCount;
  // int? answerStatus;
  // int? isSeniorMember;
  WbiImg? wbiImg;
  bool? isJury;

  factory UserInfoResponseData.fromRawJson(String str) =>
      UserInfoResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserInfoResponseData.fromJson(Map<String, dynamic> json) =>
      UserInfoResponseData(
        isLogin: json["isLogin"],
        // emailVerified: json["email_verified"],
        face: json["face"],
        // faceNft: json["face_nft"],
        // faceNftType: json["face_nft_type"],
        levelInfo: json["level_info"] == null
            ? null
            : LevelInfo.fromJson(json["level_info"]),
        mid: json["mid"],
        // mobileVerified: json["mobile_verified"],
        // money: json["money"],
        // moral: json["moral"],
        official: json["official"] == null
            ? null
            : Official.fromJson(json["official"]),
        officialVerify: json["officialVerify"] == null
            ? null
            : OfficialVerify.fromJson(json["officialVerify"]),
        pendant:
            json["pendant"] == null ? null : Pendant.fromJson(json["pendant"]),
        // scores: json["scores"],
        uname: json["uname"],
        // vipDueDate: json["vipDueDate"],
        // vipStatus: json["vipStatus"],
        // vipType: json["vipType"],
        // vipPayType: json["vip_pay_type"],
        // vipThemeType: json["vip_theme_type"],
        vipLabel: json["vip_label"] == null
            ? null
            : Label.fromJson(json["vip_label"]),
        // vipAvatarSubscript: json["vip_avatar_subscript"],
        // vipNicknameColor: json["vip_nickname_color"],
        vip: json["vip"] == null ? null : Vip.fromJson(json["vip"]),
        wallet: json["wallet"] == null ? null : Wallet.fromJson(json["wallet"]),
        hasShop: json["has_shop"],
        shopUrl: json["shop_url"],
        // allowanceCount: json["allowance_count"],
        // answerStatus: json["answer_status"],
        // isSeniorMember: json["is_senior_member"],
        wbiImg:
            json["wbi_img"] == null ? null : WbiImg.fromJson(json["wbi_img"]),
        isJury: json["is_jury"],
      );

  Map<String, dynamic> toJson() => {
        "isLogin": isLogin,
        // "email_verified": emailVerified,
        "face": face,
        // "face_nft": faceNft,
        // "face_nft_type": faceNftType,
        "level_info": levelInfo?.toJson(),
        "mid": mid,
        // "mobile_verified": mobileVerified,
        // "money": money,
        // "moral": moral,
        "official": official?.toJson(),
        "officialVerify": officialVerify?.toJson(),
        "pendant": pendant?.toJson(),
        // "scores": scores,
        "uname": uname,
        // "vipDueDate": vipDueDate,
        // "vipStatus": vipStatus,
        // "vipType": vipType,
        // "vip_pay_type": vipPayType,
        // "vip_theme_type": vipThemeType,
        "vip_label": vipLabel?.toJson(),
        // "vip_avatar_subscript": vipAvatarSubscript,
        // "vip_nickname_color": vipNicknameColor,
        "vip": vip?.toJson(),
        "wallet": wallet?.toJson(),
        "has_shop": hasShop,
        "shop_url": shopUrl,
        // "allowance_count": allowanceCount,
        // "answer_status": answerStatus,
        // "is_senior_member": isSeniorMember,
        "wbi_img": wbiImg?.toJson(),
        "is_jury": isJury,
      };
}

class LevelInfo {
  LevelInfo({
    this.currentLevel,
    this.currentMin,
    this.currentExp,
    this.nextExp,
  });

  int? currentLevel;
  int? currentMin;
  int? currentExp;
  int? nextExp;

  factory LevelInfo.fromRawJson(String str) =>
      LevelInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LevelInfo.fromJson(Map<String, dynamic> json) => LevelInfo(
        currentLevel: json["current_level"],
        currentMin: json["current_min"],
        currentExp: json["current_exp"],
        nextExp: json["next_exp"] is int ? json["next_exp"] : -1,
      );

  Map<String, dynamic> toJson() => {
        "current_level": currentLevel,
        "current_min": currentMin,
        "current_exp": currentExp,
        "next_exp": nextExp,
      };
}

class Official {
  Official({
    // this.role,
    this.title,
    this.desc,
    this.type,
  });

  // int? role;
  String? title;
  String? desc;
  int? type;

  factory Official.fromRawJson(String str) =>
      Official.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Official.fromJson(Map<String, dynamic> json) => Official(
        // role: json["role"],
        title: json["title"],
        desc: json["desc"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        // "role": role,
        "title": title,
        "desc": desc,
        "type": type,
      };
}

class OfficialVerify {
  OfficialVerify({
    this.type,
    this.desc,
  });

  int? type;
  String? desc;

  factory OfficialVerify.fromRawJson(String str) =>
      OfficialVerify.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OfficialVerify.fromJson(Map<String, dynamic> json) => OfficialVerify(
        type: json["type"],
        desc: json["desc"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "desc": desc,
      };
}

class Pendant {
  Pendant({
    this.pid,
    // this.name,
    // this.image,
    // this.expire,
    // this.imageEnhance,
    // this.imageEnhanceFrame,
  });

  int? pid;
  // String? name;
  // String? image;
  // int? expire;
  // String? imageEnhance;
  // String? imageEnhanceFrame;

  factory Pendant.fromRawJson(String str) => Pendant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pendant.fromJson(Map<String, dynamic> json) => Pendant(
        pid: json["pid"],
        // name: json["name"],
        // image: json["image"],
        // expire: json["expire"],
        // imageEnhance: json["image_enhance"],
        // imageEnhanceFrame: json["image_enhance_frame"],
      );

  Map<String, dynamic> toJson() => {
        "pid": pid,
        // "name": name,
        // "image": image,
        // "expire": expire,
        // "image_enhance": imageEnhance,
        // "image_enhance_frame": imageEnhanceFrame,
      };
}

class Vip {
  Vip({
    this.type,
    this.status,
    this.dueDate,
    // this.vipPayType,
    this.themeType,
    this.label,
    // this.avatarSubscript,
    // this.nicknameColor,
    // this.role,
    // this.avatarSubscriptUrl,
    // this.tvVipStatus,
    // this.tvVipPayType,
  });

  int? type;
  int? status;
  int? dueDate;
  // int? vipPayType;
  int? themeType;
  Label? label;
  // int? avatarSubscript;
  // String? nicknameColor;
  // int? role;
  // String? avatarSubscriptUrl;
  // int? tvVipStatus;
  // int? tvVipPayType;

  factory Vip.fromRawJson(String str) => Vip.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Vip.fromJson(Map<String, dynamic> json) => Vip(
        type: json["type"],
        status: json["status"],
        dueDate: json["due_date"],
        // vipPayType: json["vip_pay_type"],
        themeType: json["theme_type"],
        label: json["label"] == null ? null : Label.fromJson(json["label"]),
        // avatarSubscript: json["avatar_subscript"],
        // nicknameColor: json["nickname_color"],
        // role: json["role"],
        // avatarSubscriptUrl: json["avatar_subscript_url"],
        // tvVipStatus: json["tv_vip_status"],
        // tvVipPayType: json["tv_vip_pay_type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "status": status,
        "due_date": dueDate,
        // "vip_pay_type": vipPayType,
        "theme_type": themeType,
        "label": label?.toJson(),
        // "avatar_subscript": avatarSubscript,
        // "nickname_color": nicknameColor,
        // "role": role,
        // "avatar_subscript_url": avatarSubscriptUrl,
        // "tv_vip_status": tvVipStatus,
        // "tv_vip_pay_type": tvVipPayType,
      };
}

class Label {
  Label({
    this.path,
    this.text,
    this.labelTheme,
    this.textColor,
    this.bgStyle,
    this.bgColor,
    this.borderColor,
    this.useImgLabel,
    this.imgLabelUriHans,
    this.imgLabelUriHant,
    this.imgLabelUriHansStatic,
    this.imgLabelUriHantStatic,
  });

  String? path;
  String? text;
  String? labelTheme;
  String? textColor;
  int? bgStyle;
  String? bgColor;
  String? borderColor;
  bool? useImgLabel;
  String? imgLabelUriHans;
  String? imgLabelUriHant;
  String? imgLabelUriHansStatic;
  String? imgLabelUriHantStatic;

  factory Label.fromRawJson(String str) => Label.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Label.fromJson(Map<String, dynamic> json) => Label(
        path: json["path"],
        text: json["text"],
        labelTheme: json["label_theme"],
        textColor: json["text_color"],
        bgStyle: json["bg_style"],
        bgColor: json["bg_color"],
        borderColor: json["border_color"],
        useImgLabel: json["use_img_label"],
        imgLabelUriHans: json["img_label_uri_hans"],
        imgLabelUriHant: json["img_label_uri_hant"],
        imgLabelUriHansStatic: json["img_label_uri_hans_static"],
        imgLabelUriHantStatic: json["img_label_uri_hant_static"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "text": text,
        "label_theme": labelTheme,
        "text_color": textColor,
        "bg_style": bgStyle,
        "bg_color": bgColor,
        "border_color": borderColor,
        "use_img_label": useImgLabel,
        "img_label_uri_hans": imgLabelUriHans,
        "img_label_uri_hant": imgLabelUriHant,
        "img_label_uri_hans_static": imgLabelUriHansStatic,
        "img_label_uri_hant_static": imgLabelUriHantStatic,
      };
}

class Wallet {
  Wallet({
    this.mid,
    // this.bcoinBalance,
    // this.couponBalance,
    // this.couponDueTime,
  });

  int? mid;
  // int? bcoinBalance;
  // int? couponBalance;
  // int? couponDueTime;

  factory Wallet.fromRawJson(String str) => Wallet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        mid: json["mid"],
        // bcoinBalance: json["bcoin_balance"],
        // couponBalance: json["coupon_balance"],
        // couponDueTime: json["coupon_due_time"],
      );

  Map<String, dynamic> toJson() => {
        "mid": mid,
        // "bcoin_balance": bcoinBalance,
        // "coupon_balance": couponBalance,
        // "coupon_due_time": couponDueTime,
      };
}

class WbiImg {
  WbiImg({
    this.imgUrl,
    this.subUrl,
  });

  String? imgUrl;
  String? subUrl;

  factory WbiImg.fromRawJson(String str) => WbiImg.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WbiImg.fromJson(Map<String, dynamic> json) => WbiImg(
        imgUrl: json["img_url"],
        subUrl: json["sub_url"],
      );

  Map<String, dynamic> toJson() => {
        "img_url": imgUrl,
        "sub_url": subUrl,
      };
}
