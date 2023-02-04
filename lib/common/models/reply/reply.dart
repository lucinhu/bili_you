import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'reply_item.dart';

@jsonSerializable
@Json(valueDecorators: ReplyModel.valueDecorators)
class ReplyModel {
  static Map<Type, ValueDecoratorFunction> valueDecorators() => {
        typeOf<List<ReplyItemModel>>(): (value) => value.cast<ReplyItemModel>(),
      };

  ReplyModel({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  @JsonProperty(defaultValue: 0)
  final int code;
  @JsonProperty(defaultValue: "")
  final String message;
  @JsonProperty(defaultValue: 0)
  final int ttl;
  @JsonProperty(defaultValue: {})
  final ReplyDataModel data;
}

@jsonSerializable
class ReplyDataModel {
  ReplyDataModel({
    required this.page,
    required this.config,
    required this.replies,
    required this.topReplies,
    required this.upper,
    required this.top,
    required this.vote,
    required this.blacklist,
    required this.assist,
    required this.mode,
    required this.supportMode,
    required this.control,
    required this.folder,
  });

  @JsonProperty(defaultValue: {})
  final ReplyPageModel page;
  @JsonProperty(defaultValue: {})
  final ReplyConfigModel config;

  ///置顶的评论
  @JsonProperty(name: 'top_replies', defaultValue: [])
  final List<ReplyItemModel> topReplies;

  @JsonProperty(defaultValue: [])
  final List<ReplyItemModel> replies;
  @JsonProperty(defaultValue: {})
  final ReplyUpperModel upper;
  final dynamic top;
  @JsonProperty(defaultValue: 0)
  final int vote;
  @JsonProperty(defaultValue: 0)
  final int blacklist;
  @JsonProperty(defaultValue: 0)
  final int assist;
  @JsonProperty(defaultValue: 0)
  final int mode;
  @JsonProperty(defaultValue: [])
  final List<int> supportMode;
  @JsonProperty(defaultValue: {})
  final ReplyControlModel control;
  @JsonProperty(defaultValue: {})
  final Folder folder;
}

@jsonSerializable
class ReplyConfigModel {
  ReplyConfigModel({
    required this.showtopic,
    required this.showUpFlag,
    required this.readOnly,
  });

  @JsonProperty(defaultValue: 0)
  final int showtopic;
  @JsonProperty(defaultValue: false)
  final bool showUpFlag;
  @JsonProperty(defaultValue: false)
  final bool readOnly;
}

@jsonSerializable
class ReplyControlModel {
  ReplyControlModel({
    required this.inputDisable,
    required this.rootInputText,
    required this.childInputText,
    required this.giveupInputText,
    required this.screenshotIconState,
    required this.uploadPictureIconState,
    required this.answerGuideText,
    required this.answerGuideIconUrl,
    required this.answerGuideIosUrl,
    required this.answerGuideAndroidUrl,
    required this.bgText,
    required this.showType,
    required this.showText,
    required this.webSelection,
    required this.disableJumpEmote,
  });

  @JsonProperty(defaultValue: false)
  final bool inputDisable;
  @JsonProperty(defaultValue: "")
  final String rootInputText;
  @JsonProperty(defaultValue: "")
  final String childInputText;
  @JsonProperty(defaultValue: "")
  final String giveupInputText;
  @JsonProperty(defaultValue: 0)
  final int screenshotIconState;
  @JsonProperty(defaultValue: 0)
  final int uploadPictureIconState;
  @JsonProperty(defaultValue: "")
  final String answerGuideText;
  @JsonProperty(defaultValue: "")
  final String answerGuideIconUrl;
  @JsonProperty(defaultValue: "")
  final String answerGuideIosUrl;
  @JsonProperty(defaultValue: "")
  final String answerGuideAndroidUrl;
  @JsonProperty(defaultValue: "")
  final String bgText;
  @JsonProperty(defaultValue: 0)
  final int showType;
  @JsonProperty(defaultValue: "")
  final String showText;
  @JsonProperty(defaultValue: false)
  final bool webSelection;
  @JsonProperty(defaultValue: false)
  final bool disableJumpEmote;
}

@jsonSerializable
class ReplyPageModel {
  ReplyPageModel({
    required this.num,
    required this.size,
    required this.count,
    required this.acount,
  });

  @JsonProperty(defaultValue: 0)
  final int num;
  @JsonProperty(defaultValue: 0)
  final int size;
  @JsonProperty(defaultValue: 0)
  final int count;
  @JsonProperty(defaultValue: 0)
  final int acount;
}

@jsonSerializable
class ReplyUpperModel {
  ReplyUpperModel({
    required this.mid,
    required this.top,
    required this.vote,
  });

  @JsonProperty(defaultValue: 0)
  final int mid;
  @JsonProperty(defaultValue: {})
  final ReplyItemModel top;
  final dynamic vote;
}
