import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/models/local/history/video_view_history_item.dart';
import 'package:bili_you/common/models/network/history/report_history.dart';
import 'package:bili_you/common/utils/http_utils.dart';

import '../utils/cookie_util.dart';

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
          duration: i['duration'],
          isFinished: i['is_finish'] != 0 || i['progress'] < 0));
    }
    return list;
  }

  /// 汇报历史记录
  static Future<bool> reportVideoViewHistory(
      {required int aid, required int cid, int? progress}) async {
    var response =
        await HttpUtils().post(ApiConstants.reportHistory, queryParameters: {
      "aid": aid,
      "cid": cid,
      "progress": progress ?? 0,
      "platform": "android",
      "csrf": await CookieUtils.getCsrf()
    });
    var json = ReportHistory.fromJson(response.data);
    if (json.code != 0) {
      throw 'report_history:code:${json.code},raw:"${response.data}"';
    }
    return true;
  }
}
