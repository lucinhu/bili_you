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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _SearchTabViewGetX(
        keyWord: widget.keyWord, searchType: widget.searchType);
  }
}

class _SearchTabViewGetX extends GetView<SearchTabViewController> {
  const _SearchTabViewGetX(
      {Key? key, required this.keyWord, required this.searchType})
      : super(key: key);
  final String keyWord;
  final SearchType searchType;
  @override
  String? get tag => searchType.value;
  // 主视图
  Widget _buildView() {
    return EasyRefresh.builder(
      refreshOnStart: true,
      onLoad: controller.onLoad,
      onRefresh: controller.onRefresh,
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
    return GetBuilder<SearchTabViewController>(
      tag: searchType.value,
      init: SearchTabViewController(keyWord: keyWord, searchType: searchType),
      id: "search_video_result",
      builder: (_) {
        return _buildView();
      },
    );
  }
}
