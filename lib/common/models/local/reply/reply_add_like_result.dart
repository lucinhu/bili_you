class ReplyAddLikeResult {
  ReplyAddLikeResult({required this.isSuccess, required this.error});
  static ReplyAddLikeResult get zero =>
      ReplyAddLikeResult(isSuccess: false, error: '');
  bool isSuccess;
  String error;
}
