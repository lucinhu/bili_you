import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:bili_you/common/utils/settings.dart';
import 'package:bili_you/common/widget/bili_url_scheme.dart';
import 'package:bili_you/pages/dynamic/view.dart';
import 'package:bili_you/pages/home/index.dart';
import 'package:bili_you/pages/recommend/controller.dart';
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
    BiliUrlScheme.init(context);
    //自动检查更新
    if (SettingsUtil.getValue(SettingsStorageKeys.autoCheckUpdate,
        defaultValue: true)) {
      SettingsUtil.checkUpdate(context, showSnackBar: false);
    }
    controller = Get.put(MainController());
    super.initState();
  }

  void onDestinationSelected(int value) {
    // 点击当前 NavigationBar
    if (value == controller.selectedIndex.value) {
      var currentPage = controller.pages[value];
      // 首页
      if (currentPage is HomePage) {
        var homeController = Get.find<HomeController>();
        var controller = homeController
            .tabsList[homeController.tabController!.index]['controller'];
        if (controller == 'RecommendController') {
          Get.find<RecommendController>().animateToTop();
        }
      }
      // 动态
      if (currentPage is DynamicPage) {
        Get.find<DynamicController>().animateToTop();
      }
    }
    controller.selectedIndex.value = value;
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
            onDestinationSelected: (value) => onDestinationSelected(value),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }
}
