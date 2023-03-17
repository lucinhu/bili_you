class SearchVideoItem {
  SearchVideoItem(
      {required this.coverUrl,
      required this.bvid,
      required this.title,
      required this.upName,
      required this.timeLength,
      required this.playNum,
      required this.pubDate});
  static SearchVideoItem get zero => SearchVideoItem(
      coverUrl: "",
      bvid: "",
      title: "",
      upName: "",
      timeLength: 0,
      playNum: 0,
      pubDate: 0);
  String coverUrl;
  String bvid;
  String title;
  String upName;
  int timeLength;
  int playNum;
  int pubDate;
}
