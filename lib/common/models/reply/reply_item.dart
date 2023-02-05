import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(valueDecorators: ReplyItemModel.valueDecorators)
class ReplyItemModel {
  static Map<Type, ValueDecoratorFunction> valueDecorators() => {
        typeOf<List<CardLabel>>(): (value) => value.cast<CardLabel>(),
      };
  ReplyItemModel({
    required this.rpid,
    required this.oid,
    required this.type,
    required this.mid,
    required this.root,
    required this.parent,
    required this.dialog,
    required this.count,
    required this.rcount,
    required this.state,
    required this.fansgrade,
    required this.attr,
    required this.ctime,
    required this.rpidStr,
    required this.rootStr,
    required this.parentStr,
    required this.like,
    required this.action,
    required this.member,
    required this.content,
    required this.replies,
    required this.assist,
    required this.upAction,
    required this.invisible,
    required this.cardLabel,
    required this.replyControl,
    required this.folder,
    required this.dynamicIdStr,
  });

  @JsonProperty(defaultValue: 0)
  final int rpid;
  @JsonProperty(defaultValue: 0)
  final int oid;
  @JsonProperty(defaultValue: 0)
  final int type;
  @JsonProperty(defaultValue: 0)
  final int mid;
  @JsonProperty(defaultValue: 0)
  final int root;
  @JsonProperty(defaultValue: 0)
  final int parent;
  @JsonProperty(defaultValue: 0)
  final int dialog;
  @JsonProperty(defaultValue: 0)
  final int count;
  @JsonProperty(defaultValue: 0)
  final int rcount;
  @JsonProperty(defaultValue: 0)
  final int state;
  @JsonProperty(defaultValue: 0)
  final int fansgrade;
  @JsonProperty(defaultValue: 0)
  final int attr;
  @JsonProperty(defaultValue: 0)
  final int ctime;
  @JsonProperty(defaultValue: "")
  final String rpidStr;
  @JsonProperty(defaultValue: "")
  final String rootStr;
  @JsonProperty(defaultValue: "")
  final String parentStr;
  @JsonProperty(defaultValue: 0)
  final int like;
  @JsonProperty(defaultValue: 0)
  final int action;
  @JsonProperty(defaultValue: {})
  final Member member;
  @JsonProperty(defaultValue: {})
  final Content content;
  @JsonProperty(defaultValue: [])
  final List<ReplyItemModel> replies;
  @JsonProperty(defaultValue: 0)
  final int assist;
  @JsonProperty(defaultValue: {})
  final UpAction upAction;
  @JsonProperty(defaultValue: false)
  final bool invisible;
  @JsonProperty(name: 'card_label', defaultValue: [])
  final List<CardLabel> cardLabel;
  @JsonProperty(name: 'reply_control', defaultValue: {})
  final ReplyControl replyControl;
  @JsonProperty(defaultValue: {})
  final Folder folder;
  @JsonProperty(defaultValue: "")
  final String dynamicIdStr;
}

@jsonSerializable
@Json(valueDecorators: Content.valueDecorators)
class Content {
  static Map<Type, ValueDecoratorFunction> valueDecorators() => {
        typeOf<Map<String, Emote>>(): (value) => value.cast<String, Emote>(),
      };
  Content(
      {required this.message,
      required this.members,
      required this.maxLine,
      required this.emoteMap});

  @JsonProperty(defaultValue: "")
  final String message;
  @JsonProperty(defaultValue: [])
  final List<dynamic> members;
  @JsonProperty(name: "max_line", defaultValue: 0)
  final int maxLine;
  @JsonProperty(name: 'emote', defaultValue: {})
  final Map<String, Emote> emoteMap; //匹配名与表情对象表
}

@jsonSerializable
class Emote {
  Emote({
    // required this.id,
    // required this.packageId,
    // required this.state,
    // required this.type,
    // required this.attr,
    required this.text,
    required this.url,
    required this.size,
    // required this.mtime,
    // required this.jumpTitle,
  });
  // @JsonProperty(defaultValue: 0)
  // final int id;
  // @JsonProperty(name: "package_id", defaultValue: 0)
  // final int packageId;
  // @JsonProperty(defaultValue: 0)
  // final int state;
  // @JsonProperty(defaultValue: 0)
  // final int type;
  // @JsonProperty(defaultValue: 0)
  // final int attr;
  @JsonProperty(defaultValue: "[]")
  final String text; //表情匹配名
  @JsonProperty(defaultValue: "")
  final String url; //表情url
  @JsonProperty(name: "meta/size", defaultValue: 0)
  final int size; //1小,2大
  // @JsonProperty(defaultValue: 0)
  // final int mtime;
  // @JsonProperty(name: "jump_title", defaultValue: 0)
  // final String jumpTitle;
}

@jsonSerializable
class CardLabel {
  CardLabel({
    required this.rpid,
    required this.textContent,
    required this.textColorDay,
    required this.textColorNight,
    required this.labelColorDay,
    required this.labelColorNight,
    required this.image,
    required this.type,
    required this.background,
    required this.backgroundWidth,
    required this.backgroundHeight,
    required this.jumpUrl,
    required this.effect,
    required this.effectStartTime,
  });
  @JsonProperty(defaultValue: 0)
  final int rpid;
  @JsonProperty(name: 'text_content', defaultValue: '')
  final String textContent;
  @JsonProperty(name: 'text_color_day', defaultValue: '')
  final String textColorDay;
  @JsonProperty(name: 'text_color_night', defaultValue: '')
  final String textColorNight;
  @JsonProperty(name: 'label_color_day', defaultValue: '')
  final String labelColorDay;
  @JsonProperty(name: 'label_color_night', defaultValue: '')
  final String labelColorNight;
  @JsonProperty(defaultValue: '')
  final String image;
  @JsonProperty(defaultValue: 0)
  final int type;
  @JsonProperty(defaultValue: '')
  final String background;
  @JsonProperty(name: 'background_width', defaultValue: 0)
  final int backgroundWidth;
  @JsonProperty(name: 'background_height', defaultValue: 0)
  final int backgroundHeight;
  @JsonProperty(name: 'jump_url', defaultValue: '')
  final String jumpUrl;
  @JsonProperty(defaultValue: 0)
  final int effect;
  @JsonProperty(name: 'effect_start_time', defaultValue: 0)
  final int effectStartTime;
}

@jsonSerializable
class ReplyControl {
  ReplyControl({
    required this.timeDesc,
    required this.location,
  });
  @JsonProperty(name: 'time_desc', defaultValue: '')
  final String timeDesc;
  @JsonProperty(defaultValue: '')
  final String location;
}

@jsonSerializable
class Member {
  Member({
    required this.mid,
    required this.uname,
    required this.sex,
    required this.sign,
    required this.avatar,
    required this.rank,
    required this.faceNftNew,
    required this.isSeniorMember,
    required this.levelInfo,
    required this.pendant,
    required this.nameplate,
    required this.officialVerify,
    required this.vip,
    required this.fansDetail,
    required this.userSailing,
    required this.isContractor,
    required this.contractDesc,
    required this.nftInteraction,
    required this.avatarItem,
  });

  @JsonProperty(defaultValue: "")
  final String mid;
  @JsonProperty(defaultValue: "")
  final String uname;
  @JsonProperty(defaultValue: "")
  final String sex;
  @JsonProperty(defaultValue: "")
  final String sign;
  @JsonProperty(defaultValue: "")
  final String avatar;
  @JsonProperty(defaultValue: "")
  final String rank;
  @JsonProperty(defaultValue: 0)
  final int faceNftNew;
  @JsonProperty(defaultValue: 0)
  final int isSeniorMember;
  @JsonProperty(defaultValue: {})
  final LevelInfo levelInfo;
  @JsonProperty(defaultValue: {})
  final MemberPendant pendant;
  @JsonProperty(defaultValue: {})
  final Nameplate nameplate;
  @JsonProperty(defaultValue: {})
  final OfficialVerify officialVerify;
  @JsonProperty(defaultValue: {})
  final Vip vip;
  final dynamic fansDetail;
  @JsonProperty(defaultValue: {})
  final UserSailing userSailing;
  @JsonProperty(defaultValue: false)
  final bool isContractor;
  @JsonProperty(defaultValue: "")
  final String contractDesc;
  final dynamic nftInteraction;
  @JsonProperty(defaultValue: {})
  final AvatarItem avatarItem;
}

@jsonSerializable
class AvatarItem {
  AvatarItem({
    required this.containerSize,
    required this.fallbackLayers,
    required this.mid,
  });

  @JsonProperty(defaultValue: {})
  final ContainerSize containerSize;
  @JsonProperty(defaultValue: {})
  final FallbackLayers fallbackLayers;
  @JsonProperty(defaultValue: "")
  final String mid;
}

@jsonSerializable
class ContainerSize {
  ContainerSize({
    required this.width,
    required this.height,
  });

  @JsonProperty(defaultValue: 0.0)
  final double width;
  @JsonProperty(defaultValue: 0.0)
  final double height;
}

@jsonSerializable
@Json(valueDecorators: FallbackLayers.valueDecorators)
class FallbackLayers {
  static Map<Type, ValueDecoratorFunction> valueDecorators() => {
        typeOf<List<Layer>>(): (value) => value.cast<Layer>(),
      };
  FallbackLayers({
    required this.layers,
    required this.isCriticalGroup,
  });

  @JsonProperty(defaultValue: [])
  final List<Layer> layers;
  @JsonProperty(defaultValue: false)
  final bool isCriticalGroup;
}

@jsonSerializable
class Layer {
  Layer({
    required this.visible,
    required this.generalSpec,
    required this.layerConfig,
    required this.resource,
  });

  @JsonProperty(defaultValue: false)
  final bool visible;
  @JsonProperty(defaultValue: {})
  final GeneralSpec generalSpec;
  @JsonProperty(defaultValue: {})
  final LayerConfig layerConfig;
  @JsonProperty(defaultValue: {})
  final Resource resource;
}

@jsonSerializable
class GeneralSpec {
  GeneralSpec({
    required this.posSpec,
    required this.sizeSpec,
    required this.renderSpec,
  });

  @JsonProperty(defaultValue: {})
  final PosSpec posSpec;
  @JsonProperty(defaultValue: {})
  final ContainerSize sizeSpec;
  @JsonProperty(defaultValue: {})
  final RenderSpec renderSpec;
}

@jsonSerializable
class PosSpec {
  PosSpec({
    required this.coordinatePos,
    required this.axisX,
    required this.axisY,
  });

  @JsonProperty(defaultValue: 0)
  final int coordinatePos;
  @JsonProperty(defaultValue: 0.0)
  final double axisX;
  @JsonProperty(defaultValue: 0.0)
  final double axisY;
}

@jsonSerializable
class RenderSpec {
  RenderSpec({
    required this.opacity,
  });

  @JsonProperty(defaultValue: 0)
  final int opacity;
}

@jsonSerializable
class LayerConfig {
  LayerConfig({
    required this.tags,
    required this.isCritical,
    required this.layerMask,
  });

  @JsonProperty(defaultValue: {})
  final Tags tags;
  @JsonProperty(defaultValue: false)
  final bool isCritical;
  @JsonProperty(defaultValue: {})
  final LayerMask layerMask;
}

@jsonSerializable
class LayerMask {
  LayerMask({
    required this.generalSpec,
    required this.maskSrc,
  });

  @JsonProperty(defaultValue: {})
  final GeneralSpec generalSpec;
  @JsonProperty(defaultValue: {})
  final MaskSrc maskSrc;
}

@jsonSerializable
class MaskSrc {
  MaskSrc({
    required this.srcType,
    required this.draw,
  });

  @JsonProperty(defaultValue: 0)
  final int srcType;
  @JsonProperty(defaultValue: {})
  final Draw draw;
}

@jsonSerializable
class Draw {
  Draw({
    required this.drawType,
    required this.fillMode,
    required this.colorConfig,
  });

  @JsonProperty(defaultValue: 0)
  final int drawType;
  @JsonProperty(defaultValue: 0)
  final int fillMode;
  @JsonProperty(defaultValue: {})
  final ColorConfig colorConfig;
}

@jsonSerializable
class ColorConfig {
  ColorConfig({
    required this.day,
  });

  @JsonProperty(defaultValue: {})
  final Day day;
}

@jsonSerializable
class Day {
  Day({
    required this.argb,
  });

  @JsonProperty(defaultValue: "")
  final String argb;
}

@jsonSerializable
class Tags {
  Tags({
    required this.avatarLayer,
    required this.pendentLayer,
  });

  @JsonProperty(defaultValue: {})
  final dynamic avatarLayer;
  @JsonProperty(defaultValue: {})
  final dynamic pendentLayer;
}

@jsonSerializable
class Resource {
  Resource({
    required this.resType,
    required this.resImage,
    required this.resAnimation,
  });

  @JsonProperty(defaultValue: 0)
  final int resType;
  @JsonProperty(defaultValue: {})
  final ResImage resImage;
  @JsonProperty(defaultValue: {})
  final ResAnimation resAnimation;
}

@jsonSerializable
class ResAnimation {
  ResAnimation({
    required this.webpSrc,
  });

  @JsonProperty(defaultValue: {})
  final WebpSrc webpSrc;
}

@jsonSerializable
class WebpSrc {
  WebpSrc({
    required this.srcType,
    required this.remote,
  });

  @JsonProperty(defaultValue: 0)
  final int srcType;
  @JsonProperty(defaultValue: {})
  final Remote remote;
}

@jsonSerializable
class Remote {
  Remote({
    required this.url,
    required this.bfsStyle,
  });

  @JsonProperty(defaultValue: "")
  final String url;
  @JsonProperty(defaultValue: "")
  final String bfsStyle;
}

@jsonSerializable
class ResImage {
  ResImage({
    required this.imageSrc,
  });

  @JsonProperty(defaultValue: {})
  final ImageSrc imageSrc;
}

@jsonSerializable
class ImageSrc {
  ImageSrc({
    required this.srcType,
    required this.placeholder,
    required this.remote,
  });

  @JsonProperty(defaultValue: 0)
  final int srcType;
  @JsonProperty(defaultValue: 0)
  final int placeholder;
  @JsonProperty(defaultValue: {})
  final Remote remote;
}

@jsonSerializable
class LevelInfo {
  LevelInfo({
    required this.currentLevel,
    required this.currentMin,
    required this.currentExp,
    required this.nextExp,
  });

  @JsonProperty(defaultValue: 0)
  final int currentLevel;
  @JsonProperty(defaultValue: 0)
  final int currentMin;
  @JsonProperty(defaultValue: 0)
  final int currentExp;
  @JsonProperty(defaultValue: 0)
  final int nextExp;
}

@jsonSerializable
class Nameplate {
  Nameplate({
    required this.nid,
    required this.name,
    required this.image,
    required this.imageSmall,
    required this.level,
    required this.condition,
  });

  @JsonProperty(defaultValue: 0)
  final int nid;
  @JsonProperty(defaultValue: "")
  final String name;
  @JsonProperty(defaultValue: "")
  final String image;
  @JsonProperty(defaultValue: "")
  final String imageSmall;
  @JsonProperty(defaultValue: "")
  final String level;
  @JsonProperty(defaultValue: "")
  final String condition;
}

@jsonSerializable
class OfficialVerify {
  OfficialVerify({
    required this.type,
    required this.desc,
  });

  @JsonProperty(defaultValue: 0)
  final int type;
  @JsonProperty(defaultValue: "")
  final String desc;
}

@jsonSerializable
class MemberPendant {
  MemberPendant({
    required this.pid,
    required this.name,
    required this.image,
    required this.expire,
    required this.imageEnhance,
    required this.imageEnhanceFrame,
  });

  @JsonProperty(defaultValue: 0)
  final int pid;
  @JsonProperty(defaultValue: "")
  final String name;
  @JsonProperty(defaultValue: "")
  final String image;
  @JsonProperty(defaultValue: 0)
  final int expire;
  @JsonProperty(defaultValue: "")
  final String imageEnhance;
  @JsonProperty(defaultValue: "")
  final String imageEnhanceFrame;
}

@jsonSerializable
class UserSailing {
  UserSailing({
    required this.pendant,
    required this.cardbg,
    required this.cardbgWithFocus,
  });

  @JsonProperty(defaultValue: {})
  final UserSailingPendant pendant;
  @JsonProperty(defaultValue: {})
  final Cardbg cardbg;
  @JsonProperty(defaultValue: {})
  final dynamic cardbgWithFocus;
}

@jsonSerializable
class Cardbg {
  Cardbg({
    required this.id,
    required this.name,
    required this.image,
    required this.jumpUrl,
    required this.fan,
    required this.type,
  });

  @JsonProperty(defaultValue: 0)
  final int id;
  @JsonProperty(defaultValue: "")
  final String name;
  @JsonProperty(defaultValue: "")
  final String image;
  @JsonProperty(defaultValue: "")
  final String jumpUrl;
  @JsonProperty(defaultValue: {})
  final Fan fan;
  @JsonProperty(defaultValue: "")
  final String type;
}

@jsonSerializable
class Fan {
  Fan({
    required this.isFan,
    required this.number,
    required this.color,
    required this.name,
    required this.numDesc,
  });

  @JsonProperty(defaultValue: 0)
  final int isFan;
  @JsonProperty(defaultValue: 0)
  final int number;
  @JsonProperty(defaultValue: "")
  final String color;
  @JsonProperty(defaultValue: "")
  final String name;
  @JsonProperty(defaultValue: "")
  final String numDesc;
}

@jsonSerializable
class UserSailingPendant {
  UserSailingPendant({
    required this.id,
    required this.name,
    required this.image,
    required this.jumpUrl,
    required this.type,
    required this.imageEnhance,
    required this.imageEnhanceFrame,
  });

  @JsonProperty(defaultValue: 0)
  final int id;
  @JsonProperty(defaultValue: "")
  final String name;
  @JsonProperty(defaultValue: "")
  final String image;
  @JsonProperty(defaultValue: "")
  final String jumpUrl;
  @JsonProperty(defaultValue: "")
  final String type;
  @JsonProperty(defaultValue: "")
  final String imageEnhance;
  @JsonProperty(defaultValue: "")
  final String imageEnhanceFrame;
}

@jsonSerializable
class Vip {
  Vip({
    required this.vipType,
    required this.vipDueDate,
    required this.dueRemark,
    required this.accessStatus,
    required this.vipStatus,
    required this.vipStatusWarn,
    required this.themeType,
    required this.label,
    required this.avatarSubscript,
    required this.nicknameColor,
  });

  @JsonProperty(defaultValue: 0)
  final int vipType;
  @JsonProperty(defaultValue: 0)
  final int vipDueDate;
  @JsonProperty(defaultValue: "")
  final String dueRemark;
  @JsonProperty(defaultValue: 0)
  final int accessStatus;
  @JsonProperty(defaultValue: 0)
  final int vipStatus;
  @JsonProperty(defaultValue: "")
  final String vipStatusWarn;
  @JsonProperty(defaultValue: 0)
  final int themeType;
  @JsonProperty(defaultValue: {})
  final Label label;
  @JsonProperty(defaultValue: 0)
  final int avatarSubscript;
  @JsonProperty(defaultValue: "")
  final String nicknameColor;
}

@jsonSerializable
class Label {
  Label({
    required this.path,
    required this.text,
    required this.labelTheme,
    required this.textColor,
    required this.bgStyle,
    required this.bgColor,
    required this.borderColor,
    required this.useImgLabel,
    required this.imgLabelUriHans,
    required this.imgLabelUriHant,
    required this.imgLabelUriHansStatic,
    required this.imgLabelUriHantStatic,
  });

  @JsonProperty(defaultValue: "")
  final String path;
  @JsonProperty(defaultValue: "")
  final String text;
  @JsonProperty(defaultValue: "")
  final String labelTheme;
  @JsonProperty(defaultValue: "")
  final String textColor;
  @JsonProperty(defaultValue: 0)
  final int bgStyle;
  @JsonProperty(defaultValue: "")
  final String bgColor;
  @JsonProperty(defaultValue: "")
  final String borderColor;
  @JsonProperty(defaultValue: false)
  final bool useImgLabel;
  @JsonProperty(defaultValue: "")
  final String imgLabelUriHans;
  @JsonProperty(defaultValue: "")
  final String imgLabelUriHant;
  @JsonProperty(defaultValue: "")
  final String imgLabelUriHansStatic;
  @JsonProperty(defaultValue: "")
  final String imgLabelUriHantStatic;
}

@jsonSerializable
class UpAction {
  UpAction({
    required this.like,
    required this.reply,
  });

  @JsonProperty(defaultValue: false)
  final bool like;
  @JsonProperty(defaultValue: false)
  final bool reply;
}

@jsonSerializable
class Folder {
  Folder({
    required this.hasFolded,
    required this.isFolded,
    required this.rule,
  });

  @JsonProperty(defaultValue: false)
  final bool hasFolded;
  @JsonProperty(defaultValue: false)
  final bool isFolded;
  @JsonProperty(defaultValue: "")
  final String rule;
}
