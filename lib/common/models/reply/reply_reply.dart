import 'package:dart_json_mapper/dart_json_mapper.dart';

import 'reply_item.dart';

@jsonSerializable
@Json(valueDecorators: ReplyReplyModel.valueDecorators)
class ReplyReplyModel {
  static Map<Type, ValueDecoratorFunction> valueDecorators() => {
        typeOf<List<ReplyItemModel>>(): (value) => value.cast<ReplyItemModel>(),
      };
  ReplyReplyModel({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  @JsonProperty(defaultValue: 0)
  final int code;
  @JsonProperty(defaultValue: '')
  final String message;
  @JsonProperty(defaultValue: 0)
  final int ttl;
  @JsonProperty(defaultValue: {})
  final Data data;
}

@jsonSerializable
class Data {
  Data({
    required this.config,
    required this.control,
    required this.page,
    required this.replies,
    required this.root,
    required this.showBvid,
    required this.showText,
    required this.showType,
    required this.upper,
  });
  @JsonProperty(defaultValue: {})
  final Config config;
  @JsonProperty(defaultValue: {})
  final Control control;
  @JsonProperty(defaultValue: {})
  final Page page;
  @JsonProperty(defaultValue: [])
  final List<ReplyItemModel> replies;
  @JsonProperty(defaultValue: {})
  final ReplyItemModel root;
  @JsonProperty(name: "show_bvid", defaultValue: false)
  final bool showBvid;
  @JsonProperty(name: "show_text", defaultValue: '')
  final String showText;
  @JsonProperty(name: "show_type", defaultValue: 0)
  final int showType;
  @JsonProperty(defaultValue: {})
  final Upper upper;
}

@jsonSerializable
class Upper {
  Upper({
    required this.mid,
  });

  @JsonProperty(defaultValue: 0)
  final int mid;
}

@jsonSerializable
class Config {
  Config({
    required this.showadmin,
    required this.showentry,
    required this.showfloor,
    required this.showtopic,
    required this.showUpFlag,
    required this.readOnly,
    required this.showDelLog,
  });

  @JsonProperty(defaultValue: 0)
  final int showadmin;
  @JsonProperty(defaultValue: 0)
  final int showentry;
  @JsonProperty(defaultValue: 0)
  final int showfloor;
  @JsonProperty(defaultValue: 0)
  final int showtopic;
  @JsonProperty(name: 'show_up_flag', defaultValue: false)
  final bool showUpFlag;
  @JsonProperty(name: 'read_only', defaultValue: false)
  final bool readOnly;
  @JsonProperty(name: 'show_del_log', defaultValue: false)
  final bool showDelLog;
}

@jsonSerializable
class Control {
  Control({
    required this.inputDisable,
    required this.rootInputText,
    required this.childInputText,
    required this.giveupInputText,
    required this.bgText,
    required this.webSelection,
    required this.answerGuideText,
    required this.answerGuideIconUrl,
    required this.answerGuideIosUrl,
    required this.answerGuideAndroidUrl,
    required this.showType,
    required this.showText,
    required this.disableJumpEmote,
  });

  @JsonProperty(name: 'input_disable', defaultValue: false)
  final bool inputDisable;
  @JsonProperty(name: 'root_input_text', defaultValue: '')
  final String rootInputText;
  @JsonProperty(name: 'child_input_text', defaultValue: '')
  final String childInputText;
  @JsonProperty(name: 'giveup_input_text', defaultValue: '')
  final String giveupInputText;
  @JsonProperty(name: 'bg_text', defaultValue: '')
  final String bgText;
  @JsonProperty(name: 'web_selection', defaultValue: false)
  final bool webSelection;
  @JsonProperty(name: 'answer_guide_text', defaultValue: '')
  final String answerGuideText;
  @JsonProperty(name: 'answer_guide_icon_url', defaultValue: '')
  final String answerGuideIconUrl;
  @JsonProperty(name: 'answer_guide_ios_url', defaultValue: '')
  final String answerGuideIosUrl;
  @JsonProperty(name: 'answer_guide_android_url', defaultValue: '')
  final String answerGuideAndroidUrl;
  @JsonProperty(name: 'show_type', defaultValue: 0)
  final int showType;
  @JsonProperty(name: 'show_text', defaultValue: '')
  final String showText;
  @JsonProperty(name: 'disable_jump_emote', defaultValue: false)
  final bool disableJumpEmote;
}

@jsonSerializable
class Page {
  Page({
    required this.count,
    required this.num,
    required this.size,
  });

  @JsonProperty(defaultValue: 0)
  final int count;
  @JsonProperty(defaultValue: 0)
  final int num;
  @JsonProperty(defaultValue: 0)
  final int size;
}
