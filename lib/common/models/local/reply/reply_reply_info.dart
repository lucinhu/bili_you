import 'package:bili_you/common/models/local/reply/reply_item.dart';

class ReplyReplyInfo {
  ReplyReplyInfo(
      {required this.replies,
      required this.rootReply,
      required this.upperMid,
      required this.replyCount});
  static ReplyReplyInfo get zero => ReplyReplyInfo(
      replies: [], rootReply: ReplyItem.zero, upperMid: 0, replyCount: 0);
  List<ReplyItem> replies;
  ReplyItem rootReply;
  int upperMid;

  ///评论总数
  int replyCount;
}
