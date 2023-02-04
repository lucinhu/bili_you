import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/video_info/video_info.dart';
import 'package:bili_you/common/models/video_info/video_parts.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:bili_you/main.reflectable.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:flutter/foundation.dart';

class VideoInfoApi {
  static Future<VideoInfoModel> requestVideoInfo({required String bvid}) async {
    var dio = MyDio.dio;
    var response =
        await dio.get(ApiConstants.videoInfo, queryParameters: {'bvid': bvid});
    var ret = await compute((data) async {
      initializeReflectable();
      return JsonMapper.deserialize<VideoInfoModel>(data)!;
    }, response.data);
    return ret;
  }

  static Future<VideoPartsModel> requestVideoParts(
      {required String bvid}) async {
    var dio = MyDio.dio;
    var response =
        await dio.get(ApiConstants.videoParts, queryParameters: {'bvid': bvid});
    var ret = await compute((data) {
      initializeReflectable();
      return JsonMapper.deserialize<VideoPartsModel>(data)!;
    }, response.data);
    return ret;
  }
}
