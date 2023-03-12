import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/network/reply/reply.dart';
import 'package:bili_you/common/models/network/reply/reply_reply.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class VideoReplyApi {
  static Future<ReplyResponse> requestVideoReply(
      {required String bvid,
      required int pageNum,
      VideoReplySort sort = VideoReplySort.like}) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.reply,
        queryParameters: {
          'oid': bvid,
          'pn': pageNum,
          'type': 1,
          'sort': sort.index
        },
        options: Options(responseType: ResponseType.plain));
    var ret = await compute((data) async {
      return ReplyResponse.fromRawJson(data);
    }, response.data);
    return ret;
  }

  static Future<ReplyReplyResponse> requestReplyReply({
    required String bvid,
    required int rootId,
    required int pageNum,
    int pageSize = 20,
  }) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.replyReply,
        queryParameters: {
          'type': 1,
          'oid': bvid,
          'root': rootId,
          'pn': pageNum,
          'ps': pageSize
        },
        options: Options(responseType: ResponseType.plain));
    var ret = await compute((data) async {
      return ReplyReplyResponse.fromRawJson(data);
    }, response.data);
    return ret;
  }
}

enum VideoReplySort { time, like, reply }
