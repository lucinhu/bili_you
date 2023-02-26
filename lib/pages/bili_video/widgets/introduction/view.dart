import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/values/cache_keys.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
      this.isBangumi = false});
  final String bvid;

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
  static int tagId = 0;
  String tag = "IntroductionPage:${tagId++}";
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _IntroductionViewGetX(
      changePartCallback: widget.changePartCallback,
      bvid: widget.bvid,
      cid: widget.cid,
      refreshReply: widget.refreshReply ?? () {},
      ssid: widget.ssid,
      isBangumi: widget.isBangumi,
      stopVideo: widget.pauseVideoCallback,
      tag: tag,
    );
  }

  @override
  void dispose() {
    tagId--;
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

class _IntroductionViewGetX extends GetView<IntroductionController> {
  const _IntroductionViewGetX(
      {Key? key,
      required this.changePartCallback,
      required this.bvid,
      required this.refreshReply,
      this.cid,
      this.ssid,
      required this.isBangumi,
      required this.stopVideo,
      required String tag})
      : _tag = tag,
        super(key: key);
  final String bvid;
  final int? cid;
  final int? ssid;
  final bool isBangumi;
  final Function() stopVideo;
  final Function(String bivd, int cid) changePartCallback;
  final Function() refreshReply;

  final String _tag;
  @override
  String? get tag => _tag;

  //带有图标,及图标底下有标题的按钮
  Widget _iconTextButton(
      {required Icon icon, required String text, Function()? onPressed}) {
    return ElevatedButton(
      style: const ButtonStyle(
        elevation: MaterialStatePropertyAll(0),
        padding: MaterialStatePropertyAll(EdgeInsets.all(5)),
      ),
      onPressed: onPressed ?? () {},
      child: Column(
        children: [
          icon,
          Text(
            text,
            maxLines: 1,
            style: const TextStyle(fontSize: 10),
          )
        ],
      ),
    );
  }

  // 主视图
  Widget _buildView(context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: //头像
                    CachedNetworkImage(
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.none,
                  cacheManager: CacheManager(Config(CacheKeys.othersFaceKey)),
                  imageUrl: controller.videoInfo.owner.face,
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    controller.videoInfo.owner.name,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ))
            ],
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
              " ${StringFormatUtils.numFormat(controller.videoInfo.stat.view)}  ",
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
              " ${controller.videoInfo.stat.danmaku}   ",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).hintColor,
              ),
            ),
            Text(
              "${StringFormatUtils.timeStampToDate(controller.videoInfo.pubdate)} ${StringFormatUtils.timeStampToTime(controller.videoInfo.pubdate)}",
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
                "${controller.videoInfo.bvid} 版权信息:${controller.videoInfo.copyright}",
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
              )
            ],
          ),
        ),

        Obx(
          () => SelectableText(
            controller.describe.value,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
        //TODO tags
        Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: [
                const Spacer(),
                _iconTextButton(
                    icon: const Icon(Icons.thumb_up_rounded),
                    text: StringFormatUtils.numFormat(
                        controller.videoInfo.stat.like)),
                const Spacer(),
                _iconTextButton(
                    icon: const Icon(Icons.thumb_down_alt_rounded),
                    text: "不喜欢"),
                const Spacer(),
                _iconTextButton(
                    icon: const Icon(Icons.circle_rounded),
                    text: StringFormatUtils.numFormat(
                        controller.videoInfo.stat.coin)),
                const Spacer(),
                _iconTextButton(
                    icon: const Icon(Icons.star_rounded),
                    text: StringFormatUtils.numFormat(
                        controller.videoInfo.stat.favorite)),
                const Spacer(),
                _iconTextButton(
                    icon: const Icon(Icons.share_rounded),
                    text: StringFormatUtils.numFormat(
                        controller.videoInfo.stat.share)),
                const Spacer(),
              ],
            )),

        Builder(
          builder: (context) {
            if (controller.partButtons.length > 1) {
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
  Widget build(BuildContext context) {
    return GetBuilder(
        init: IntroductionController(
            changePartCallback: changePartCallback,
            bvid: bvid,
            refreshReply: refreshReply,
            cid: cid,
            ssid: ssid,
            isBangumi: isBangumi,
            stopVideo: stopVideo),
        tag: tag,
        id: "introduction",
        builder: (_) => FutureBuilder(
              future: controller.loadVideoInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == true) {
                    return _buildView(context);
                  } else {
                    return Center(
                      child: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          controller.update(["introduction"]);
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
            ));
  }
}
