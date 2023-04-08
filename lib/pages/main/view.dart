import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:bili_you/common/utils/settings.dart';
import 'package:bili_you/pages/dynamic/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dynamic/controller.dart';
import 'index.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainController controller;
  @override
  void initState() {
    //自动检查更新
    if (BiliYouStorage.settings
        .get(SettingsStorageKeys.autoCheckUpdate, defaultValue: true)) {
      SettingsUtil.checkUpdate(context, showSnackBar: false);
    }
    controller = Get.put(MainController());
    super.initState();
  }

  @override
  void dispose() {
    // controller.onClose();
    // controller.onDelete();
    controller.dispose();
    super.dispose();
  }

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
            height: 64,
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
              if (value == controller.selectedIndex.value &&
                  controller.pages[value] is DynamicPage) {
                Get.find<DynamicController>().animateToTop();
              }
              controller.selectedIndex.value = value;
            },
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }
}
