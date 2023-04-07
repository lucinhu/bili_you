import 'dart:async';

import 'package:bili_you/common/api/search_api.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class SearchTabViewPage extends StatefulWidget {
  const SearchTabViewPage(
      {Key? key, required this.keyWord, this.searchType = SearchType.video})
      : super(key: key);
  final String keyWord;
  final SearchType searchType;

  @override
  State<SearchTabViewPage> createState() => _SearchTabViewPageState();
}

class _SearchTabViewPageState extends State<SearchTabViewPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late SearchTabViewController controller;

  @override
  void initState() {
    controller = Get.put(
        SearchTabViewController(
            keyWord: widget.keyWord, searchType: widget.searchType),
        tag: widget.keyWord + widget.searchType.value);
    super.initState();
  }

  @override
  void dispose() {
    controller.onClose();
    controller.onDelete();
    super.dispose();
  }

  // 主视图
  Widget _buildView() {
    if (controller.keyWord != widget.keyWord) {
      controller.keyWord = widget.keyWord;
      Timer(const Duration(seconds: 1), () {
        controller.jumpAvBvidWhenDetected();
      });
    }
    controller.searchType = widget.searchType;
    return EasyRefresh.builder(
      refreshOnStart: true,
      onLoad: () async {
        await controller.onLoad();
        setState(() {});
      },
      onRefresh: () async {
        await controller.onRefresh();
        setState(() {});
      },
      header: const ClassicHeader(
        processedDuration: Duration.zero,
        safeArea: false,
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
        safeArea: false,
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
        padding: const EdgeInsets.all(8),
        physics: physics,
        itemCount: controller.searchItemWidgetList.length,
        itemBuilder: (context, index) {
          return controller.searchItemWidgetList[index];
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildView();
  }
}
