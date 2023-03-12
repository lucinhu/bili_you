import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/network/video_info/video_info.dart';
import 'package:bili_you/common/models/network/video_info/video_parts.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class VideoInfoApi {
  static Future<VideoInfoResponse> requestVideoInfo(
      {required String bvid}) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.videoInfo,
        queryParameters: {'bvid': bvid},
        options: Options(responseType: ResponseType.plain));
    var ret = await compute((data) async {
      return VideoInfoResponse.fromRawJson(data);
    }, response.data);
    return ret;
  }

  static Future<VideoPartsResponse> requestVideoParts(
      {required String bvid}) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.videoParts,
        queryParameters: {'bvid': bvid},
        options: Options(responseType: ResponseType.plain));
    var ret = await compute((data) {
      return VideoPartsResponse.fromRawJson(data);
    }, response.data);
    return ret;
  }
}
