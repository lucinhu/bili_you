import 'package:bili_you/common/models/local/home/recommend_item_info.dart';
import 'package:bili_you/common/models/network/home/recommend_video.dart';
import 'package:bili_you/common/utils/http_utils.dart';
import 'package:bili_you/common/api/api_constants.dart';

class HomeApi {
  static Future<RecommendVideoResponse> _requestRecommendVideos(
      int num, int refreshIdx) async {
    var response = await HttpUtils().get(
      ApiConstants.recommendItems,
      queryParameters: {
        'user-agent': ApiConstants.userAgent,
        'feed_version': "V3",
        'ps': num,
        'fresh_idx': refreshIdx
      },
    );
    return RecommendVideoResponse.fromJson(response.data);
  }

  ///#### 获取首页推荐
  ///[num]需要获取多少条推荐视频
  ///[refreshIdx]刷新加载的次数
  static Future<List<RecommendVideoItemInfo>> getRecommendVideoItems(
      {required int num, required int refreshIdx}) async {
    late RecommendVideoResponse response;
    response = await _requestRecommendVideos(num, refreshIdx);
    List<RecommendVideoItemInfo> list = [];
    if (response.code != 0) {
      throw "getRecommendVideoItems: code:${response.code}, message:${response.message}";
    }
    if (response.data == null || response.data!.item == null) {
      return list;
    }
    for (var i in response.data!.item!) {
      list.add(RecommendVideoItemInfo(
          coverUrl: i.pic ?? "",
          danmakuNum: i.stat?.danmaku ?? 0,
          timeLength: i.duration ?? 0,
          title: i.title ?? "",
          upName: i.owner?.name ?? "",
          bvid: i.bvid ?? "",
          cid: i.cid ?? 0,
          playNum: i.stat?.view ?? 0));
    }
    return list;
  }
}
