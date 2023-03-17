import 'package:bili_you/common/api/bangumi_api.dart';
import 'package:bili_you/common/models/local/bangumi/bangumi_info.dart';
import 'package:bili_you/common/models/local/search/search_bangumi_item.dart';
import 'package:bili_you/common/models/local/search/search_video_item.dart';
import 'package:bili_you/common/models/local/video/part_info.dart';
import 'package:bili_you/common/widget/bangumi_tile_item.dart';
import 'package:bili_you/pages/bili_video/index.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:bili_you/common/api/search_api.dart';
import 'package:bili_you/common/api/video_info_api.dart';
import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/values/cache_keys.dart';
import 'package:bili_you/common/widget/video_tile_item.dart';
import 'package:bili_you/pages/bili_video/view.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SearchTabViewController extends GetxController {
  SearchTabViewController({required this.keyWord, required this.searchType});
  late final String keyWord;
  late final SearchType searchType;

  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  CacheManager cacheManager =
      CacheManager(Config(CacheKeys.searchResultItemCoverKey));
  List<Widget> searchItemWidgetList = <Widget>[];
  int currentPage = 1;

  _initData() {
    // update(["search_video_result"]);
  }

//搜索视频
  Future<bool> loadSearchVideoItemWidgtLists() async {
    late List<SearchVideoItem> list;
    try {
      list = await SearchApi.getSearchVideos(
          keyWord: keyWord,
          page: currentPage,
          order: SearchVideoOrder.comprehensive);
    } catch (e) {
      log("loadSearchVideoItemWidgtLists:$e");
      return false;
    }
    currentPage++;
    for (var i in list) {
      searchItemWidgetList.add(VideoTileItem(
        picUrl: i.coverUrl,
        bvid: i.bvid,
        title: StringFormatUtils.keyWordTitleToRawTitle(i.title),
        upName: i.upName,
        duration: StringFormatUtils.timeLengthFormat(i.timeLength),
        playNum: i.playNum,
        pubDate: i.pubDate,
        cacheManager: cacheManager,
        onTap: (context) {
          late List<PartInfo> videoParts;
          Get.to(() => FutureBuilder(
                future: Future(() async {
                  try {
                    videoParts = await VideoInfoApi.getVideoParts(bvid: i.bvid);
                  } catch (e) {
                    log("加载cid失败,${e.toString()}");
                  }
                }),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return BiliVideoPage(
                      bvid: i.bvid,
                      cid: videoParts.first.cid,
                    );
                  } else {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ));
        },
      ));
    }
    return true;
  }

//搜索番剧
  Future<bool> loadSearchBangumiItemWidgtLists() async {
    late List<SearchBangumiItem> list;
    try {
      list = await SearchApi.getSearchBangumis(
          keyWord: keyWord, page: currentPage);
    } catch (e) {
      log("loadSearchBangumiItemWidgtLists:$e");
      return false;
    }
    for (var i in list) {
      log(i.coverUrl);
      searchItemWidgetList.add(BangumiTileItem(
        coverUrl: i.coverUrl,
        title: i.title,
        describe: i.describe,
        score: i.score,
        onTap: (context) async {
          late BangumiInfo bangumiInfo;
          Get.to(() => FutureBuilder(
                future: Future(() async {
                  try {
                    bangumiInfo = await BangumiApi.getBangumiInfo(ssid: i.ssid);
                  } catch (e) {
                    log("加载失败");
                    rethrow;
                  }
                }),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return BiliVideoPage(
                      bvid: bangumiInfo.episodes.first.bvid,
                      cid: bangumiInfo.episodes.first.cid,
                      ssid: bangumiInfo.ssid,
                      isBangumi: true,
                    );
                  } else {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ));
        },
      ));
    }
    currentPage++;
    return true;
  }

  Future<bool> selectType() async {
    switch (searchType) {
      case SearchType.video:
        return await loadSearchVideoItemWidgtLists();

      case SearchType.bangumi:
        return await loadSearchBangumiItemWidgtLists();
      case SearchType.movie:
        return false;
      case SearchType.liveRoom:
        return false;
      case SearchType.user:
        return false;

      default:
        return false;
    }
  }

  Future<void> onLoad() async {
    bool success = await selectType();
    if (success) {
      refreshController.finishLoad();
      refreshController.resetFooter();
    } else {
      refreshController.finishLoad(IndicatorResult.fail);
    }
    update(["search_video_result"]);
  }

  Future<void> onRefresh() async {
    currentPage = 1;
    await cacheManager.emptyCache();
    searchItemWidgetList.clear();
    update(["search_video_result"]);
    bool success = await selectType();
    if (success) {
      refreshController.finishRefresh();
    } else {
      refreshController.finishRefresh(IndicatorResult.fail);
    }
    update(["search_video_result"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    cacheManager.emptyCache();
    super.onClose();
  }
}
