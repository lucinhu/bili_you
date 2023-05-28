import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:bili_you/pages/live_tab_page/controller.dart';
import 'package:bili_you/pages/live_tab_page/view.dart';
import 'package:bili_you/pages/popular_video/controller.dart';
import 'package:bili_you/pages/popular_video/view.dart';
import 'package:bili_you/pages/recommend/controller.dart';
import 'package:bili_you/pages/search_input/index.dart';
import 'package:bili_you/pages/ui_test/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bili_you/pages/recommend/view.dart';
import 'index.dart';
import 'widgets/user_menu/view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  late HomeController controller;
  final RecommendPage recommendPage = const RecommendPage();
  final PopularVideoPage popularVideoPage = const PopularVideoPage();
  final LiveTabPage liveTabPage = const LiveTabPage();
  List<Map<String, dynamic>> tabsList = [];

  @override
  void initState() {
    controller = Get.put(HomeController());
    tabsList = controller.tabsList;
    controller.tabController = TabController(
        length: tabsList.length,
        vsync: this,
        initialIndex: controller.tabInitIndex);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // 主视图
  Widget _buildView(context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: MaterialButton(
          onLongPress: () {
            //长按进入测试界面
            // Get.to(() => const UiTestPage());
            Navigator.of(context)
                .push(GetPageRoute(page: () => const UiTestPage()));
          },
          onPressed: () {
            Navigator.of(context).push(GetPageRoute(
                page: () => SearchInputPage(
                      key: ValueKey(
                          'SearchInputPage:${controller.defaultSearchWord.value}'),
                      defaultHintSearchWord: controller.defaultSearchWord.value,
                    )));

            //更新搜索框默认词
            controller.refreshDefaultSearchWord();
          },
          color: Theme.of(context).colorScheme.surfaceVariant,
          height: 50,
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          disabledElevation: 0,
          highlightElevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(28)),
          ),
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  //更新搜索框默认词
                  controller.refreshDefaultSearchWord();
                },
                child: Icon(
                  (Icons.search),
                  size: 24,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Obx(() => Text(
                      //搜索框默认词
                      controller.defaultSearchWord.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge))),
              const SizedBox(
                width: 16,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const UserMenuPage(),
                  );
                },
                child: ClipOval(
                  child: FutureBuilder(
                    future: controller.loadOldFace(),
                    builder: (context, snapshot) {
                      Widget placeHolder = Container(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      );
                      if (snapshot.connectionState == ConnectionState.done) {
                        //头像
                        return Obx(() => CachedNetworkImage(
                            cacheWidth: 100,
                            cacheHeight: 100,
                            cacheManager: controller.cacheManager,
                            width: 32,
                            height: 32,
                            fit: BoxFit.fill,
                            imageUrl: controller.faceUrl.value,
                            placeholder: () => placeHolder));
                      } else {
                        return placeHolder;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          isScrollable: true,
          tabs: tabsList.map((e) => Tab(text: e['text'])).toList(),
          controller: controller.tabController,
          onTap: (index) {
            if (controller.tabController!.indexIsChanging) return;
            switch (index) {
              case 0:
                //点击“直播”回到顶
                Get.find<LiveTabPageController>().animateToTop();
                break;
              case 1:
                //点击“推荐”回到顶
                Get.find<RecommendController>().animateToTop();
                break;
              case 2:
                Get.find<PopularVideoController>().animateToTop();
                break;
              default:
            }
          },
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: tabsList.map((e) {
          switch (e['text']) {
            case '直播':
              return liveTabPage;
            case '推荐':
              return recommendPage;
            case '热门':
              return popularVideoPage;
            default:
              return const Center(child: Text("该功能暂无"));
          }
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildView(context);
  }
}
