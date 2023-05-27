import 'dart:async';

import 'package:bili_you/common/api/bangumi_api.dart';
import 'package:bili_you/common/models/local/bangumi/bangumi_info.dart';
import 'package:bili_you/common/models/local/search/search_bangumi_item.dart';
import 'package:bili_you/common/models/local/search/search_user_item.dart';
import 'package:bili_you/common/models/local/search/search_video_item.dart';
import 'package:bili_you/common/models/local/video/part_info.dart';
import 'package:bili_you/common/utils/bvid_avid_util.dart';
import 'package:bili_you/common/values/hero_tag_id.dart';
import 'package:bili_you/common/widget/bangumi_tile_item.dart';
import 'package:bili_you/common/widget/user_tile_item.dart';
import 'package:bili_you/pages/bili_video/index.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:bili_you/common/api/search_api.dart';
import 'package:bili_you/common/api/video_info_api.dart';
import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/utils/cache_util.dart';
import 'package:bili_you/common/widget/video_tile_item.dart';
import 'package:bili_you/pages/bili_video/view.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SearchTabViewController extends GetxController {
  SearchTabViewController({required this.keyWord, required this.searchType});
  String keyWord;
  SearchType searchType;

  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  CacheManager cacheManager = CacheUtils.searchResultItemCoverCacheManager;
  List<dynamic> searchItems = [];
  int currentPage = 1;
  ScrollController scrollController = ScrollController();

  animateToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

//搜索视频
  Future<bool> loadSearchVideoItemWidgetLists() async {
    late List<SearchVideoItem> list;
    try {
      list = await SearchApi.getSearchVideos(
          keyWord: keyWord,
          page: currentPage,
          order: SearchVideoOrder.comprehensive);
    } catch (e) {
      log("loadSearchVideoItemWidgetLists:$e");
      return false;
    }
    if (list.isNotEmpty) {
      currentPage++;
    }
    searchItems.addAll(list);
    return true;
  }

  //从搜索结果条目构造widget
  Widget buildVideoItemWidget(SearchVideoItem i) {
    int heroTagId = HeroTagId.id++;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: VideoTileItem(
        picUrl: i.coverUrl,
        bvid: i.bvid,
        title: i.title,
        upName: i.upName,
        duration: StringFormatUtils.timeLengthFormat(i.timeLength),
        playNum: i.playNum,
        pubDate: i.pubDate,
        cacheManager: cacheManager,
        heroTagId: heroTagId,
        onTap: (context) {
          HeroTagId.lastId = heroTagId;
          late List<PartInfo> videoParts;
          Navigator.of(context).push(GetPageRoute(
              page: () => FutureBuilder(
                    future: Future(() async {
                      try {
                        videoParts =
                            await VideoInfoApi.getVideoParts(bvid: i.bvid);
                      } catch (e) {
                        log("加载cid失败,${e.toString()}");
                      }
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return BiliVideoPage(
                          key: ValueKey('BiliVideoPage:${i.bvid}'),
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
                  )));
        },
      ),
    );
  }

//搜索番剧
  Future<bool> loadSearchBangumiItemWidgetLists() async {
    late List<SearchBangumiItem> list;
    try {
      list = await SearchApi.getSearchBangumis(
          keyWord: keyWord, page: currentPage);
    } catch (e) {
      log("loadSearchBangumiItemWidgetLists:$e");
      return false;
    }
    searchItems.addAll(list);
    if (list.isNotEmpty) {
      currentPage++;
    }
    return true;
  }

  Widget buildBangumiItemWidget(SearchBangumiItem i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: BangumiTileItem(
        coverUrl: i.coverUrl,
        title: i.title,
        describe: i.describe,
        score: i.score,
        onTap: (context) async {
          late BangumiInfo bangumiInfo;
          Navigator.of(context).push(GetPageRoute(
              page: () => FutureBuilder(
                    future: Future(() async {
                      try {
                        bangumiInfo =
                            await BangumiApi.getBangumiInfo(ssid: i.ssid);
                      } catch (e) {
                        log("加载失败");
                        rethrow;
                      }
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return BiliVideoPage(
                          key: ValueKey(
                              'BiliVideoPage:${bangumiInfo.episodes.first.bvid}'),
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
                  )));
        },
      ),
    );
  }

  Future<bool> loadSearchUserItemWidgetLists() async {
    late List<SearchUserItem> list;
    try {
      list =
          await SearchApi.getSearchUsers(keyWord: keyWord, page: currentPage);
    } catch (e) {
      log("loadSearchUserItemWidgetLists:$e");
      return false;
    }
    searchItems.addAll(list);
    if (list.isNotEmpty) {
      currentPage++;
    }
    return true;
  }

  Widget buildUserItemWidget(SearchUserItem i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: UserTileItem(searchUserItem: i),
    );
  }

  Future<bool> selectType() async {
    switch (searchType) {
      case SearchType.video:
        return await loadSearchVideoItemWidgetLists();
      case SearchType.bangumi:
        return await loadSearchBangumiItemWidgetLists();
      case SearchType.movie:
      //TODO: movie搜索
      case SearchType.liveRoom:
      //TODO: liveroom搜索
      case SearchType.user:
        return await loadSearchUserItemWidgetLists();
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
  }

  Future<void> onRefresh() async {
    currentPage = 1;
    await cacheManager.emptyCache();
    searchItems.clear();
    bool success = await selectType();
    if (success) {
      refreshController.finishRefresh();
    } else {
      refreshController.finishRefresh(IndicatorResult.fail);
    }
  }

  ///当检测到关键词是bvid或av号时，自动跳转对应的视频
  void jumpAvBvidWhenDetected() {
    String bvid = '';
    if (BvidAvidUtil.isBvid(keyWord)) {
      bvid = keyWord;
    }
    String upperCaseKeyWord = keyWord.toUpperCase();
    int? av = int.tryParse(upperCaseKeyWord.replaceFirst('AV', ''));
    if (upperCaseKeyWord.startsWith('AV') && av != null) {
      bvid = BvidAvidUtil.av2Bvid(av);
    }
    if (bvid.isNotEmpty) {
      VideoInfoApi.getVideoParts(bvid: bvid).then((value) =>
          Navigator.of(Get.context!).push(GetPageRoute(
              page: () => BiliVideoPage(bvid: bvid, cid: value.first.cid))));
    }
  }

  @override
  void onInit() {
    Timer(const Duration(seconds: 1), () {
      jumpAvBvidWhenDetected();
    });
    super.onInit();
  }

  @override
  void onClose() {
    cacheManager.emptyCache();
    super.onClose();
  }
}
