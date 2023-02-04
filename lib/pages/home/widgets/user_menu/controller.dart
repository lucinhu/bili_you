import 'dart:developer';

import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/api/user_api.dart';
import 'package:bili_you/common/models/user/user_info.dart';
import 'package:bili_you/common/models/user/user_stat.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:bili_you/common/values/cache_keys.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMenuController extends GetxController {
  UserMenuController();
  CacheManager cacheManager = CacheManager(Config(CacheKeys.userFaceKey));
  RxString faceUrl = ApiConstants.noface.obs;
  RxString name = '游客'.obs;
  RxInt level = 0.obs;
  RxInt currentExp = 0.obs;
  RxInt nextExp = 0.obs;
  RxInt dynamicCount = 0.obs;
  RxInt followingCount = 0.obs;
  RxInt followerCount = 0.obs;

  late UserInfoModel userInfo;
  late UserStatModel userStat;

  _initData() async {
    try {
      userInfo = await UserApi.requestUserInfo();
      userStat = await UserApi.requestUserStat();
      faceUrl.value = userInfo.face;
      name.value = userInfo.userName;
      level.value = userInfo.levelInfo.currentLevel;
      currentExp.value = userInfo.levelInfo.currentExp;
      nextExp.value = userInfo.levelInfo.nextExp;
      dynamicCount.value = userStat.dynamicCount;
      followerCount.value = userStat.followerCount;
      followingCount.value = userStat.followingCount;
    } catch (e) {
      log(e.toString());
    }
    // update(["user_face"]);
  }

  void onTap() {}

  // @override
  // void onInit() async {
  //   super.onInit();

  // }
  Future<void> loadOldFace() async {
    var pref = (await SharedPreferences.getInstance());
    faceUrl.value = pref.getString("userFace") ?? ApiConstants.noface;
    return;
  }

  void resetRX() {
    faceUrl.value = ApiConstants.noface;
    name.value = '游客';
    level.value = 0;
    currentExp.value = 0;
    nextExp.value = 0;
    dynamicCount.value = 0;
    followingCount.value = 0;
    followerCount.value = 0;
  }

  @override
  void onReady() async {
    super.onReady();
    _initData();
  }

  onLogout() async {
    MyDio.cookieManager.cookieJar.deleteAll();
    resetRX();
    (await SharedPreferences.getInstance()).setBool('hasLogin', false);
    cacheManager.emptyCache();
  }

  Future<bool> hasLogin() async {
    return (await SharedPreferences.getInstance()).getBool("hasLogin") ?? false;
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
