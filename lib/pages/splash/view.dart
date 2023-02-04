import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bili_you/pages/main/view.dart';

import 'index.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({Key? key}) : super(key: key);

  Widget _buildView() {
    //暂时先不写splash屏画面，让它直接跳转到主页面
    return const MainPage();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      id: "splash",
      builder: (splashController) {
        return _buildView();
      },
    );
  }
}
