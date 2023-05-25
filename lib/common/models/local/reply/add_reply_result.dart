import 'package:bili_you/common/models/local/reply/reply_item.dart';

class AddReplyResult {
  AddReplyResult(
      {required this.isSuccess, required this.error, required this.replyItem});
  bool isSuccess;
  String error;
  ReplyItem replyItem;
}
