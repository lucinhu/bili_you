import 'package:bili_you/common/widget/simple_easy_refresher.dart';
import 'package:bili_you/pages/dynamic/widget/dynamic_author_filter.dart';
import 'package:bili_you/pages/dynamic/widget/dynamic_item_card.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class DynamicPage extends StatefulWidget {
  const DynamicPage({Key? key}) : super(key: key);

  @override
  State<DynamicPage> createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> {
  late final DynamicController controller;
  @override
  void initState() {
    controller = Get.put(DynamicController());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("动态")),
        body: SimpleEasyRefresher(
          easyRefreshController: controller.refreshController,
          indicatorPosition: IndicatorPosition.locator,
          childBuilder: (context, physics) => CustomScrollView(
            cacheExtent: MediaQuery.of(context).size.height,
            controller: controller.scrollController,
            physics: physics,
            slivers: [
              //up主面板
              DynamicAuthorFilter(
                authors: controller.dynamicAuthorList,
                onAuthorFilterApplied: controller.applyAuthorFilter,
              ),
              const HeaderLocator.sliver(),
              //動態内容卡片
              SliverList.builder(
                itemCount: controller.dynamicItems.length,
                itemBuilder: (context, index) =>
                    DynamicItemCard(dynamicItem: controller.dynamicItems[index]),
              ),
              const FooterLocator.sliver(),
            ],
          ),
          onLoad: controller.onLoad,
          onRefresh: controller.onRefresh,
        ));
  }
}
