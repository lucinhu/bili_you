import 'dart:developer';

import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/reply/reply.dart';
import 'package:bili_you/common/models/reply/reply_reply.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:bili_you/main.reflectable.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:flutter/foundation.dart';

class VideoReplyApi {
  static Future<ReplyModel> requestVideoReply(
      {required String bvid,
      required int pageNum,
      VideoReplySort sort = VideoReplySort.like}) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.reply, queryParameters: {
      'oid': bvid,
      'pn': pageNum,
      'type': 1,
      'sort': sort.index
    });
    var ret = await compute((data) async {
      initializeReflectable();
      return JsonMapper.deserialize<ReplyModel>(data);
    }, response.data);
    return ret!;
  }

  static Future<ReplyReplyModel> requestReplyReply({
    required String bvid,
    required int rootId,
    required int pageNum,
    int pageSize = 20,
  }) async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.replyReply, queryParameters: {
      'type': 1,
      'oid': bvid,
      'root': rootId,
      'pn': pageNum,
      'ps': pageSize
    });
    var start = DateTime.now();
    var ret = await compute((data) async {
      var start = DateTime.now();
      initializeReflectable();
      log((DateTime.now().millisecondsSinceEpoch - start.millisecondsSinceEpoch)
          .toString());
      return JsonMapper.deserialize<ReplyReplyModel>(data);
    }, response.data);
    log((DateTime.now().millisecondsSinceEpoch - start.millisecondsSinceEpoch)
        .toString());
    return ret!;
  }
}

enum VideoReplySort { time, like, reply }
