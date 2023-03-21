import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/models/local/video/click_like_result.dart';
import 'package:bili_you/common/utils/index.dart';
import 'package:dio/dio.dart';

///视频操作
class VideoOperationApi {
  ///点赞/取消赞
  static Future<ClickLikeResult> clickLike({
    required String bvid,
    //点赞还是取消赞
    required bool likeOrCancelLike,
  }) async {
    String csrf = "";
    //从cookie中获取csrf需要的数据
    for (var i in (await MyDio.cookieManager.cookieJar
        .loadForRequest(Uri.parse(ApiConstants.bilibiliBase)))) {
      if (i.name == 'bili_jct') {
        csrf = i.value;
        break;
      }
    }
    var response = await MyDio.dio.post(ApiConstants.like,
        queryParameters: {
          'bvid': bvid,
          'like': likeOrCancelLike ? 1 : 2,
          'csrf': csrf
        },
        options: Options(responseType: ResponseType.json));
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
    var response = await MyDio.dio.get(ApiConstants.hasLike,
        queryParameters: {'bvid': bvid},
        options: Options(responseType: ResponseType.json));
    return response.data['data'] == 1;
  }
}
