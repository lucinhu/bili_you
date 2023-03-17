class SearchBangumiItem {
  SearchBangumiItem(
      {required this.coverUrl,
      required this.title,
      required this.describe,
      required this.score,
      required this.ssid});
  static SearchBangumiItem get zero => SearchBangumiItem(
      coverUrl: "", title: "", describe: "", score: 0, ssid: 0);
  String coverUrl;
  String title;
  String describe;
  double score;
  int ssid;
}
