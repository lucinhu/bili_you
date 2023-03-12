import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/network/video_play/video_play.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class VideoPlayApi {
  static Future<VideoPlayResponse> requestVideoPlay(
      {required String bvid,
      required int cid,
      int qn = 116,
      int fnval = 0,
      int fourk = 1}) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.videoPlay,
        queryParameters: {
          'bvid': bvid,
          'cid': cid,
          'qn': qn,
          'fnver': 0,
          'fnval': fnval,
          'fourk': fourk
        },
        options: Options(headers: {
          'user_agent': ApiConstants.userAgent,
        }, responseType: ResponseType.plain));
    var ret = await compute((data) async {
      return VideoPlayResponse.fromRawJson(data);
    }, response.data);
    return ret;
  }

  static Map<String, String> videoPlayerHttpHeaders = {
    'user-agent': ApiConstants.userAgent,
    'referer': ApiConstants.bilibiliBase
  };

  // static Future<String> requestVideoPlayUrlInDurl(
  //     {required String bvid, required int cid}) async {
  //   var data = await requestVideoPlay(bvid: bvid, cid: cid, qn: 116);
  //   return data.durl[0].url;
  // }
}
