import 'dart:developer';

import 'package:bili_you/common/api/bangumi_api.dart';
import 'package:bili_you/common/api/related_video_api.dart';
import 'package:bili_you/common/api/video_info_api.dart';
import 'package:bili_you/common/models/local/related_video/related_video_info.dart';
import 'package:bili_you/common/models/local/video/video_info.dart';
import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/values/cache_keys.dart';
import 'package:bili_you/common/widget/video_tile_item.dart';
import 'package:bili_you/pages/bili_video/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class IntroductionController extends GetxController {
  IntroductionController(
      {required this.bvid,
      required this.cid,
      required this.ssid,
      required this.isBangumi,
      required this.changePartCallback,
      required this.pauseVideo,
      required this.refreshReply});
  String bvid;
  int? cid;
  int? ssid;
  RxString title = "".obs;
  RxString describe = "".obs;

  late VideoInfo videoInfo;

  final bool isBangumi;
  final Function(String bvid, int cid) changePartCallback;
  final Function() refreshReply;
  final Function() pauseVideo;
  final CacheManager cacheManager =
      CacheManager(Config(CacheKeys.relatedVideosItemCoverKey));

  final List<Widget> partButtons = []; //分p按钮列表
  final List<Widget> relatedVideos = []; //相关视频列表

//加载视频信息
  Future<bool> loadVideoInfo() async {
    try {
      videoInfo = await VideoInfoApi.getVideoInfo(bvid: bvid);
    } catch (e) {
      log("loadVideoInfo:$e");
      return false;
    }
    title.value = videoInfo.title;
    describe.value = videoInfo.title;
    if (!isBangumi) {
      //当是普通视频时
      //初始化时构造分p按钮
      _loadVideoPartButtons();
      //构造相关视频
      await _loadRelatedVideos();
    } else {
      //如果是番剧
      await _loadBangumiPartButtons();
    }
    return true;
  }

  // _initData() {
  //   update(["introduction"]);
  // }

  //添加一个分p/剧集按钮
  void _addAButtion(String bvid, int cid, String text, int index) {
    partButtons.add(
      Padding(
        padding: const EdgeInsets.all(2),
        child: MaterialButton(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: Theme.of(Get.context!).colorScheme.primaryContainer,
            onPressed: () async {
              //点击切换分p
              changePartCallback(bvid, cid);
              if (isBangumi) {
                //如果是番剧的还，切换时还需要改变标题，简介
                videoInfo = await VideoInfoApi.getVideoInfo(bvid: bvid);
                title.value = videoInfo.title;
                describe.value = videoInfo.describe;
                //评论区也要刷新
                refreshReply();
              }
            },
            child: Text(text)),
      ),
    );
  }

  //构造分p按钮列表
  void _loadVideoPartButtons() {
    if (videoInfo.parts.length > 1) {
      for (int i = 0; i < videoInfo.parts.length; i++) {
        _addAButtion(bvid, videoInfo.parts[i].cid, videoInfo.parts[i].title, i);
      }
    }
  }

//构造番剧剧集按钮
  Future<void> _loadBangumiPartButtons() async {
    var bangumiInfo = await BangumiApi.getBangumiInfo(ssid: ssid);
    for (int i = 0; i < bangumiInfo.episodes.length; i++) {
      _addAButtion(bangumiInfo.episodes[i].bvid, bangumiInfo.episodes[i].cid,
          bangumiInfo.episodes[i].title, i);
    }
  }

//构造相关视频
  Future<void> _loadRelatedVideos() async {
    late List<RelatedVideoInfo> list;
    try {
      list = await RelatedVideoApi.getRelatedVideo(bvid: bvid);
    } catch (e) {
      log("构造相关视频失败:${e.toString()}");
    }
    for (var i in list) {
      relatedVideos.add(VideoTileItem(
        picUrl: i.coverUrl,
        bvid: i.bvid,
        title: i.title,
        upName: i.upName,
        duration: StringFormatUtils.timeLengthFormat(i.timeLength),
        playNum: i.playNum,
        pubDate: i.pubDate,
        cacheManager: cacheManager,
        onTap: (context) {
          pauseVideo();
          Get.to(
              () => BiliVideoPage(
                    bvid: i.bvid,
                    cid: i.cid,
                  ),
              preventDuplicates: false);
        },
      ));
    }
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  //   // _initData();
  // }

  @override
  void onClose() {
    cacheManager.emptyCache();
    super.onClose();
  }
}
