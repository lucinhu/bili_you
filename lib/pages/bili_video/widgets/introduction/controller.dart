import 'dart:developer';

import 'package:bili_you/common/api/related_video_api.dart';
import 'package:bili_you/common/api/video_info_api.dart';
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
      required this.changePartCallback,
      required this.stopVideo});
  final String bvid;
  late VideoInfoModel videoInfo;
  late RelatedVideoModel? relatedVideoModel;
  final Function(int cid) changePartCallback;
  final Function() stopVideo;

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
  Future<void> loadVideoInfo() async {
    try {
      await _loadRelatedVideo(); //加载相关视频
      videoInfo = await VideoInfoApi.requestVideoInfo(bvid: bvid);
      //初始化时构造分p按钮
      _loadPartButtons();
      //构造相关视频
      _loadRelatedVideos();
      return;
    } catch (e) {
      log(e.toString());
      return;
    }
  }

  _initData() {
    update(["introduction"]);
  }

  _loadPartButtons() {
    //构造分p按钮列表
    for (var i in videoInfo.pages) {
      partButtons.add(
        Padding(
          padding: const EdgeInsets.all(2),
          child: MaterialButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: Theme.of(Get.context!).colorScheme.primaryContainer,
              onPressed: () {
                //点击切换分p
                changePartCallback(i.cid);
              },
              child: Builder(
                builder: (context) {
                  if (i.part.isNotEmpty) {
                    return Text(i.part);
                  } else {
                    return Container();
                  }
                },
              )),
        ),
      );
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
          cacheManager:
              CacheManager(Config(CacheKeys.relatedVideosItemCoverKey)),
          onTap: (context) {
            stopVideo();
            Get.to(() => BiliVideoPage(bvid: i.bvid, cid: i.cid),
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

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
