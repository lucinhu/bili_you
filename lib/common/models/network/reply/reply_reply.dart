import 'dart:convert';

import 'package:bili_you/common/models/network/reply/reply.dart';

class ReplyReplyResponse {
  ReplyReplyResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  VideoReplyReplyResponseData? data;

  factory ReplyReplyResponse.fromRawJson(String str) =>
      ReplyReplyResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReplyReplyResponse.fromJson(Map<String, dynamic> json) =>
      ReplyReplyResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null
            ? null
            : VideoReplyReplyResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class VideoReplyReplyResponseData {
  VideoReplyReplyResponseData({
    this.config,
    this.control,
    this.page,
    this.replies,
    this.root,
    this.showBvid,
    this.showText,
    this.showType,
    this.upper,
  });

  Config? config;
  Control? control;
  Page? page;
  List<ReplyItemRaw>? replies;
  ReplyItemRaw? root;
  bool? showBvid;
  String? showText;
  int? showType;
  Upper? upper;

  factory VideoReplyReplyResponseData.fromRawJson(String str) =>
      VideoReplyReplyResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VideoReplyReplyResponseData.fromJson(Map<String, dynamic> json) =>
      VideoReplyReplyResponseData(
        config: json["config"] == null ? null : Config.fromJson(json["config"]),
        control:
            json["control"] == null ? null : Control.fromJson(json["control"]),
        page: json["page"] == null ? null : Page.fromJson(json["page"]),
        replies: json["replies"] == null
            ? []
            : List<ReplyItemRaw>.from(
                json["replies"]!.map((x) => ReplyItemRaw.fromJson(x))),
        root: json["root"] == null ? null : ReplyItemRaw.fromJson(json["root"]),
        showBvid: json["show_bvid"],
        showText: json["show_text"],
        showType: json["show_type"],
        upper: json["upper"] == null ? null : Upper.fromJson(json["upper"]),
      );

  Map<String, dynamic> toJson() => {
        "config": config?.toJson(),
        "control": control?.toJson(),
        "page": page?.toJson(),
        "replies": replies == null
            ? []
            : List<ReplyItemRaw>.from(replies!.map((x) => x.toJson())),
        "root": root?.toJson(),
        "show_bvid": showBvid,
        "show_text": showText,
        "show_type": showType,
        "upper": upper?.toJson(),
      };
}

class Config {
  Config({
    this.showtopic,
    this.showUpFlag,
    this.readOnly,
  });

  int? showtopic;
  bool? showUpFlag;
  bool? readOnly;

  factory Config.fromRawJson(String str) => Config.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        showtopic: json["showtopic"],
        showUpFlag: json["show_up_flag"],
        readOnly: json["read_only"],
      );

  Map<String, dynamic> toJson() => {
        "showtopic": showtopic,
        "show_up_flag": showUpFlag,
        "read_only": readOnly,
      };
}

class Control {
  Control({
    this.inputDisable,
    this.rootInputText,
    this.childInputText,
    this.giveupInputText,
    this.screenshotIconState,
    this.uploadPictureIconState,
    this.answerGuideText,
    this.answerGuideIconUrl,
    this.answerGuideIosUrl,
    this.answerGuideAndroidUrl,
    this.bgText,
    this.emptyPage,
    this.showType,
    this.showText,
    this.webSelection,
    this.disableJumpEmote,
  });

  bool? inputDisable;
  String? rootInputText;
  String? childInputText;
  String? giveupInputText;
  int? screenshotIconState;
  int? uploadPictureIconState;
  String? answerGuideText;
  String? answerGuideIconUrl;
  String? answerGuideIosUrl;
  String? answerGuideAndroidUrl;
  String? bgText;
  dynamic emptyPage;
  int? showType;
  String? showText;
  bool? webSelection;
  bool? disableJumpEmote;

  factory Control.fromRawJson(String str) => Control.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Control.fromJson(Map<String, dynamic> json) => Control(
        inputDisable: json["input_disable"],
        rootInputText: json["root_input_text"],
        childInputText: json["child_input_text"],
        giveupInputText: json["giveup_input_text"],
        screenshotIconState: json["screenshot_icon_state"],
        uploadPictureIconState: json["upload_picture_icon_state"],
        answerGuideText: json["answer_guide_text"],
        answerGuideIconUrl: json["answer_guide_icon_url"],
        answerGuideIosUrl: json["answer_guide_ios_url"],
        answerGuideAndroidUrl: json["answer_guide_android_url"],
        bgText: json["bg_text"],
        emptyPage: json["empty_page"],
        showType: json["show_type"],
        showText: json["show_text"],
        webSelection: json["web_selection"],
        disableJumpEmote: json["disable_jump_emote"],
      );

  Map<String, dynamic> toJson() => {
        "input_disable": inputDisable,
        "root_input_text": rootInputText,
        "child_input_text": childInputText,
        "giveup_input_text": giveupInputText,
        "screenshot_icon_state": screenshotIconState,
        "upload_picture_icon_state": uploadPictureIconState,
        "answer_guide_text": answerGuideText,
        "answer_guide_icon_url": answerGuideIconUrl,
        "answer_guide_ios_url": answerGuideIosUrl,
        "answer_guide_android_url": answerGuideAndroidUrl,
        "bg_text": bgText,
        "empty_page": emptyPage,
        "show_type": showType,
        "show_text": showText,
        "web_selection": webSelection,
        "disable_jump_emote": disableJumpEmote,
      };
}

class Page {
  Page({
    this.count,
    this.num,
    this.size,
  });

  int? count;
  int? num;
  int? size;

  factory Page.fromRawJson(String str) => Page.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Page.fromJson(Map<String, dynamic> json) => Page(
        count: json["count"],
        num: json["num"],
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "num": num,
        "size": size,
      };
}

// class Reply {
//   Reply({
//     this.rpid,
//     this.oid,
//     this.type,
//     this.mid,
//     this.root,
//     this.parent,
//     this.dialog,
//     this.count,
//     this.rcount,
//     this.state,
//     this.fansgrade,
//     this.attr,
//     this.ctime,
//     this.rpidStr,
//     this.rootStr,
//     this.parentStr,
//     this.like,
//     this.action,
//     this.member,
//     this.content,
//     this.replies,
//     this.assist,
//     this.upAction,
//     this.invisible,
//     this.replyControl,
//     this.folder,
//     this.dynamicIdStr,
//   });

//   int? rpid;
//   int? oid;
//   int? type;
//   int? mid;
//   int? root;
//   int? parent;
//   int? dialog;
//   int? count;
//   int? rcount;
//   int? state;
//   int? fansgrade;
//   int? attr;
//   int? ctime;
//   String? rpidStr;
//   String? rootStr;
//   String? parentStr;
//   int? like;
//   int? action;
//   ReplyMember? member;
//   Content? content;
//   dynamic replies;
//   int? assist;
//   UpAction? upAction;
//   bool? invisible;
//   ReplyReplyControl? replyControl;
//   Folder? folder;
//   String? dynamicIdStr;

//   factory Reply.fromRawJson(String str) => Reply.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Reply.fromJson(Map<String, dynamic> json) => Reply(
//         rpid: json["rpid"],
//         oid: json["oid"],
//         type: json["type"],
//         mid: json["mid"],
//         root: json["root"],
//         parent: json["parent"],
//         dialog: json["dialog"],
//         count: json["count"],
//         rcount: json["rcount"],
//         state: json["state"],
//         fansgrade: json["fansgrade"],
//         attr: json["attr"],
//         ctime: json["ctime"],
//         rpidStr: json["rpid_str"],
//         rootStr: json["root_str"],
//         parentStr: json["parent_str"],
//         like: json["like"],
//         action: json["action"],
//         member: json["member"] == null
//             ? null
//             : ReplyMember.fromJson(json["member"]),
//         content:
//             json["content"] == null ? null : Content.fromJson(json["content"]),
//         replies: json["replies"],
//         assist: json["assist"],
//         upAction: json["up_action"] == null
//             ? null
//             : UpAction.fromJson(json["up_action"]),
//         invisible: json["invisible"],
//         replyControl: json["reply_control"] == null
//             ? null
//             : ReplyReplyControl.fromJson(json["reply_control"]),
//         folder: json["folder"] == null ? null : Folder.fromJson(json["folder"]),
//         dynamicIdStr: json["dynamic_id_str"],
//       );

//   Map<String, dynamic> toJson() => {
//         "rpid": rpid,
//         "oid": oid,
//         "type": type,
//         "mid": mid,
//         "root": root,
//         "parent": parent,
//         "dialog": dialog,
//         "count": count,
//         "rcount": rcount,
//         "state": state,
//         "fansgrade": fansgrade,
//         "attr": attr,
//         "ctime": ctime,
//         "rpid_str": rpidStr,
//         "root_str": rootStr,
//         "parent_str": parentStr,
//         "like": like,
//         "action": action,
//         "member": member?.toJson(),
//         "content": content?.toJson(),
//         "replies": replies,
//         "assist": assist,
//         "up_action": upAction?.toJson(),
//         "invisible": invisible,
//         "reply_control": replyControl?.toJson(),
//         "folder": folder?.toJson(),
//         "dynamic_id_str": dynamicIdStr,
//       };
// }

class ReplyContent {
  ReplyContent({
    this.message,
    this.members,
    this.jumpUrl,
    this.maxLine,
    this.emote,
    this.atNameToMid,
  });

  String? message;
  List<MemberElement>? members;
  AvatarLayerClass? jumpUrl;
  int? maxLine;
  Map<String, Emote>? emote;
  Map<String, int>? atNameToMid;

  factory ReplyContent.fromRawJson(String str) =>
      ReplyContent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReplyContent.fromJson(Map<String, dynamic> json) => ReplyContent(
        message: json["message"],
        members: json["members"] == null
            ? []
            : List<MemberElement>.from(
                json["members"]!.map((x) => MemberElement.fromJson(x))),
        jumpUrl: json["jump_url"] == null
            ? null
            : AvatarLayerClass.fromJson(json["jump_url"]),
        maxLine: json["max_line"],
        emote: Map.from(json["emote"]!)
            .map((k, v) => MapEntry<String, Emote>(k, Emote.fromJson(v))),
        atNameToMid: Map.from(json["at_name_to_mid"]!)
            .map((k, v) => MapEntry<String, int>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "members": members == null
            ? []
            : List<dynamic>.from(members!.map((x) => x.toJson())),
        "jump_url": jumpUrl?.toJson(),
        "max_line": maxLine,
        "emote": Map.from(emote!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "at_name_to_mid": Map.from(atNameToMid!)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class Emote {
  Emote({
    this.id,
    this.packageId,
    this.state,
    this.type,
    this.attr,
    this.text,
    this.url,
    this.meta,
    this.mtime,
    this.jumpTitle,
    this.gifUrl,
  });

  int? id;
  int? packageId;
  int? state;
  int? type;
  int? attr;
  String? text;
  String? url;
  Meta? meta;
  int? mtime;
  String? jumpTitle;
  String? gifUrl;

  factory Emote.fromRawJson(String str) => Emote.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Emote.fromJson(Map<String, dynamic> json) => Emote(
        id: json["id"],
        packageId: json["package_id"],
        state: json["state"],
        type: json["type"],
        attr: json["attr"],
        text: json["text"],
        url: json["url"],
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        mtime: json["mtime"],
        jumpTitle: json["jump_title"],
        gifUrl: json["gif_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_id": packageId,
        "state": state,
        "type": type,
        "attr": attr,
        "text": text,
        "url": url,
        "meta": meta?.toJson(),
        "mtime": mtime,
        "jump_title": jumpTitle,
        "gif_url": gifUrl,
      };
}

class Meta {
  Meta({
    this.size,
  });

  int? size;

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "size": size,
      };
}

class AvatarLayerClass {
  AvatarLayerClass();

  factory AvatarLayerClass.fromRawJson(String str) =>
      AvatarLayerClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AvatarLayerClass.fromJson(Map<String, dynamic> json) =>
      AvatarLayerClass();

  Map<String, dynamic> toJson() => {};
}

class MemberElement {
  MemberElement({
    this.mid,
    this.uname,
    this.sex,
    this.sign,
    this.avatar,
    this.rank,
    this.faceNftNew,
    this.isSeniorMember,
    this.levelInfo,
    this.pendant,
    this.nameplate,
    this.officialVerify,
    this.vip,
  });

  String? mid;
  String? uname;
  String? sex;
  String? sign;
  String? avatar;
  String? rank;
  int? faceNftNew;
  int? isSeniorMember;
  LevelInfo? levelInfo;
  MemberPendant? pendant;
  Nameplate? nameplate;
  OfficialVerify? officialVerify;
  Vip? vip;

  factory MemberElement.fromRawJson(String str) =>
      MemberElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MemberElement.fromJson(Map<String, dynamic> json) => MemberElement(
        mid: json["mid"],
        uname: json["uname"],
        sex: json["sex"],
        sign: json["sign"],
        avatar: json["avatar"],
        rank: json["rank"],
        faceNftNew: json["face_nft_new"],
        isSeniorMember: json["is_senior_member"],
        levelInfo: json["level_info"] == null
            ? null
            : LevelInfo.fromJson(json["level_info"]),
        pendant: json["pendant"] == null
            ? null
            : MemberPendant.fromJson(json["pendant"]),
        nameplate: json["nameplate"] == null
            ? null
            : Nameplate.fromJson(json["nameplate"]),
        officialVerify: json["official_verify"] == null
            ? null
            : OfficialVerify.fromJson(json["official_verify"]),
        vip: json["vip"] == null ? null : Vip.fromJson(json["vip"]),
      );

  Map<String, dynamic> toJson() => {
        "mid": mid,
        "uname": uname,
        "sex": sex,
        "sign": sign,
        "avatar": avatar,
        "rank": rank,
        "face_nft_new": faceNftNew,
        "is_senior_member": isSeniorMember,
        "level_info": levelInfo?.toJson(),
        "pendant": pendant?.toJson(),
        "nameplate": nameplate?.toJson(),
        "official_verify": officialVerify?.toJson(),
        "vip": vip?.toJson(),
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
        nextExp: json["next_exp"],
      );

  Map<String, dynamic> toJson() => {
        "current_level": currentLevel,
        "current_min": currentMin,
        "current_exp": currentExp,
        "next_exp": nextExp,
      };
}

class Nameplate {
  Nameplate({
    this.nid,
    this.name,
    this.image,
    this.imageSmall,
    this.level,
    this.condition,
  });

  int? nid;
  String? name;
  String? image;
  String? imageSmall;
  String? level;
  String? condition;

  factory Nameplate.fromRawJson(String str) =>
      Nameplate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Nameplate.fromJson(Map<String, dynamic> json) => Nameplate(
        nid: json["nid"],
        name: json["name"],
        image: json["image"],
        imageSmall: json["image_small"],
        level: json["level"],
        condition: json["condition"],
      );

  Map<String, dynamic> toJson() => {
        "nid": nid,
        "name": name,
        "image": image,
        "image_small": imageSmall,
        "level": level,
        "condition": condition,
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

class MemberPendant {
  MemberPendant({
    this.pid,
    this.name,
    this.image,
    this.expire,
    this.imageEnhance,
    this.imageEnhanceFrame,
  });

  int? pid;
  String? name;
  String? image;
  int? expire;
  String? imageEnhance;
  String? imageEnhanceFrame;

  factory MemberPendant.fromRawJson(String str) =>
      MemberPendant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MemberPendant.fromJson(Map<String, dynamic> json) => MemberPendant(
        pid: json["pid"],
        name: json["name"],
        image: json["image"],
        expire: json["expire"],
        imageEnhance: json["image_enhance"],
        imageEnhanceFrame: json["image_enhance_frame"],
      );

  Map<String, dynamic> toJson() => {
        "pid": pid,
        "name": name,
        "image": image,
        "expire": expire,
        "image_enhance": imageEnhance,
        "image_enhance_frame": imageEnhanceFrame,
      };
}

class Vip {
  Vip({
    this.vipType,
    this.vipDueDate,
    this.dueRemark,
    this.accessStatus,
    this.vipStatus,
    this.vipStatusWarn,
    this.themeType,
    this.label,
    this.avatarSubscript,
    this.nicknameColor,
  });

  int? vipType;
  int? vipDueDate;
  String? dueRemark;
  int? accessStatus;
  int? vipStatus;
  String? vipStatusWarn;
  int? themeType;
  Label? label;
  int? avatarSubscript;
  String? nicknameColor;

  factory Vip.fromRawJson(String str) => Vip.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Vip.fromJson(Map<String, dynamic> json) => Vip(
        vipType: json["vipType"],
        vipDueDate: json["vipDueDate"],
        dueRemark: json["dueRemark"],
        accessStatus: json["accessStatus"],
        vipStatus: json["vipStatus"],
        vipStatusWarn: json["vipStatusWarn"],
        themeType: json["themeType"],
        label: json["label"] == null ? null : Label.fromJson(json["label"]),
        avatarSubscript: json["avatar_subscript"],
        nicknameColor: json["nickname_color"],
      );

  Map<String, dynamic> toJson() => {
        "vipType": vipType,
        "vipDueDate": vipDueDate,
        "dueRemark": dueRemark,
        "accessStatus": accessStatus,
        "vipStatus": vipStatus,
        "vipStatusWarn": vipStatusWarn,
        "themeType": themeType,
        "label": label?.toJson(),
        "avatar_subscript": avatarSubscript,
        "nickname_color": nicknameColor,
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

class Folder {
  Folder({
    this.hasFolded,
    this.isFolded,
    this.rule,
  });

  bool? hasFolded;
  bool? isFolded;
  String? rule;

  factory Folder.fromRawJson(String str) => Folder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Folder.fromJson(Map<String, dynamic> json) => Folder(
        hasFolded: json["has_folded"],
        isFolded: json["is_folded"],
        rule: json["rule"],
      );

  Map<String, dynamic> toJson() => {
        "has_folded": hasFolded,
        "is_folded": isFolded,
        "rule": rule,
      };
}

class ReplyMember {
  ReplyMember({
    this.mid,
    this.uname,
    this.sex,
    this.sign,
    this.avatar,
    this.rank,
    this.faceNftNew,
    this.isSeniorMember,
    this.levelInfo,
    this.pendant,
    this.nameplate,
    this.officialVerify,
    this.vip,
    this.fansDetail,
    this.userSailing,
    this.isContractor,
    this.contractDesc,
    this.nftInteraction,
    this.avatarItem,
  });

  String? mid;
  String? uname;
  String? sex;
  String? sign;
  String? avatar;
  String? rank;
  int? faceNftNew;
  int? isSeniorMember;
  LevelInfo? levelInfo;
  MemberPendant? pendant;
  Nameplate? nameplate;
  OfficialVerify? officialVerify;
  Vip? vip;
  dynamic fansDetail;
  UserSailing? userSailing;
  bool? isContractor;
  String? contractDesc;
  dynamic nftInteraction;
  PurpleAvatarItem? avatarItem;

  factory ReplyMember.fromRawJson(String str) =>
      ReplyMember.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReplyMember.fromJson(Map<String, dynamic> json) => ReplyMember(
        mid: json["mid"],
        uname: json["uname"],
        sex: json["sex"],
        sign: json["sign"],
        avatar: json["avatar"],
        rank: json["rank"],
        faceNftNew: json["face_nft_new"],
        isSeniorMember: json["is_senior_member"],
        levelInfo: json["level_info"] == null
            ? null
            : LevelInfo.fromJson(json["level_info"]),
        pendant: json["pendant"] == null
            ? null
            : MemberPendant.fromJson(json["pendant"]),
        nameplate: json["nameplate"] == null
            ? null
            : Nameplate.fromJson(json["nameplate"]),
        officialVerify: json["official_verify"] == null
            ? null
            : OfficialVerify.fromJson(json["official_verify"]),
        vip: json["vip"] == null ? null : Vip.fromJson(json["vip"]),
        fansDetail: json["fans_detail"],
        userSailing: json["user_sailing"] == null
            ? null
            : UserSailing.fromJson(json["user_sailing"]),
        isContractor: json["is_contractor"],
        contractDesc: json["contract_desc"],
        nftInteraction: json["nft_interaction"],
        avatarItem: json["avatar_item"] == null
            ? null
            : PurpleAvatarItem.fromJson(json["avatar_item"]),
      );

  Map<String, dynamic> toJson() => {
        "mid": mid,
        "uname": uname,
        "sex": sex,
        "sign": sign,
        "avatar": avatar,
        "rank": rank,
        "face_nft_new": faceNftNew,
        "is_senior_member": isSeniorMember,
        "level_info": levelInfo?.toJson(),
        "pendant": pendant?.toJson(),
        "nameplate": nameplate?.toJson(),
        "official_verify": officialVerify?.toJson(),
        "vip": vip?.toJson(),
        "fans_detail": fansDetail,
        "user_sailing": userSailing?.toJson(),
        "is_contractor": isContractor,
        "contract_desc": contractDesc,
        "nft_interaction": nftInteraction,
        "avatar_item": avatarItem?.toJson(),
      };
}

class PurpleAvatarItem {
  PurpleAvatarItem({
    this.containerSize,
    this.fallbackLayers,
    this.mid,
  });

  ContainerSize? containerSize;
  PurpleFallbackLayers? fallbackLayers;
  String? mid;

  factory PurpleAvatarItem.fromRawJson(String str) =>
      PurpleAvatarItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleAvatarItem.fromJson(Map<String, dynamic> json) =>
      PurpleAvatarItem(
        containerSize: json["container_size"] == null
            ? null
            : ContainerSize.fromJson(json["container_size"]),
        fallbackLayers: json["fallback_layers"] == null
            ? null
            : PurpleFallbackLayers.fromJson(json["fallback_layers"]),
        mid: json["mid"],
      );

  Map<String, dynamic> toJson() => {
        "container_size": containerSize?.toJson(),
        "fallback_layers": fallbackLayers?.toJson(),
        "mid": mid,
      };
}

class ContainerSize {
  ContainerSize({
    this.width,
    this.height,
  });

  double? width;
  double? height;

  factory ContainerSize.fromRawJson(String str) =>
      ContainerSize.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContainerSize.fromJson(Map<String, dynamic> json) => ContainerSize(
        width: json["width"]?.toDouble(),
        height: json["height"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
      };
}

class PurpleFallbackLayers {
  PurpleFallbackLayers({
    this.layers,
    this.isCriticalGroup,
  });

  List<PurpleLayer>? layers;
  bool? isCriticalGroup;

  factory PurpleFallbackLayers.fromRawJson(String str) =>
      PurpleFallbackLayers.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleFallbackLayers.fromJson(Map<String, dynamic> json) =>
      PurpleFallbackLayers(
        layers: json["layers"] == null
            ? []
            : List<PurpleLayer>.from(
                json["layers"]!.map((x) => PurpleLayer.fromJson(x))),
        isCriticalGroup: json["is_critical_group"],
      );

  Map<String, dynamic> toJson() => {
        "layers": layers == null
            ? []
            : List<dynamic>.from(layers!.map((x) => x.toJson())),
        "is_critical_group": isCriticalGroup,
      };
}

class PurpleLayer {
  PurpleLayer({
    this.visible,
    this.generalSpec,
    this.layerConfig,
    this.resource,
  });

  bool? visible;
  GeneralSpec? generalSpec;
  PurpleLayerConfig? layerConfig;
  Resource? resource;

  factory PurpleLayer.fromRawJson(String str) =>
      PurpleLayer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleLayer.fromJson(Map<String, dynamic> json) => PurpleLayer(
        visible: json["visible"],
        generalSpec: json["general_spec"] == null
            ? null
            : GeneralSpec.fromJson(json["general_spec"]),
        layerConfig: json["layer_config"] == null
            ? null
            : PurpleLayerConfig.fromJson(json["layer_config"]),
        resource: json["resource"] == null
            ? null
            : Resource.fromJson(json["resource"]),
      );

  Map<String, dynamic> toJson() => {
        "visible": visible,
        "general_spec": generalSpec?.toJson(),
        "layer_config": layerConfig?.toJson(),
        "resource": resource?.toJson(),
      };
}

class GeneralSpec {
  GeneralSpec({
    this.posSpec,
    this.sizeSpec,
    this.renderSpec,
  });

  PosSpec? posSpec;
  ContainerSize? sizeSpec;
  RenderSpec? renderSpec;

  factory GeneralSpec.fromRawJson(String str) =>
      GeneralSpec.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GeneralSpec.fromJson(Map<String, dynamic> json) => GeneralSpec(
        posSpec: json["pos_spec"] == null
            ? null
            : PosSpec.fromJson(json["pos_spec"]),
        sizeSpec: json["size_spec"] == null
            ? null
            : ContainerSize.fromJson(json["size_spec"]),
        renderSpec: json["render_spec"] == null
            ? null
            : RenderSpec.fromJson(json["render_spec"]),
      );

  Map<String, dynamic> toJson() => {
        "pos_spec": posSpec?.toJson(),
        "size_spec": sizeSpec?.toJson(),
        "render_spec": renderSpec?.toJson(),
      };
}

class PosSpec {
  PosSpec({
    this.coordinatePos,
    this.axisX,
    this.axisY,
  });

  int? coordinatePos;
  double? axisX;
  double? axisY;

  factory PosSpec.fromRawJson(String str) => PosSpec.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosSpec.fromJson(Map<String, dynamic> json) => PosSpec(
        coordinatePos: json["coordinate_pos"],
        axisX: json["axis_x"]?.toDouble(),
        axisY: json["axis_y"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "coordinate_pos": coordinatePos,
        "axis_x": axisX,
        "axis_y": axisY,
      };
}

class RenderSpec {
  RenderSpec({
    this.opacity,
  });

  int? opacity;

  factory RenderSpec.fromRawJson(String str) =>
      RenderSpec.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RenderSpec.fromJson(Map<String, dynamic> json) => RenderSpec(
        opacity: json["opacity"],
      );

  Map<String, dynamic> toJson() => {
        "opacity": opacity,
      };
}

class PurpleLayerConfig {
  PurpleLayerConfig({
    this.tags,
    this.isCritical,
    this.layerMask,
  });

  PurpleTags? tags;
  bool? isCritical;
  LayerMask? layerMask;

  factory PurpleLayerConfig.fromRawJson(String str) =>
      PurpleLayerConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleLayerConfig.fromJson(Map<String, dynamic> json) =>
      PurpleLayerConfig(
        tags: json["tags"] == null ? null : PurpleTags.fromJson(json["tags"]),
        isCritical: json["is_critical"],
        layerMask: json["layer_mask"] == null
            ? null
            : LayerMask.fromJson(json["layer_mask"]),
      );

  Map<String, dynamic> toJson() => {
        "tags": tags?.toJson(),
        "is_critical": isCritical,
        "layer_mask": layerMask?.toJson(),
      };
}

class LayerMask {
  LayerMask({
    this.generalSpec,
    this.maskSrc,
  });

  GeneralSpec? generalSpec;
  MaskSrc? maskSrc;

  factory LayerMask.fromRawJson(String str) =>
      LayerMask.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LayerMask.fromJson(Map<String, dynamic> json) => LayerMask(
        generalSpec: json["general_spec"] == null
            ? null
            : GeneralSpec.fromJson(json["general_spec"]),
        maskSrc: json["mask_src"] == null
            ? null
            : MaskSrc.fromJson(json["mask_src"]),
      );

  Map<String, dynamic> toJson() => {
        "general_spec": generalSpec?.toJson(),
        "mask_src": maskSrc?.toJson(),
      };
}

class MaskSrc {
  MaskSrc({
    this.srcType,
    this.draw,
  });

  int? srcType;
  MaskSrcDraw? draw;

  factory MaskSrc.fromRawJson(String str) => MaskSrc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MaskSrc.fromJson(Map<String, dynamic> json) => MaskSrc(
        srcType: json["src_type"],
        draw: json["draw"] == null ? null : MaskSrcDraw.fromJson(json["draw"]),
      );

  Map<String, dynamic> toJson() => {
        "src_type": srcType,
        "draw": draw?.toJson(),
      };
}

class MaskSrcDraw {
  MaskSrcDraw({
    this.drawType,
    this.fillMode,
    this.colorConfig,
  });

  int? drawType;
  int? fillMode;
  PurpleColorConfig? colorConfig;

  factory MaskSrcDraw.fromRawJson(String str) =>
      MaskSrcDraw.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MaskSrcDraw.fromJson(Map<String, dynamic> json) => MaskSrcDraw(
        drawType: json["draw_type"],
        fillMode: json["fill_mode"],
        colorConfig: json["color_config"] == null
            ? null
            : PurpleColorConfig.fromJson(json["color_config"]),
      );

  Map<String, dynamic> toJson() => {
        "draw_type": drawType,
        "fill_mode": fillMode,
        "color_config": colorConfig?.toJson(),
      };
}

class PurpleColorConfig {
  PurpleColorConfig({
    this.day,
  });

  Day? day;

  factory PurpleColorConfig.fromRawJson(String str) =>
      PurpleColorConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleColorConfig.fromJson(Map<String, dynamic> json) =>
      PurpleColorConfig(
        day: json["day"] == null ? null : Day.fromJson(json["day"]),
      );

  Map<String, dynamic> toJson() => {
        "day": day?.toJson(),
      };
}

class Day {
  Day({
    this.argb,
  });

  String? argb;

  factory Day.fromRawJson(String str) => Day.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        argb: json["argb"],
      );

  Map<String, dynamic> toJson() => {
        "argb": argb,
      };
}

class PurpleTags {
  PurpleTags({
    this.avatarLayer,
    this.iconLayer,
    this.pendentLayer,
  });

  AvatarLayerClass? avatarLayer;
  AvatarLayerClass? iconLayer;
  AvatarLayerClass? pendentLayer;

  factory PurpleTags.fromRawJson(String str) =>
      PurpleTags.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleTags.fromJson(Map<String, dynamic> json) => PurpleTags(
        avatarLayer: json["AVATAR_LAYER"] == null
            ? null
            : AvatarLayerClass.fromJson(json["AVATAR_LAYER"]),
        iconLayer: json["ICON_LAYER"] == null
            ? null
            : AvatarLayerClass.fromJson(json["ICON_LAYER"]),
        pendentLayer: json["PENDENT_LAYER"] == null
            ? null
            : AvatarLayerClass.fromJson(json["PENDENT_LAYER"]),
      );

  Map<String, dynamic> toJson() => {
        "AVATAR_LAYER": avatarLayer?.toJson(),
        "ICON_LAYER": iconLayer?.toJson(),
        "PENDENT_LAYER": pendentLayer?.toJson(),
      };
}

class Resource {
  Resource({
    this.resType,
    this.resImage,
    this.resNativeDraw,
  });

  int? resType;
  ResImage? resImage;
  ResNativeDraw? resNativeDraw;

  factory Resource.fromRawJson(String str) =>
      Resource.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
        resType: json["res_type"],
        resImage: json["res_image"] == null
            ? null
            : ResImage.fromJson(json["res_image"]),
        resNativeDraw: json["res_native_draw"] == null
            ? null
            : ResNativeDraw.fromJson(json["res_native_draw"]),
      );

  Map<String, dynamic> toJson() => {
        "res_type": resType,
        "res_image": resImage?.toJson(),
        "res_native_draw": resNativeDraw?.toJson(),
      };
}

class ResImage {
  ResImage({
    this.imageSrc,
  });

  ImageSrc? imageSrc;

  factory ResImage.fromRawJson(String str) =>
      ResImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResImage.fromJson(Map<String, dynamic> json) => ResImage(
        imageSrc: json["image_src"] == null
            ? null
            : ImageSrc.fromJson(json["image_src"]),
      );

  Map<String, dynamic> toJson() => {
        "image_src": imageSrc?.toJson(),
      };
}

class ImageSrc {
  ImageSrc({
    this.srcType,
    this.placeholder,
    this.remote,
    this.local,
  });

  int? srcType;
  int? placeholder;
  Remote? remote;
  int? local;

  factory ImageSrc.fromRawJson(String str) =>
      ImageSrc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImageSrc.fromJson(Map<String, dynamic> json) => ImageSrc(
        srcType: json["src_type"],
        placeholder: json["placeholder"],
        remote: json["remote"] == null ? null : Remote.fromJson(json["remote"]),
        local: json["local"],
      );

  Map<String, dynamic> toJson() => {
        "src_type": srcType,
        "placeholder": placeholder,
        "remote": remote?.toJson(),
        "local": local,
      };
}

class Remote {
  Remote({
    this.url,
    this.bfsStyle,
  });

  String? url;
  String? bfsStyle;

  factory Remote.fromRawJson(String str) => Remote.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Remote.fromJson(Map<String, dynamic> json) => Remote(
        url: json["url"],
        bfsStyle: json["bfs_style"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "bfs_style": bfsStyle,
      };
}

class ResNativeDraw {
  ResNativeDraw({
    this.drawSrc,
  });

  DrawSrc? drawSrc;

  factory ResNativeDraw.fromRawJson(String str) =>
      ResNativeDraw.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResNativeDraw.fromJson(Map<String, dynamic> json) => ResNativeDraw(
        drawSrc: json["draw_src"] == null
            ? null
            : DrawSrc.fromJson(json["draw_src"]),
      );

  Map<String, dynamic> toJson() => {
        "draw_src": drawSrc?.toJson(),
      };
}

class DrawSrc {
  DrawSrc({
    this.srcType,
    this.draw,
  });

  int? srcType;
  DrawSrcDraw? draw;

  factory DrawSrc.fromRawJson(String str) => DrawSrc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DrawSrc.fromJson(Map<String, dynamic> json) => DrawSrc(
        srcType: json["src_type"],
        draw: json["draw"] == null ? null : DrawSrcDraw.fromJson(json["draw"]),
      );

  Map<String, dynamic> toJson() => {
        "src_type": srcType,
        "draw": draw?.toJson(),
      };
}

class DrawSrcDraw {
  DrawSrcDraw({
    this.drawType,
    this.fillMode,
    this.colorConfig,
  });

  int? drawType;
  int? fillMode;
  FluffyColorConfig? colorConfig;

  factory DrawSrcDraw.fromRawJson(String str) =>
      DrawSrcDraw.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DrawSrcDraw.fromJson(Map<String, dynamic> json) => DrawSrcDraw(
        drawType: json["draw_type"],
        fillMode: json["fill_mode"],
        colorConfig: json["color_config"] == null
            ? null
            : FluffyColorConfig.fromJson(json["color_config"]),
      );

  Map<String, dynamic> toJson() => {
        "draw_type": drawType,
        "fill_mode": fillMode,
        "color_config": colorConfig?.toJson(),
      };
}

class FluffyColorConfig {
  FluffyColorConfig({
    this.isDarkModeAware,
    this.day,
    this.night,
  });

  bool? isDarkModeAware;
  Day? day;
  Day? night;

  factory FluffyColorConfig.fromRawJson(String str) =>
      FluffyColorConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyColorConfig.fromJson(Map<String, dynamic> json) =>
      FluffyColorConfig(
        isDarkModeAware: json["is_dark_mode_aware"],
        day: json["day"] == null ? null : Day.fromJson(json["day"]),
        night: json["night"] == null ? null : Day.fromJson(json["night"]),
      );

  Map<String, dynamic> toJson() => {
        "is_dark_mode_aware": isDarkModeAware,
        "day": day?.toJson(),
        "night": night?.toJson(),
      };
}

class UserSailing {
  UserSailing({
    this.pendant,
    this.cardbg,
    this.cardbgWithFocus,
  });

  UserSailingPendant? pendant;
  Cardbg? cardbg;
  dynamic cardbgWithFocus;

  factory UserSailing.fromRawJson(String str) =>
      UserSailing.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserSailing.fromJson(Map<String, dynamic> json) => UserSailing(
        pendant: json["pendant"] == null
            ? null
            : UserSailingPendant.fromJson(json["pendant"]),
        cardbg: json["cardbg"] == null ? null : Cardbg.fromJson(json["cardbg"]),
        cardbgWithFocus: json["cardbg_with_focus"],
      );

  Map<String, dynamic> toJson() => {
        "pendant": pendant?.toJson(),
        "cardbg": cardbg?.toJson(),
        "cardbg_with_focus": cardbgWithFocus,
      };
}

class Cardbg {
  Cardbg({
    this.id,
    this.name,
    this.image,
    this.jumpUrl,
    this.fan,
    this.type,
  });

  int? id;
  String? name;
  String? image;
  String? jumpUrl;
  Fan? fan;
  String? type;

  factory Cardbg.fromRawJson(String str) => Cardbg.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cardbg.fromJson(Map<String, dynamic> json) => Cardbg(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        jumpUrl: json["jump_url"],
        fan: json["fan"] == null ? null : Fan.fromJson(json["fan"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "jump_url": jumpUrl,
        "fan": fan?.toJson(),
        "type": type,
      };
}

class Fan {
  Fan({
    this.isFan,
    this.number,
    this.color,
    this.name,
    this.numDesc,
  });

  int? isFan;
  int? number;
  String? color;
  String? name;
  String? numDesc;

  factory Fan.fromRawJson(String str) => Fan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Fan.fromJson(Map<String, dynamic> json) => Fan(
        isFan: json["is_fan"],
        number: json["number"],
        color: json["color"],
        name: json["name"],
        numDesc: json["num_desc"],
      );

  Map<String, dynamic> toJson() => {
        "is_fan": isFan,
        "number": number,
        "color": color,
        "name": name,
        "num_desc": numDesc,
      };
}

class UserSailingPendant {
  UserSailingPendant({
    this.id,
    this.name,
    this.image,
    this.jumpUrl,
    this.type,
    this.imageEnhance,
    this.imageEnhanceFrame,
  });

  int? id;
  String? name;
  String? image;
  String? jumpUrl;
  String? type;
  String? imageEnhance;
  String? imageEnhanceFrame;

  factory UserSailingPendant.fromRawJson(String str) =>
      UserSailingPendant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserSailingPendant.fromJson(Map<String, dynamic> json) =>
      UserSailingPendant(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        jumpUrl: json["jump_url"],
        type: json["type"],
        imageEnhance: json["image_enhance"],
        imageEnhanceFrame: json["image_enhance_frame"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "jump_url": jumpUrl,
        "type": type,
        "image_enhance": imageEnhance,
        "image_enhance_frame": imageEnhanceFrame,
      };
}

class ReplyReplyControl {
  ReplyReplyControl({
    this.following,
    this.maxLine,
    this.timeDesc,
    this.location,
  });

  bool? following;
  int? maxLine;
  String? timeDesc;
  String? location;

  factory ReplyReplyControl.fromRawJson(String str) =>
      ReplyReplyControl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReplyReplyControl.fromJson(Map<String, dynamic> json) =>
      ReplyReplyControl(
        following: json["following"],
        maxLine: json["max_line"],
        timeDesc: json["time_desc"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "following": following,
        "max_line": maxLine,
        "time_desc": timeDesc,
        "location": location,
      };
}

class UpAction {
  UpAction({
    this.like,
    this.reply,
  });

  bool? like;
  bool? reply;

  factory UpAction.fromRawJson(String str) =>
      UpAction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpAction.fromJson(Map<String, dynamic> json) => UpAction(
        like: json["like"],
        reply: json["reply"],
      );

  Map<String, dynamic> toJson() => {
        "like": like,
        "reply": reply,
      };
}

// class Root {
//   Root({
//     this.rpid,
//     this.oid,
//     this.type,
//     this.mid,
//     this.root,
//     this.parent,
//     this.dialog,
//     this.count,
//     this.rcount,
//     this.state,
//     this.fansgrade,
//     this.attr,
//     this.ctime,
//     this.rpidStr,
//     this.rootStr,
//     this.parentStr,
//     this.like,
//     this.action,
//     this.member,
//     this.content,
//     this.replies,
//     this.assist,
//     this.upAction,
//     this.invisible,
//     this.replyControl,
//     this.folder,
//     this.dynamicIdStr,
//   });

//   int? rpid;
//   int? oid;
//   int? type;
//   int? mid;
//   int? root;
//   int? parent;
//   int? dialog;
//   int? count;
//   int? rcount;
//   int? state;
//   int? fansgrade;
//   int? attr;
//   int? ctime;
//   String? rpidStr;
//   String? rootStr;
//   String? parentStr;
//   int? like;
//   int? action;
//   RootMember? member;
//   Content? content;
//   dynamic replies;
//   int? assist;
//   UpAction? upAction;
//   bool? invisible;
//   RootReplyControl? replyControl;
//   Folder? folder;
//   String? dynamicIdStr;

//   factory Root.fromRawJson(String str) => Root.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Root.fromJson(Map<String, dynamic> json) => Root(
//         rpid: json["rpid"],
//         oid: json["oid"],
//         type: json["type"],
//         mid: json["mid"],
//         root: json["root"],
//         parent: json["parent"],
//         dialog: json["dialog"],
//         count: json["count"],
//         rcount: json["rcount"],
//         state: json["state"],
//         fansgrade: json["fansgrade"],
//         attr: json["attr"],
//         ctime: json["ctime"],
//         rpidStr: json["rpid_str"],
//         rootStr: json["root_str"],
//         parentStr: json["parent_str"],
//         like: json["like"],
//         action: json["action"],
//         member:
//             json["member"] == null ? null : RootMember.fromJson(json["member"]),
//         content:
//             json["content"] == null ? null : Content.fromJson(json["content"]),
//         replies: json["replies"],
//         assist: json["assist"],
//         upAction: json["up_action"] == null
//             ? null
//             : UpAction.fromJson(json["up_action"]),
//         invisible: json["invisible"],
//         replyControl: json["reply_control"] == null
//             ? null
//             : RootReplyControl.fromJson(json["reply_control"]),
//         folder: json["folder"] == null ? null : Folder.fromJson(json["folder"]),
//         dynamicIdStr: json["dynamic_id_str"],
//       );

//   Map<String, dynamic> toJson() => {
//         "rpid": rpid,
//         "oid": oid,
//         "type": type,
//         "mid": mid,
//         "root": root,
//         "parent": parent,
//         "dialog": dialog,
//         "count": count,
//         "rcount": rcount,
//         "state": state,
//         "fansgrade": fansgrade,
//         "attr": attr,
//         "ctime": ctime,
//         "rpid_str": rpidStr,
//         "root_str": rootStr,
//         "parent_str": parentStr,
//         "like": like,
//         "action": action,
//         "member": member?.toJson(),
//         "content": content?.toJson(),
//         "replies": replies,
//         "assist": assist,
//         "up_action": upAction?.toJson(),
//         "invisible": invisible,
//         "reply_control": replyControl?.toJson(),
//         "folder": folder?.toJson(),
//         "dynamic_id_str": dynamicIdStr,
//       };
// }

// class RootContent {
//   RootContent({
//     this.message,
//     this.members,
//     this.jumpUrl,
//     this.maxLine,
//   });

//   String? message;
//   List<dynamic>? members;
//   PurpleJumpUrl? jumpUrl;
//   int? maxLine;

//   factory RootContent.fromRawJson(String str) =>
//       RootContent.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory RootContent.fromJson(Map<String, dynamic> json) => RootContent(
//         message: json["message"],
//         members: json["members"] == null
//             ? []
//             : List<dynamic>.from(json["members"]!.map((x) => x)),
//         jumpUrl: json["jump_url"] == null
//             ? null
//             : PurpleJumpUrl.fromJson(json["jump_url"]),
//         maxLine: json["max_line"],
//       );

//   Map<String, dynamic> toJson() => {
//         "message": message,
//         "members":
//             members == null ? [] : List<dynamic>.from(members!.map((x) => x)),
//         "jump_url": jumpUrl?.toJson(),
//         "max_line": maxLine,
//       };
// }

class PurpleJumpUrl {
  PurpleJumpUrl({
    this.tetris,
  });

  Tetris? tetris;

  factory PurpleJumpUrl.fromRawJson(String str) =>
      PurpleJumpUrl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleJumpUrl.fromJson(Map<String, dynamic> json) => PurpleJumpUrl(
        tetris: json["tetris"] == null ? null : Tetris.fromJson(json["tetris"]),
      );

  Map<String, dynamic> toJson() => {
        "tetris": tetris?.toJson(),
      };
}

class Tetris {
  Tetris({
    this.title,
    this.state,
    this.prefixIcon,
    this.appUrlSchema,
    this.appName,
    this.appPackageName,
    this.clickReport,
    this.isHalfScreen,
    this.exposureReport,
    this.extra,
    this.underline,
    this.matchOnce,
    this.pcUrl,
    this.iconPosition,
  });

  String? title;
  int? state;
  String? prefixIcon;
  String? appUrlSchema;
  String? appName;
  String? appPackageName;
  String? clickReport;
  bool? isHalfScreen;
  String? exposureReport;
  Extra? extra;
  bool? underline;
  bool? matchOnce;
  String? pcUrl;
  int? iconPosition;

  factory Tetris.fromRawJson(String str) => Tetris.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tetris.fromJson(Map<String, dynamic> json) => Tetris(
        title: json["title"],
        state: json["state"],
        prefixIcon: json["prefix_icon"],
        appUrlSchema: json["app_url_schema"],
        appName: json["app_name"],
        appPackageName: json["app_package_name"],
        clickReport: json["click_report"],
        isHalfScreen: json["is_half_screen"],
        exposureReport: json["exposure_report"],
        extra: json["extra"] == null ? null : Extra.fromJson(json["extra"]),
        underline: json["underline"],
        matchOnce: json["match_once"],
        pcUrl: json["pc_url"],
        iconPosition: json["icon_position"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "state": state,
        "prefix_icon": prefixIcon,
        "app_url_schema": appUrlSchema,
        "app_name": appName,
        "app_package_name": appPackageName,
        "click_report": clickReport,
        "is_half_screen": isHalfScreen,
        "exposure_report": exposureReport,
        "extra": extra?.toJson(),
        "underline": underline,
        "match_once": matchOnce,
        "pc_url": pcUrl,
        "icon_position": iconPosition,
      };
}

class Extra {
  Extra({
    this.goodsShowType,
    this.isWordSearch,
    this.goodsCmControl,
    this.goodsClickReport,
    this.goodsExposureReport,
  });

  int? goodsShowType;
  bool? isWordSearch;
  int? goodsCmControl;
  String? goodsClickReport;
  String? goodsExposureReport;

  factory Extra.fromRawJson(String str) => Extra.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        goodsShowType: json["goods_show_type"],
        isWordSearch: json["is_word_search"],
        goodsCmControl: json["goods_cm_control"],
        goodsClickReport: json["goods_click_report"],
        goodsExposureReport: json["goods_exposure_report"],
      );

  Map<String, dynamic> toJson() => {
        "goods_show_type": goodsShowType,
        "is_word_search": isWordSearch,
        "goods_cm_control": goodsCmControl,
        "goods_click_report": goodsClickReport,
        "goods_exposure_report": goodsExposureReport,
      };
}

class RootMember {
  RootMember({
    this.mid,
    this.uname,
    this.sex,
    this.sign,
    this.avatar,
    this.rank,
    this.faceNftNew,
    this.isSeniorMember,
    this.levelInfo,
    this.pendant,
    this.nameplate,
    this.officialVerify,
    this.vip,
    this.fansDetail,
    this.userSailing,
    this.isContractor,
    this.contractDesc,
    this.nftInteraction,
    this.avatarItem,
  });

  String? mid;
  String? uname;
  String? sex;
  String? sign;
  String? avatar;
  String? rank;
  int? faceNftNew;
  int? isSeniorMember;
  LevelInfo? levelInfo;
  MemberPendant? pendant;
  Nameplate? nameplate;
  OfficialVerify? officialVerify;
  Vip? vip;
  dynamic fansDetail;
  UserSailing? userSailing;
  bool? isContractor;
  String? contractDesc;
  dynamic nftInteraction;
  FluffyAvatarItem? avatarItem;

  factory RootMember.fromRawJson(String str) =>
      RootMember.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RootMember.fromJson(Map<String, dynamic> json) => RootMember(
        mid: json["mid"],
        uname: json["uname"],
        sex: json["sex"],
        sign: json["sign"],
        avatar: json["avatar"],
        rank: json["rank"],
        faceNftNew: json["face_nft_new"],
        isSeniorMember: json["is_senior_member"],
        levelInfo: json["level_info"] == null
            ? null
            : LevelInfo.fromJson(json["level_info"]),
        pendant: json["pendant"] == null
            ? null
            : MemberPendant.fromJson(json["pendant"]),
        nameplate: json["nameplate"] == null
            ? null
            : Nameplate.fromJson(json["nameplate"]),
        officialVerify: json["official_verify"] == null
            ? null
            : OfficialVerify.fromJson(json["official_verify"]),
        vip: json["vip"] == null ? null : Vip.fromJson(json["vip"]),
        fansDetail: json["fans_detail"],
        userSailing: json["user_sailing"] == null
            ? null
            : UserSailing.fromJson(json["user_sailing"]),
        isContractor: json["is_contractor"],
        contractDesc: json["contract_desc"],
        nftInteraction: json["nft_interaction"],
        avatarItem: json["avatar_item"] == null
            ? null
            : FluffyAvatarItem.fromJson(json["avatar_item"]),
      );

  Map<String, dynamic> toJson() => {
        "mid": mid,
        "uname": uname,
        "sex": sex,
        "sign": sign,
        "avatar": avatar,
        "rank": rank,
        "face_nft_new": faceNftNew,
        "is_senior_member": isSeniorMember,
        "level_info": levelInfo?.toJson(),
        "pendant": pendant?.toJson(),
        "nameplate": nameplate?.toJson(),
        "official_verify": officialVerify?.toJson(),
        "vip": vip?.toJson(),
        "fans_detail": fansDetail,
        "user_sailing": userSailing?.toJson(),
        "is_contractor": isContractor,
        "contract_desc": contractDesc,
        "nft_interaction": nftInteraction,
        "avatar_item": avatarItem?.toJson(),
      };
}

class FluffyAvatarItem {
  FluffyAvatarItem({
    this.containerSize,
    this.fallbackLayers,
    this.mid,
  });

  ContainerSize? containerSize;
  FluffyFallbackLayers? fallbackLayers;
  String? mid;

  factory FluffyAvatarItem.fromRawJson(String str) =>
      FluffyAvatarItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyAvatarItem.fromJson(Map<String, dynamic> json) =>
      FluffyAvatarItem(
        containerSize: json["container_size"] == null
            ? null
            : ContainerSize.fromJson(json["container_size"]),
        fallbackLayers: json["fallback_layers"] == null
            ? null
            : FluffyFallbackLayers.fromJson(json["fallback_layers"]),
        mid: json["mid"],
      );

  Map<String, dynamic> toJson() => {
        "container_size": containerSize?.toJson(),
        "fallback_layers": fallbackLayers?.toJson(),
        "mid": mid,
      };
}

class FluffyFallbackLayers {
  FluffyFallbackLayers({
    this.layers,
    this.isCriticalGroup,
  });

  List<FluffyLayer>? layers;
  bool? isCriticalGroup;

  factory FluffyFallbackLayers.fromRawJson(String str) =>
      FluffyFallbackLayers.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyFallbackLayers.fromJson(Map<String, dynamic> json) =>
      FluffyFallbackLayers(
        layers: json["layers"] == null
            ? []
            : List<FluffyLayer>.from(
                json["layers"]!.map((x) => FluffyLayer.fromJson(x))),
        isCriticalGroup: json["is_critical_group"],
      );

  Map<String, dynamic> toJson() => {
        "layers": layers == null
            ? []
            : List<dynamic>.from(layers!.map((x) => x.toJson())),
        "is_critical_group": isCriticalGroup,
      };
}

class FluffyLayer {
  FluffyLayer({
    this.visible,
    this.generalSpec,
    this.layerConfig,
    this.resource,
  });

  bool? visible;
  GeneralSpec? generalSpec;
  FluffyLayerConfig? layerConfig;
  Resource? resource;

  factory FluffyLayer.fromRawJson(String str) =>
      FluffyLayer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyLayer.fromJson(Map<String, dynamic> json) => FluffyLayer(
        visible: json["visible"],
        generalSpec: json["general_spec"] == null
            ? null
            : GeneralSpec.fromJson(json["general_spec"]),
        layerConfig: json["layer_config"] == null
            ? null
            : FluffyLayerConfig.fromJson(json["layer_config"]),
        resource: json["resource"] == null
            ? null
            : Resource.fromJson(json["resource"]),
      );

  Map<String, dynamic> toJson() => {
        "visible": visible,
        "general_spec": generalSpec?.toJson(),
        "layer_config": layerConfig?.toJson(),
        "resource": resource?.toJson(),
      };
}

class FluffyLayerConfig {
  FluffyLayerConfig({
    this.tags,
    this.isCritical,
    this.layerMask,
  });

  FluffyTags? tags;
  bool? isCritical;
  LayerMask? layerMask;

  factory FluffyLayerConfig.fromRawJson(String str) =>
      FluffyLayerConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyLayerConfig.fromJson(Map<String, dynamic> json) =>
      FluffyLayerConfig(
        tags: json["tags"] == null ? null : FluffyTags.fromJson(json["tags"]),
        isCritical: json["is_critical"],
        layerMask: json["layer_mask"] == null
            ? null
            : LayerMask.fromJson(json["layer_mask"]),
      );

  Map<String, dynamic> toJson() => {
        "tags": tags?.toJson(),
        "is_critical": isCritical,
        "layer_mask": layerMask?.toJson(),
      };
}

class FluffyTags {
  FluffyTags({
    this.avatarLayer,
    this.iconLayer,
  });

  AvatarLayerClass? avatarLayer;
  AvatarLayerClass? iconLayer;

  factory FluffyTags.fromRawJson(String str) =>
      FluffyTags.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyTags.fromJson(Map<String, dynamic> json) => FluffyTags(
        avatarLayer: json["AVATAR_LAYER"] == null
            ? null
            : AvatarLayerClass.fromJson(json["AVATAR_LAYER"]),
        iconLayer: json["ICON_LAYER"] == null
            ? null
            : AvatarLayerClass.fromJson(json["ICON_LAYER"]),
      );

  Map<String, dynamic> toJson() => {
        "AVATAR_LAYER": avatarLayer?.toJson(),
        "ICON_LAYER": iconLayer?.toJson(),
      };
}

class RootReplyControl {
  RootReplyControl({
    this.upReply,
    this.following,
    this.maxLine,
    this.subReplyEntryText,
    this.subReplyTitleText,
    this.timeDesc,
    this.location,
  });

  bool? upReply;
  bool? following;
  int? maxLine;
  String? subReplyEntryText;
  String? subReplyTitleText;
  String? timeDesc;
  String? location;

  factory RootReplyControl.fromRawJson(String str) =>
      RootReplyControl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RootReplyControl.fromJson(Map<String, dynamic> json) =>
      RootReplyControl(
        upReply: json["up_reply"],
        following: json["following"],
        maxLine: json["max_line"],
        subReplyEntryText: json["sub_reply_entry_text"],
        subReplyTitleText: json["sub_reply_title_text"],
        timeDesc: json["time_desc"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "up_reply": upReply,
        "following": following,
        "max_line": maxLine,
        "sub_reply_entry_text": subReplyEntryText,
        "sub_reply_title_text": subReplyTitleText,
        "time_desc": timeDesc,
        "location": location,
      };
}

// class Upper {
//   Upper({
//     this.mid,
//   });

//   int? mid;

//   factory Upper.fromRawJson(String str) => Upper.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Upper.fromJson(Map<String, dynamic> json) => Upper(
//         mid: json["mid"],
//       );

//   Map<String, dynamic> toJson() => {
//         "mid": mid,
//       };
// }
