import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/models/local/video/click_add_coin_result.dart';
import 'package:bili_you/common/models/local/video/click_add_share_result.dart';
import 'package:bili_you/common/models/local/video/click_like_result.dart';
import 'package:bili_you/common/utils/cookie_util.dart';
import 'package:bili_you/common/utils/http_utils.dart';

///视频操作
class VideoOperationApi {
  ///点赞/取消赞
  static Future<ClickLikeResult> clickLike({
    required String bvid,
    //点赞还是取消赞
    required bool likeOrCancelLike,
  }) async {
    var response = await HttpUtils().post(
      ApiConstants.like,
      queryParameters: {
        'bvid': bvid,
        'like': likeOrCancelLike ? 1 : 2,
        'csrf': await CookieUtils.getCsrf()
      },
    );
    return ClickLikeResult(
        isSuccess: response.data['code'] == 0,
        error: response.data['message'],
        haslike:
            response.data['code'] == 0 ? likeOrCancelLike : !likeOrCancelLike);
  }

  ///判断视频是否已点赞
  ///true已点赞
  ///false未点赞
  static Future<bool> hasLike({required String bvid}) async {
    var response = await HttpUtils().get(
      ApiConstants.hasLike,
      queryParameters: {'bvid': bvid},
    );
    return response.data['data'] == 1;
  }

  ///判断是否已投币
  static Future<bool> hasAddCoin({required String bvid}) async {
    var response = await HttpUtils()
        .get(ApiConstants.hasAddCoin, queryParameters: {'bvid': bvid});
    return (response.data?['data']?['multiply'] ?? 0) > 0;
  }

  ///投币
  static Future<ClickAddCoinResult> addCoin(
      {required String bvid, int? num}) async {
    var response = await HttpUtils().post(ApiConstants.addCoin,
        queryParameters: {
          'bvid': bvid,
          'multiply': num ?? 1,
          'csrf': await CookieUtils.getCsrf()
        });
    if (response.data['code'] == 0) {
      return ClickAddCoinResult(isSuccess: true, error: '');
    } else {
      return ClickAddCoinResult(
          isSuccess: false, error: response.data['message']);
    }
  }

  ///判断是否已收藏
  static Future<bool> hasFavourite({required String bvid}) async {
    var response = await HttpUtils()
        .get(ApiConstants.hasFavourite, queryParameters: {'bvid': bvid});
    return response.data?['data']?['favoured'] == true;
  }

  ///收藏
  // static Future<> addFavourite({required String rid}) async{

  // }

  ///分享
  static Future<ClickAddShareResult> share({required String bvid}) async {
    var response = await HttpUtils().post(ApiConstants.share,
        queryParameters: {'bvid': bvid, 'csrf': await CookieUtils.getCsrf()});
    if (response.data['code'] == 0) {
      return ClickAddShareResult(
          isSuccess: true,
          error: '',
          currentShareNum: response.data['data'] ?? 0);
    } else {
      return ClickAddShareResult(
          isSuccess: false,
          error: response.data['message'],
          currentShareNum: response.data['data'] ?? 0);
    }
  }
}
