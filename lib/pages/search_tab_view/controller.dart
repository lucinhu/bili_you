import 'package:bili_you/common/api/bangumi_api.dart';
import 'package:bili_you/common/models/search/search_bangumi.dart';
import 'package:bili_you/common/widget/bangumi_tile_item.dart';
import 'package:bili_you/pages/bili_video/index.dart';
import 'package:bili_you/pages/bili_video/widgets/introduction/index.dart';
import 'package:get/get.dart';
import 'dart:developer';

import 'package:bili_you/common/api/search_api.dart';
import 'package:bili_you/common/api/video_info_api.dart';
import 'package:bili_you/common/models/video_info/video_parts.dart';
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
  int numPages = 0;

  _initData() {
    // update(["search_video_result"]);
  }

//搜索视频
  Future<bool> loadSearchVideoItemWidgtLists() async {
    //如果当前页数等于总页数的话,就直接返回成功,代表已经没了
    if (currentPage == numPages) {
      return true;
    }
    try {
      var videoSearch = await SearchApi.requestSearchVideo(
          keyword: keyWord, page: currentPage);
      if (videoSearch.code != 0) {
        log("搜索失败");
        //加载失败
        return false;
      }
      //加载成功,添加控件
      numPages = videoSearch.numPages;
      for (var i in videoSearch.result) {
        searchItemWidgetList.add(VideoTileItem(
          picUrl: i.pic,
          bvid: i.bvid,
          title: StringFormatUtils.keyWordTitleToRawTitle(i.title),
          upName: i.author,
          duration: StringFormatUtils.timeLengthFormat(Duration(
                  minutes: int.parse(i.duration.split(':').first),
                  seconds: int.parse(i.duration.split(':').last))
              .inSeconds),
          playNum: i.playNum,
          pubDate: i.pubdate,
          cacheManager: cacheManager,
          onTap: (context) async {
            late VideoPartsModel videoParts;
            try {
              videoParts = await VideoInfoApi.requestVideoParts(bvid: i.bvid);
              if (videoParts.code != 0) {
                log("加载cid失败,${videoParts.message}");
                return false;
              }
            } catch (e) {
              log("加载cid失败,${e.toString()}");
              return false;
            }
            Get.to(() => BiliVideoPage(
                  bvid: i.bvid,
                  cid: videoParts.data.first.cid,
                  introductionBuilder:
                      (changePartCallback, pauseVideoCallback, refreshReply) =>
                          IntroductionPage(
                    changePartCallback: changePartCallback,
                    pauseVideoCallback: pauseVideoCallback,
                    bvid: i.bvid,
                  ),
                ));
          },
        ));
        currentPage += 1;
      }
      return true;
    } catch (e) {
      log("加载失败,${e.toString()}");
      return false;
    }
  }

//搜索番剧
  Future<bool> loadSearchBangumiItemWidgtLists() async {
    //如果当前页数等于总页数的话,就直接返回成功,代表已经没了
    if (currentPage == numPages) {
      return true;
    }
    try {
      var response = await SearchApi.requestSearchBangumi(
          keyWord: keyWord, page: currentPage);
      if (response.code != 0 || response.data == null) {
        log("搜索失败");
        //加载失败
        return false;
      }
      //加载成功,添加控件
      numPages = response.data!.numPages ?? 0;
      for (var i in response.data!.result ?? <SearchBangumiResultItem>[]) {
        searchItemWidgetList.add(BangumiTileItem(
            coverUrl: i.cover!,
            title: StringFormatUtils.keyWordTitleToRawTitle(i.title!),
            describe: "${i.areas}\n${i.styles!}",
            score: i.mediaScore!.score!,
            onTap: (context) async {
              var bangumi =
                  await BangumiApi.requestBangumiInfo(ssid: i.seasonId);
              if (bangumi.code != 0) {
                log("搜索失败");
                //加载失败
                return false;
              }
              Get.to(() => BiliVideoPage(
                    bvid: bangumi.result!.episodes!.first.bvid!,
                    cid: bangumi.result!.episodes!.first.cid!,
                    introductionBuilder: (changePartCallback,
                            pauseVideoCallback, refreshReply) =>
                        IntroductionPage(
                      bvid: bangumi.result!.episodes!.first.bvid!,
                      cid: bangumi.result!.episodes!.first.cid!,
                      ssid: i.seasonId,
                      isBangumi: true,
                      refreshReply: refreshReply,
                      changePartCallback: changePartCallback,
                      pauseVideoCallback: pauseVideoCallback,
                    ),
                  ));
            }));
        currentPage += 1;
      }
      return true;
    } catch (e) {
      log("加载失败,${e.toString()}");
      return false;
    }
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
    numPages = 0;
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
