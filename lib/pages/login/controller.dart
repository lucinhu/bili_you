import 'package:bili_you/common/models/user/user_info.dart';
import 'package:bili_you/common/models/user/user_stat.dart';
import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:bili_you/common/values/cache_keys.dart';
import 'package:bili_you/pages/home/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:gt3_flutter_plugin/gt3_flutter_plugin.dart';

import '../../common/api/login_api.dart';
import '../../common/models/login/captcha_result.dart';

///人机测试
///必须在回调函数里面处理成功事件
///错误已处理
startCaptcha(
    {required Function(CaptchaResultModel captchaResult) onSuccess}) async {
  late CaptchaResultModel captchaResult;
  Gt3CaptchaConfig config = Gt3CaptchaConfig();
  config.language = WidgetsBinding.instance.window.locale.countryCode;
  config.timeout = 5.0;
  var captcha = Gt3FlutterPlugin(config);
  try {
    captchaResult =
        CaptchaResultModel(captchaData: await LoginApi.getCaptchaData());
  } catch (e) {
    Get.rawSnackbar(title: "获取captcha数据错误", message: "网络问题");
    debugPrint("获取captcha数据错误,${e.toString()}");
    return;
  }
  var gtCaptchaData = Gt3RegisterData(
      challenge: captchaResult.captchaData.challenge,
      gt: captchaResult.captchaData.gt,
      success: captchaResult.captchaData.code == 0);
  captcha.addEventHandler(
      //返回信息的时候
      onResult: (message) async {
    String code = message["code"];
    if (code == "1") {
      //人机测试成功
      //获取数据
      captchaResult.validate = message['result']['geetest_validate'];
      captchaResult.seccode = message['result']['geetest_seccode'];
      //执行回调函数
      onSuccess(captchaResult);
    }
  },
      //错误的时候
      onError: (message) async {
    debugPrint("Captcha error: $message");
    Get.rawSnackbar(title: "人机测试错误");
  });
  //打开人机测试验证框
  captcha.startCaptcha(gtCaptchaData);
}

///登录成功时设置登录状态
///清除头像缓存
Future<void> onLoginSuccess(
    UserInfoModel userInfo, UserStatModel userStat) async {
  var pref = BiliYouStorage.user;
  await CacheManager(Config(CacheKeys.userFaceKey)).emptyCache();
  await pref.put("hasLogin", true);
  await pref.put("userFace", userInfo.face);
  await pref.put("userName", userInfo.userName);
  await pref.put("userLevel", userInfo.levelInfo.currentLevel);
  await pref.put("userCurrentExp", userInfo.levelInfo.currentExp);
  await pref.put("userNextExp", userInfo.levelInfo.nextExp);
  await pref.put("userDynamicCount", userStat.dynamicCount);
  await pref.put("userfollowerCount", userStat.followerCount);
  await pref.put("userFollowingCount", userStat.followingCount);
  Get.find<HomeController>().faceUrl.value = userInfo.face;
}
