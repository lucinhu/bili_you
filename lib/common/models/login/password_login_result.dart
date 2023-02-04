import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class PasswordLoginResultModel {
  @JsonProperty(defaultValue: -1)
  final int code;
  @JsonProperty(defaultValue: "未知错误")
  final String message;
  @JsonProperty(name: 'data/status', defaultValue: 0)
  final int status;

  PasswordLoginResultModel(
      {required this.code, required this.message, required this.status});
}
