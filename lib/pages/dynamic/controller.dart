import 'dart:developer';

import 'package:bili_you/common/api/dynamic_api.dart';
import 'package:bili_you/common/models/local/dynamic/dynamic_item.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicController extends GetxController {
  DynamicController();
  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  int currentPage = 1;
  List<DynamicItem> dynamicItems = [];
  ScrollController scrollController = ScrollController();
  void animateToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  Future<bool> _loadDynamicItemCards() async {
    late List<DynamicItem> items;
    try {
      items = await DynamicApi.getDynamicItems(page: currentPage);
    } catch (e) {
      log("_loadDynamicItemCards:$e");
      return false;
    }
    dynamicItems.addAll(items);
    if (items.isNotEmpty) {
      currentPage++;
    }
    return true;
  }

  void onLoad() async {
    if (await _loadDynamicItemCards()) {
      refreshController.finishLoad(IndicatorResult.success);
    } else {
      refreshController.finishLoad(IndicatorResult.fail);
    }
  }

  void onRefresh() async {
    dynamicItems.clear();
    currentPage = 1;
    if (await _loadDynamicItemCards()) {
      refreshController.finishRefresh(IndicatorResult.success);
    } else {
      refreshController.finishRefresh(IndicatorResult.fail);
    }
  }
}
