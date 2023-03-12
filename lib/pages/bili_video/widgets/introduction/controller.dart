import 'dart:developer';

import 'package:bili_you/common/api/bangumi_api.dart';
import 'package:bili_you/common/api/related_video_api.dart';
import 'package:bili_you/common/api/video_info_api.dart';
import 'package:bili_you/common/models/bangumi/bangumi_info.dart';
import 'package:bili_you/common/models/related_video/related_video.dart';
import 'package:bili_you/common/models/video_info/video_info.dart';
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
  late RxString title = "".obs;
  late RxString describe = "".obs;
  final bool isBangumi;
  late VideoInfoModel videoInfo;
  late BangumiInfoModel bangumiInfo;
  late RelatedVideoModel? relatedVideoModel;
  final Function(String bvid, int cid) changePartCallback;
  final Function() refreshReply;
  final Function() pauseVideo;
  final CacheManager cacheManager =
      CacheManager(Config(CacheKeys.relatedVideosItemCoverKey));

  final List<Widget> partButtons = []; //分p按钮列表
  final List<Widget> relatedVideos = []; //相关视频列表

//加载相关视频
  Future<void> _loadRelatedVideo() async {
    try {
      relatedVideoModel = await RelatedVideoApi.requestRelatedVideo(bvid: bvid);
    } catch (e) {
      log(e.toString());
    }
    return;
  }

//加载视频信息
  Future<bool> loadVideoInfo() async {
    try {
      videoInfo = await VideoInfoApi.requestVideoInfo(bvid: bvid);
      title.value = videoInfo.title;
      describe.value = videoInfo.desc;
      if (!isBangumi) {
        //当是普通视频时
        await _loadRelatedVideo(); //加载相关视频
        //初始化时构造分p按钮
        _loadVideoPartButtons();
        //构造相关视频
        _loadRelatedVideos();
      } else {
        //如果是番剧
        bangumiInfo = await BangumiApi.requestBangumiInfo(ssid: ssid);
        _loadBangumiPartButtons(bangumiInfo);
      }
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // _initData() {
  //   update(["introduction"]);
  // }

  //添加一个分p/剧集按钮
  _addAButtion(String bvid, int cid, String text, int index) {
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
                videoInfo = await VideoInfoApi.requestVideoInfo(bvid: bvid);
                title.value = videoInfo.title;
                describe.value = videoInfo.desc;
                //评论区也要刷新
                refreshReply();
              }
            },
            child: Text(text)),
      ),
    );
  }

  //构造分p按钮列表
  _loadVideoPartButtons() {
    if ((videoInfo.data?.pages ?? []).length > 1) {
      for (int i = 0; i < (videoInfo.data?.pages ?? []).length; i++) {
        _addAButtion(bvid, videoInfo.data!.pages![i].cid!,
            videoInfo.data!.pages![i].pagePart ?? '', i);
      }
    }
  }

//构造番剧剧集按钮
  _loadBangumiPartButtons(BangumiInfoModel bangumiInfoModel) {
    for (int i = 0; i < bangumiInfoModel.result!.episodes!.length; i++) {
      _addAButtion(
          bangumiInfoModel.result!.episodes![i].bvid!,
          bangumiInfoModel.result!.episodes![i].cid!,
          bangumiInfoModel.result!.episodes![i].longTitle!,
          i);
    }
  }

//构造相关视频
  _loadRelatedVideos() {
    if (relatedVideoModel != null) {
      for (var i in relatedVideoModel!.data) {
        relatedVideos.add(VideoTileItem(
          picUrl: i.pic,
          bvid: i.bvid,
          title: i.title,
          upName: i.owner.name,
          duration: StringFormatUtils.timeLengthFormat(i.duration),
          playNum: i.stat.view,
          pubDate: i.pubdate,
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
