import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/network/bangumi/bangumi_info.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BangumiApi {
  //ssid(seaseon_id)或者epid都可以
  static Future<BangumiInfoResponse> requestBangumiInfo(
      {int? ssid, int? epid}) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.bangumiInfo,
        queryParameters: {"season_id": ssid, "ep_id": epid},
        options: Options(responseType: ResponseType.plain));
    var ret = await compute((message) async {
      return BangumiInfoResponse.fromRawJson(message);
    }, response.data);
    return ret;
  }
}
