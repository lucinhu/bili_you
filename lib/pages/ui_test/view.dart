import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class UiTestPage extends StatefulWidget {
  const UiTestPage({Key? key}) : super(key: key);

  @override
  State<UiTestPage> createState() => _UiTestPageState();
}

class _UiTestPageState extends State<UiTestPage> {
  late final UiTestController controller;
  @override
  void initState() {
    controller = Get.put(UiTestController());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildView(BuildContext context) {
    return ListView.builder(
      itemCount: controller.listTiles.length,
      itemBuilder: (context, index) => controller.listTiles[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ui_test")),
      body: _buildView(context),
    );
  }
}
