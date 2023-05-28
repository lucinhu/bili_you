import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/models/local/live/live_room_card_info.dart';
import 'package:bili_you/common/utils/http_utils.dart';

class LiveApi {
  static Future<List<LiveRoomCardInfo>> getUserRecommendLive(
      {required int pageNum, required int pageSize}) async {
    var response = await HttpUtils().get(ApiConstants.userRecommendLive,
        queryParameters: {
          'page': pageNum,
          'page_size': pageSize,
          'platform': 'web'
        });
    if (response.data['code'] != 0) {
      throw "getUserRecommendLive: code:${response.data['code']}, message:${response.data['message']}";
    }

    return [
      for (Map<String, dynamic> i in response.data['data']['list'])
        LiveRoomCardInfo(
            roomId: i['roomid'] ?? 0,
            uid: i['uid'] ?? 0,
            title: i['title'] ?? '',
            uname: i['uname'] ?? '',
            cover: i['cover'] ?? '',
            userFace: i['face'] ?? '',
            parentId: i['parent_id'] ?? 0,
            parentName: i['parent_name'] ?? '',
            areaId: i['area_id'] ?? 0,
            areaName: i['area_name'] ?? '',
            watchNum: i['watched_show']?['num'] ?? 0)
    ];
  }
}
