import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ErrorPage extends GetView<ErrorController> {
  const ErrorPage({Key? key, required this.message}) : super(key: key);
  final String message;

  // 主视图
  Widget _buildView() {
    return Center(
      child: Text(message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ErrorController>(
      init: ErrorController(),
      id: "error",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("错误")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
