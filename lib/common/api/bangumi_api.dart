import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/bangumi/bangumi_info.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:flutter/foundation.dart';

class BangumiApi {
  //ssid(seaseon_id)或者epid都可以
  static Future<BangumiInfoModel> requestBangumiInfo(
      {int? ssid, int? epid}) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.bangumiInfo,
        queryParameters: {"season_id": ssid, "ep_id": epid});
    var ret = await compute((message) async {
      return BangumiInfoModel.fromJson(message);
    }, response.data);
    return ret;
  }
}
