import 'package:bili_you/common/api/reply_operation_api.dart';
import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///发表评论工具类
class AddReplyUtil {
  ///显示发表评论输入卡片
  ///
  ///type 评论区类型
  ///
  ///oid 目标评论区id
  ///
  ///root 根评论rpid（二级评论以上使用）
  ///
  ///parent 父评论rpid（二级评论同根评论id，若大于二级评论则为要回复的评论id）
  ///
  ///message 评论内容（最大10000字符，表情使用表情转义符）
  ///
  ///platform 发送平台标识
  ///
  ///newReplyItems 外部用来存放新增评论的数组
  ///
  ///updateWidget 当发表成功时用来更新评论区组件的函数
  ///
  ///scrollController 用来滚动评论区组件到最上方
  static Future<void> showAddReplySheet(
      {required ReplyType replyType,
      required String oid,
      int? root,
      int? parent,
      ReplyPlatform platform = ReplyPlatform.web,
      required List<ReplyItem> newReplyItems,
      required Function()? updateWidget,
      required ScrollController? scrollController}) async {
    String message = "";
    onAddReply() async {
      var result = await ReplyOperationApi.addReply(
          type: replyType,
          oid: oid,
          root: root,
          parent: parent,
          message: message);
      if (result.isSuccess) {
        Navigator.pop(Get.context!);
        Get.rawSnackbar(message: '发表成功');
        newReplyItems.insert(0, result.replyItem);
        updateWidget?.call();
        scrollController?.animateTo(0,
            duration: const Duration(milliseconds: 200), curve: Curves.linear);
      } else {
        Get.rawSnackbar(message: result.error);
      }
    }

    Get.bottomSheet(BottomSheet(
      onClosing: () => {},
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                autofocus: true,
                onChanged: (value) => message = value,
                onSubmitted: (value) async {
                  onAddReply();
                },
              )),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  onAddReply();
                },
              )
            ],
          ),
        );
      },
    ));
  }
}
