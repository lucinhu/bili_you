import 'package:bili_you/common/models/local/dynamic/dynamic_item.dart';
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

class Draw {
  Draw(
      {required this.width,
      required this.height,
      required this.size,
      required this.picUrl});
  int width;
  int height;
  double size;
  String picUrl;
}

class DrawDynamicContent extends DynamicContent {
  DrawDynamicContent(
      {required super.description, required super.emotes, required this.draws});
  static DrawDynamicContent get zero =>
      DrawDynamicContent(description: '', emotes: [], draws: []);
  List<Draw> draws;
}

class ArticleDynamicContent extends DynamicContent {
  ArticleDynamicContent(
      {required super.description,
      required this.title,
      required this.text,
      required super.emotes,
      required this.draws,
      required this.jumpUrl});
  static ArticleDynamicContent get zero => ArticleDynamicContent(
      title: '', description: '', text: '', emotes: [], draws: [], jumpUrl: '');
  List<Draw> draws;
  String title;
  String text;
  String jumpUrl;
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

class ForwardDynamicContent extends DynamicContent {
  ForwardDynamicContent(
      {required super.description,
      required super.emotes,
      required this.forward});
  static ForwardDynamicContent get zero => ForwardDynamicContent(
      description: "", emotes: [], forward: DynamicItem.zero);
  DynamicItem forward;
}
