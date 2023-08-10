import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/widget/simple_easy_refresher.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/widgets/reply_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ReplyPage extends StatefulWidget {
  const ReplyPage({
    Key? key,
    required this.replyId,
    required this.replyType,
  })  : tag = "ReplyPage:$replyId",
        super(key: key);
  final String replyId;
  final ReplyType replyType;
  final String tag;

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  _ReplyPageState();
  @override
  bool get wantKeepAlive => true;
  late ReplyController controller;

  @override
  void initState() {
    controller = Get.put(
        ReplyController(
          bvid: widget.replyId,
          replyType: widget.replyType,
        ),
        tag: widget.tag);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // 主视图
  Widget _buildView(ReplyController controller) {
    controller.updateWidget = () => setState(() => ());
    return SimpleEasyRefresher(
      childBuilder: (context, physics) => ListView.builder(
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        controller: controller.scrollController,
        physics: physics,
        padding: const EdgeInsets.all(0),
        itemCount: controller.replyItems.length +
            controller.newReplyItems.length +
            controller.topReplyItems.length,
        itemBuilder: (context, index) {
          late ReplyItem item;
          if (index < controller.topReplyItems.length) {
            //置顶评论
            item = controller.topReplyItems[index];
          } else if (index >= controller.topReplyItems.length &&
              index <
                  controller.topReplyItems.length +
                      controller.newReplyItems.length) {
            //新增的评论
            item = controller
                .newReplyItems[index - controller.topReplyItems.length];
          } else if (index >=
              controller.topReplyItems.length +
                  controller.newReplyItems.length) {
            //普通评论
            item = controller.replyItems[index -
                (controller.topReplyItems.length +
                    controller.newReplyItems.length)];
          }
          if (index == 0) {
            //在首个元素前放置排列方式切换控件
            return Column(
              children: [
                SortReplyItemWidget(replyController: controller),
                ReplyItemWidget(
                  reply: item,
                  isTop: controller.topReplyItems.contains(item),
                  isUp: item.member.mid == controller.upperMid,
                  officialVerifyType: item.member.officialVerify.type,
                ),
              ],
            );
          } else {
            return ReplyItemWidget(
              reply: item,
              isTop: controller.topReplyItems.contains(item),
              isUp: item.member.mid == controller.upperMid,
              officialVerifyType: item.member.officialVerify.type,
            );
          }
        },
      ),
      onLoad: controller.onReplyLoad,
      onRefresh: controller.onReplyRefresh,
      easyRefreshController: controller.refreshController,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.showAddReplySheet,
        tooltip: '发表评论',
        label:const Row(
          children: [
            Icon(Icons.reply),
            Text("   发表评论")
          ],
        )
      ),
      body: _buildView(controller),
    );
  }
}

class SortReplyItemWidget extends StatelessWidget {
  const SortReplyItemWidget({super.key, required this.replyController});
  final ReplyController replyController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Obx(
              () => Text(
                  "${replyController.sortInfoText.value} ${StringFormatUtils.numFormat(replyController.replyCount)}"),
            )),
        const Spacer(),
        //排列方式按钮
        MaterialButton(
          child: Row(
            children: [
              Icon(Icons.sort_rounded,
                  size: 16, color: Get.textTheme.bodyMedium!.color),
              Obx(
                () => Text(
                  replyController.sortTypeText.value,
                  style: TextStyle(color: Get.textTheme.bodyMedium!.color),
                ),
              )
            ],
          ),
          //点击切换评论排列方式
          onPressed: () {
            replyController.toggleSort();
          },
        ),
      ],
    );
  }
}
