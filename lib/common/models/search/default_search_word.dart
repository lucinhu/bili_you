import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class DefaultSearchWordModel {
  DefaultSearchWordModel({
    required this.code,
    required this.message,
    required this.seid,
    required this.id,
    required this.type,
    required this.showName,
    required this.name,
    required this.gotoType,
    required this.gotoValue,
    required this.url,
  });
  @JsonProperty(defaultValue: -1)
  final int code;
  @JsonProperty(defaultValue: '未知错误')
  final String message;
  @JsonProperty(name: 'data/seid', defaultValue: '')
  final String seid;
  @JsonProperty(name: 'data/id', defaultValue: 0)
  final num id;
  @JsonProperty(name: 'data/type', defaultValue: 0)
  final int type;
  @JsonProperty(name: 'data/show_name', defaultValue: '')
  final String showName;
  @JsonProperty(name: 'data/name', defaultValue: '')
  final String name;
  @JsonProperty(name: 'data/goto_type', defaultValue: 0)
  final int gotoType;
  @JsonProperty(name: 'data/goto_value', defaultValue: '')
  final String gotoValue;
  @JsonProperty(name: 'data/url', defaultValue: '')
  final String url;
}
