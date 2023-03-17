class UserVideoSearch {
  UserVideoSearch({required this.videos});
  static UserVideoSearch get zero => UserVideoSearch(videos: []);
  List<UserVideoItem> videos;

  ///TODO 该用户所有投稿视频分区列表
}

class UserVideoItem {
  UserVideoItem({
    required this.author,
    required this.title,
    required this.mid,
    required this.bvid,
    required this.coverUrl,
    required this.danmakuCount,
    required this.description,
    required this.isUnionVideo,
    required this.playCount,
    required this.duration,
    required this.pubDate,
    required this.replyCount,
    // required this.typeid
  });
  static UserVideoItem get zero => UserVideoItem(
        author: "",
        title: "",
        mid: 0,
        bvid: "",
        coverUrl: "",
        danmakuCount: 0,
        description: "",
        isUnionVideo: false,
        playCount: 0,
        duration: "--:--",
        pubDate: 0,
        replyCount: 0,
        // typeid: 0
      );

  ///评论数
  int replyCount;

  // ///分区id
  // int typeid;

  ///播放量
  int playCount;

  ///封面
  String coverUrl;

  ///简介
  String description;

  ///标题
  String title;

  ///up主名字，如果是合作视频的话是第一个人的名字
  String author;

  ///up主mid
  int mid;

  ///投稿时间戳
  int pubDate;

  ///弹幕量
  int danmakuCount;

  ///视频时长，分:秒的形式
  String duration;

  ///bvid
  String bvid;

  ///是否是合作视频
  bool isUnionVideo;
}
