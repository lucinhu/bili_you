import 'package:bili_you/common/widget/cached_network_image.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final TabController tabController =
        TabController(length: 2, vsync: this, initialIndex: 1);

    return HomeViewGetX(
      tabController: tabController,
    );
  }
}

class HomeViewGetX extends GetView<HomeController> {
  const HomeViewGetX({Key? key, required this.tabController}) : super(key: key);
  final TabController tabController;
  final RecommendPage recommendPage = const RecommendPage();

  // 主视图
  Widget _buildView(context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: MaterialButton(
          onLongPress: () {
            //长按进入测试界面
            Get.to(() => const UiTestPage());
          },
          onPressed: () {
            //跳转到搜索页面
            Get.to(() => SearchInputPage(
                  defaultSearchWord: controller.defaultSearchWord.value,
                ));
            //更新搜索框默认词
            controller.refreshDefaultSearchWord();
          },
          color: Theme.of(context).colorScheme.surfaceVariant,
          height: 56,
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
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
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
                              placeholder: (context) => placeHolder));
                        } else {
                          return placeHolder;
                        }
                      },
                    )),
              ),
            ],
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          splashFactory: NoSplash.splashFactory,
          labelStyle: const TextStyle(height: 2.5, fontSize: 15),
          labelPadding: const EdgeInsets.only(bottom: 6),
          tabs: const [Text("直播"), Text("推荐")],
          controller: tabController,
          onTap: (index) {
            //点击“推荐”回到顶
            if (index == 1 && !tabController.indexIsChanging) {
              Get.find<RecommendController>().animateToTop();
            }
          },
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          const Center(
            child: Text("直播"),
          ),
          recommendPage
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      id: "home",
      builder: (_) {
        return _buildView(context);
      },
    );
  }
}
