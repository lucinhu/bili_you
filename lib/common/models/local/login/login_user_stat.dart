class LoginUserStat {
  LoginUserStat(
      {required this.followerCount,
      required this.followingCount,
      required this.dynamicCount});
  static LoginUserStat get zero =>
      LoginUserStat(followerCount: 0, followingCount: 0, dynamicCount: 0);
  int followerCount;
  int followingCount;
  int dynamicCount;
}
