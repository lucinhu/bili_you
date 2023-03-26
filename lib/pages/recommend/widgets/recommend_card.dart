import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:bili_you/pages/bili_video/view.dart';
import 'package:get/get.dart';

class RecommendCard extends StatelessWidget {
  const RecommendCard(
      {super.key,
      required this.imageUrl,
      required this.cacheManager,
      String? title,
      String? upName,
      String? timeLength,
      String? playNum,
      String? danmakuNum,
      String? bvid,
      int? cid})
      : title = title ?? "--",
        upName = upName ?? "--",
        timeLength = timeLength ?? "--",
        playNum = playNum ?? "--",
        danmakuNum = danmakuNum ?? "--",
        bvid = bvid ?? "BV17x411w7KC",
        cid = cid ?? 279786;

  final CacheManager cacheManager;
  final String imageUrl;
  final String title;
  final String upName;
  final String timeLength;
  final String playNum;
  final String danmakuNum;
  final String bvid;
  final int cid;

  final playInfoTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 12,
  );

  void onTap(BuildContext context) {
    // Get.to(
    //   () => BiliVideoPage(
    //     key: ValueKey('BiliVideoPage:${bvid}'),
    //     bvid: bvid,
    //     cid: cid,
    //   ),
    // );
    Navigator.of(context).push(GetPageRoute(
      page: () => BiliVideoPage(
        key: ValueKey('BiliVideoPage:$bvid'),
        bvid: bvid,
        cid: cid,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: LayoutBuilder(builder: (context, boxConstraints) {
                    return Hero(
                        tag: "BiliVideoPlayer:$bvid",
                        transitionOnUserGestures: true,
                        child: CachedNetworkImage(
                          cacheWidth: (boxConstraints.maxWidth *
                                  MediaQuery.of(context).devicePixelRatio)
                              .toInt(),
                          cacheHeight: (boxConstraints.maxHeight *
                                  MediaQuery.of(context).devicePixelRatio)
                              .toInt(),
                          cacheManager: cacheManager,
                          fit: BoxFit.cover,
                          imageUrl: imageUrl,
                          placeholder: () => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          errorWidget: () => const Center(
                            child: Icon(Icons.error),
                          ),
                          filterQuality: FilterQuality.none,
                        ));
                  }),
                ),
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black38,
                          blurRadius: 12,
                          spreadRadius: 10,
                          offset: Offset(0, 12)),
                    ],
                  ),
                  padding: const EdgeInsets.only(left: 6, right: 6, bottom: 3),
                  child: Row(children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.slideshow_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        Text(
                          " $playNum  ",
                          maxLines: 1,
                          style: playInfoTextStyle,
                        ),
                        const Icon(
                          Icons.format_list_bulleted_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        Text(
                          " $danmakuNum",
                          maxLines: 1,
                          style: playInfoTextStyle,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      timeLength,
                      maxLines: 1,
                      style: playInfoTextStyle,
                    ),
                  ]),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 52,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 2),
              child: Text(
                title,
                maxLines: 2,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 6),
            child: Text(
              upName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        ],
      ),
      Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => onTap(context),
          ))
    ]));
  }
}
