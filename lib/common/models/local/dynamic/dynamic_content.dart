import 'package:bili_you/common/models/local/reply/reply_content.dart';

abstract class DynamicContent {
  DynamicContent({required this.description, required this.emotes});
  String description;
  List<Emote> emotes;
}

class WordDynamicContent extends DynamicContent {
  WordDynamicContent({required super.description, required super.emotes});
  static WordDynamicContent get zero =>
      WordDynamicContent(description: "", emotes: []);
}

class AVDynamicContent extends DynamicContent {
  AVDynamicContent(
      {required super.description,
      required super.emotes,
      required this.picUrl,
      required this.bvid,
      required this.title,
      required this.subTitle,
      required this.duration,
      required this.damakuCount,
      required this.playCount});
  static AVDynamicContent get zero => AVDynamicContent(
      description: "",
      emotes: [],
      picUrl: '',
      title: '',
      subTitle: '',
      duration: '',
      damakuCount: '',
      playCount: '',
      bvid: '');
  final String picUrl;
  final String bvid;
  final String title;
  final String subTitle;
  final String duration;
  final String playCount;
  final String damakuCount;
}
