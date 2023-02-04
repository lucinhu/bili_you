import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';

import 'package:bili_you/common/utils/my_dio.dart';
import 'api_constants.dart';
import '../models/login/captcha_data.dart';
import '../models/login/captcha_result.dart';
import '../models/login/password_login_key_hash.dart';
import '../models/login/password_login_result.dart';
import '../models/login/sms_login_result.dart';
import '../models/login/sms_request_result.dart';

///b站登陆接口\
///设计原则：\
///1.不涉及任何UI控件\
///2.不处理错误\
///返回值设计原则(在model)：\
///1.不为空，都有默认值，且某项为空时只将该项设为默认值，其余项不影响\
///2.如果错误码默认值为-1，错误信息默认为"未知错误"，其余成员默认为""或0\
///使用注意：\
///1.请使用try-catch处理抛错，一般为网络错误
///2.其余错误请判断错误码(code)，配套有错误信息(message)
abstract class LoginApi {
  ///获取登陆需要的key和hash
  static Future<PasswordLoginKeyHashModel> getPasswordLoginKeyHash() async {
    Dio dio = MyDio.dio;
    var response = await dio.get(ApiConstants.passwordPublicKeyHash);
    return JsonMapper.deserialize<PasswordLoginKeyHashModel>(response.data)!;
  }

  ///获取人机测试所需要的数据
  static Future<CaptchaDataModel> getCaptchaData() async {
    var dio = MyDio.dio;
    var response = await dio
        .get(ApiConstants.captcha, queryParameters: {"source": "main_web"});
    return JsonMapper.deserialize<CaptchaDataModel>(response.data)!;
  }

  ///请求发送验证码信息到手机
  static Future<SmsRequestResultModel> requestSmsToPhone(int cid, int tel,
      String token, String challenge, String validate, String seccode) async {
    var dio = MyDio.dio;
    var response = await dio.post(ApiConstants.smsCode,
        data: {
          "cid": cid,
          "tel": tel,
          "source": "main_web",
          "token": token,
          "challenge": challenge,
          "validate": validate,
          "seccode": seccode
        },
        options: Options(contentType: Headers.formUrlEncodedContentType));
    return JsonMapper.deserialize<SmsRequestResultModel>(response.data)!;
  }

  ///短信登录
  static Future<SmsLoginResultModel> smsLogin(
      int cid, int tel, int code, String captchaKey) async {
    Dio dio = MyDio.dio;
    var response = await dio.post(ApiConstants.smsLogin,
        data: {
          "cid": cid,
          "tel": tel,
          "code": code,
          "source": "main_mini",
          "keep": 0,
          "captcha_key": captchaKey,
          "go_url": ApiConstants.bilibiliBase
        },
        options: Options(contentType: Headers.formUrlEncodedContentType));
    return JsonMapper.deserialize<SmsLoginResultModel>(response.data)!;
  }

  ///密码登陆
  static Future<PasswordLoginResultModel> postPasswordLoginInfo(
      CaptchaResultModel captchaResult,
      PasswordLoginKeyHashModel passwordLoginKeyHash,
      String username,
      String password) async {
    Dio dio = MyDio.dio;
    //加密密码
    dynamic publicKey = RSAKeyParser().parse(passwordLoginKeyHash.key);
    String passwordEncryptyed = Encrypter(RSA(publicKey: publicKey))
        .encrypt(passwordLoginKeyHash.hash + password)
        .base64;
    var response = await dio.post(ApiConstants.passwordLogin,
        data: {
          'username': username,
          'password': passwordEncryptyed,
          'keep': 0,
          'token': captchaResult.captchaData.token,
          'challenge': captchaResult.captchaData.challenge,
          'validate': captchaResult.validate,
          'seccode': captchaResult.seccode,
          'go_url': ApiConstants.bilibiliBase,
          'source': "main_web"
        },
        options: Options(headers: {
          'User-Agent': ApiConstants.userAgent,
          'Referer': ApiConstants.passwordLogin
        }, contentType: Headers.formUrlEncodedContentType));

    return JsonMapper.deserialize<PasswordLoginResultModel>(response.data)!;
  }
}
