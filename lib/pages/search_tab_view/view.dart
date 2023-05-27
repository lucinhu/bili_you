import 'dart:async';

import 'package:bili_you/common/api/search_api.dart';
import 'package:bili_you/common/widget/simple_easy_refresher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class SearchTabViewPage extends StatefulWidget {
  const SearchTabViewPage(
      {Key? key,
      required this.keyWord,
      this.searchType = SearchType.video,
      required this.tagName})
      : super(key: key);
  final String keyWord;
  final SearchType searchType;
  final String tagName;

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
        tag: widget.tagName);
    super.initState();
  }

  @override
  void dispose() {
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
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        controller: controller.scrollController,
        padding: const EdgeInsets.all(12),
        physics: physics,
        itemCount: controller.searchItems.length,
        itemBuilder: (context, index) {
          var i = controller.searchItems[index];
          switch (controller.searchType) {
            case SearchType.video:
              return controller.buildVideoItemWidget(i);
            case SearchType.bangumi:
              return controller.buildBangumiItemWidget(i);
            case SearchType.user:
              return controller.buildUserItemWidget(i);
            case SearchType.movie:
            // TODO: Handle this case.
            case SearchType.liveRoom:
            // TODO: Handle this case.
            default:
              return const SizedBox();
          }
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
