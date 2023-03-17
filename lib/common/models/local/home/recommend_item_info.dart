class RecommendVideoItemInfo {
  RecommendVideoItemInfo(
      {required this.coverUrl,
      required this.danmakuNum,
      required this.playNum,
      required this.timeLength,
      required this.title,
      required this.upName,
      required this.bvid,
      required this.cid});
  static RecommendVideoItemInfo get zero => RecommendVideoItemInfo(
      coverUrl: "",
      danmakuNum: 0,
      playNum: 0,
      timeLength: 0,
      title: "",
      upName: "",
      bvid: "",
      cid: 0);
  String coverUrl;
  int danmakuNum;
  int playNum;
  int timeLength;
  String title;
  String upName;
  String bvid;
  int cid;
}
