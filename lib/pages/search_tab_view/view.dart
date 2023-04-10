import 'dart:async';

import 'package:bili_you/common/api/search_api.dart';
import 'package:bili_you/common/widget/simple_easy_refresher.dart';
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
    // controller.onClose();
    // controller.onDelete();
    controller.dispose();
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

    return SimpleEasyRefresher(
      easyRefreshController: controller.refreshController,
      onLoad: controller.onLoad,
      onRefresh: controller.onRefresh,
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
