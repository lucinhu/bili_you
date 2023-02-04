import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/search/default_search_word.dart';
import 'package:bili_you/common/models/search/hot_words.dart';
import 'package:bili_you/common/models/search/search_suggest.dart';
import 'package:bili_you/common/models/search/search_video.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:bili_you/main.reflectable.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:flutter/foundation.dart';

class SearchApi {
  static Future<DefaultSearchWordModel> requestDefaultSearchWord() async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.defualtSearchWord);
    return JsonMapper.deserialize<DefaultSearchWordModel>(response.data)!;
  }

  static Future<HotWordsModel> requestHotWorlds() async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.hotWordsMob);
    return JsonMapper.deserialize<HotWordsModel>(response.data)!;
  }

  static Future<SearchSuggestModel> requestSearchSuggests(
      String keyWord) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.searchSuggest,
        queryParameters: {'term': keyWord, "main_ver": 'v1'});
    return JsonMapper.deserialize<SearchSuggestModel>(response.data)!;
  }

  ///搜索视频请求
  ///keyword 搜索的词
  ///page 页码
  ///order搜索结果排序方式
  static Future<SearchVideoModel> requestSearchVideo({
    required String keyword,
    required int page,
    SearchVideoOrder? order,
  }) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.searchWithType, queryParameters: {
      'keyword': keyword,
      'search_type': 'video',
      'order': order?.value ?? SearchVideoOrder.comprehensive,
      'page': page,
    });
    var ret = await compute((data) {
      initializeReflectable();
      return JsonMapper.deserialize<SearchVideoModel>(data)!;
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
