import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(valueDecorators: HotWordsModel.valueDecorators)
class HotWordsModel {
  static Map<Type, ValueDecoratorFunction> valueDecorators() => {
        typeOf<List<HotWordItemModel>>(): (value) =>
            value.cast<HotWordItemModel>(),
      };
  HotWordsModel({
    required this.code,
    required this.message,
    required this.trackid,
    required this.list,
    required this.expStr,
  });
  @JsonProperty(defaultValue: 0)
  final int code;
  @JsonProperty(defaultValue: "未知错误")
  final String message;
  @JsonProperty(name: 'data/trackid', defaultValue: '')
  final String trackid;
  @JsonProperty(name: 'data/list', defaultValue: [])
  final List<HotWordItemModel> list;
  @JsonProperty(name: 'data/exp_str', defaultValue: '')
  final String expStr;
}

@jsonSerializable
class HotWordItemModel {
  HotWordItemModel({
    required this.position,
    required this.keyword,
    required this.showName,
    required this.wordType,
    required this.icon,
    required this.hotId,
  });
  @JsonProperty(defaultValue: 0)
  final int position;
  @JsonProperty(defaultValue: '')
  final String keyword;
  @JsonProperty(name: 'show_name', defaultValue: '')
  final String showName;
  @JsonProperty(name: 'word_type', defaultValue: 0)
  final int wordType;
  @JsonProperty(defaultValue: '')
  final String icon;
  @JsonProperty(defaultValue: 0)
  final int hotId;
}
