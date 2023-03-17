import 'dart:developer';

import 'package:bili_you/common/api/user_space_api.dart';
import 'package:bili_you/common/api/video_info_api.dart';
import 'package:bili_you/common/models/local/user_space/user_video_search.dart';
import 'package:bili_you/common/models/local/video/part_info.dart';
import 'package:bili_you/common/values/cache_keys.dart';
import 'package:bili_you/common/widget/video_tile_item.dart';
import 'package:bili_you/pages/bili_video/index.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class UserSpacePageController extends GetxController {
  UserSpacePageController({required this.mid});
  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  CacheManager cacheManager =
      CacheManager(Config(CacheKeys.searchResultItemCoverKey));
  final int mid;
  int currentPage = 1;
  List<Widget> searchItemWidgetList = <Widget>[];

  Future<bool> loadVideoItemWidgtLists() async {
    late UserVideoSearch userVideoSearch;
    // try {
    userVideoSearch =
        await UserSpaceApi.getUserVideoSearch(mid: mid, pageNum: currentPage);
    // } catch (e) {
    //   log("loadVideoItemWidgtLists:$e");
    //   return false;
    // }
    for (var item in userVideoSearch.videos) {
      searchItemWidgetList.add(VideoTileItem(
          picUrl: item.coverUrl,
          bvid: item.bvid,
          title: item.title,
          upName: item.author,
          duration: item.duration,
          playNum: item.playCount,
          pubDate: item.pubDate,
          cacheManager: cacheManager,
          onTap: (context) {
            late List<PartInfo> videoParts;
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return FutureBuilder(future: Future(() async {
                  try {
                    videoParts =
                        await VideoInfoApi.getVideoParts(bvid: item.bvid);
                  } catch (e) {
                    log("加载cid失败,${e.toString()}");
                  }
                }), builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return BiliVideoPage(
                      bvid: item.bvid,
                      cid: videoParts.first.cid,
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
  }

  Future<void> onLoad() async {
    if (await loadVideoItemWidgtLists()) {
      refreshController.finishLoad(IndicatorResult.success);
      refreshController.resetFooter();
    } else {
      refreshController.finishLoad(IndicatorResult.fail);
    }
    update(['user_space']);
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
    update(['user_space']);
  }
}
