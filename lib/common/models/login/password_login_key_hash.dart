import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class PasswordLoginKeyHashModel {
  @JsonProperty(defaultValue: -1)
  final int code;
  @JsonProperty(defaultValue: '未知错误')
  final String message;

  @JsonProperty(name: 'data/hash', defaultValue: '')
  final String hash;
  @JsonProperty(name: 'data/key', defaultValue: '')
  final String key;

  PasswordLoginKeyHashModel(
      {required this.code,
      required this.hash,
      required this.key,
      required this.message});
}
