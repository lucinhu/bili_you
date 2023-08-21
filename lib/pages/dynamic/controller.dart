import 'dart:developer';

import 'package:bili_you/common/api/dynamic_api.dart';
import 'package:bili_you/common/models/local/dynamic/dynamic_author.dart';
import 'package:bili_you/common/models/local/dynamic/dynamic_item.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicController extends GetxController {
  DynamicController();
  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  int currentPage = 1;
  int authorFilterMid = -1;
  List<DynamicItem> dynamicItems = [];
  List<DynamicAuthor> dynamicAuthorList = [];
  ScrollController scrollController = ScrollController();
  void animateToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  Future<bool> _loadDynamicItemCards() async {
    //動態内容卡片
    late List<DynamicItem> items;
    try {
      items = await DynamicApi.getDynamicItems(page: currentPage, mid: authorFilterMid);
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

  Future<bool> _loadAuthorList() async {
    //動態up主
    try {
      dynamicAuthorList = await DynamicApi.getDynamicAuthorList();
    } catch (e) {
      log("_loadDynamicAuthorList:$e");
      return false;
    }
    return true;
  }

  void onLoad() async {
    //加載更多
    if (await _loadDynamicItemCards()) {
      refreshController.finishLoad(IndicatorResult.success);
    } else {
      refreshController.finishLoad(IndicatorResult.fail);
    }
  }

  void onRefresh() async {
    //刷新
    dynamicItems.clear();
    currentPage = 1;
    if (authorFilterMid == -1) {
      await _loadAuthorList();
      authorFilterMid = 0;
    }
    if (await _loadDynamicItemCards()) {
      refreshController.finishRefresh(IndicatorResult.success);
    } else {
      refreshController.finishRefresh(IndicatorResult.fail);
    }
  }

  void applyAuthorFilter(mid) {
    //up主過濾
    authorFilterMid = mid;
    refreshController.callRefresh();
  }
}
