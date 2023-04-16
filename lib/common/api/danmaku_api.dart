import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/network/proto/danmaku/danmaku.pb.dart';
import 'package:bili_you/common/utils/http_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DanmakuApi {
  static Future<DmSegMobileReply> requestDanmaku(
      {int type = 1, required int cid, required int segmentIndex}) async {
    var ret = await compute((Map<String, int> params) async {
      var response = await HttpUtils().get(ApiConstants.danmaku,
          queryParameters: params,
          options: Options(responseType: ResponseType.bytes));
      return DmSegMobileReply.fromBuffer(response.data);
    }, {'type': type, 'oid': cid, 'segment_index': segmentIndex});
    return ret;
  }
}
