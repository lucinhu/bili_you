import 'package:bili_you/pages/bili_video/widgets/reply/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UiTestController extends GetxController {
  UiTestController();

  List<ListTile> listTiles = [];

  //测试名称,页面对应表
  final Map<String, Widget> _testPages = {
    "评论测试": ReplyPage(
      bvid: "170001",
    )
  };

  _buildListTiles() {
    _testPages.forEach((text, page) {
      listTiles.add(ListTile(
        title: Text(text),
        onTap: () => Get.to(() => Scaffold(
              appBar: AppBar(title: Text(text)),
              body: page,
            )),
      ));
    });
  }

  _initData() {
    update(["ui_test"]);
  }

  void onTap() {}

  @override
  void onInit() {
    //初始化构建测试页面项列表
    _buildListTiles();
    super.onInit();
  }

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
