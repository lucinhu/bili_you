import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResultController extends GetxController
    with GetSingleTickerProviderStateMixin {
  SearchResultController();
  late TabController tabController;
  String keyWord = "";

  @override
  void onInit() {
    tabController = TabController(length: 5, vsync: this);
    super.onInit();
  }
}
