import 'dart:developer';

import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/models/local/login/login_user_info.dart';
import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:bili_you/common/utils/settings.dart';
import 'package:bili_you/common/utils/cache_util.dart';
import 'package:flutter/material.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController();
  CacheManager cacheManager = CacheUtils.userFaceCacheManager;
  RxString faceUrl = ApiConstants.noface.obs;
  late LoginUserInfo userInfo;

  RxString defaultSearchWord = "搜索".obs;
  final List<Map<String, String>> tabsList = [
    {'text': '直播', 'id': '', 'controller': 'LiveTabPageController'},
    {'text': '推荐', 'id': '', 'controller': 'RecommendController'},
    {'text': '热门', 'id': '', 'controller': 'PopularVideoController'},
    {'text': '番剧', 'id': '', 'controller': ''}
  ];
  late TabController? tabController;
  final int tabInitIndex = 1;
  RxInt tabIndex = 1.obs;

  _initData() async {
    refreshDefaultSearchWord();
  }

  //刷新搜索框默认词
  refreshDefaultSearchWord() async {
    if (!SettingsUtil.getValue(SettingsStorageKeys.showSearchDefualtWord,
        defaultValue: true)) {
      //如果没有开启默认词的话，就直接跳出
      defaultSearchWord.value = "搜索";
      return;
    }
    try {
      defaultSearchWord.value =
          (await SearchApi.getDefaultSearchWords()).showName;
    } catch (e) {
      log("refreshDefaultSearchWord:$e");
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
      userInfo = await LoginApi.getLoginUserInfo();
      faceUrl.value = userInfo.avatarUrl;
    } catch (e) {
      faceUrl.value = ApiConstants.noface;
      log(e.toString());
    }
  }

  Future<void> loadOldFace() async {
    var box = BiliYouStorage.user;
    faceUrl.value = box.get(UserStorageKeys.userFace) ?? ApiConstants.noface;
  }
}
