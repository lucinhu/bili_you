import 'dart:developer';

import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/api/danmaku_api.dart';
import 'package:bili_you/common/api/video_play_api.dart';
import 'package:bili_you/common/models/proto/danmaku/danmaku.pb.dart';
import 'package:bili_you/common/models/video_play/video_play.dart';
import 'package:fanjiao_danmu/fanjiao_danmu/adapter/fanjiao_danmu_adapter.dart';

import 'package:fanjiao_danmu/fanjiao_danmu/fanjiao_danmu.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class BiliVideoPlayerController extends GetxController {
  BiliVideoPlayerController({required this.bvid, required this.cid});
  VideoPlayerController? videoPlayerController;
  VideoPlayerController? audioPlayerController;
  DanmuController fanjiaoDanmuController =
      DanmuController(maxSize: 200, adapter: FanjiaoDanmuAdapter());

  //是否显示(由controll_pannel更新)
  RxBool showController = false.obs;
  //视频播放模型数据,存放声/画网络链接及其他信息.(由本控制器加载)
  late VideoPlayModel videoPlay;
  //视频是否真正播放(由本控制器更新)
  RxBool isPlaying = true.obs;
  //视频是否真正缓冲(由本控制器更新)
  RxBool isBufferring = true.obs;
  //视频是否到结尾了(由本控制器更新)
  RxBool isEnd = false.obs;
  //当前播放的进度,秒为单位(由本控制器更新)
  RxInt position = 0.obs;
  //是否全屏(由controll_pannel及fullscrenn_player更新,以便在这里使用的)
  bool isFullScreen = false;
  String bvid;
  int cid;

  //弹幕数据
  List<DmSegMobileReply> danmakuSegList = [];
  List<DanmakuElem> danmakuElemList = [];
  //弹幕字体大小缩放
  double danmakuFontScale = 0.6;
  //弹幕控制器是正在初始化
  bool isDanmakuControllerInitializing = false;
  //上一次的弹幕进度
  Duration lastDanmakuProgress = Duration.zero;
  //上一次弹幕分段索引
  int lastDanmakuSegIndex = 0;
  //上一次弹幕索引
  int lastDanmakuSegElemsIndex = 0;

  //计数
  int count = 0;

  _initData() {
    update(["bili_video_player"]);
  }

  Future<void> addDanmaku(
      DanmakuElem element, DanmuController fanjiaoDanmuController) async {
    try {
      if (element.mode == 1 || element.mode == 2 || element.mode == 3) {
        //普通弹幕
        fanjiaoDanmuController.addDanmu(DanmuModel(
            id: ++count,
            text: element.content,
            startTime: Duration(
              milliseconds: element.progress,
            ),
            textStyle: TextStyle(
                fontSize: element.fontsize.toDouble() * danmakuFontScale,
                color: Color.fromARGB(255, (element.color << 8) >> 24,
                    (element.color << 16) >> 24, (element.color << 24) >> 24)),
            flag: DanmuFlag.scroll));
      } else if (element.mode == 4) {
        //底部弹幕
        fanjiaoDanmuController.addDanmu(DanmuModel(
            id: ++count,
            text: element.content,
            startTime: Duration(
              milliseconds: element.progress,
            ),
            textStyle: TextStyle(
                fontSize: element.fontsize.toDouble() * danmakuFontScale,
                color: Color.fromARGB(255, (element.color << 8) >> 24,
                    (element.color << 16) >> 24, (element.color << 24) >> 24)),
            flag: DanmuFlag.bottom));
      } else if (element.mode == 5) {
        log(element.content + element.progress.toString());
        //顶部弹幕
        fanjiaoDanmuController.addDanmu(DanmuModel(
            id: ++count,
            text: element.content,
            startTime: Duration(
              milliseconds: element.progress,
            ),
            textStyle: TextStyle(
                fontSize: element.fontsize.toDouble() * danmakuFontScale,
                color: Color.fromARGB(255, (element.color << 8) >> 24,
                    (element.color << 16) >> 24, (element.color << 24) >> 24)),
            flag: DanmuFlag.top));
      }
    } catch (e) {
      log(e.toString());
    }

    return;
  }

  whenDanmakuEmpty(DanmuController fanjiaoDanmuController) {
    if (fanjiaoDanmuController.danmuItems.isEmpty) {
      var currentSegIndex =
          (fanjiaoDanmuController.progress.inMilliseconds / 360000.0).ceil();
      if (currentSegIndex != 0) {
        currentSegIndex -= 1;
      }
      lastDanmakuSegIndex = currentSegIndex;
      int elementCount = 0;
      var maxSize = fanjiaoDanmuController.maxSize;
      var positionIndex = 0;
      if (currentSegIndex < danmakuSegList.length) {
        //找出当前的位置所对应的弹幕索引
        for (;
            positionIndex < danmakuSegList[currentSegIndex].elems.length;
            positionIndex++) {
          if (danmakuSegList[currentSegIndex].elems[positionIndex].progress >=
              fanjiaoDanmuController.progress.inMilliseconds) {
            break;
          }
        }
        lastDanmakuSegElemsIndex = positionIndex;
        //添加前半部分弹幕
        var preList = [];
        for (int i = positionIndex;
            i >= 0 && preList.length <= maxSize / 2;
            i--) {
          preList.add(danmakuSegList[currentSegIndex].elems[i]);
        }
        if (preList.length <= maxSize / 2 && currentSegIndex - 1 >= 0) {
          for (var element
              in danmakuSegList[currentSegIndex - 1].elems.reversed) {
            preList.add(element);
            if (preList.length == maxSize / 2) {
              break;
            }
          }
        }
        for (var element in preList.reversed) {
          addDanmaku(element, fanjiaoDanmuController);
          elementCount++;
        }
        //后半部分
        for (var i = positionIndex + 1;
            i < danmakuSegList[currentSegIndex].elems.length &&
                elementCount < maxSize;
            i++) {
          addDanmaku(
              danmakuSegList[currentSegIndex].elems[i], fanjiaoDanmuController);
          elementCount++;
          lastDanmakuSegElemsIndex = i;
        }
        if (elementCount < maxSize &&
            currentSegIndex + 1 < danmakuSegList.length) {
          lastDanmakuSegIndex = currentSegIndex + 1;
          lastDanmakuSegElemsIndex = 0;
          for (var element in danmakuSegList[currentSegIndex + 1].elems) {
            addDanmaku(element, fanjiaoDanmuController);
            elementCount++;
            lastDanmakuSegElemsIndex++;
            if (elementCount == maxSize) {
              break;
            }
          }
        }
      }
    }
  }

  initDanmakuController(DanmuController fanjiaoDanmuController) {
    fanjiaoDanmuController
        .setDuration(Duration(milliseconds: videoPlay.timelength));
    fanjiaoDanmuController.addStatusListener((status) {
      if (status == DanmuStatus.playing) {
        log('danmu playing');
      } else if (status == DanmuStatus.pause) {
        log('danmu pause');
      } else if (status == DanmuStatus.stop) {
        log('danmu stop');
      }
    });
    fanjiaoDanmuController.addListener(() {
      if (videoPlayerController != null) {
        if (!(videoPlayerController!.value.isPlaying) &&
            !(audioPlayerController!.value.isPlaying)) {
          pauseDanmaku(fanjiaoDanmuController);
        }
        if ((videoPlayerController!.value.position.inMilliseconds -
                    fanjiaoDanmuController.progress.inMilliseconds)
                .abs() >=
            1000) {
          fanjiaoDanmuController.progress =
              videoPlayerController!.value.position;
        }
      }
      var progressDelta = fanjiaoDanmuController.progress.inMilliseconds -
          lastDanmakuProgress.inMilliseconds;
      if (progressDelta < 0) {
        fanjiaoDanmuController.clearDanmu();
      } else if (fanjiaoDanmuController.danmuItems.isNotEmpty &&
          fanjiaoDanmuController.progress.inMilliseconds -
                  fanjiaoDanmuController
                      .danmuItems.last.model.startTime.inMilliseconds >
              0 &&
          progressDelta >
              fanjiaoDanmuController.progress.inMilliseconds -
                  fanjiaoDanmuController
                      .danmuItems.last.model.startTime.inMilliseconds) {
        fanjiaoDanmuController.clearDanmu();
      }

      lastDanmakuProgress = fanjiaoDanmuController.progress;

      //当没有弹幕时
      whenDanmakuEmpty(fanjiaoDanmuController);

      //如果有空位,则接着上一次补一段
      if (fanjiaoDanmuController.danmuItems.isNotEmpty &&
          fanjiaoDanmuController.danmuItems.length <
              fanjiaoDanmuController.maxSize) {
        for (int i = lastDanmakuSegElemsIndex + 1;
            i < danmakuSegList[lastDanmakuSegIndex].elems.length;
            i++) {
          addDanmaku(danmakuSegList[lastDanmakuSegIndex].elems[i],
              fanjiaoDanmuController);
          lastDanmakuSegElemsIndex = i;
          if (fanjiaoDanmuController.danmuItems.length ==
              fanjiaoDanmuController.maxSize) {
            break;
          }
        }
      }
      //如果补完一段都还有空位,就再接着补下一段
      if (fanjiaoDanmuController.danmuItems.length <
              fanjiaoDanmuController.maxSize &&
          lastDanmakuSegIndex + 1 < danmakuSegList.length) {
        lastDanmakuSegIndex++;
        lastDanmakuSegElemsIndex = 0;
        for (int i = 0;
            i < danmakuSegList[lastDanmakuSegIndex].elems.length;
            i++) {
          addDanmaku(danmakuSegList[lastDanmakuSegIndex].elems[i],
              fanjiaoDanmuController);
          lastDanmakuSegElemsIndex = i;
          if (fanjiaoDanmuController.danmuItems.length ==
              fanjiaoDanmuController.maxSize) {
            break;
          }
        }
      }
    });
  }

  pauseDanmaku(DanmuController fanjiaoDanmuController) {
    try {
      fanjiaoDanmuController.pause();
    } catch (_) {}
  }

  startDanmaku(DanmuController fanjiaoDanmuController) {
    try {
      fanjiaoDanmuController.start();
    } catch (_) {}
  }

  Future<void> loadDanmaku() async {
    danmakuSegList.clear();
    var segmentCount = (videoPlay.timelength / 360000.0).ceil();
    for (int i = 1; i <= segmentCount; i++) {
      DmSegMobileReply danmakuSeg;
      try {
        danmakuSeg = await DanmakuApi.requestDanmaku(cid: cid, segmentIndex: i);
        danmakuSeg.elems.sort((a, b) {
          return a.progress - b.progress;
        });
        danmakuSegList.add(danmakuSeg);
      } catch (e) {
        log("loadDanmaku:$e");
        return;
      }
    }
  }

  danmakuFirstInit() {
    if (isDanmakuControllerInitializing && danmakuSegList.isNotEmpty) {
      int elementCount = 0;
      for (var element in danmakuSegList[0].elems) {
        if (element.progress >=
                fanjiaoDanmuController.progress.inMilliseconds &&
            elementCount < fanjiaoDanmuController.maxSize) {
          addDanmaku(element, fanjiaoDanmuController);
          elementCount++;
        } else if (elementCount >= fanjiaoDanmuController.maxSize) {
          break;
        }
      }
      startDanmaku(fanjiaoDanmuController);

      isDanmakuControllerInitializing = false;
    }
  }

  void syncDanmakuByVideo(DanmuController fanjiaoDanmuController) async {
    if (audioPlayerController!.value.isPlaying &&
        fanjiaoDanmuController.state == DanmuStatus.pause) {
      if (fanjiaoDanmuController.progress !=
          (await videoPlayerController!.position)!) {
        log('set1');
        fanjiaoDanmuController.progress =
            (await videoPlayerController!.position)!;
      }
      startDanmaku(fanjiaoDanmuController);
    }
  }

  void syncDanmakuByAudio(DanmuController fanjiaoDanmuController) async {
    if (videoPlayerController!.value.isPlaying &&
        fanjiaoDanmuController.state == DanmuStatus.pause) {
      if (fanjiaoDanmuController.progress !=
          (await audioPlayerController!.position)!) {
        log('set1');
        fanjiaoDanmuController.progress =
            (await audioPlayerController!.position)!;
      }
      startDanmaku(fanjiaoDanmuController);
    }
  }

  Future<void> loadVideo() async {
    try {
      videoPlay = await VideoPlayApi.requestVideoPlay(
          bvid: bvid, cid: cid, qn: 0, fnval: 80);
      //音频源
      var audioUrl = videoPlay.dash.audio[0].baseUrl;
      audioPlayerController = VideoPlayerController.network(audioUrl,
          videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true, allowBackgroundPlayback: true),
          httpHeaders: {
            'user-agent': ApiConstants.userAgent,
            'referer': ApiConstants.bilibiliBase
          });

      //视频源
      var url = videoPlay.dash.video[0].baseUrl;

      videoPlayerController = VideoPlayerController.network(url,
          videoPlayerOptions: VideoPlayerOptions(
              allowBackgroundPlayback: true, mixWithOthers: true),
          httpHeaders: {
            'user-agent': ApiConstants.userAgent,
            'referer': ApiConstants.bilibiliBase
          });
      if (videoPlayerController!.value.isInitialized == false) {
        await videoPlayerController!.initialize(); //确保videoPlayerController已初始化
      }
      if (audioPlayerController!.value.isInitialized == false) {
        await audioPlayerController!.initialize(); //初始化音频
      }
    } catch (e) {
      log("bili_video_player/controller ${e.toString()}");
      disposeAllControllers();
      return;
    }
    videoPlayerController!.addListener(() {
      var isVideoPlaying = videoPlayerController!.value.isPlaying;
      var isAudioPlaying = audioPlayerController!.value.isPlaying;
      var isVideoBuffering = videoPlayerController!.value.isBuffering;
      var isAudioBuffering = audioPlayerController!.value.isBuffering;
      var videoPosition = videoPlayerController!.value.position;
      var audioPosition = audioPlayerController!.value.position;
      var max = videoPlayerController!.value.duration;
      danmakuFirstInit();
      if (isFullScreen) {
        pauseDanmaku(fanjiaoDanmuController);
      } else {
        syncDanmakuByVideo(fanjiaoDanmuController);
      }

      //更新秒进度
      if (videoPosition.inSeconds != position.value) {
        position.value = videoPosition.inSeconds;
      }

      if (isPlaying.value && isVideoPlaying) {
        if (isVideoBuffering) {
          isBufferring.value = true;
        }
        if (isBufferring.value) {
          if (!isVideoBuffering && isVideoPlaying && !isAudioPlaying) {
            if (audioPosition < videoPosition) {
              audioPlayerController!.seekTo(videoPosition);
            }
            audioPlayerController!.play();

            isBufferring.value = false;
          }
          if (isAudioBuffering && !isVideoBuffering && isVideoPlaying) {
            videoPlayerController!.pause();
          }
        }
      } else if (videoPosition == max && max != Duration.zero) {
        isEnd.value = true;
        isPlaying.value = false;
        isBufferring.value = false;
      } else if (!isAudioPlaying && !isVideoPlaying) {
        isPlaying.value = false;
        isBufferring.value = false;
      } else if (isAudioPlaying && isVideoPlaying) {
        isPlaying.value = true;
      }

      //如果视频在播放,就保持亮屏,除非暂停播放(退出界面也会,因为我在dispose前写了暂停播放)
      if (isPlaying.value) {
        Wakelock.enable();
      } else {
        Wakelock.disable();
      }
    });

    audioPlayerController!.addListener(() {
      var isVideoPlaying = videoPlayerController!.value.isPlaying;
      var isAudioPlaying = audioPlayerController!.value.isPlaying;
      var isVideoBuffering = videoPlayerController!.value.isBuffering;
      var isAudioBuffering = audioPlayerController!.value.isBuffering;
      var videoPosition = videoPlayerController!.value.position;
      var audioPosition = audioPlayerController!.value.position;
      var max = videoPlayerController!.value.duration;

      if (isPlaying.value && isAudioPlaying) {
        if (isAudioBuffering) {
          isBufferring.value = true;
        }
        if (isBufferring.value) {
          if (!isAudioBuffering && isAudioPlaying && !isVideoPlaying) {
            if (videoPosition < audioPosition) {
              videoPlayerController!
                  .seekTo(audioPlayerController!.value.position);
            }
            videoPlayerController!.play();

            isBufferring.value = false;
          }
          if (isVideoBuffering && !isAudioBuffering && isAudioPlaying) {
            audioPlayerController!.pause();
          }
        }
      } else if (audioPosition == max) {
        isEnd.value = true;
        isPlaying.value = false;
        isBufferring.value = false;
      } else if (!isAudioPlaying && !isVideoPlaying) {
        isPlaying.value = false;
        isBufferring.value = false;
      } else if (isAudioPlaying && isVideoPlaying) {
        isPlaying.value = true;
      }
    });

    return;
  }

  Future<void> load() async {
    await loadVideo();

    loadDanmaku();
  }
  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  changePart(int partCid) {
    cid = partCid;
    update(["bili_video_player"]);
  }

  Future<void> disposeAllControllers() async {
    videoPlayerController?.pause();
    audioPlayerController?.pause();
    videoPlayerController?.dispose();
    audioPlayerController?.dispose();
    videoPlayerController = null;
    audioPlayerController = null;
  }

  @override
  void onClose() async {
    super.onClose();
    await disposeAllControllers();
  }
}
