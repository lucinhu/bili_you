import 'package:bili_you/common/models/local/login/login_user_info.dart';
import 'package:bili_you/common/models/local/login/login_user_stat.dart';
import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:bili_you/common/utils/cache_util.dart';
import 'package:bili_you/pages/dynamic/controller.dart';
import 'package:bili_you/pages/home/index.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gt3_flutter_plugin/gt3_flutter_plugin.dart';

import '../../common/api/login_api.dart';
import '../../common/models/network/login/captcha_result.dart';

///人机测试
///必须在回调函数里面处理成功事件
///错误已处理
Future<void> startCaptcha(
    {required Function(CaptchaResultModel captchaResult) onSuccess}) async {
  late CaptchaResultModel captchaResult;
  Gt3CaptchaConfig config = Gt3CaptchaConfig();
  // config.language = WidgetsBinding.instance.window.locale.countryCode;
  config.timeout = 240;
  config.serviceNode = 1;
  var captcha = Gt3FlutterPlugin(config);
  try {
    captchaResult =
        CaptchaResultModel(captchaData: await LoginApi.requestCaptchaData());
  } catch (e) {
    Get.rawSnackbar(title: "获取captcha数据错误", message: "网络问题");
    debugPrint("获取captcha数据错误,${e.toString()}");
    return;
  }
  var gtCaptchaData = Gt3RegisterData(
      challenge: captchaResult.captchaData.data!.geetest!.challenge,
      gt: captchaResult.captchaData.data!.geetest!.gt!,
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
    LoginUserInfo userInfo, LoginUserStat userStat) async {
  var box = BiliYouStorage.user;
  await CacheUtils.userFaceCacheManager.emptyCache();
  await box.put(UserStorageKeys.hasLogin, true);
  await box.put(UserStorageKeys.userFace, userInfo.avatarUrl);
  await box.put(UserStorageKeys.userName, userInfo.name);
  // await box.put(UserStorageKeys.userLevel, userInfo.levelInfo.currentLevel);
  // await box.put(UserStorageKeys.userCurrentExp, userInfo.levelInfo.currentExp);
  // await box.put(UserStorageKeys.userNextExp, userInfo.levelInfo.nextExp);
  // await box.put(UserStorageKeys.userDynamicCount, userStat.dynamicCount);
  // await box.put(UserStorageKeys.userFollowerCount, userStat.followerCount);
  // await box.put(UserStorageKeys.userFollowingCount, userStat.followingCount);
  Get.find<HomeController>().faceUrl.value = userInfo.avatarUrl;
  Get.find<DynamicController>().refreshController.callRefresh();
}
