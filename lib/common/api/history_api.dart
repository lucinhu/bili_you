import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/models/local/history/video_view_history_item.dart';
import 'package:bili_you/common/utils/http_utils.dart';

class HistoryApi {
  ///max是上一个历史记录的id，或者是oid
  ///viewAt是上一条记录的最后观看时间
  ///可以两者都设，也可任意设置一个
  static Future<List<VideoViewHistoryItem>> getVideoViewHistory(
      {int? max, int? viewAt}) async {
    var response =
        await HttpUtils().get(ApiConstants.viewHistory, queryParameters: {
      'type': 'archive',
      'business': 'archive',
      'ps': 20,
      if (max != null) 'max': max,
      if (viewAt != null) 'view_at': viewAt
    });
    if (response.data['code'] != 0) {
      throw 'getVideoViewHistory:code:${response.data['code']},message:${response.data['message']}';
    }
    List<VideoViewHistoryItem> list = [];
    for (Map<String, dynamic> i in response.data['data']['list']) {
      list.add(VideoViewHistoryItem(
          oid: i['history']['oid'],
          title: i['title'],
          cover: i['cover'],
          bvid: i['history']['bvid'],
          cid: i['history']['cid'],
          epid: i['history']['epid'],
          page: i['history']['page'],
          authorName: i['author_name'],
          viewAt: i['view_at'],
          progress: i['progress'],
          duration: i['duration']));
    }
    return list;
  }
}
