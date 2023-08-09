import 'dart:developer';

import 'package:bili_you/common/api/realtions_api.dart';
import 'package:bili_you/common/models/network/user_relations/user_realtion.dart';
import 'package:bili_you/common/models/network/user_relations/user_relation_types.dart';
import 'package:bili_you/common/values/index.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class RealtionController extends GetxController {
  RealtionController({required this.mid, required this.type});
  final int mid;
  final UserRelationType type;

  EasyRefreshController easyRefreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);

  int ps = 20;
  int pn = 1;

  ScrollController scrollController = ScrollController();
  List<UserRelation> relationsItems = [];
  CacheManager cacheManager = CacheUtils.searchResultItemCoverCacheManager;

  Future<bool> _loadList() async {
    late List<UserRelation> list;
    try {
      switch (type) {
        case UserRelationType.following:
          list = await RelationApi.getFollowingList(vmid: mid, ps: ps, pn: pn);
          break;
        case UserRelationType.follower:
          list = await RelationApi.getFollowersList(vmid: mid, ps: ps, pn: pn);
      }

      pn++;
    } catch (e) {
      log(e.toString());
      return false;
    }
    relationsItems.addAll(list);
    return true;
  }

  Future<void> onLoad() async {
    if (await _loadList()) {
      easyRefreshController.finishLoad(IndicatorResult.success);
      easyRefreshController.resetFooter();
    } else {
      easyRefreshController.finishLoad(IndicatorResult.fail);
    }
  }

  Future<void> onRefresh() async {
    relationsItems.clear();
    pn = 1;
    await cacheManager.emptyCache();
    if (await _loadList()) {
      easyRefreshController.finishRefresh(IndicatorResult.success);
    } else {
      easyRefreshController.finishRefresh(IndicatorResult.fail);
    }
  }
}
