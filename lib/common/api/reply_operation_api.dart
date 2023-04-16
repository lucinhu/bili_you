import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/models/local/reply/reply_add_like_result.dart';
import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:bili_you/common/utils/cookie_util.dart';
import 'package:bili_you/common/utils/http_utils.dart';

class ReplyOperationApi {
  static Future<ReplyAddLikeResult> addLike(
      {required ReplyType type,
      required int oid,
      required int rpid,
      required bool likeOrUnlike}) async {
    var response =
        await HttpUtils().post(ApiConstants.replyAddLike, queryParameters: {
      'type': type.code,
      'oid': oid,
      'rpid': rpid,
      'action': likeOrUnlike ? 1 : 0,
      'csrf': await CookieUtils.getCsrf()
    });
    return ReplyAddLikeResult(
        isSuccess: response.data?['code'] == 0,
        error: response.data?['message'] ?? '');
  }
}
