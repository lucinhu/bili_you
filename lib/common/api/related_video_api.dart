import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/network/related_video/related_video.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RelatedVideoApi {
  static Future<RelatedVideoResponse> requestRelatedVideo(
      {required String bvid}) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.relatedVideo,
        queryParameters: {'bvid': bvid},
        options: Options(responseType: ResponseType.plain));
    var ret = await compute((data) {
      return RelatedVideoResponse.fromRawJson(data);
    }, response.data);
    return ret;
  }
}
