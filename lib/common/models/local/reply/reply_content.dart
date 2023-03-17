import 'package:bili_you/common/models/local/reply/reply_member.dart';

class ReplyContent {
  ReplyContent(
      {required this.message, required this.atMembers, required this.emotes});
  static get zero {
    return ReplyContent(message: "", atMembers: [], emotes: []);
  }

  ///评论
  String message;

  ///@到的用户
  List<ReplyMember> atMembers;

  ///需要渲染的表情转义和所表示的表情信息
  List<Emote> emotes;
}

class Emote {
  Emote({required this.text, required this.url, required this.size});
  static Emote get zero => Emote(text: "", url: "", size: EmoteSize.small);

  ///表情转义符
  String text;

  ///表情图片url
  String url;

  ///表情大小
  EmoteSize size;
}

enum EmoteSize {
  ///1
  small,

  ///2
  big,
}

extension EmoteSizeCode on EmoteSize {
  int get code => [1, 2][index];
}
