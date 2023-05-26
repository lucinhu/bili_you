import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/local/video_tile/video_tile_info.dart';
import 'package:bili_you/common/models/network/related_video/related_video.dart';
import 'package:bili_you/common/utils/http_utils.dart';

class RelatedVideoApi {
  static Future<RelatedVideoResponse> _requestRelatedVideo(
      {required String bvid}) async {
    var response = await HttpUtils().get(
      ApiConstants.relatedVideo,
      queryParameters: {'bvid': bvid},
    );
    return RelatedVideoResponse.fromJson(response.data);
  }

  ///获取相关视频
  static Future<List<VideoTileInfo>> getRelatedVideo(
      {required String bvid}) async {
    List<VideoTileInfo> list = [];
    var response = await _requestRelatedVideo(bvid: bvid);
    if (response.code != 0) {
      throw "getRelatedVideo: code:${response.code}, message:${response.message}";
    }
    if (response.data == null) {
      return list;
    }
    for (var i in response.data!) {
      list.add(VideoTileInfo(
          coverUrl: i.pic ?? "",
          bvid: i.bvid ?? "",
          cid: i.cid ?? 0,
          title: i.title ?? "",
          upName: i.owner?.name ?? "",
          timeLength: i.duration ?? 0,
          playNum: i.stat?.view ?? 0,
          pubDate: i.pubdate ?? 0));
    }
    return list;
  }
}
