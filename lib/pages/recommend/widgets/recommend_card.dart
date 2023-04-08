import 'package:bili_you/common/values/hero_tag_id.dart';
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
      required this.heroTagId,
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
  final int heroTagId;

  void onTap(BuildContext context) {
    // Get.to(
    //   () => BiliVideoPage(
    //     key: ValueKey('BiliVideoPage:${bvid}'),
    //     bvid: bvid,
    //     cid: cid,
    //   ),
    // );
    HeroTagId.lastId = heroTagId;
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
    TextStyle playInfoTextStyle = TextStyle(
        color: Theme.of(context).hintColor,
        fontSize: 12,
        overflow: TextOverflow.ellipsis);
    Color iconColor = Theme.of(context).hintColor;
    return Card(
        margin: EdgeInsets.zero,
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: LayoutBuilder(builder: (context, boxConstraints) {
                    return Hero(
                        tag: heroTagId,
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
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40 * MediaQuery.of(context).textScaleFactor,
                      child: Text(
                        title,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text.rich(
                      TextSpan(children: [
                        WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.slideshow_rounded,
                              color: iconColor,
                              size: 12 * MediaQuery.of(context).textScaleFactor,
                            )),
                        TextSpan(
                          text: " $playNum  ",
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.format_list_bulleted_rounded,
                            color: iconColor,
                            size: 12 * MediaQuery.of(context).textScaleFactor,
                          ),
                        ),
                        TextSpan(
                          text: " $danmakuNum ",
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.timer_outlined,
                            color: iconColor,
                            size: 12 * MediaQuery.of(context).textScaleFactor,
                          ),
                        ),
                        TextSpan(
                          text: ' $timeLength',
                        ),
                      ]),
                      style: playInfoTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      upName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: playInfoTextStyle,
                    )
                  ],
                ),
              )
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
