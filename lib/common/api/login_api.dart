import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';

import 'package:bili_you/common/utils/my_dio.dart';
import 'api_constants.dart';
import '../models/network/login/captcha_data.dart';
import '../models/network/login/captcha_result.dart';
import '../models/network/login/password_login_key_hash.dart';
import '../models/network/login/password_login_result.dart';
import '../models/network/login/post_sms_login.dart';
import '../models/network/login/post_sms_require.dart';

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
  static Future<PasswordLoginKeyHashResponse>
      requestPasswordLoginKeyHash() async {
    Dio dio = MyDio.dio;
    var response = await dio.get(ApiConstants.passwordPublicKeyHash);
    return PasswordLoginKeyHashResponse.fromJson(response.data);
  }

  ///获取人机测试所需要的数据
  static Future<CaptchaDataResponse> requestCaptchaData() async {
    var dio = MyDio.dio;
    var response = await dio
        .get(ApiConstants.captcha, queryParameters: {"source": "main_web"});
    return CaptchaDataResponse.fromJson(response.data);
  }

  ///请求发送验证码信息到手机
  static Future<PostSmsRequireResponse> postSendSmsToPhone(int cid, int tel,
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
    return PostSmsRequireResponse.fromJson(response.data);
  }

  ///短信登录
  static Future<PostSmsLoginResponse> smsLogin(
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
    return PostSmsLoginResponse.fromJson(response.data);
  }

  ///密码登陆
  static Future<PostPasswordLoginResponse> postPasswordLoginInfo(
      CaptchaResultModel captchaResult,
      PasswordLoginKeyHashResponse passwordLoginKeyHash,
      String username,
      String password) async {
    Dio dio = MyDio.dio;
    //先获取cookie
    await dio.get(ApiConstants.bilibiliBase);
    //加密密码
    dynamic publicKey = RSAKeyParser().parse(passwordLoginKeyHash.data!.key!);
    String passwordEncryptyed = Encrypter(RSA(publicKey: publicKey))
        .encrypt(passwordLoginKeyHash.data!.hash! + password)
        .base64;
    var response = await dio.post(ApiConstants.passwordLogin,
        data: {
          'username': username,
          'password': passwordEncryptyed,
          'keep': 0,
          'token': captchaResult.captchaData.data!.token!,
          'challenge': captchaResult.captchaData.data!.geetest!.challenge!,
          'validate': captchaResult.validate,
          'seccode': captchaResult.seccode,
          'go_url': ApiConstants.bilibiliBase,
        },
        options: Options(headers: {
          'user-agent': ApiConstants.userAgent,
        }, contentType: Headers.formUrlEncodedContentType));

    return PostPasswordLoginResponse.fromJson(response.data);
  }
}
