import 'package:bili_you/common/models/local/reply/reply_item.dart';

class ReplyInfo {
  ReplyInfo(
      {required this.replies,
      required this.topReplies,
      required this.upperMid,
      required this.replyCount});
  static ReplyInfo get zero =>
      ReplyInfo(replies: [], topReplies: [], upperMid: 0, replyCount: 0);

  ///评论
  List<ReplyItem> replies;

  ///置顶评论
  List<ReplyItem> topReplies;

  ///up主的mid
  int upperMid;

  ///评论总数
  int replyCount;
}
