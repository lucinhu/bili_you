import 'package:bili_you/common/models/local/login/level_info.dart';
import 'package:bili_you/common/models/local/login/login_qrcode_info.dart';
import 'package:bili_you/common/models/local/login/login_qrcode_stat.dart';
import 'package:bili_you/common/models/local/login/login_user_info.dart';
import 'package:bili_you/common/models/local/login/login_user_stat.dart';
import 'package:bili_you/common/models/local/reply/official_verify.dart';
import 'package:bili_you/common/models/local/reply/vip.dart';
import 'package:bili_you/common/models/network/user/user_info.dart' as raw;
import 'package:bili_you/common/models/network/user/user_stat.dart' as raw;
import 'package:bili_you/common/utils/http_utils.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'api_constants.dart';
import '../models/network/login/captcha_data.dart' as raw;
import '../models/network/login/captcha_result.dart' as raw;
import '../models/network/login/password_login_key_hash.dart' as raw;
import '../models/network/login/password_login_result.dart' as raw;
import '../models/network/login/post_sms_login.dart' as raw;
import '../models/network/login/post_sms_require.dart' as raw;

abstract class LoginApi {
  ///获取登录需要的key和hash
  static Future<raw.PasswordLoginKeyHashResponse>
      requestPasswordLoginKeyHash() async {
    var response = await HttpUtils().get(
      ApiConstants.passwordPublicKeyHash,
    );
    return raw.PasswordLoginKeyHashResponse.fromJson(response.data);
  }

  ///获取人机测试所需要的数据
  static Future<raw.CaptchaDataResponse> requestCaptchaData() async {
    var response = await HttpUtils().get(
      ApiConstants.captcha,
      queryParameters: {"source": "main_web"},
    );
    return raw.CaptchaDataResponse.fromJson(response.data);
  }

  ///请求发送验证码信息到手机
  static Future<raw.PostSmsRequireResponse> postSendSmsToPhone(int cid, int tel,
      String token, String challenge, String validate, String seccode) async {
    var response = await HttpUtils().post(ApiConstants.smsCode,
        data: {
          "cid": cid,
          "tel": tel,
          "source": "main_web",
          "token": token,
          "challenge": challenge,
          "validate": validate,
          "seccode": seccode
        },
        options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {'user-agent': ApiConstants.userAgent}));
    return raw.PostSmsRequireResponse.fromJson(response.data);
  }

  ///短信登录
  static Future<raw.PostSmsLoginResponse> smsLogin(
      int cid, int tel, int code, String captchaKey) async {
    var response = await HttpUtils().post(ApiConstants.smsLogin,
        data: {
          "cid": cid,
          "tel": tel,
          "code": code,
          "source": "main_mini",
          "keep": 0,
          "captcha_key": captchaKey,
          "go_url": ApiConstants.bilibiliBase
        },
        options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {'user-agent': ApiConstants.userAgent}));
    return raw.PostSmsLoginResponse.fromJson(response.data);
  }

  ///密码登录
  static Future<raw.PostPasswordLoginResponse> postPasswordLoginInfo(
      raw.CaptchaResultModel captchaResult,
      raw.PasswordLoginKeyHashResponse passwordLoginKeyHash,
      String username,
      String password) async {
    //先获取cookie
    await HttpUtils().get(ApiConstants.bilibiliBase,
        options: Options(headers: {'user-agent': ApiConstants.userAgent}));
    //加密密码
    dynamic publicKey = RSAKeyParser().parse(passwordLoginKeyHash.data!.key!);
    String passwordEncryptyed = Encrypter(RSA(publicKey: publicKey))
        .encrypt(passwordLoginKeyHash.data!.hash! + password)
        .base64;
    var response = await HttpUtils().post(ApiConstants.passwordLogin,
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

    return raw.PostPasswordLoginResponse.fromJson(response.data);
  }

  static Future<raw.LoginUserInfoResponse> _requestLoginUserInfo() async {
    var response = await HttpUtils().get(
      ApiConstants.userInfo,
    );
    raw.LoginUserInfoResponse ret;
    try {
      ret = raw.LoginUserInfoResponse.fromJson(response.data);
    } catch (e) {
      throw '$e, json:${response.data}';
    }
    return ret;
  }

  ///获取当前cookie的用户信息
  static Future<LoginUserInfo> getLoginUserInfo() async {
    var response = await _requestLoginUserInfo();
    if (response.code != 0) {
      throw "getLoginUserInfo: code:${response.code}, message:${response.message}";
    }
    if (response.data == null) {
      return LoginUserInfo.zero;
    }
    var data = response.data!;
    return LoginUserInfo(
        mid: data.mid ?? 0,
        name: data.uname ?? "",
        avatarUrl: data.face ?? "",
        levelInfo: LevelInfo(
            currentLevel: data.levelInfo?.currentLevel ?? 0,
            currentExp: data.levelInfo?.currentExp ?? 0,
            currentMin: data.levelInfo?.currentMin ?? 0,
            nextExp: data.levelInfo?.nextExp ?? 0),
        officialVerify: OfficialVerify(
            type:
                OfficialVerifyTypeCode.fromCode(data.officialVerify?.type ?? 0),
            description: data.officialVerify?.desc ?? ""),
        vip: Vip(
            isVip: data.vip?.status == 1,
            type: VipType.values[data.vip?.type ?? 0]),
        isLogin: data.isLogin ?? false);
  }

  ///获取当前cookie用户的状态：粉丝数，关注数，动态数
  static Future<raw.LoginUserStatResponse> _requestLoginUserStat() async {
    var response = await HttpUtils().get(ApiConstants.userStat);
    return raw.LoginUserStatResponse.fromJson(response.data);
  }

  static Future<LoginUserStat> getLoginUserStat() async {
    var response = await _requestLoginUserStat();
    if (response.code != 0) {
      throw "getLoginUserStat: code:${response.code}, message:${response.message}";
    }
    if (response.data == null) {
      return LoginUserStat.zero;
    }
    var data = response.data!;
    return LoginUserStat(
        followerCount: data.follower ?? 0,
        followingCount: data.following ?? 0,
        dynamicCount: data.dynamicCount ?? 0);
  }

  ///获取二维码
  static Future<LoginQRcodeInfo> getQRcode() async {
    var response = await HttpUtils().get(ApiConstants.qrcodeGenerate);
    if (response.data['code'] != 0) {
      throw "getQRcode: code:${response.data['code']}, message:${response.data['message']}";
    }
    LoginQRcodeInfo qrcode = LoginQRcodeInfo();
    qrcode.qrcodeKey = response.data?['data']?['qrcode_key'] ?? '';
    qrcode.url = response.data?['data']?['url'] ?? '';
    return qrcode;
  }

  ///检查维码登录，若登录会自动设置cookie
  ///qrcodeKey超时时长为180秒
  static Future<LoginQrcodeStat> checkQRcodeLogin(
      {required String qrcodeKey}) async {
    var response = await HttpUtils().get(ApiConstants.qrcodeLogin,
        queryParameters: {'qrcode_key': qrcodeKey});
    if (response.data['code'] != 0) {
      throw "checkQRcodeLogin: code:${response.data['code']}, message:${response.data['message']}";
    }
    return LoginQrcodeStatExtension.fromCode(
        response.data?['data']?['code'] ?? -1);
  }
}
