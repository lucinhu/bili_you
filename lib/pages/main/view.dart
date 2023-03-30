import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class MainPage extends GetView<MainController> {
  const MainPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Obx(() => Scaffold(
          extendBody: true, extendBodyBehindAppBar: true, primary: true,
          //IndexedStack，使"首页，动态"这三个页面互相切换的时候保持状态
          body: IndexedStack(
            index: controller.selectedIndex.value,
            children: controller.pages,
          ),
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: "首页",
              ),
              NavigationDestination(
                icon: Icon(Icons.star_border_outlined),
                label: "动态",
                selectedIcon: Icon(Icons.star),
              ),
            ],
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (value) {
              controller.selectedIndex.value = value;
            },
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: MainController(),
      id: "main",
      builder: (_) {
        return _buildView();
      },
    );
  }
}
