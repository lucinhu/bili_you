import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/network/user_space/user_video_search.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class UserSpaceApi {
  static Future<UserVideoSearchResponse> requestUserVideoSearch({
    required int mid,
    required int pageNum,
    String? keyword,
  }) async {
    var dio = MyDio.dio;
    //TODO order排序方式，tid分区筛选，keyword关键词筛选，ps每页项数，
    var response = await dio.get(ApiConstants.userVideoSearch,
        queryParameters: {
          "mid": mid,
          "pn": pageNum,
          "ps": 30,
          "keyword": keyword,
          "order": "pubdate",
          "tid": 0,
        },
        options: Options(headers: {
          'user-agent': ApiConstants.userAgent,
        }));
    var ret = await compute((message) async {
      return UserVideoSearchResponse.fromJson(message);
    }, response.data);
    return ret;
  }
}
