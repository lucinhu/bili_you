import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class ChannelPage extends GetView<ChannelController> {
  const ChannelPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const Center(
      child: Text("ChannelPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChannelController>(
      init: ChannelController(),
      id: "channel",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("频道")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
