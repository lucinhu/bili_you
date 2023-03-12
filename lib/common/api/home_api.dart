import 'package:bili_you/common/models/network/home/recommend_video.dart';
import 'package:dio/dio.dart';
import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:flutter/foundation.dart';

class HomeApi {
  ///#### 获取首页推荐
  ///[num]需要获取多少条推荐视频
  ///[refreshIdx]刷新加载的次数
  ///无null错误
  static Future<RecommendVideoResponse> requestRecommendVideos(
      int num, int refreshIdx) async {
    Dio dio = MyDio.dio;
    Response response;
    response = await dio.get(ApiConstants.recommendItems,
        queryParameters: {
          'user-agent': ApiConstants.userAgent,
          'feed_version': "V3",
          'ps': num,
          'fresh_idx': refreshIdx
        },
        options: Options(responseType: ResponseType.plain));
    var ret = await compute((message) async {
      return RecommendVideoResponse.fromRawJson(message);
    }, response.data);
    return ret;
  }
}
