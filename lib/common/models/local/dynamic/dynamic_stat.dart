class DynamicStat {
  DynamicStat(
      {required this.shareCount,
      required this.replyCount,
      required this.likeCount});
  static DynamicStat get zero =>
      DynamicStat(shareCount: 0, replyCount: 0, likeCount: 0);
  int shareCount;
  int replyCount;
  int likeCount;
}
