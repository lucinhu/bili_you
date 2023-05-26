class VideoTileInfo {
  VideoTileInfo(
      {required this.coverUrl,
      required this.bvid,
      required this.cid,
      required this.title,
      required this.upName,
      required this.timeLength,
      required this.playNum,
      required this.pubDate});
  static VideoTileInfo get zero => VideoTileInfo(
      coverUrl: "",
      bvid: "",
      cid: 0,
      title: "",
      upName: "",
      timeLength: 0,
      playNum: 0,
      pubDate: 0);
  String coverUrl;
  String bvid;
  int cid;
  String title;
  String upName;
  int timeLength;
  int playNum;
  int pubDate;
}
