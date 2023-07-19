import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:bili_you/common/utils/index.dart';
import 'package:bili_you/common/values/hero_tag_id.dart';
import 'package:bili_you/common/values/index.dart';
import 'package:bili_you/pages/bili_video/widgets/bili_video_player/bili_video_player.dart';
import 'package:bili_you/pages/bili_video/widgets/introduction/index.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../common/api/history_api.dart';
import '../../common/utils/bvid_avid_util.dart';
import 'index.dart';
import 'widgets/bili_video_player/bili_danmaku.dart';
import 'widgets/bili_video_player/bili_video_player_panel.dart';
import 'widgets/reply/controller.dart';

class BiliVideoPage extends StatefulWidget {
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

  const BiliVideoPage(
      {Key? key,
      required this.bvid,
      required this.cid,
      this.isBangumi = false,
      this.ssid,
      this.progress})
      : tag = "BiliVideoPage:$bvid",
        super(key: key);
  final String bvid;
  final int cid;
  final int? ssid;
  final bool isBangumi;
  final int? progress;
  final String tag;

  @override
  State<BiliVideoPage> createState() => _BiliVideoPageState();
}

class _BiliVideoPageState extends State<BiliVideoPage>
    with RouteAware, WidgetsBindingObserver {
  int currentTabIndex = 0;
  late BiliVideoController controller;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //当应用切换后台时
    //如果不允许后台播放,就暂停视频
    if (state == AppLifecycleState.paused) {
      if (SettingsUtil.getValue(SettingsStorageKeys.isBackGroundPlay,
              defaultValue: true) ==
          false) {
        controller.biliVideoPlayerController.pause();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void didChangeDependencies() {
    //订阅路由监听
    BiliVideoPage.routeObserver
        .subscribe(this, ModalRoute.of(context) as PageRoute);
    super.didChangeDependencies();
  }

  @override
  void didPushNext() async {
    //当进入下一个页面时
    //释放所有图片缓存
    CacheUtils.clearAllCacheImageMem();
    //暂停视频
    await controller.biliVideoPlayerController.pause();
    super.didPushNext();
  }

  @override
  void didPopNext() async {
    //回到当前页面时
    //刷新页面
    await controller.biliVideoPlayerController.refreshPlayer();
    super.didPopNext();
  }

  @override
  void didPop() async {
    //当退出页面时
    //暂停视频
    var second = controller.biliVideoPlayerController.position.inSeconds;
    await controller.biliVideoPlayerController.pause();
    await HistoryApi.reportVideoViewHistory(aid: BvidAvidUtil.bvid2Av(controller.bvid),cid: controller.cid,progress: second);
    //释放所有图片缓存
    CacheUtils.clearAllCacheImageMem();
    super.didPop();
  }

  @override
  void dispose() async {
    controller.dispose();
    //取消路由监听
    BiliVideoPage.routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    controller = Get.put(
      BiliVideoController(
          bvid: widget.bvid,
          cid: widget.cid,
          isBangumi: widget.isBangumi,
          progress: widget.progress,
          ssid: widget.ssid),
      tag: widget.tag,
    );
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  Widget _buildView(context, BiliVideoController controller) {
    return Column(
      children: [
        TabBar(
          controller: controller.tabController,
          splashFactory: NoSplash.splashFactory,
          tabs: const [
            Tab(
              text: "简介",
            ),
            Tab(text: "评论")
          ],
          onTap: (value) {
            if (value == currentTabIndex) {
              //当按下的tab和当前的一样，就滚动到顶部
              switch (value) {
                case 0:
                  Get.find<IntroductionController>(
                          tag: "IntroductionPage:${widget.bvid}")
                      .scrollController
                      .animateTo(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear);
                  break;
                case 1:
                  Get.find<ReplyController>(tag: "ReplyPage:${widget.bvid}")
                      .scrollController
                      .animateTo(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear);
                  break;
                default:
                  break;
              }
            } else {
              currentTabIndex = value;
            }
          },
        ),
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: [
              IntroductionPage(
                changePartCallback: controller.changeVideoPart,
                refreshReply: controller.refreshReply,
                bvid: controller.bvid,
                cid: controller.cid,
                ssid: controller.ssid,
                isBangumi: controller.isBangumi,
              ),
              Builder(builder: (context) {
                //Builder可以让ReplyPage在TabBarView显示到它的时候才取controller.bvid
                return ReplyPage(
                  replyId: controller.bvid,
                  replyType: ReplyType.video,
                );
              })
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light),
        child: Scaffold(
          body: Column(
            children: [
              BiliVideoPlayerWidget(
                controller.biliVideoPlayerController,
                heroTagId: HeroTagId.lastId,
                buildControllPanel: () {
                  return BiliVideoPlayerPanel(
                    controller.biliVideoPlayerPanelController,
                  );
                },
                buildDanmaku: () {
                  return BiliDanmaku(
                      controller: controller.biliDanmakuController);
                },
              ),
              Expanded(child: _buildView(context, controller)),
            ],
          ),
        ));
  }
}
