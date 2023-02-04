import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class UiTestPage extends GetView<UiTestController> {
  const UiTestPage({Key? key}) : super(key: key);

  Widget _buildView(BuildContext context) {
    return ListView(
      children: const [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UiTestController>(
      init: UiTestController(),
      id: "ui_test",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("ui_test")),
          body: _buildView(context),
        );
      },
    );
  }
}
