class ClickAddCoinResult {
  ClickAddCoinResult({required this.isSuccess, required this.error});
  static ClickAddCoinResult get zero =>
      ClickAddCoinResult(isSuccess: false, error: '');
  bool isSuccess;
  String error;
}
