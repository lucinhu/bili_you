import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/models/local/reply/add_reply_result.dart';
import 'package:bili_you/common/models/local/reply/reply_add_like_result.dart';
import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:bili_you/common/models/network/reply/reply.dart';
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

  ///# 发表评论
  ///
  ///type 评论区类型
  ///
  ///oid 目标评论区id
  ///
  ///root 根评论rpid（二级评论以上使用）
  ///
  ///parent 父评论rpid（二级评论同根评论id，若大于二级评论则为要回复的评论id）
  ///
  ///message 评论内容（最大10000字符，表情使用表情转义符）
  ///
  ///platform 发送平台标识
  static Future<AddReplyResult> addReply({
    required ReplyType type,
    required String oid,
    int? root,
    int? parent,
    required String message,
    ReplyPlatform platform = ReplyPlatform.web,
  }) async {
    var response =
        await HttpUtils().post(ApiConstants.addReply, queryParameters: {
      'type': type.code,
      'oid': oid,
      if (root != null) 'root': root,
      if (parent != null) 'parent': parent,
      'message': message,
      'plat': platform.index,
      'csrf': await CookieUtils.getCsrf()
    });
    return AddReplyResult(
        isSuccess: response.data?['code'] == 0,
        error: response.data?['message'] ?? '',
        replyItem: ReplyApi.replyItemRawToReplyItem(
            ReplyItemRaw.fromJson(response.data?['data']?['reply'] ?? {})));
  }
}

/// 发表评论用的平台标识
enum ReplyPlatform {
  unkown,
  web,
  android,
  ios,
  wp,
}
