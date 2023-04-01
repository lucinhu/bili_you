import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class DynamicPage extends GetView<DynamicController> {
  const DynamicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DynamicController>(
      init: DynamicController(),
      id: "dynamic",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("动态")),
          body: EasyRefresh.builder(
            refreshOnStart: true,
            onLoad: controller.onLoad,
            onRefresh: controller.onRefresh,
            header: const ClassicHeader(
              processedDuration: Duration.zero,
              showMessage: false,
              processingText: "正在刷新...",
              readyText: "正在刷新...",
              armedText: "释放以刷新",
              dragText: "下拉刷新",
              processedText: "刷新成功",
              failedText: "刷新失败",
            ),
            footer: const ClassicFooter(
              processedDuration: Duration.zero,
              showMessage: false,
              processingText: "加载中...",
              processedText: "加载成功",
              readyText: "加载中...",
              armedText: "释放以加载更多",
              dragText: "上拉加载",
              failedText: "加载失败",
              noMoreText: "没有更多内容",
            ),
            controller: controller.refreshController,
            childBuilder: (context, physics) => ListView.builder(
              cacheExtent: MediaQuery.of(context).size.height,
              controller: controller.scrollController,
              physics: physics,
              itemCount: controller.dynamicItemCards.length,
              itemBuilder: (context, index) =>
                  controller.dynamicItemCards[index],
            ),
          ),
        );
      },
    );
  }
}
