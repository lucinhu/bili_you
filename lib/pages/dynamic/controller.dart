import 'dart:developer';

import 'package:bili_you/common/api/dynamic_api.dart';
import 'package:bili_you/common/models/local/dynamic/dynamic_item.dart';
import 'package:bili_you/pages/dynamic/widget/dynamic_item_card.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicController extends GetxController {
  DynamicController();
  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  // _initData() {
  //   update(["dynamic"]);
  // }
  int currentPage = 1;
  List<DynamicItemCard> dynamicItemCards = [];
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
    for (var i in items) {
      dynamicItemCards.add(DynamicItemCard(dynamicItem: i));
    }
    currentPage++;
    return true;
  }

  void onLoad() async {
    if (await _loadDynamicItemCards()) {
      refreshController.finishLoad(IndicatorResult.success);
    } else {
      refreshController.finishLoad(IndicatorResult.fail);
    }
    update(["dynamic"]);
  }

  void onRefresh() async {
    dynamicItemCards.clear();
    currentPage = 1;
    if (await _loadDynamicItemCards()) {
      refreshController.finishRefresh(IndicatorResult.success);
    } else {
      refreshController.finishRefresh(IndicatorResult.fail);
    }
    log(dynamicItemCards.length.toString());
    update(["dynamic"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  //   _initData();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
