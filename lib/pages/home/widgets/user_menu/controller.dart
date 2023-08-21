import 'dart:developer';

import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/models/local/login/login_user_info.dart';
import 'package:bili_you/common/models/local/login/login_user_stat.dart';
import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:bili_you/common/utils/http_utils.dart';
import 'package:bili_you/common/utils/cache_util.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:get/get.dart';

class UserMenuController extends GetxController {
  UserMenuController();
  CacheManager cacheManager = CacheUtils.userFaceCacheManager;
  RxString faceUrl = ApiConstants.noface.obs;
  RxString name = '游客'.obs;
  RxInt level = 0.obs;
  RxInt currentExp = 0.obs;
  RxInt nextExp = 0.obs;
  RxInt dynamicCount = 0.obs;
  RxInt followingCount = 0.obs;
  RxInt followerCount = 0.obs;

  RxBool islogin_ = false.obs;

  late LoginUserInfo userInfo;
  late LoginUserStat userStat;
//用戶信息
  _initData() async {
    try {
      userInfo = await LoginApi.getLoginUserInfo();
      userStat = await LoginApi.getLoginUserStat();
      faceUrl.value = userInfo.avatarUrl;
      name.value = userInfo.name;
      level.value = userInfo.levelInfo.currentLevel;
      currentExp.value = userInfo.levelInfo.currentExp;
      nextExp.value = userInfo.levelInfo.nextExp;
      dynamicCount.value = userStat.dynamicCount;
      followerCount.value = userStat.followerCount;
      followingCount.value = userStat.followingCount;
      islogin_.value = true;
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
    var box = BiliYouStorage.user;
    if (!await hasLogin()) {
      faceUrl.value = ApiConstants.noface;
    } else {
      faceUrl.value = box.get("userFace") ?? ApiConstants.noface;
    }
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
//登出
  onLogout() async {
    HttpUtils.cookieManager.cookieJar.deleteAll();
    resetRX();
    var box = BiliYouStorage.user;
    box.put(UserStorageKeys.hasLogin, false);
    cacheManager.emptyCache();
    islogin_.value = false;
  }
//檢查用戶是否登錄
  Future<bool> hasLogin() async {
    return BiliYouStorage.user.get(UserStorageKeys.hasLogin) ?? false;
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
