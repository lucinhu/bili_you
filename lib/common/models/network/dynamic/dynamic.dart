// To parse this JSON data, do
//
//     final dynamicResponse = dynamicResponseFromJson(jsonString);

import 'dart:convert';

import 'package:bili_you/common/models/network/reply/reply.dart';

class DynamicResponse {
  DynamicResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  int? code;
  String? message;
  int? ttl;
  Data? data;

  factory DynamicResponse.fromRawJson(String str) =>
      DynamicResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DynamicResponse.fromJson(Map<String, dynamic> json) =>
      DynamicResponse(
        code: json["code"],
        message: json["message"],
        ttl: json["ttl"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "ttl": ttl,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.hasMore,
    this.items,
    this.offset,
    this.updateBaseline,
    this.updateNum,
  });

  bool? hasMore;
  List<DataItem>? items;
  String? offset;
  String? updateBaseline;
  int? updateNum;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        hasMore: json["has_more"],
        items: json["items"] == null
            ? []
            : List<DataItem>.from(
                json["items"]!.map((x) => DataItem.fromJson(x))),
        offset: json["offset"],
        updateBaseline: json["update_baseline"],
        updateNum: json["update_num"],
      );

  Map<String, dynamic> toJson() => {
        "has_more": hasMore,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "offset": offset,
        "update_baseline": updateBaseline,
        "update_num": updateNum,
      };
}

class DataItem {
  DataItem({
    this.basic,
    this.idStr,
    this.modules,
    this.type,
    this.visible,
    this.orig,
  });

  Basic? basic;
  String? idStr;
  ItemModules? modules;
  String? type;
  bool? visible;
  DataItem? orig;

  factory DataItem.fromRawJson(String str) =>
      DataItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataItem.fromJson(Map<String, dynamic> json) => DataItem(
        basic: json["basic"] == null ? null : Basic.fromJson(json["basic"]),
        idStr: json["id_str"],
        modules: json["modules"] == null
            ? null
            : ItemModules.fromJson(json["modules"]),
        type: json["type"],
        visible: json["visible"],
        orig: json["orig"] == null ? null : DataItem.fromJson(json["orig"]),
      );

  Map<String, dynamic> toJson() => {
        "basic": basic?.toJson(),
        "id_str": idStr,
        "modules": modules?.toJson(),
        "type": type,
        "visible": visible,
        "orig": orig?.toJson(),
      };
}

class Basic {
  Basic({
    this.commentIdStr,
    this.commentType,
    this.likeIcon,
    this.ridStr,
  });

  String? commentIdStr;
  int? commentType;
  LikeIcon? likeIcon;
  String? ridStr;

  factory Basic.fromRawJson(String str) => Basic.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Basic.fromJson(Map<String, dynamic> json) => Basic(
        commentIdStr: json["comment_id_str"],
        commentType: json["comment_type"],
        likeIcon: json["like_icon"] == null
            ? null
            : LikeIcon.fromJson(json["like_icon"]),
        ridStr: json["rid_str"],
      );

  Map<String, dynamic> toJson() => {
        "comment_id_str": commentIdStr,
        "comment_type": commentType,
        "like_icon": likeIcon?.toJson(),
        "rid_str": ridStr,
      };
}

class LikeIcon {
  LikeIcon({
    this.actionUrl,
    this.endUrl,
    this.id,
    this.startUrl,
  });

  String? actionUrl;
  String? endUrl;
  int? id;
  String? startUrl;

  factory LikeIcon.fromRawJson(String str) =>
      LikeIcon.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LikeIcon.fromJson(Map<String, dynamic> json) => LikeIcon(
        actionUrl: json["action_url"],
        endUrl: json["end_url"],
        id: json["id"],
        startUrl: json["start_url"],
      );

  Map<String, dynamic> toJson() => {
        "action_url": actionUrl,
        "end_url": endUrl,
        "id": id,
        "start_url": startUrl,
      };
}

class ItemModules {
  ItemModules({
    this.moduleAuthor,
    this.moduleDynamic,
    this.moduleMore,
    this.moduleStat,
    this.moduleInteraction,
  });

  ModuleAuthor? moduleAuthor;
  ModuleDynamic? moduleDynamic;
  ModuleMore? moduleMore;
  ModuleStat? moduleStat;
  ModuleInteraction? moduleInteraction;

  factory ItemModules.fromRawJson(String str) =>
      ItemModules.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemModules.fromJson(Map<String, dynamic> json) => ItemModules(
        moduleAuthor: json["module_author"] == null
            ? null
            : ModuleAuthor.fromJson(json["module_author"]),
        moduleDynamic: json["module_dynamic"] == null
            ? null
            : ModuleDynamic.fromJson(json["module_dynamic"]),
        moduleMore: json["module_more"] == null
            ? null
            : ModuleMore.fromJson(json["module_more"]),
        moduleStat: json["module_stat"] == null
            ? null
            : ModuleStat.fromJson(json["module_stat"]),
        moduleInteraction: json["module_interaction"] == null
            ? null
            : ModuleInteraction.fromJson(json["module_interaction"]),
      );

  Map<String, dynamic> toJson() => {
        "module_author": moduleAuthor?.toJson(),
        "module_dynamic": moduleDynamic?.toJson(),
        "module_more": moduleMore?.toJson(),
        "module_stat": moduleStat?.toJson(),
        "module_interaction": moduleInteraction?.toJson(),
      };
}

class ModuleAuthor {
  ModuleAuthor({
    this.avatar,
    this.face,
    this.faceNft,
    this.following,
    this.jumpUrl,
    this.label,
    this.mid,
    this.name,
    this.officialVerify,
    this.pendant,
    this.pubAction,
    this.pubLocationText,
    this.pubTime,
    this.pubTs,
    this.type,
    this.vip,
    this.decorate,
  });

  Avatar? avatar;
  String? face;
  bool? faceNft;
  bool? following;
  String? jumpUrl;
  String? label;
  int? mid;
  String? name;
  OfficialVerify? officialVerify;
  MemberPendant? pendant;
  String? pubAction;
  String? pubLocationText;
  String? pubTime;
  int? pubTs;
  String? type;
  Vip? vip;
  Decorate? decorate;

  factory ModuleAuthor.fromRawJson(String str) =>
      ModuleAuthor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModuleAuthor.fromJson(Map<String, dynamic> json) => ModuleAuthor(
        avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
        face: json["face"],
        faceNft: json["face_nft"],
        following: json["following"],
        jumpUrl: json["jump_url"],
        label: json["label"],
        mid: json["mid"],
        name: json["name"],
        officialVerify: json["official_verify"] == null
            ? null
            : OfficialVerify.fromJson(json["official_verify"]),
        pendant: json["pendant"] == null
            ? null
            : MemberPendant.fromJson(json["pendant"]),
        pubAction: json["pub_action"],
        pubLocationText: json["pub_location_text"],
        pubTime: json["pub_time"],
        pubTs: json["pub_ts"],
        type: json["type"],
        vip: json["vip"] == null ? null : Vip.fromJson(json["vip"]),
        decorate: json["decorate"] == null
            ? null
            : Decorate.fromJson(json["decorate"]),
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar?.toJson(),
        "face": face,
        "face_nft": faceNft,
        "following": following,
        "jump_url": jumpUrl,
        "label": label,
        "mid": mid,
        "name": name,
        "official_verify": officialVerify?.toJson(),
        "pendant": pendant?.toJson(),
        "pub_action": pubAction,
        "pub_location_text": pubLocationText,
        "pub_time": pubTime,
        "pub_ts": pubTs,
        "type": type,
        "vip": vip?.toJson(),
        "decorate": decorate?.toJson(),
      };
}

class Avatar {
  Avatar({
    this.containerSize,
    this.fallbackLayers,
    this.mid,
    this.layers,
  });

  ContainerSize? containerSize;
  FallbackLayers? fallbackLayers;
  String? mid;
  List<AvatarLayer>? layers;

  factory Avatar.fromRawJson(String str) => Avatar.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        containerSize: json["container_size"] == null
            ? null
            : ContainerSize.fromJson(json["container_size"]),
        fallbackLayers: json["fallback_layers"] == null
            ? null
            : FallbackLayers.fromJson(json["fallback_layers"]),
        mid: json["mid"],
        layers: json["layers"] == null
            ? []
            : List<AvatarLayer>.from(
                json["layers"]!.map((x) => AvatarLayer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "container_size": containerSize?.toJson(),
        "fallback_layers": fallbackLayers?.toJson(),
        "mid": mid,
        "layers": layers == null
            ? []
            : List<dynamic>.from(layers!.map((x) => x.toJson())),
      };
}

class ContainerSize {
  ContainerSize({
    this.height,
    this.width,
  });

  double? height;
  double? width;

  factory ContainerSize.fromRawJson(String str) =>
      ContainerSize.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContainerSize.fromJson(Map<String, dynamic> json) => ContainerSize(
        height: json["height"]?.toDouble(),
        width: json["width"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "width": width,
      };
}

class FallbackLayers {
  FallbackLayers({
    this.isCriticalGroup,
    this.layers,
  });

  bool? isCriticalGroup;
  List<FallbackLayersLayer>? layers;

  factory FallbackLayers.fromRawJson(String str) =>
      FallbackLayers.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FallbackLayers.fromJson(Map<String, dynamic> json) => FallbackLayers(
        isCriticalGroup: json["is_critical_group"],
        layers: json["layers"] == null
            ? []
            : List<FallbackLayersLayer>.from(
                json["layers"]!.map((x) => FallbackLayersLayer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "is_critical_group": isCriticalGroup,
        "layers": layers == null
            ? []
            : List<dynamic>.from(layers!.map((x) => x.toJson())),
      };
}

class FallbackLayersLayer {
  FallbackLayersLayer({
    this.generalSpec,
    this.layerConfig,
    this.resource,
    this.visible,
  });

  GeneralSpec? generalSpec;
  LayerConfig? layerConfig;
  Resource? resource;
  bool? visible;

  factory FallbackLayersLayer.fromRawJson(String str) =>
      FallbackLayersLayer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FallbackLayersLayer.fromJson(Map<String, dynamic> json) =>
      FallbackLayersLayer(
        generalSpec: json["general_spec"] == null
            ? null
            : GeneralSpec.fromJson(json["general_spec"]),
        layerConfig: json["layer_config"] == null
            ? null
            : LayerConfig.fromJson(json["layer_config"]),
        resource: json["resource"] == null
            ? null
            : Resource.fromJson(json["resource"]),
        visible: json["visible"],
      );

  Map<String, dynamic> toJson() => {
        "general_spec": generalSpec?.toJson(),
        "layer_config": layerConfig?.toJson(),
        "resource": resource?.toJson(),
        "visible": visible,
      };
}

class GeneralSpec {
  GeneralSpec({
    this.posSpec,
    this.renderSpec,
    this.sizeSpec,
  });

  PosSpec? posSpec;
  RenderSpec? renderSpec;
  ContainerSize? sizeSpec;

  factory GeneralSpec.fromRawJson(String str) =>
      GeneralSpec.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GeneralSpec.fromJson(Map<String, dynamic> json) => GeneralSpec(
        posSpec: json["pos_spec"] == null
            ? null
            : PosSpec.fromJson(json["pos_spec"]),
        renderSpec: json["render_spec"] == null
            ? null
            : RenderSpec.fromJson(json["render_spec"]),
        sizeSpec: json["size_spec"] == null
            ? null
            : ContainerSize.fromJson(json["size_spec"]),
      );

  Map<String, dynamic> toJson() => {
        "pos_spec": posSpec?.toJson(),
        "render_spec": renderSpec?.toJson(),
        "size_spec": sizeSpec?.toJson(),
      };
}

class PosSpec {
  PosSpec({
    this.axisX,
    this.axisY,
    this.coordinatePos,
  });

  double? axisX;
  double? axisY;
  int? coordinatePos;

  factory PosSpec.fromRawJson(String str) => PosSpec.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PosSpec.fromJson(Map<String, dynamic> json) => PosSpec(
        axisX: json["axis_x"]?.toDouble(),
        axisY: json["axis_y"]?.toDouble(),
        coordinatePos: json["coordinate_pos"],
      );

  Map<String, dynamic> toJson() => {
        "axis_x": axisX,
        "axis_y": axisY,
        "coordinate_pos": coordinatePos,
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

class LayerConfig {
  LayerConfig({
    this.isCritical,
    this.tags,
  });

  bool? isCritical;
  Tags? tags;

  factory LayerConfig.fromRawJson(String str) =>
      LayerConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LayerConfig.fromJson(Map<String, dynamic> json) => LayerConfig(
        isCritical: json["is_critical"],
        tags: json["tags"] == null ? null : Tags.fromJson(json["tags"]),
      );

  Map<String, dynamic> toJson() => {
        "is_critical": isCritical,
        "tags": tags?.toJson(),
      };
}

class Tags {
  Tags({
    this.avatarLayer,
    this.generalCfg,
    this.iconLayer,
    this.pendentLayer,
  });

  Layer? avatarLayer;
  GeneralCfg? generalCfg;
  Layer? iconLayer;
  Layer? pendentLayer;

  factory Tags.fromRawJson(String str) => Tags.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tags.fromJson(Map<String, dynamic> json) => Tags(
        avatarLayer: json["AVATAR_LAYER"] == null
            ? null
            : Layer.fromJson(json["AVATAR_LAYER"]),
        generalCfg: json["GENERAL_CFG"] == null
            ? null
            : GeneralCfg.fromJson(json["GENERAL_CFG"]),
        iconLayer: json["ICON_LAYER"] == null
            ? null
            : Layer.fromJson(json["ICON_LAYER"]),
        pendentLayer: json["PENDENT_LAYER"] == null
            ? null
            : Layer.fromJson(json["PENDENT_LAYER"]),
      );

  Map<String, dynamic> toJson() => {
        "AVATAR_LAYER": avatarLayer?.toJson(),
        "GENERAL_CFG": generalCfg?.toJson(),
        "ICON_LAYER": iconLayer?.toJson(),
        "PENDENT_LAYER": pendentLayer?.toJson(),
      };
}

class Layer {
  Layer();

  factory Layer.fromRawJson(String str) => Layer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Layer.fromJson(Map<String, dynamic> json) => Layer();

  Map<String, dynamic> toJson() => {};
}

class GeneralCfg {
  GeneralCfg({
    this.configType,
    this.generalConfig,
  });

  int? configType;
  GeneralConfig? generalConfig;

  factory GeneralCfg.fromRawJson(String str) =>
      GeneralCfg.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GeneralCfg.fromJson(Map<String, dynamic> json) => GeneralCfg(
        configType: json["config_type"],
        generalConfig: json["general_config"] == null
            ? null
            : GeneralConfig.fromJson(json["general_config"]),
      );

  Map<String, dynamic> toJson() => {
        "config_type": configType,
        "general_config": generalConfig?.toJson(),
      };
}

class GeneralConfig {
  GeneralConfig({
    this.webCssStyle,
  });

  WebCssStyle? webCssStyle;

  factory GeneralConfig.fromRawJson(String str) =>
      GeneralConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GeneralConfig.fromJson(Map<String, dynamic> json) => GeneralConfig(
        webCssStyle: json["web_css_style"] == null
            ? null
            : WebCssStyle.fromJson(json["web_css_style"]),
      );

  Map<String, dynamic> toJson() => {
        "web_css_style": webCssStyle?.toJson(),
      };
}

class WebCssStyle {
  WebCssStyle({
    this.borderRadius,
    this.backgroundColor,
    this.border,
    this.boxSizing,
  });

  String? borderRadius;
  String? backgroundColor;
  String? border;
  String? boxSizing;

  factory WebCssStyle.fromRawJson(String str) =>
      WebCssStyle.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WebCssStyle.fromJson(Map<String, dynamic> json) => WebCssStyle(
        borderRadius: json["borderRadius"],
        backgroundColor: json["background-color"],
        border: json["border"],
        boxSizing: json["boxSizing"],
      );

  Map<String, dynamic> toJson() => {
        "borderRadius": borderRadius,
        "background-color": backgroundColor,
        "border": border,
        "boxSizing": boxSizing,
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
    this.placeholder,
    this.remote,
    this.srcType,
    this.local,
  });

  int? placeholder;
  Remote? remote;
  int? srcType;
  int? local;

  factory ImageSrc.fromRawJson(String str) =>
      ImageSrc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImageSrc.fromJson(Map<String, dynamic> json) => ImageSrc(
        placeholder: json["placeholder"],
        remote: json["remote"] == null ? null : Remote.fromJson(json["remote"]),
        srcType: json["src_type"],
        local: json["local"],
      );

  Map<String, dynamic> toJson() => {
        "placeholder": placeholder,
        "remote": remote?.toJson(),
        "src_type": srcType,
        "local": local,
      };
}

class Remote {
  Remote({
    this.bfsStyle,
    this.url,
  });

  String? bfsStyle;
  String? url;

  factory Remote.fromRawJson(String str) => Remote.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Remote.fromJson(Map<String, dynamic> json) => Remote(
        bfsStyle: json["bfs_style"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "bfs_style": bfsStyle,
        "url": url,
      };
}

class AvatarLayer {
  AvatarLayer({
    this.isCriticalGroup,
    this.layers,
  });

  bool? isCriticalGroup;
  List<LayerLayer>? layers;

  factory AvatarLayer.fromRawJson(String str) =>
      AvatarLayer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AvatarLayer.fromJson(Map<String, dynamic> json) => AvatarLayer(
        isCriticalGroup: json["is_critical_group"],
        layers: json["layers"] == null
            ? []
            : List<LayerLayer>.from(
                json["layers"]!.map((x) => LayerLayer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "is_critical_group": isCriticalGroup,
        "layers": layers == null
            ? []
            : List<dynamic>.from(layers!.map((x) => x.toJson())),
      };
}

class LayerLayer {
  LayerLayer({
    this.generalSpec,
    this.layerConfig,
    this.resource,
    this.visible,
  });

  GeneralSpec? generalSpec;
  LayerConfig? layerConfig;
  Resource? resource;
  bool? visible;

  factory LayerLayer.fromRawJson(String str) =>
      LayerLayer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LayerLayer.fromJson(Map<String, dynamic> json) => LayerLayer(
        generalSpec: json["general_spec"] == null
            ? null
            : GeneralSpec.fromJson(json["general_spec"]),
        layerConfig: json["layer_config"] == null
            ? null
            : LayerConfig.fromJson(json["layer_config"]),
        resource: json["resource"] == null
            ? null
            : Resource.fromJson(json["resource"]),
        visible: json["visible"],
      );

  Map<String, dynamic> toJson() => {
        "general_spec": generalSpec?.toJson(),
        "layer_config": layerConfig?.toJson(),
        "resource": resource?.toJson(),
        "visible": visible,
      };
}

class Resource {
  Resource({
    this.resImage,
    this.resType,
    this.resAnimation,
  });

  ResImage? resImage;
  int? resType;
  ResAnimation? resAnimation;

  factory Resource.fromRawJson(String str) =>
      Resource.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
        resImage: json["res_image"] == null
            ? null
            : ResImage.fromJson(json["res_image"]),
        resType: json["res_type"],
        resAnimation: json["res_animation"] == null
            ? null
            : ResAnimation.fromJson(json["res_animation"]),
      );

  Map<String, dynamic> toJson() => {
        "res_image": resImage?.toJson(),
        "res_type": resType,
        "res_animation": resAnimation?.toJson(),
      };
}

class ResAnimation {
  ResAnimation({
    this.webpSrc,
  });

  WebpSrc? webpSrc;

  factory ResAnimation.fromRawJson(String str) =>
      ResAnimation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResAnimation.fromJson(Map<String, dynamic> json) => ResAnimation(
        webpSrc: json["webp_src"] == null
            ? null
            : WebpSrc.fromJson(json["webp_src"]),
      );

  Map<String, dynamic> toJson() => {
        "webp_src": webpSrc?.toJson(),
      };
}

class WebpSrc {
  WebpSrc({
    this.remote,
    this.srcType,
  });

  Remote? remote;
  int? srcType;

  factory WebpSrc.fromRawJson(String str) => WebpSrc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WebpSrc.fromJson(Map<String, dynamic> json) => WebpSrc(
        remote: json["remote"] == null ? null : Remote.fromJson(json["remote"]),
        srcType: json["src_type"],
      );

  Map<String, dynamic> toJson() => {
        "remote": remote?.toJson(),
        "src_type": srcType,
      };
}

class Decorate {
  Decorate({
    this.cardUrl,
    this.fan,
    this.id,
    this.jumpUrl,
    this.name,
    this.type,
  });

  String? cardUrl;
  Fan? fan;
  int? id;
  String? jumpUrl;
  String? name;
  int? type;

  factory Decorate.fromRawJson(String str) =>
      Decorate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Decorate.fromJson(Map<String, dynamic> json) => Decorate(
        cardUrl: json["card_url"],
        fan: json["fan"] == null ? null : Fan.fromJson(json["fan"]),
        id: json["id"],
        jumpUrl: json["jump_url"],
        name: json["name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "card_url": cardUrl,
        "fan": fan?.toJson(),
        "id": id,
        "jump_url": jumpUrl,
        "name": name,
        "type": type,
      };
}

class Fan {
  Fan({
    this.color,
    this.isFan,
    this.numStr,
    this.number,
  });

  String? color;
  bool? isFan;
  String? numStr;
  int? number;

  factory Fan.fromRawJson(String str) => Fan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Fan.fromJson(Map<String, dynamic> json) => Fan(
        color: json["color"],
        isFan: json["is_fan"],
        numStr: json["num_str"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "color": color,
        "is_fan": isFan,
        "num_str": numStr,
        "number": number,
      };
}

class Vip {
  Vip({
    this.avatarSubscript,
    this.avatarSubscriptUrl,
    this.dueDate,
    this.label,
    this.nicknameColor,
    this.status,
    this.themeType,
    this.type,
  });

  int? avatarSubscript;
  String? avatarSubscriptUrl;
  int? dueDate;
  Label? label;
  String? nicknameColor;
  int? status;
  int? themeType;
  int? type;

  factory Vip.fromRawJson(String str) => Vip.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Vip.fromJson(Map<String, dynamic> json) => Vip(
        avatarSubscript: json["avatar_subscript"],
        avatarSubscriptUrl: json["avatar_subscript_url"],
        dueDate: json["due_date"],
        label: json["label"] == null ? null : Label.fromJson(json["label"]),
        nicknameColor: json["nickname_color"],
        status: json["status"],
        themeType: json["theme_type"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "avatar_subscript": avatarSubscript,
        "avatar_subscript_url": avatarSubscriptUrl,
        "due_date": dueDate,
        "label": label?.toJson(),
        "nickname_color": nicknameColor,
        "status": status,
        "theme_type": themeType,
        "type": type,
      };
}

class Label {
  Label({
    this.bgColor,
    this.bgStyle,
    this.borderColor,
    this.imgLabelUriHans,
    this.imgLabelUriHansStatic,
    this.imgLabelUriHant,
    this.imgLabelUriHantStatic,
    this.labelTheme,
    this.path,
    this.text,
    this.textColor,
    this.useImgLabel,
  });

  String? bgColor;
  int? bgStyle;
  String? borderColor;
  String? imgLabelUriHans;
  String? imgLabelUriHansStatic;
  String? imgLabelUriHant;
  String? imgLabelUriHantStatic;
  String? labelTheme;
  String? path;
  String? text;
  String? textColor;
  bool? useImgLabel;

  factory Label.fromRawJson(String str) => Label.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Label.fromJson(Map<String, dynamic> json) => Label(
        bgColor: json["bg_color"],
        bgStyle: json["bg_style"],
        borderColor: json["border_color"],
        imgLabelUriHans: json["img_label_uri_hans"],
        imgLabelUriHansStatic: json["img_label_uri_hans_static"],
        imgLabelUriHant: json["img_label_uri_hant"],
        imgLabelUriHantStatic: json["img_label_uri_hant_static"],
        labelTheme: json["label_theme"],
        path: json["path"],
        text: json["text"],
        textColor: json["text_color"],
        useImgLabel: json["use_img_label"],
      );

  Map<String, dynamic> toJson() => {
        "bg_color": bgColor,
        "bg_style": bgStyle,
        "border_color": borderColor,
        "img_label_uri_hans": imgLabelUriHans,
        "img_label_uri_hans_static": imgLabelUriHansStatic,
        "img_label_uri_hant": imgLabelUriHant,
        "img_label_uri_hant_static": imgLabelUriHantStatic,
        "label_theme": labelTheme,
        "path": path,
        "text": text,
        "text_color": textColor,
        "use_img_label": useImgLabel,
      };
}

class ModuleDynamic {
  ModuleDynamic({
    this.additional,
    this.desc,
    this.major,
    this.topic,
  });

  Additional? additional;
  Desc? desc;
  Major? major;
  Topic? topic;

  factory ModuleDynamic.fromRawJson(String str) =>
      ModuleDynamic.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModuleDynamic.fromJson(Map<String, dynamic> json) => ModuleDynamic(
        additional: json["additional"] == null
            ? null
            : Additional.fromJson(json["additional"]),
        desc: json["desc"] == null ? null : Desc.fromJson(json["desc"]),
        major: json["major"] == null ? null : Major.fromJson(json["major"]),
        topic: json["topic"] == null ? null : Topic.fromJson(json["topic"]),
      );

  Map<String, dynamic> toJson() => {
        "additional": additional?.toJson(),
        "desc": desc?.toJson(),
        "major": major?.toJson(),
        "topic": topic?.toJson(),
      };
}

class Additional {
  Additional({
    this.common,
    this.type,
  });

  Common? common;
  String? type;

  factory Additional.fromRawJson(String str) =>
      Additional.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Additional.fromJson(Map<String, dynamic> json) => Additional(
        common: json["common"] == null ? null : Common.fromJson(json["common"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "common": common?.toJson(),
        "type": type,
      };
}

class Common {
  Common({
    this.button,
    this.cover,
    this.desc1,
    this.desc2,
    this.headText,
    this.idStr,
    this.jumpUrl,
    this.style,
    this.subType,
    this.title,
  });

  Button? button;
  String? cover;
  String? desc1;
  String? desc2;
  String? headText;
  String? idStr;
  String? jumpUrl;
  int? style;
  String? subType;
  String? title;

  factory Common.fromRawJson(String str) => Common.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Common.fromJson(Map<String, dynamic> json) => Common(
        button: json["button"] == null ? null : Button.fromJson(json["button"]),
        cover: json["cover"],
        desc1: json["desc1"],
        desc2: json["desc2"],
        headText: json["head_text"],
        idStr: json["id_str"],
        jumpUrl: json["jump_url"],
        style: json["style"],
        subType: json["sub_type"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "button": button?.toJson(),
        "cover": cover,
        "desc1": desc1,
        "desc2": desc2,
        "head_text": headText,
        "id_str": idStr,
        "jump_url": jumpUrl,
        "style": style,
        "sub_type": subType,
        "title": title,
      };
}

class Button {
  Button({
    this.jumpStyle,
    this.jumpUrl,
    this.type,
  });

  JumpStyle? jumpStyle;
  String? jumpUrl;
  int? type;

  factory Button.fromRawJson(String str) => Button.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Button.fromJson(Map<String, dynamic> json) => Button(
        jumpStyle: json["jump_style"] == null
            ? null
            : JumpStyle.fromJson(json["jump_style"]),
        jumpUrl: json["jump_url"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "jump_style": jumpStyle?.toJson(),
        "jump_url": jumpUrl,
        "type": type,
      };
}

class JumpStyle {
  JumpStyle({
    this.iconUrl,
    this.text,
  });

  String? iconUrl;
  String? text;

  factory JumpStyle.fromRawJson(String str) =>
      JumpStyle.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JumpStyle.fromJson(Map<String, dynamic> json) => JumpStyle(
        iconUrl: json["icon_url"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "icon_url": iconUrl,
        "text": text,
      };
}

class Desc {
  Desc({
    this.richTextNodes,
    this.text,
  });

  List<RichTextNode>? richTextNodes;
  String? text;

  factory Desc.fromRawJson(String str) => Desc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Desc.fromJson(Map<String, dynamic> json) => Desc(
        richTextNodes: json["rich_text_nodes"] == null
            ? []
            : List<RichTextNode>.from(
                json["rich_text_nodes"]!.map((x) => RichTextNode.fromJson(x))),
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "rich_text_nodes": richTextNodes == null
            ? []
            : List<dynamic>.from(richTextNodes!.map((x) => x.toJson())),
        "text": text,
      };
}

class Stat {
  Stat({
    this.danmaku,
    this.play,
  });

  String? danmaku;
  String? play;

  factory Stat.fromRawJson(String str) => Stat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        danmaku: json["danmaku"],
        play: json["play"],
      );

  Map<String, dynamic> toJson() => {
        "danmaku": danmaku,
        "play": play,
      };
}

class RichTextNode {
  RichTextNode({
    this.jumpUrl,
    this.origText,
    this.text,
    this.type,
    this.emoji,
    this.rid,
  });

  String? jumpUrl;
  String? origText;
  String? text;
  String? type;
  Emoji? emoji;
  String? rid;

  factory RichTextNode.fromRawJson(String str) =>
      RichTextNode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RichTextNode.fromJson(Map<String, dynamic> json) => RichTextNode(
        jumpUrl: json["jump_url"],
        origText: json["orig_text"],
        text: json["text"],
        type: json["type"],
        emoji: json["emoji"] == null ? null : Emoji.fromJson(json["emoji"]),
        rid: json["rid"],
      );

  Map<String, dynamic> toJson() => {
        "jump_url": jumpUrl,
        "orig_text": origText,
        "text": text,
        "type": type,
        "emoji": emoji?.toJson(),
        "rid": rid,
      };
}

class Emoji {
  Emoji({
    this.iconUrl,
    this.size,
    this.text,
    this.type,
  });

  String? iconUrl;
  int? size;
  String? text;
  int? type;

  factory Emoji.fromRawJson(String str) => Emoji.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Emoji.fromJson(Map<String, dynamic> json) => Emoji(
        iconUrl: json["icon_url"],
        size: json["size"],
        text: json["text"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "icon_url": iconUrl,
        "size": size,
        "text": text,
        "type": type,
      };
}

class Major {
  Major({this.liveRcmd, this.type, this.archive, this.draw, this.opus});

  LiveRcmd? liveRcmd;
  String? type;
  Archive? archive;
  Draw? draw;
  Opus? opus;

  factory Major.fromRawJson(String str) => Major.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Major.fromJson(Map<String, dynamic> json) => Major(
        liveRcmd: json["live_rcmd"] == null
            ? null
            : LiveRcmd.fromJson(json["live_rcmd"]),
        type: json["type"],
        archive:
            json["archive"] == null ? null : Archive.fromJson(json["archive"]),
        draw: json["draw"] == null ? null : Draw.fromJson(json["draw"]),
        opus: json["opus"] == null ? null : Opus.fromJson(json["opus"]),
      );

  Map<String, dynamic> toJson() => {
        "opus": opus?.toJson(),
        "live_rcmd": liveRcmd?.toJson(),
        "type": type,
        "archive": archive?.toJson(),
        "draw": draw?.toJson(),
      };
}

class Opus {
  Opus({
    this.jumpUrl,
    this.pics,
    this.summary,
    this.title,
  });

  String? jumpUrl;
  List<Pic>? pics;
  Summary? summary;
  String? title;

  factory Opus.fromRawJson(String str) => Opus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Opus.fromJson(Map<String, dynamic> json) => Opus(
        jumpUrl: json["jump_url"] ?? '',
        pics: json["pics"] == null
            ? []
            : List<Pic>.from(json["pics"]!.map((x) => Pic.fromJson(x))),
        summary:
            json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        title: json["title"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "jump_url": jumpUrl,
        "pics": pics == null
            ? []
            : List<dynamic>.from(pics!.map((x) => x.toJson())),
        "summary": summary?.toJson(),
        "title": title,
      };
}

class Pic {
  Pic({
    this.height,
    this.size,
    this.url,
    this.width,
  });

  int? height;
  double? size;
  String? url;
  int? width;

  factory Pic.fromRawJson(String str) => Pic.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pic.fromJson(Map<String, dynamic> json) => Pic(
        height: json["height"],
        size: json["size"]?.toDouble(),
        url: json["url"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "size": size,
        "url": url,
        "width": width,
      };
}

class Summary {
  Summary({
    this.richTextNodes,
    this.text,
  });

  List<RichTextNode>? richTextNodes;
  String? text;

  factory Summary.fromRawJson(String str) => Summary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        richTextNodes: json["rich_text_nodes"] == null
            ? []
            : List<RichTextNode>.from(
                json["rich_text_nodes"]!.map((x) => RichTextNode.fromJson(x))),
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "rich_text_nodes": richTextNodes == null
            ? []
            : List<dynamic>.from(richTextNodes!.map((x) => x.toJson())),
        "text": text,
      };
}

class Archive {
  Archive({
    this.aid,
    this.badge,
    this.bvid,
    this.cover,
    this.desc,
    this.disablePreview,
    this.durationText,
    this.jumpUrl,
    this.stat,
    this.title,
    this.type,
  });

  String? aid;
  Badge? badge;
  String? bvid;
  String? cover;
  String? desc;
  int? disablePreview;
  String? durationText;
  String? jumpUrl;
  Stat? stat;
  String? title;
  int? type;

  factory Archive.fromRawJson(String str) => Archive.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Archive.fromJson(Map<String, dynamic> json) => Archive(
        aid: json["aid"],
        badge: json["badge"] == null ? null : Badge.fromJson(json["badge"]),
        bvid: json["bvid"],
        cover: json["cover"],
        desc: json["desc"],
        disablePreview: json["disable_preview"],
        durationText: json["duration_text"],
        jumpUrl: json["jump_url"],
        stat: json["stat"] == null ? null : Stat.fromJson(json["stat"]),
        title: json["title"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "aid": aid,
        "badge": badge?.toJson(),
        "bvid": bvid,
        "cover": cover,
        "desc": desc,
        "disable_preview": disablePreview,
        "duration_text": durationText,
        "jump_url": jumpUrl,
        "stat": stat?.toJson(),
        "title": title,
        "type": type,
      };
}

class Badge {
  Badge({
    this.bgColor,
    this.color,
    this.text,
  });

  String? bgColor;
  String? color;
  String? text;

  factory Badge.fromRawJson(String str) => Badge.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
        bgColor: json["bg_color"],
        color: json["color"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "bg_color": bgColor,
        "color": color,
        "text": text,
      };
}

class Draw {
  Draw({
    this.id,
    this.items,
  });

  int? id;
  List<DrawItem>? items;

  factory Draw.fromRawJson(String str) => Draw.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Draw.fromJson(Map<String, dynamic> json) => Draw(
        id: json["id"],
        items: json["items"] == null
            ? []
            : List<DrawItem>.from(
                json["items"]!.map((x) => DrawItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class DrawItem {
  DrawItem({
    this.height,
    this.size,
    this.src,
    this.tags,
    this.width,
  });

  int? height;
  double? size;
  String? src;
  List<dynamic>? tags;
  int? width;

  factory DrawItem.fromRawJson(String str) =>
      DrawItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DrawItem.fromJson(Map<String, dynamic> json) => DrawItem(
        height: json["height"],
        size: json["size"]?.toDouble(),
        src: json["src"],
        tags: json["tags"] == null
            ? []
            : List<dynamic>.from(json["tags"]!.map((x) => x)),
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "size": size,
        "src": src,
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "width": width,
      };
}

class LiveRcmd {
  LiveRcmd({
    this.content,
    this.reserveType,
  });

  String? content;
  int? reserveType;

  factory LiveRcmd.fromRawJson(String str) =>
      LiveRcmd.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LiveRcmd.fromJson(Map<String, dynamic> json) => LiveRcmd(
        content: json["content"],
        reserveType: json["reserve_type"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "reserve_type": reserveType,
      };
}

class Topic {
  Topic({
    this.id,
    this.jumpUrl,
    this.name,
  });

  int? id;
  String? jumpUrl;
  String? name;

  factory Topic.fromRawJson(String str) => Topic.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json["id"],
        jumpUrl: json["jump_url"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jump_url": jumpUrl,
        "name": name,
      };
}

class ModuleInteraction {
  ModuleInteraction({
    this.items,
  });

  List<ModuleInteractionItem>? items;

  factory ModuleInteraction.fromRawJson(String str) =>
      ModuleInteraction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModuleInteraction.fromJson(Map<String, dynamic> json) =>
      ModuleInteraction(
        items: json["items"] == null
            ? []
            : List<ModuleInteractionItem>.from(
                json["items"]!.map((x) => ModuleInteractionItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class ModuleInteractionItem {
  ModuleInteractionItem({
    this.desc,
    this.type,
  });

  Desc? desc;
  int? type;

  factory ModuleInteractionItem.fromRawJson(String str) =>
      ModuleInteractionItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModuleInteractionItem.fromJson(Map<String, dynamic> json) =>
      ModuleInteractionItem(
        desc: json["desc"] == null ? null : Desc.fromJson(json["desc"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc?.toJson(),
        "type": type,
      };
}

class ModuleMore {
  ModuleMore({
    this.threePointItems,
  });

  List<ThreePointItem>? threePointItems;

  factory ModuleMore.fromRawJson(String str) =>
      ModuleMore.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModuleMore.fromJson(Map<String, dynamic> json) => ModuleMore(
        threePointItems: json["three_point_items"] == null
            ? []
            : List<ThreePointItem>.from(json["three_point_items"]!
                .map((x) => ThreePointItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "three_point_items": threePointItems == null
            ? []
            : List<dynamic>.from(threePointItems!.map((x) => x.toJson())),
      };
}

class ThreePointItem {
  ThreePointItem({
    this.label,
    this.type,
  });

  String? label;
  String? type;

  factory ThreePointItem.fromRawJson(String str) =>
      ThreePointItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ThreePointItem.fromJson(Map<String, dynamic> json) => ThreePointItem(
        label: json["label"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "type": type,
      };
}

class ModuleStat {
  ModuleStat({
    this.comment,
    this.forward,
    this.like,
  });

  Comment? comment;
  Forward? forward;
  Like? like;

  factory ModuleStat.fromRawJson(String str) =>
      ModuleStat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModuleStat.fromJson(Map<String, dynamic> json) => ModuleStat(
        comment:
            json["comment"] == null ? null : Comment.fromJson(json["comment"]),
        forward:
            json["forward"] == null ? null : Forward.fromJson(json["forward"]),
        like: json["like"] == null ? null : Like.fromJson(json["like"]),
      );

  Map<String, dynamic> toJson() => {
        "comment": comment?.toJson(),
        "forward": forward?.toJson(),
        "like": like?.toJson(),
      };
}

class Comment {
  Comment({
    this.count,
    this.forbidden,
    this.hidden,
  });

  int? count;
  bool? forbidden;
  bool? hidden;

  factory Comment.fromRawJson(String str) => Comment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        count: json["count"],
        forbidden: json["forbidden"],
        hidden: json["hidden"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "forbidden": forbidden,
        "hidden": hidden,
      };
}

class Forward {
  Forward({
    this.count,
    this.forbidden,
  });

  int? count;
  bool? forbidden;

  factory Forward.fromRawJson(String str) => Forward.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Forward.fromJson(Map<String, dynamic> json) => Forward(
        count: json["count"],
        forbidden: json["forbidden"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "forbidden": forbidden,
      };
}

class Like {
  Like({
    this.count,
    this.forbidden,
    this.status,
  });

  int? count;
  bool? forbidden;
  bool? status;

  factory Like.fromRawJson(String str) => Like.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Like.fromJson(Map<String, dynamic> json) => Like(
        count: json["count"],
        forbidden: json["forbidden"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "forbidden": forbidden,
        "status": status,
      };
}

class Orig {
  Orig({
    this.basic,
    this.idStr,
    this.modules,
    this.type,
    this.visible,
  });

  Basic? basic;
  String? idStr;
  OrigModules? modules;
  String? type;
  bool? visible;

  factory Orig.fromRawJson(String str) => Orig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Orig.fromJson(Map<String, dynamic> json) => Orig(
        basic: json["basic"] == null ? null : Basic.fromJson(json["basic"]),
        idStr: json["id_str"],
        modules: json["modules"] == null
            ? null
            : OrigModules.fromJson(json["modules"]),
        type: json["type"],
        visible: json["visible"],
      );

  Map<String, dynamic> toJson() => {
        "basic": basic?.toJson(),
        "id_str": idStr,
        "modules": modules?.toJson(),
        "type": type,
        "visible": visible,
      };
}

class OrigModules {
  OrigModules({
    this.moduleAuthor,
    this.moduleDynamic,
  });

  ModuleAuthor? moduleAuthor;
  ModuleDynamic? moduleDynamic;

  factory OrigModules.fromRawJson(String str) =>
      OrigModules.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrigModules.fromJson(Map<String, dynamic> json) => OrigModules(
        moduleAuthor: json["module_author"] == null
            ? null
            : ModuleAuthor.fromJson(json["module_author"]),
        moduleDynamic: json["module_dynamic"] == null
            ? null
            : ModuleDynamic.fromJson(json["module_dynamic"]),
      );

  Map<String, dynamic> toJson() => {
        "module_author": moduleAuthor?.toJson(),
        "module_dynamic": moduleDynamic?.toJson(),
      };
}
