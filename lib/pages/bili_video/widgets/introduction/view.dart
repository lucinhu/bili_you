import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/widget/avatar.dart';
import 'package:bili_you/common/widget/foldable_text.dart';
import 'package:bili_you/pages/user_space/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage(
      {super.key,
      required this.changePartCallback,
      required this.pauseVideoCallback,
      this.refreshReply,
      required this.bvid,
      this.cid,
      this.ssid,
      this.isBangumi = false})
      : tag = "IntroductionPage:$bvid";
  final String bvid;
  final String tag;

  ///普通视频可以不用传入cid, 番剧必须传入
  final int? cid;

  ///番剧专用
  final int? ssid;

  ///是否是番剧
  final bool isBangumi;

  ///番剧必须要的刷新评论区回调
  final Function()? refreshReply;

  final Function(String bvid, int cid) changePartCallback;
  final Function() pauseVideoCallback;

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey operationButtonKey = GlobalKey();
  final TextStyle operationButtonTextStyle = const TextStyle(fontSize: 10);
  late IntroductionController controller;

  // 主视图
  Widget _buildView(BuildContext context, IntroductionController controller) {
    return ListView(
      controller: controller.scrollController,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      children: [
        SizedBox(
          height: 50,
          child: GestureDetector(
            onTap: () {
              controller.pauseVideo();
              // Get.to(
              //   () => UserSpacePage(
              //       key: ValueKey(
              //           'UserSpacePage:${controller.videoInfo.ownerMid}'),
              //       mid: controller.videoInfo.ownerMid),
              // );
              Navigator.of(context).push(GetPageRoute(
                page: () => UserSpacePage(
                    key: ValueKey(
                        'UserSpacePage:${controller.videoInfo.ownerMid}'),
                    mid: controller.videoInfo.ownerMid),
              ));
            },
            child: Row(
              children: [
                AvatarWidget(
                  avatarUrl: controller.videoInfo.ownerFace,
                  radius: 45 / 2,
                  cacheWidthHeight: 200,
                ),
                Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      controller.videoInfo.ownerName,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Obx(() => SelectableText(
                controller.title.value,
                style: const TextStyle(fontSize: 16),
              )),
        ),
        Row(
          children: [
            Icon(
              Icons.slideshow_rounded,
              size: 14,
              color: Theme.of(context).hintColor,
            ),
            Text(
              " ${StringFormatUtils.numFormat(controller.videoInfo.playNum)}  ",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).hintColor,
              ),
            ),
            Icon(
              Icons.format_list_bulleted_rounded,
              size: 14,
              color: Theme.of(context).hintColor,
            ),
            Text(
              " ${controller.videoInfo.danmaukuNum}   ",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).hintColor,
              ),
            ),
            Text(
              "${StringFormatUtils.timeStampToDate(controller.videoInfo.pubDate)} ${StringFormatUtils.timeStampToTime(controller.videoInfo.pubDate)}",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).hintColor,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: //copyrights info
              Row(
            children: [
              Text(
                "${controller.videoInfo.bvid} 版权信息:${controller.videoInfo.copyRight}",
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
              )
            ],
          ),
        ),

        SelectableRegion(
            magnifierConfiguration: const TextMagnifierConfiguration(),
            focusNode: FocusNode(),
            selectionControls: MaterialTextSelectionControls(),
            child: Obx(
              () => FoldableText(
                //简介详细
                controller.describe.value,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
                maxLines: 6,
                folderTextStyle: TextStyle(
                    fontSize: 12, color: Theme.of(context).colorScheme.primary),
              ),
            )),
        //TODO tags
        Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: StatefulBuilder(
                key: operationButtonKey,
                builder: (context, setState) {
                  controller.refreshOperationButton = () {
                    operationButtonKey.currentState?.setState(() {});
                  };
                  var buttonWidth = (MediaQuery.of(context).size.width) / 6;
                  var buttonHeight =
                      (MediaQuery.of(context).size.width) / 6 * 0.8;
                  return Row(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: buttonWidth,
                        height: buttonHeight,
                        child: IconTextButton(
                          selected: controller.videoInfo.hasLike,
                          icon: const Icon(Icons.thumb_up_rounded),
                          text: Text(
                            StringFormatUtils.numFormat(
                                controller.videoInfo.likeNum),
                            style: operationButtonTextStyle,
                          ),
                          onPressed: controller.onLikePressed,
                        ),
                      ),
                      // const Spacer(),
                      // SizedBox(
                      //     width: buttonWidth,
                      //   height: buttonHeight,
                      //     child: IconTextButton(
                      //       icon: const Icon(Icons.thumb_down_alt_rounded),
                      //       text: Text(
                      //         "不喜欢",
                      //         style: operationButtonTextStyle,
                      //       ),
                      //       onPressed: () {},
                      //     )),
                      const Spacer(),
                      SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: IconTextButton(
                              selected: controller.videoInfo.hasAddCoin,
                              icon: const Icon(Icons.circle_rounded),
                              text: Text(
                                  StringFormatUtils.numFormat(
                                      controller.videoInfo.coinNum),
                                  style: operationButtonTextStyle),
                              onPressed: controller.onAddCoinPressed)),
                      const Spacer(),
                      SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: IconTextButton(
                            selected: controller.videoInfo.hasFavourite,
                            icon: const Icon(Icons.star_rounded),
                            text: Text(
                                StringFormatUtils.numFormat(
                                    controller.videoInfo.favariteNum),
                                style: operationButtonTextStyle),
                            onPressed: () {},
                          )),
                      const Spacer(),
                      SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: IconTextButton(
                            icon: const Icon(Icons.share_rounded),
                            text: Text(
                                StringFormatUtils.numFormat(
                                    controller.videoInfo.shareNum),
                                style: operationButtonTextStyle),
                            onPressed: controller.onAddSharePressed,
                          )),
                      const Spacer(),
                    ],
                  );
                })),

        Builder(
          builder: (context) {
            if (controller.partButtons.isNotEmpty) {
              return SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Flexible(
                          child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.partButtons.length,
                        itemBuilder: (context, index) {
                          return controller.partButtons[index];
                        },
                      )),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  clipBehavior: Clip.antiAlias,
                                  builder: (context) => SizedBox(
                                        height: context.height / 2,
                                        child: ListView(
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              left: 10,
                                              right: 10,
                                              bottom: context
                                                  .mediaQueryPadding.bottom),
                                          children: [
                                            Wrap(
                                              alignment:
                                                  WrapAlignment.spaceBetween,
                                              children: controller.partButtons,
                                            )
                                          ],
                                        ),
                                      ));
                            },
                            child: const Icon(Icons.more_vert_rounded)),
                      ),
                    ],
                  ));
            } else {
              return const SizedBox(
                height: 0,
              );
            }
          },
        ),
        Divider(
          color: Theme.of(Get.context!).colorScheme.secondaryContainer,
          thickness: 1,
          height: 20,
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          addAutomaticKeepAlives: false,
          cacheExtent: 100,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.relatedVideos.length,
          itemBuilder: (context, index) {
            return controller.relatedVideos[index];
          },
        )
      ],
    );
  }

  @override
  void initState() {
    controller = Get.put(
        IntroductionController(
            changePartCallback: widget.changePartCallback,
            bvid: widget.bvid,
            refreshReply: widget.refreshReply ?? () {},
            cid: widget.cid,
            ssid: widget.ssid,
            isBangumi: widget.isBangumi,
            pauseVideo: widget.pauseVideoCallback),
        tag: widget.tag);
    super.initState();
  }

  @override
  void dispose() {
    controller.onClose();
    controller.onDelete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: controller.loadVideoInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return _buildView(context, controller);
          } else {
            return Center(
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  setState(() {});
                },
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
    this.selected = false,
  });
  final Function()? onPressed;
  final Icon icon;
  final Text text;

  ///是否被选上
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: selected
            ? MaterialStatePropertyAll(Theme.of(context).colorScheme.onPrimary)
            : null,
        backgroundColor: selected
            ? MaterialStatePropertyAll(Theme.of(context).colorScheme.primary)
            : null,
        elevation: const MaterialStatePropertyAll(0),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(5)),
      ),
      onPressed: onPressed ?? () {},
      child: FittedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [icon, text],
        ),
      ),
    );
  }
}
