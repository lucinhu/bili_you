class VideoViewHistoryItem {
  VideoViewHistoryItem(
      {required this.oid,
      required this.title,
      required this.cover,
      required this.bvid,
      required this.cid,
      required this.epid,
      required this.page,
      required this.authorName,
      required this.viewAt,
      required this.progress,
      required this.duration,
      required this.isFinished});
  static VideoViewHistoryItem get zero => VideoViewHistoryItem(
      oid: 0,
      title: '',
      cover: '',
      bvid: '',
      cid: 0,
      epid: 0,
      page: 1,
      authorName: '',
      viewAt: 0,
      progress: 0,
      duration: 0,
      isFinished: false);
  int oid;
  String title;
  String cover;
  String bvid;
  int cid;
  int epid;
  int page;
  String authorName;
  int viewAt;
  int progress;
  int duration;
  bool isFinished;
}
