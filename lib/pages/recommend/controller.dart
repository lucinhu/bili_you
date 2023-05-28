import 'dart:developer';

import 'package:bili_you/common/models/local/home/recommend_item_info.dart';
import 'package:bili_you/common/utils/index.dart';
import 'package:bili_you/common/utils/cache_util.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:bili_you/common/api/home_api.dart';

class RecommendController extends GetxController {
  RecommendController();
  List<RecommendVideoItemInfo> recommendItems = [];

  ScrollController scrollController = ScrollController();
  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  int refreshIdx = 0;
  CacheManager cacheManager = CacheUtils.recommendItemCoverCacheManager;
  int recommendColumnCount = 2;

  @override
  void onInit() {
    recommendColumnCount = SettingsUtil.getValue(
        SettingsStorageKeys.recommendColumnCount,
        defaultValue: 2);
    super.onInit();
  }

  void animateToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

//加载并追加视频推荐
  Future<bool> _addRecommendItems() async {
    try {
      recommendItems.addAll(await HomeApi.getRecommendVideoItems(
          num: 30, refreshIdx: refreshIdx));
    } catch (e) {
      log("加载推荐视频失败:${e.toString()}");
      return false;
    }
    refreshIdx += 1;
    return true;
  }

  Future<void> onRefresh() async {
    recommendItems.clear();
    await cacheManager.emptyCache();
    if (await _addRecommendItems()) {
      refreshController.finishRefresh(IndicatorResult.success);
    } else {
      refreshController.finishRefresh(IndicatorResult.fail);
    }
  }

  Future<void> onLoad() async {
    if (await _addRecommendItems()) {
      refreshController.finishLoad(IndicatorResult.success);
      refreshController.resetFooter();
    } else {
      refreshController.finishLoad(IndicatorResult.fail);
    }
  }
}
