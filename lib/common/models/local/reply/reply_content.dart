import 'package:bili_you/common/models/local/reply/reply_member.dart';

class ReplyContent {
  ReplyContent(
      {required this.message,
      required this.atMembers,
      required this.emotes,
      required this.jumpUrls,
      required this.pictures});
  static get zero {
    return ReplyContent(
        message: "", atMembers: [], emotes: [], jumpUrls: [], pictures: []);
  }

  ///评论
  String message;

  ///@到的用户
  List<ReplyMember> atMembers;

  ///需要渲染的表情转义和所表示的表情信息
  List<Emote> emotes;

  ///跳转链接
  List<ReplyJumpUrl> jumpUrls;

  ///图片
  List<ReplyPicture> pictures;
}

class ReplyJumpUrl {
  ReplyJumpUrl({required this.url, required this.title});
  static ReplyJumpUrl get zero => ReplyJumpUrl(url: '', title: '');
  String url;
  String title;
}

class ReplyPicture {
  ReplyPicture(
      {required this.url,
      required this.width,
      required this.height,
      required this.size});
  static ReplyPicture get zero =>
      ReplyPicture(url: '', width: 0, height: 0, size: 1);
  String url;
  int width;
  int height;
  double size;
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
