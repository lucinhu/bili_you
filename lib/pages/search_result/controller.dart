import 'package:bili_you/common/api/search_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResultController extends GetxController
    with GetSingleTickerProviderStateMixin {
  SearchResultController({required this.keyWord});
  late TabController tabController;
  static int searchResultCount = 0;
  //tagId用来给tab使用,使同一个搜索界面下tab的tagName可以确定,以便使用Get.find获得对应的controller
  final tagId = searchResultCount++;
  int currentSelectedTabIndex = 0;
  String keyWord;

//根据tab的index获取该搜索页面下该tab的tagName
  String getTabTagNameByIndex(int index) {
    return '${SearchType.values[index].name}:$tagId';
  }

  @override
  void onInit() {
    tabController = TabController(
        length: 5, vsync: this, initialIndex: currentSelectedTabIndex);
    super.onInit();
  }
}
