import 'dart:developer';

import 'package:bili_you/common/api/history_api.dart';
import 'package:bili_you/common/models/local/history/video_view_history_item.dart';
import 'package:bili_you/common/values/index.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  HistoryController();
  EasyRefreshController easyRefreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  int max = 0;
  int viewAt = 0;
  ScrollController scrollController = ScrollController();
  List<VideoViewHistoryItem> videoViewHistoryItems = [];
  CacheManager cacheManager = CacheUtils.searchResultItemCoverCacheManager;

  Future<bool> _loadVideoViewHistoryItemList() async {
    late List<VideoViewHistoryItem> list;
    try {
      if (max == 0 && viewAt == 0) {
        list = await HistoryApi.getVideoViewHistory();
      } else {
        list = await HistoryApi.getVideoViewHistory(max: max, viewAt: viewAt);
      }
      if (list.isNotEmpty) {
        max = list.last.oid;
        viewAt = list.last.viewAt;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
    videoViewHistoryItems.addAll(list);
    return true;
  }
  Future<void> onLoad() async {
    if (await _loadVideoViewHistoryItemList()) {
      easyRefreshController.finishLoad(IndicatorResult.success);
      easyRefreshController.resetFooter();
    } else {
      easyRefreshController.finishLoad(IndicatorResult.fail);
    }
  }

  Future<void> onRefresh() async {
    videoViewHistoryItems.clear();
    max = 0;
    viewAt = 0;
    await cacheManager.emptyCache();
    if (await _loadVideoViewHistoryItemList()) {
      easyRefreshController.finishRefresh(IndicatorResult.success);
    } else {
      easyRefreshController.finishRefresh(IndicatorResult.fail);
    }
  }
}
