import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(valueDecorators: SearchVideoModel.valueDecorators)
class SearchVideoModel {
  static Map<Type, ValueDecoratorFunction> valueDecorators() => {
        typeOf<List<SearchVideoResultItemModel>>(): (value) =>
            value.cast<SearchVideoResultItemModel>(),
      };
  SearchVideoModel({
    required this.code,
    required this.message,
    required this.seid,
    required this.page,
    required this.pagesize,
    required this.numResults,
    required this.numPages,
    required this.result,
  });
  @JsonProperty(defaultValue: -1)
  final int code;
  @JsonProperty(defaultValue: "未知错误")
  final String message;

  ///搜索seid
  @JsonProperty(name: 'data/seid', defaultValue: '')
  final String seid;

  ///当前页码
  @JsonProperty(name: 'data/page', defaultValue: 0)
  final int page;

  ///每页条数(每页有多少条搜索结果)
  @JsonProperty(name: 'data/pagesize', defaultValue: 0)
  final int pagesize;

  ///搜索结果总条数
  @JsonProperty(name: 'data/numResults', defaultValue: 0)
  final int numResults;

  ///总页数
  @JsonProperty(name: 'data/numPages', defaultValue: 0)
  final int numPages;

  ///搜索结果
  @JsonProperty(name: 'data/result', defaultValue: [])
  final List<SearchVideoResultItemModel> result;
}

///搜索视频结果条目
@jsonSerializable
class SearchVideoResultItemModel {
  SearchVideoResultItemModel({
    required this.author,
    required this.mid,
    required this.typeid,
    required this.typename,
    required this.bvid,
    required this.title,
    required this.description,
    required pic,
    required this.playNum,
    required this.danmakuNum,
    required this.favoriteNum,
    required this.tag,
    required this.reviewNum,
    required this.pubdate,
    required this.senddate,
    required this.duration,
    required this.hitColumns,
    required this.isUnionVideo,
    required this.rankScore,
  }) {
    _pic = pic;
  }

  ///视频作者
  @JsonProperty(defaultValue: '')
  final String author;

  ///视频作者mid
  @JsonProperty(defaultValue: 0)
  final int mid;

  ///视频分区tid
  @JsonProperty(defaultValue: '')
  final String typeid;

  ///视频子分区名
  @JsonProperty(defaultValue: '')
  final String typename;

  ///bvid
  @JsonProperty(defaultValue: '')
  final String bvid;

  ///标题
  @JsonProperty(defaultValue: '')
  final String title;

  ///描述
  @JsonProperty(defaultValue: '')
  final String description;

  ///封面图
  @JsonProperty(name: 'pic', defaultValue: '')
  late final String _pic;
  String get pic => 'http:$_pic';

  ///播放量
  @JsonProperty(name: 'play', defaultValue: 0)
  final int playNum;

  ///弹幕量
  @JsonProperty(name: 'video_review', defaultValue: 0)
  final int danmakuNum;

  ///视频收藏数
  @JsonProperty(name: 'favorites', defaultValue: 0)
  final int favoriteNum;

  ///视频tag,多个tag用,分割
  @JsonProperty(defaultValue: '')
  final String tag;

  ///评论数
  @JsonProperty(name: 'review', defaultValue: 0)
  final int reviewNum;

  ///	视频投稿时间时间戳
  @JsonProperty(defaultValue: 0)
  final int pubdate;

  ///发布时间时间戳
  @JsonProperty(defaultValue: 0)
  final int senddate;

  ///视频时长
  @JsonProperty(defaultValue: '')
  final String duration;

  ///关键字匹配类型,表明该视频搜索结果条目是以什么形式匹配到的,比如tag,title
  @JsonProperty(name: 'hit_columns', defaultValue: [])
  final List<String> hitColumns;

  ///是否是合作视频
  @JsonProperty(name: 'is_union_video', defaultValue: 0)
  final int isUnionVideo;

  ///结果排序量化值
  @JsonProperty(name: 'rank_score', defaultValue: 0)
  final int rankScore;
}
