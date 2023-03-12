import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/network/search/default_search_word.dart';
import 'package:bili_you/common/models/network/search/hot_words.dart';
import 'package:bili_you/common/models/network/search/search_bangumi.dart';
import 'package:bili_you/common/models/network/search/search_suggest.dart';
import 'package:bili_you/common/models/network/search/search_video.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SearchApi {
  static Future<DefaultSearchWordResponse> requestDefaultSearchWord() async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.defualtSearchWord);
    return DefaultSearchWordResponse.fromJson(response.data);
  }

  static Future<HotWordResponse> requestHotWorlds() async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.hotWordsMob);
    return HotWordResponse.fromJson(response.data);
  }

  static Future<SearchSuggestResponse> requestSearchSuggests(
      String keyWord) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.searchSuggest,
        queryParameters: {'term': keyWord, "main_ver": 'v1'});
    return SearchSuggestResponse.fromJson(response.data);
  }

  ///搜索视频请求
  ///keyword 搜索的词
  ///page 页码
  ///order搜索结果排序方式
  static Future<SearchVideoResponse> requestSearchVideo({
    required String keyword,
    required int page,
    SearchVideoOrder? order,
  }) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.searchWithType,
        queryParameters: {
          'keyword': keyword,
          'search_type': 'video',
          'order': order?.value ?? SearchVideoOrder.comprehensive,
          'page': page,
        },
        options: Options(responseType: ResponseType.plain));
    var ret = await compute((data) {
      return SearchVideoResponse.fromRawJson(response.data);
    }, response.data);
    return ret;
  }

  ///搜索番剧请求
  static Future<BangumiSearchResponse> requestSearchBangumi(
      {required String keyWord, required int page}) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.searchWithType, queryParameters: {
      'keyword': keyWord,
      'search_type': SearchType.bangumi.value,
      'page': page,
    });
    var ret = await compute((data) {
      return BangumiSearchResponse.fromJson(response.data);
    }, response.data);
    return ret;
  }
}

//视频搜索排序类型
enum SearchVideoOrder {
  //综合,默认
  comprehensive,
  //最多点击
  click,
  //最新发布
  pubdate,
  //最多弹幕
  danmaku,
  //最多收藏
  favorites,
  //最多评论
  comments
}

//视频搜索排序类型对应的字符串值实现
extension SearchVideoOrderExtension on SearchVideoOrder {
  String get value => ['', 'click', 'pubdate', 'dm', 'stow', 'scores'][index];
}

// 视频：video
// 番剧：media_bangumi
// 影视：media_ft
// 直播间及主播：live
// 直播间：live_room
// 主播：live_user
// 专栏：article
// 话题：topic
// 用户：bili_user
// 相簿：photo
// 搜索类型
enum SearchType {
  //视频
  video,
  //番剧
  bangumi,
  //影视
  movie,
  //直播间
  liveRoom,
  //用户
  user
}

extension SearchTypeExtension on SearchType {
  String get value =>
      ['video', 'media_bangumi', 'media_ft', 'live_room', 'user'][index];
}
