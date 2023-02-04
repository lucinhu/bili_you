import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key, required this.keyword}) : super(key: key);
  final String keyword;
  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _SearchResultViewGetX(keyword: widget.keyword);
  }
}

class _SearchResultViewGetX extends GetView<SearchResultController> {
  const _SearchResultViewGetX({Key? key, required this.keyword})
      : super(key: key);
  final String keyword;

  AppBar _appBar(context) {
    controller.keyWord = keyword;
    return AppBar(
        shape: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).dividerColor)),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(text: keyword),
                readOnly: true,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onTap: () {
                  Get.back();
                },
              ),
            ),
            SizedBox(
              width: 70,
              child: IconButton(
                onPressed: () {
                  controller.refreshController.callRefresh();
                },
                icon: const Icon(Icons.search_rounded),
              ),
            )
          ],
        ));
  }

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
    return GetBuilder<SearchResultController>(
      init: SearchResultController(),
      id: "search_result",
      builder: (_) {
        return Scaffold(
          appBar: _appBar(context),
          body: _buildView(),
        );
      },
    );
  }
}
