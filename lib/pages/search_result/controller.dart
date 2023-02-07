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
import 'package:get/get.dart';

class SearchResultController extends GetxController {
  SearchResultController();
  // RefreshController refreshController = RefreshController(initialRefresh: true);
  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  CacheManager cacheManager =
      CacheManager(Config(CacheKeys.searchResultItemCoverKey));
  List<Widget> searchItemWidgetList = <Widget>[];
  int currentPage = 1;
  int numPages = 0;
  late String keyWord;

  _initData() {
    update(["search_result"]);
  }

  Future<bool> loadSearchItemWidgtLists() async {
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
          duration: i.duration,
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
            Get.to(() =>
                BiliVideoPage(bvid: i.bvid, cid: videoParts.data.first.cid));
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

  onLoad() async {
    if (await loadSearchItemWidgtLists()) {
      refreshController.finishLoad();
      refreshController.resetFooter();
    } else {
      refreshController.finishLoad(IndicatorResult.fail);
    }
    update(["search_result"]);
  }

  onRefresh() async {
    currentPage = 1;
    numPages = 0;
    await cacheManager.emptyCache();
    searchItemWidgetList.clear();
    update(["search_result"]);
    if (await loadSearchItemWidgtLists()) {
      refreshController.finishRefresh();
    } else {
      refreshController.finishRefresh(IndicatorResult.fail);
    }
    update(["search_result"]);
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
