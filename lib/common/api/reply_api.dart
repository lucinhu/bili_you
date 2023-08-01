import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/local/reply/reply_content.dart';
import 'package:bili_you/common/models/local/reply/reply_info.dart';
import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:bili_you/common/models/local/reply/reply_member.dart';
import 'package:bili_you/common/models/local/reply/reply_reply_info.dart';
import 'package:bili_you/common/models/local/reply/vip.dart';
import 'package:bili_you/common/models/network/reply/reply.dart' as reply_raw;
import 'package:bili_you/common/models/network/reply/reply_reply.dart'
    as reply_reply_raw;
import 'package:bili_you/common/utils/http_utils.dart';
import 'package:bili_you/common/utils/index.dart';
import 'package:flutter/foundation.dart';

import '../models/local/reply/official_verify.dart';

class ReplyApi {
  static Future<reply_raw.ReplyResponse> _requestReply(
      {required String oid,
      required int pageNum,
      required ReplyType type,
      ReplySort sort = ReplySort.like}) async {
    var response = await HttpUtils().get(
      ApiConstants.reply,
      queryParameters: {
        'oid': oid,
        'pn': pageNum,
        'type': type.code,
        'sort': sort.index
      },
    );
    return await compute(
        (response) => reply_raw.ReplyResponse.fromJson(response),
        response.data);
  }

  ///原始评论成员数据转评论成员数据
  static ReplyMember _replyMemberRawToReplyMember(reply_raw.MemberElement raw) {
    return ReplyMember(
        mid: int.tryParse(raw.mid ?? "0") ?? 0,
        name: raw.uname ?? "",
        gender: GenderText.fromText(raw.sex ?? ""),
        avatarUrl: raw.avatar ?? "",
        level: raw.levelInfo?.currentLevel ?? 0,
        officialVerify: OfficialVerify(
            type:
                OfficialVerifyTypeCode.fromCode(raw.officialVerify?.type ?? -1),
            description: raw.officialVerify?.desc ?? ""),
        vip: Vip(
            isVip: raw.vip?.vipStatus == 1 ? true : false,
            type: VipType.values[raw.vip?.vipType ?? 0]));
  }

  ///原始评论数据转评论数据
  static ReplyItem replyItemRawToReplyItem(reply_raw.ReplyItemRaw raw) {
    //将message中html字符实体改为对应的文字符号
    raw.content?.message = StringFormatUtils.replaceAllHtmlEntitiesToCharacter(
        raw.content?.message ?? "");
    //外显示评论
    List<ReplyItem> preReplies = [];
    for (var i in raw.replies ?? <reply_raw.ReplyItemRaw>[]) {
      preReplies.add(replyItemRawToReplyItem(i));
    }
    //at到的人
    List<ReplyMember> atMembers = [];
    for (var i in raw.content?.members ?? <reply_raw.MemberElement>[]) {
      atMembers.add(_replyMemberRawToReplyMember(i));
    }
    //表情
    List<Emote> emotes = [];
    raw.content?.emote?.forEach(
      (key, value) {
        emotes.add(Emote(
            text: value.text ?? "",
            url: value.url ?? "",
            size: value.meta?.size == 2 ? EmoteSize.big : EmoteSize.small));
      },
    );
    //tag
    List<String> tags = [];
    for (var i in raw.cardLabels ?? <reply_raw.CardLabel>[]) {
      tags.add(i.textContent ?? "");
    }
    //图片
    List<ReplyPicture> pictures = [];
    if (raw.content?.pictures != null) {
      for (var i in raw.content!.pictures!) {
        pictures.add(ReplyPicture(
            size: i.imgSize ?? 1,
            url: i.imgSrc ?? "",
            width: i.imgWidth ?? 0,
            height: i.imgHeight ?? 0));
      }
    }
    //链接
    List<ReplyJumpUrl> jumpUrls = [];
    raw.content?.jumpUrl?.forEach(
      (key, value) {
        jumpUrls.add(ReplyJumpUrl(url: key, title: value.title ?? key));
      },
    );
    return ReplyItem(
        rpid: raw.rpid ?? 0,
        oid: raw.oid ?? 0,
        type: ReplyTypeCode.fromCode(raw.type ?? 0),
        member: raw.member == null
            ? ReplyMember.zero
            : _replyMemberRawToReplyMember(raw.member!),
        rootRpid: raw.root ?? 0,
        parentRpid: raw.parent ?? 0,
        dialogRpid: raw.dialog ?? 0,
        replyCount: raw.count ?? 0,
        replyTime: raw.ctime ?? 0,
        preReplies: preReplies,
        likeCount: raw.like ?? 0,
        hasLike: raw.action == 1 ? true : false,
        location: raw.replyControl?.location?.replaceAll("IP属地：", "") ?? "",
        content: ReplyContent(
            message: raw.content?.message ?? "",
            atMembers: atMembers,
            emotes: emotes,
            pictures: pictures,
            jumpUrls: jumpUrls),
        tags: tags);
  }

  ///获取评论
  static Future<ReplyInfo> getReply(
      {required String oid,
      required int pageNum,
      required ReplyType type,
      ReplySort sort = ReplySort.like}) async {
    var response =
        await _requestReply(oid: oid, pageNum: pageNum, type: type, sort: sort);
    if (response.code != 0) {
      throw "getReplies: code:${response.code}, message:${response.message}";
    }
    if (response.data == null || response.data!.replies == null) {
      return ReplyInfo.zero;
    }
    return await compute((response) {
      List<ReplyItem> replies = [];
      for (var i in response.data!.replies!) {
        replies.add(replyItemRawToReplyItem(i));
      }
      List<ReplyItem> topReplies = [];
      if (response.data!.topReplies != null) {
        for (var i in response.data!.topReplies!) {
          topReplies.add(replyItemRawToReplyItem(i));
        }
      }
      return ReplyInfo(
          replies: replies,
          topReplies: topReplies,
          upperMid: response.data!.upper?.mid ?? 0,
          replyCount: response.data!.page?.acount ?? 0);
    }, response);
  }

  //请求评论的评论
  static Future<reply_reply_raw.ReplyReplyResponse> _requestReplyReply({
    required ReplyType type,
    required String oid,
    required int rootId,
    required int pageNum,
    int pageSize = 20,
  }) async {
    var response = await HttpUtils().get(
      ApiConstants.replyReply,
      queryParameters: {
        'type': type.code,
        'oid': oid,
        'root': rootId,
        'pn': pageNum,
        'ps': pageSize
      },
    );

    return reply_reply_raw.ReplyReplyResponse.fromJson(response.data);
  }

  ///获取评论的评论
  static Future<ReplyReplyInfo> getReplyReply({
    required ReplyType type,
    required String oid,
    required int rootId,
    required int pageNum,
    int pageSize = 20,
  }) async {
    var response = await _requestReplyReply(
        type: type, oid: oid, rootId: rootId, pageNum: pageNum);
    if (response.code != 0) {
      throw "getReplies: code:${response.code}, message:${response.message}";
    }
    if (response.data == null ||
        response.data!.replies == null ||
        response.data!.root == null) {
      return ReplyReplyInfo.zero;
    }
    List<ReplyItem> replies = [];
    for (var i in response.data!.replies!) {
      replies.add(replyItemRawToReplyItem(i));
    }
    return ReplyReplyInfo(
        replies: replies,
        rootReply: replyItemRawToReplyItem(response.data!.root!),
        upperMid: response.data!.upper?.mid ?? 0,
        replyCount: response.data!.page?.count ?? 0);
  }
}

enum ReplySort { time, like, reply }
