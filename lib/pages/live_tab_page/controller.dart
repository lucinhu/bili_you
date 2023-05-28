import 'dart:developer';

import 'package:bili_you/common/api/live_api.dart';
import 'package:bili_you/common/models/local/live/live_room_card_info.dart';
import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:bili_you/common/utils/settings.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveTabPageController extends GetxController {
  var refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  var scrollController = ScrollController();
  int currentPageNum = 1;
  RxList<LiveRoomCardInfo> infoList = <LiveRoomCardInfo>[].obs;
  int columnCount = 2;
  @override
  void onInit() {
    columnCount = SettingsUtil.getValue(
        SettingsStorageKeys.recommendColumnCount,
        defaultValue: 2);
    super.onInit();
  }

  void animateToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  Future<bool> _loadInfos() async {
    try {
      infoList.addAll(await LiveApi.getUserRecommendLive(
          pageNum: currentPageNum, pageSize: 30));
      currentPageNum++;
      return true;
    } catch (e) {
      log("LiveTabPageController:$e");
    }
    return false;
  }

  Future<void> onRefresh() async {
    infoList.clear();
    currentPageNum = 1;
    if (await _loadInfos()) {
      refreshController.finishRefresh(IndicatorResult.success);
    } else {
      refreshController.finishRefresh(IndicatorResult.fail);
    }
  }

  Future<void> onLoad() async {
    if (await _loadInfos()) {
      refreshController.finishLoad(IndicatorResult.success);
    } else {
      refreshController.finishLoad(IndicatorResult.fail);
    }
  }
}
