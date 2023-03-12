import 'dart:developer';

import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/api/search_api.dart';
import 'package:bili_you/common/api/user_api.dart';
import 'package:bili_you/common/models/network/search/default_search_word.dart';
import 'package:bili_you/common/models/network/user/user_info.dart';
import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:bili_you/common/values/cache_keys.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController();
  CacheManager cacheManager = CacheManager(Config(CacheKeys.userFaceKey));
  RxString faceUrl = ApiConstants.noface.obs;
  late UserInfoResponse userInfo;

  RxString defaultSearchWord = "搜索".obs;

  _initData() async {
    refreshDefaultSearchWord();
  }

  refreshDefaultSearchWord() async {
    try {
      DefaultSearchWordResponse defaultSearchWordModel =
          await SearchApi.requestDefaultSearchWord();
      if (defaultSearchWordModel.code == 0) {
        defaultSearchWord.value = defaultSearchWordModel.data?.showName ?? "";
      }
    } catch (e) {
      log("获取搜素框默认词失败,网络错误?");
      log(e.toString());
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() async {
    super.onReady();
    _initData();
  }

  Future<void> refreshFace() async {
    try {
      userInfo = await UserApi.requestUserInfo();
      faceUrl.value = userInfo.data?.face ?? ApiConstants.noface;
    } catch (e) {
      faceUrl.value = ApiConstants.noface;
      log(e.toString());
    }
  }

  Future<void> loadOldFace() async {
    var box = BiliYouStorage.user;
    faceUrl.value = box.get(UserStorageKeys.userFace) ?? ApiConstants.noface;
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
