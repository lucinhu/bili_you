import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class SmsRequestResultModel {
  @JsonProperty(defaultValue: -1)
  final int code;
  @JsonProperty(defaultValue: "未知错误")
  final String message;
  @JsonProperty(name: 'data/captcha_key', defaultValue: '')
  final String captchaKey;
  SmsRequestResultModel({
    required this.code,
    required this.message,
    required this.captchaKey,
  });
}
