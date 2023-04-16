import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/api/video_operation_api.dart';
import 'package:bili_you/common/models/local/video/part_info.dart';
import 'package:bili_you/common/models/local/video/video_info.dart';
import 'package:bili_you/common/models/network/video_info/video_info.dart';
import 'package:bili_you/common/models/network/video_info/video_parts.dart';
import 'package:bili_you/common/utils/http_utils.dart';

class VideoInfoApi {
  static Future<VideoInfoResponse> _requestVideoInfo(
      {required String bvid}) async {
    var response = await HttpUtils().get(
      ApiConstants.videoInfo,
      queryParameters: {'bvid': bvid},
    );
    return VideoInfoResponse.fromJson(response.data);
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
        hasLike: await VideoOperationApi.hasLike(bvid: bvid),
        hasAddCoin: await VideoOperationApi.hasAddCoin(bvid: bvid),
        hasFavourite: await VideoOperationApi.hasFavourite(bvid: bvid));
  }

  static Future<VideoPartsResponse> _requestVideoParts(
      {required String bvid}) async {
    var response = await HttpUtils().get(
      ApiConstants.videoParts,
      queryParameters: {'bvid': bvid},
    );

    return VideoPartsResponse.fromJson(response.data);
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

  static Future<int> getFirstCid({required String bvid}) async {
    return (await getVideoParts(bvid: bvid)).first.cid;
  }
}
