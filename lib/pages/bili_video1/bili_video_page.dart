import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:bili_you/pages/bili_video/widgets/introduction/view.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/view.dart';
import 'package:bili_you/pages/bili_video1/bili_media_content_cubit.dart';
import 'package:bili_you/pages/bili_video1/bili_media_cubit.dart';
import 'package:bili_you/pages/bili_video1/bili_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BiliVideoPage1 extends StatelessWidget {
  const BiliVideoPage1({super.key});

  Widget _buildView(context, BiliMedia media) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            splashFactory: NoSplash.splashFactory,
            tabs: const [
              Tab(
                text: "简介",
              ),
              Tab(text: "评论")
            ],
            onTap: (value) {
              // if (value == currentTabIndex) {
              //   //当按下的tab和当前的一样，就滚动到顶部
              //   switch (value) {
              //     case 0:
              //       Get.find<IntroductionController>(
              //               tag: "IntroductionPage:${widget.bvid}")
              //           .scrollController
              //           .animateTo(0,
              //               duration: const Duration(milliseconds: 500),
              //               curve: Curves.linear);
              //       break;
              //     case 1:
              //       Get.find<ReplyController>(tag: "ReplyPage:${widget.bvid}")
              //           .scrollController
              //           .animateTo(0,
              //               duration: const Duration(milliseconds: 500),
              //               curve: Curves.linear);
              //       break;
              //     default:
              //       break;
              //   }
              // } else {
              //   currentTabIndex = value;
              // }
            },
          ),
          Expanded(
            child: TabBarView(
              children: [
                IntroductionPage(
                  changePartCallback: (bvid, cid) {},
                  refreshReply: () {},
                  bvid: media.bvid,
                  cid: media.cid,
                  ssid: media.ssid,
                  isBangumi: media.isBangumi,
                ),
                ReplyPage(
                  replyId: media.bvid,
                  replyType: ReplyType.video,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light),
        child: Scaffold(
          body: BlocBuilder<BiliMediaCubit, BiliMedia>(
              builder: (context, state) => Column(
                    children: [
                      Container(
                        color: Colors.black,
                        child: SafeArea(
                          left: false,
                          right: false,
                          bottom: false,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: FutureBuilder(
                              future: context
                                  .read<BiliMediaCubit>()
                                  .getVideoPlayInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                          create: (_) => BiliMediaContentCubit(
                                              snapshot.data!)),
                                      BlocProvider(
                                          create: (_) => BiliVideoPlayerCubit(
                                              BiliVideoPlayerState()))
                                    ],
                                    child: const BiliVideoPlayer(),
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ));
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: _buildView(context, state))
                    ],
                  )),
        ));
  }
}
