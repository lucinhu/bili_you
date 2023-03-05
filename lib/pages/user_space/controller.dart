import 'dart:developer';

import 'package:bili_you/common/api/user_space.dart';
import 'package:bili_you/common/api/video_info_api.dart';
import 'package:bili_you/common/models/user_space/user_video_search.dart';
import 'package:bili_you/common/models/video_info/video_parts.dart';
import 'package:bili_you/common/values/cache_keys.dart';
import 'package:bili_you/common/widget/video_tile_item.dart';
import 'package:bili_you/pages/bili_video/index.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class UserSpacePageController extends GetxController {
  UserSpacePageController({required this.refreshKey, required this.mid});
  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  CacheManager cacheManager =
      CacheManager(Config(CacheKeys.searchResultItemCoverKey));
  final int mid;
  int currentPage = 1;
  List<Widget> searchItemWidgetList = <Widget>[];
  final GlobalKey refreshKey;

  Future<bool> loadVideoItemWidgtLists() async {
    try {
      var response = await UserSpaceApi.requestUserVideoSearch(
          mid: mid, pageNum: currentPage);
      if (response.code != 0 && response.data != null) {
        log("用户投稿加载失败");
        return false;
      }
      var data = response.data!;
      for (var item in data.list?.vlist ?? <Vlist>[]) {
        searchItemWidgetList.add(VideoTileItem(
            picUrl: item.pic!,
            bvid: item.bvid!,
            title: item.title!,
            upName: item.author!,
            duration: item.length!,
            playNum: item.play!,
            pubDate: item.created!,
            cacheManager: cacheManager,
            onTap: (context) {
              late VideoPartsModel videoParts;
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return FutureBuilder(future: Future(() async {
                    try {
                      videoParts = await VideoInfoApi.requestVideoParts(
                          bvid: item.bvid!);
                      if (videoParts.code != 0) {
                        log("加载cid失败,${videoParts.message}");
                      }
                    } catch (e) {
                      log("加载cid失败,${e.toString()}");
                    }
                  }), builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return BiliVideoPage(
                        bvid: item.bvid!,
                        cid: videoParts.data.first.cid,
                      );
                    } else {
                      return const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  });
                },
              ));
            }));
      }
      currentPage++;
      return true;
    } catch (e) {
      log("用户投稿加载失败");
      return false;
    }
  }

  Future<void> onLoad() async {
    if (await loadVideoItemWidgtLists()) {
      refreshController.finishLoad(IndicatorResult.success);
      refreshController.resetFooter();
    } else {
      refreshController.finishLoad(IndicatorResult.fail);
    }
    if (refreshKey.currentState?.mounted ?? false) {
      refreshKey.currentState?.setState(() {});
    }
  }

  Future<void> onRefresh() async {
    await cacheManager.emptyCache();
    searchItemWidgetList.clear();
    currentPage = 1;
    bool success = await loadVideoItemWidgtLists();
    if (success) {
      refreshController.finishRefresh(IndicatorResult.success);
    } else {
      refreshController.finishRefresh(IndicatorResult.fail);
    }
    if (refreshKey.currentState?.mounted ?? false) {
      refreshKey.currentState?.setState(() {});
    }
  }
}
