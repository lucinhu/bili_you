import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/related_video/related_video.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:bili_you/main.reflectable.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:flutter/foundation.dart';

class RelatedVideoApi {
  static Future<RelatedVideoModel> requestRelatedVideo(
      {required String bvid}) async {
    var dio = MyDio.dio;
    var response = await dio
        .get(ApiConstants.relatedVideo, queryParameters: {'bvid': bvid});
    var ret = await compute((data) {
      initializeReflectable();
      return JsonMapper.deserialize<RelatedVideoModel>(data)!;
    }, response.data);
    return ret;
  }
}
