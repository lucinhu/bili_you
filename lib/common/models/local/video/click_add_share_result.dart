class ClickAddShareResult {
  ClickAddShareResult(
      {required this.isSuccess,
      required this.error,
      required this.currentShareNum});
  static ClickAddShareResult get zero =>
      ClickAddShareResult(isSuccess: false, error: '', currentShareNum: 0);
  bool isSuccess;
  String error;
  int currentShareNum;
}
