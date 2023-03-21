import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/api/video_operation_api.dart';
import 'package:bili_you/common/models/local/video/part_info.dart';
import 'package:bili_you/common/models/local/video/video_info.dart';
import 'package:bili_you/common/models/network/video_info/video_info.dart';
import 'package:bili_you/common/models/network/video_info/video_parts.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class VideoInfoApi {
  static Future<VideoInfoResponse> _requestVideoInfo(
      {required String bvid}) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.videoInfo,
        queryParameters: {'bvid': bvid},
        options: Options(responseType: ResponseType.plain));
    var ret = await compute((data) async {
      return VideoInfoResponse.fromRawJson(data);
    }, response.data);
    return ret;
  }

  static Future<VideoInfo> getVideoInfo({required String bvid}) async {
    var response = await _requestVideoInfo(bvid: bvid);
    if (response.code != 0) {
      throw "getVideoInfo: code:${response.code}, message:${response.message}";
    }
    if (response.data == null) {
      return VideoInfo.zero;
    }
    String copyRight = "";
    switch (response.data!.copyright) {
      case 1:
        copyRight = "原创";
        break;
      case 2:
        copyRight = "转载";
        break;
    }
    List<PartInfo> parts = [];
    for (var i in response.data!.pages ?? <Page>[]) {
      parts.add(PartInfo(title: i.pagePart ?? "", cid: i.cid ?? 0));
    }
    return VideoInfo(
        title: response.data!.title ?? "",
        describe: response.data!.desc ?? "",
        bvid: response.data!.bvid ?? "",
        cid: response.data!.cid ?? 0,
        copyRight: copyRight,
        pubDate: response.data!.pubdate ?? 0,
        playNum: response.data!.stat?.view ?? 0,
        danmaukuNum: response.data!.stat?.danmaku ?? 0,
        coinNum: response.data!.stat?.coin ?? 0,
        favariteNum: response.data!.stat?.favorite ?? 0,
        likeNum: response.data!.stat?.like ?? 0,
        shareNum: response.data!.stat?.share ?? 0,
        ownerFace: response.data!.owner?.face ?? "",
        ownerMid: response.data!.owner?.mid ?? 0,
        ownerName: response.data!.owner?.name ?? "",
        parts: parts,
        hasLike: await VideoOperationApi.hasLike(bvid: bvid));
  }

  static Future<VideoPartsResponse> _requestVideoParts(
      {required String bvid}) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.videoParts,
        queryParameters: {'bvid': bvid},
        options: Options(responseType: ResponseType.plain));
    var ret = await compute((data) {
      return VideoPartsResponse.fromRawJson(data);
    }, response.data);
    return ret;
  }

  static Future<List<PartInfo>> getVideoParts({required String bvid}) async {
    List<PartInfo> list = [];
    var response = await _requestVideoParts(bvid: bvid);
    if (response.code != 0) {
      throw "getVideoParts: code:${response.code}, message:${response.message}";
    }
    if (response.data == null) {
      return list;
    }
    for (var i in response.data!) {
      list.add(PartInfo(title: i.datumPart ?? "", cid: i.cid ?? 0));
    }
    return list;
  }
}
