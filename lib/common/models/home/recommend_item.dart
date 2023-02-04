import 'package:dart_json_mapper/dart_json_mapper.dart';

///首页视频推荐项
///无null
///无需错误判定
@jsonSerializable
class RecommendItemModel {
  ///bv号
  @JsonProperty(defaultValue: "BV17x411w7KC")
  final String bvid;

  ///cid
  @JsonProperty(defaultValue: 279786)
  final int cid;

  ///视频封面
  @JsonProperty(name: 'pic', defaultValue: "")
  final String coverPic;

  ///视频标题
  @JsonProperty(defaultValue: '')
  final String title;

  ///视频时长
  @JsonProperty(name: 'duration', defaultValue: 0)
  final int timeLength;

  ///up主名字
  @JsonProperty(name: 'owner/name', defaultValue: '')
  final String upName;

  ///up主头像
  @JsonProperty(name: 'owner/face', defaultValue: '')
  final String upFace;

  ///播放量
  @JsonProperty(name: 'stat/view', defaultValue: 0)
  final int playNum;

  ///点赞量
  @JsonProperty(name: 'stat/like', defaultValue: 0)
  final int likeNum;

  ///弹幕量
  @JsonProperty(name: 'stat/danmaku', defaultValue: 0)
  final int danmakuNum;

  RecommendItemModel({
    required this.bvid,
    required this.cid,
    required this.coverPic,
    required this.title,
    required this.playNum,
    required this.danmakuNum,
    required this.likeNum,
    required this.timeLength,
    required this.upFace,
    required this.upName,
  });
}
