import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UiTestController extends GetxController {
  UiTestController();

  List<ListTile> listTiles = [];

  _initData() {
    update(["ui_test"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
