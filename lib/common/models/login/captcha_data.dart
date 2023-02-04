import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class CaptchaDataModel {
  @JsonProperty(name: 'data/token', defaultValue: '')
  final String token;
  @JsonProperty(name: 'data/geetest/challenge', defaultValue: '')
  final String challenge;
  @JsonProperty(name: 'data/geetest/gt', defaultValue: '')
  final String gt;
  @JsonProperty(defaultValue: -1)
  final int code; //用来判断是否成功获取，0为成功
  @JsonProperty(defaultValue: "未知错误")
  final String message; //错误信息
  CaptchaDataModel(
      {required this.token,
      required this.challenge,
      required this.gt,
      required this.code,
      required this.message});
}
