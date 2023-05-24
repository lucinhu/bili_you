import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/api/wbi.dart';
import 'package:bili_you/common/models/local/user_space/user_video_search.dart';
import 'package:bili_you/common/models/network/user_space/user_video_search.dart';
import 'package:bili_you/common/utils/http_utils.dart';

class UserSpaceApi {
  static Future<UserVideoSearchResponse> _requestUserVideoSearch({
    required int mid,
    required int pageNum,
    String? keyword,
  }) async {
    //TODO order排序方式，tid分区筛选，keyword关键词筛选，ps每页项数，
    var response = await HttpUtils().get(ApiConstants.userVideoSearch,
        queryParameters: await WbiSign.encodeParams({
          "mid": mid,
          "pn": pageNum,
          "ps": 30,
          "keyword": keyword ?? "",
          "order": "pubdate",
          "tid": 0,
          "platform": "web",
        }));
    return UserVideoSearchResponse.fromJson(response.data);
  }

  static Future<UserVideoSearch> getUserVideoSearch({
    required int mid,
    required int pageNum,
    String? keyword,
  }) async {
    var response = await _requestUserVideoSearch(
        mid: mid, pageNum: pageNum, keyword: keyword);
    if (response.code != 0) {
      throw "getUserVideoSearch: code:${response.code}, message:${response.message}";
    }

    if (response.data == null ||
        response.data?.list == null ||
        response.data?.list?.vlist == null) {
      return UserVideoSearch.zero;
    }
    List<UserVideoItem> videos = [];
    for (var i in response.data!.list!.vlist!) {
      videos.add(UserVideoItem(
          author: i.author ?? "",
          title: i.title ?? "",
          mid: i.mid ?? 0,
          bvid: i.bvid ?? "",
          coverUrl: i.pic ?? "",
          danmakuCount: i.videoReview ?? 0,
          description: i.description ?? "",
          isUnionVideo: i.isUnionVideo == 1,
          playCount: i.play ?? 0,
          duration: i.length ?? "--:--",
          pubDate: i.created ?? 0,
          replyCount: i.comment ?? 0));
    }
    return UserVideoSearch(videos: videos);
  }
}
