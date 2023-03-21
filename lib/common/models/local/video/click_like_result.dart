///点赞后的结果
class ClickLikeResult {
  ClickLikeResult(
      {required this.isSuccess, required this.error, required this.haslike});

  ///操作是否成功
  bool isSuccess;

  ///错误信息
  String error;

  ///成功后的状态
  ///true为已点赞
  ///false则是未点赞
  bool haslike;
}
