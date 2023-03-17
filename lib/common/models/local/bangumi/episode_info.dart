class EpisodeInfo {
  EpisodeInfo({required this.title, required this.bvid, required this.cid});
  static EpisodeInfo get zero => EpisodeInfo(title: "", bvid: "", cid: 0);
  String title;
  String bvid;
  int cid;
}
