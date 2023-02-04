import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class SmsLoginResultModel {
  @JsonProperty(defaultValue: -1)
  final int code; //返回码
// 0：成功
// -400：请求错误
// 1006：请输入正确的短信验证码
// 1007：短信验证码已过期

  @JsonProperty(defaultValue: "未知错误")
  final String message; //错误信息

  @JsonProperty(name: 'data/is_new', defaultValue: false)
  final bool isNew; //是否为新注册用户
  @JsonProperty(name: 'data/status', defaultValue: 0)
  final int status;

  SmsLoginResultModel({
    required this.code,
    required this.message,
    required this.isNew,
    required this.status,
  });
}
