import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/local/bangumi/bangumi_info.dart';
import 'package:bili_you/common/models/local/bangumi/episode_info.dart';
import 'package:bili_you/common/models/network/bangumi/bangumi_info.dart';
import 'package:bili_you/common/utils/http_utils.dart';

class BangumiApi {
  //ssid(seaseon_id)或者epid都可以
  static Future<BangumiInfoResponse> _requestBangumiInfo(
      {int? ssid, int? epid}) async {
    var response = await HttpUtils().get(
      ApiConstants.bangumiInfo,
      queryParameters: {"season_id": ssid, "ep_id": epid},
    );
    return BangumiInfoResponse.fromJson(response.data);
  }

  //获取番剧信息
  static Future<BangumiInfo> getBangumiInfo({int? ssid, int? epid}) async {
    if (ssid == null && epid == null) {
      throw "getBangumiInfo: ssid和epid不能同时为空";
    }
    var response = await _requestBangumiInfo(ssid: ssid, epid: epid);
    if (response.code != 0) {
      throw "getBangumiInfo: code:${response.code}, message:${response.message}";
    }
    List<EpisodeInfo> episodes = [];
    for (var i in response.result?.episodes ?? <Episode>[]) {
      episodes.add(EpisodeInfo(
          title: i.longTitle ?? "", bvid: i.bvid ?? "", cid: i.cid ?? 0));
    }
    return BangumiInfo(
        title: response.result?.title ?? "",
        ssid: response.result?.seasonId ?? 0,
        episodes: episodes);
  }
}
