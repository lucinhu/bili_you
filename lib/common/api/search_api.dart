import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/api/wbi.dart';
import 'package:bili_you/common/models/local/reply/official_verify.dart';
import 'package:bili_you/common/models/local/reply/reply_member.dart';
import 'package:bili_you/common/models/local/search/default_search_word.dart';
import 'package:bili_you/common/models/local/search/hot_word_item.dart';
import 'package:bili_you/common/models/local/search/search_bangumi_item.dart';
import 'package:bili_you/common/models/local/search/search_suggest_item.dart';
import 'package:bili_you/common/models/local/search/search_user_item.dart';
import 'package:bili_you/common/models/network/search/default_search_word.dart';
import 'package:bili_you/common/models/network/search/hot_words.dart';
import 'package:bili_you/common/models/network/search/search_bangumi.dart';
import 'package:bili_you/common/models/network/search/search_suggest.dart';
import 'package:bili_you/common/models/network/search/search_video.dart';
import 'package:bili_you/common/models/local/search/search_video_item.dart';
import 'package:bili_you/common/utils/http_utils.dart';
import 'package:bili_you/common/utils/string_format_utils.dart';

class SearchApi {
  static Future<DefaultSearchWordResponse> _requestDefaultSearchWords() async {
    var response = await HttpUtils().get(ApiConstants.defualtSearchWord,
        queryParameters: await WbiSign.encodeParams({}));
    return DefaultSearchWordResponse.fromJson(response.data);
  }

  ///获取默认搜索词
  static Future<DefaultSearchWord> getDefaultSearchWords() async {
    var response = await _requestDefaultSearchWords();
    if (response.code != 0) {
      throw "getRequestDefaultSearchWords: code:${response.code}, message:${response.message}";
    }
    if (response.data == null) {
      return DefaultSearchWord.zero;
    }
    return DefaultSearchWord(
        showName: response.data!.showName ?? "",
        name: response.data!.name ?? "");
  }

  static Future<HotWordResponse> _requestHotWords() async {
    var response = await HttpUtils().get(ApiConstants.hotWordsMob);
    return HotWordResponse.fromJson(response.data);
  }

  ///获取热词列表
  static Future<List<HotWordItem>> getHotWords() async {
    List<HotWordItem> list = [];
    var response = await _requestHotWords();
    if (response.code != 0) {
      throw "getHotWords: code:${response.code}, message:${response.message}";
    }
    if (response.data == null || response.data!.list == null) {
      return list;
    }
    for (var i in response.data!.list!) {
      list.add(
          HotWordItem(keyWord: i.keyword ?? "", showWord: i.showName ?? ""));
    }
    return list;
  }

  static Future<SearchSuggestResponse> _requestSearchSuggests(
      String keyWord) async {
    var response = await HttpUtils().get(ApiConstants.searchSuggest,
        queryParameters: {'term': keyWord, "main_ver": 'v1'});
    return SearchSuggestResponse.fromJson(response.data);
  }

  ///根据keyWord获取搜索建议
  static Future<List<SearchSuggestItem>> getSearchSuggests(
      {required String keyWord}) async {
    List<SearchSuggestItem> list = [];
    var response = await _requestSearchSuggests(keyWord);
    if (response.code != 0) {
      throw "getSearchSuggests: code:${response.code}";
    }
    if (response.result == null || response.result!.tag == null) {
      return list;
    }
    for (var i in response.result!.tag!) {
      list.add(
          SearchSuggestItem(showWord: i.name ?? "", realWord: i.value ?? ""));
    }
    return list;
  }

  ///搜索请求
  ///keyword 搜索的词
  ///searchType 搜索类型
  ///page 页码
  ///order搜索结果排序方式
  static Future<dynamic> _requestSearch({
    required String keyword,
    required int page,
    required SearchType searchType,
    required SearchVideoOrder order,
  }) async {
    var response = await HttpUtils().get(
      ApiConstants.searchWithType,
      queryParameters: {
        'keyword': keyword,
        'search_type': searchType.value,
        'order': order.value,
        'page': page,
      },
    );
    if (searchType == SearchType.video) {
      return SearchVideoResponse.fromJson(response.data);
    } else {
      return BangumiSearchResponse.fromJson(response.data);
    }
  }

  ///搜索视频请求
  static Future<SearchVideoResponse> _requestSearchVideo({
    required String keyword,
    required int page,
    required SearchVideoOrder order,
  }) async {
    return await _requestSearch(
        keyword: keyword,
        page: page,
        searchType: SearchType.video,
        order: order);
  }

  ///搜索视频
  static Future<List<SearchVideoItem>> getSearchVideos({
    required String keyWord,
    required int page,
    required SearchVideoOrder order,
  }) async {
    List<SearchVideoItem> list = [];
    var response =
        await _requestSearchVideo(keyword: keyWord, page: page, order: order);
    if (response.code != 0) {
      throw "getSearchVideoList: code:${response.code}, message:${response.message}";
    }
    if (response.data == null || response.data!.result == null) {
      return list;
    }
    for (var i in response.data!.result!) {
      list.add(SearchVideoItem(
          coverUrl: "http:${i.pic ?? ""}",
          title: StringFormatUtils.replaceAllHtmlEntitiesToCharacter(
              StringFormatUtils.keyWordTitleToRawTitle(i.title ?? "")),
          bvid: i.bvid ?? "",
          upName: i.author ?? "",
          timeLength: Duration(
                  minutes: int.tryParse(i.duration!.split(':').first) ?? 0,
                  seconds: int.tryParse(i.duration!.split(':').last) ?? 0)
              .inSeconds,
          playNum: i.play ?? 0,
          pubDate: i.pubdate ?? 0));
    }
    return list;
  }

  ///搜索番剧请求
  static Future<BangumiSearchResponse> _requestSearchBangumi(
      {required String keyWord, required int page}) async {
    return await _requestSearch(
        keyword: keyWord,
        page: page,
        searchType: SearchType.bangumi,
        order: SearchVideoOrder.comprehensive);
  }

  ///搜索番剧
  static Future<List<SearchBangumiItem>> getSearchBangumis(
      {required String keyWord, required int page}) async {
    List<SearchBangumiItem> list = [];
    var response = await _requestSearchBangumi(keyWord: keyWord, page: page);
    if (response.code != 0) {
      throw "getSearchBanumis: code:${response.code}, message:${response.message}";
    }
    if (response.data == null || response.data!.result == null) {
      return list;
    }
    for (var i in response.data!.result!) {
      list.add(SearchBangumiItem(
          coverUrl: i.cover ?? "",
          title: StringFormatUtils.replaceAllHtmlEntitiesToCharacter(
              StringFormatUtils.keyWordTitleToRawTitle(i.title ?? "")),
          describe: "${i.areas}\n${i.styles}",
          score: i.mediaScore?.score ?? 0,
          ssid: i.seasonId!));
    }
    return list;
  }

  static Future<List<SearchUserItem>> getSearchUsers(
      {required String keyWord, required int page}) async {
    List<SearchUserItem> list = [];
    var response =
        await HttpUtils().get(ApiConstants.searchWithType, queryParameters: {
      'keyword': keyWord,
      'search_type': SearchType.user.value,
      'page': page,
    });
    if (response.data['code'] != 0) {
      throw "getSearchUsers: code:${response.data['code']}, message:${response.data['message']}";
    }
    for (Map<String, dynamic> i in response.data['data']?['result'] ?? []) {
      list.add(SearchUserItem(
          mid: i['mid'],
          name: i['uname'],
          face: "http:${i['upic']}",
          sign: i['usign'],
          fansCount: i['fans'],
          videoCount: i['videos'],
          level: i['level'],
          gender: Gender.values[i['gender'] - 1],
          isUpper: i['is_upuser'] == 1,
          isLive: i['is_live'] == 1,
          roomId: i['room_id'],
          officialVerify: OfficialVerify(
              type:
                  OfficialVerifyTypeCode.fromCode(i['official_verify']['type']),
              description: i['official_verify']['desc'])));
    }
    return list;
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
      ['video', 'media_bangumi', 'media_ft', 'live_room', 'bili_user'][index];
  String get name => ['视频', '番剧', '影视', '直播间', '用户'][index];
}
