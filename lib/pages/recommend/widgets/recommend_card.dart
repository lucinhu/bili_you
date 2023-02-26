import 'package:bili_you/pages/bili_video/widgets/introduction/index.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  void onTap() {
    Get.to(
      () => BiliVideoPage(
        bvid: bvid,
        cid: cid,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Hero(
                      tag: "BiliVideoPlayer:$bvid",
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CachedNetworkImage(
                          cacheManager: cacheManager,
                          fit: BoxFit.cover,
                          imageUrl: imageUrl,
                          placeholder: (_, __) => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          errorWidget: (_, __, ___) => const Center(
                            child: Icon(Icons.error),
                          ),
                          filterQuality: FilterQuality.none,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 12,
                              spreadRadius: 10,
                              offset: Offset(0, 12)),
                        ],
                      ),
                      padding:
                          const EdgeInsets.only(left: 6, right: 6, bottom: 3),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.slideshow_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          Text(
                            " $playNum  ",
                            style: playInfoTextStyle,
                          ),
                          const Icon(
                            Icons.format_list_bulleted_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          Text(
                            " $danmakuNum",
                            style: playInfoTextStyle,
                          ),
                          const Spacer(),
                          Text(
                            timeLength,
                            style: playInfoTextStyle,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 5, right: 5, bottom: 2),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    // style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 6),
                child: Text(
                  upName,
                  style: TextStyle(
                      fontSize: 11, color: Theme.of(context).hintColor),
                ),
              )
            ],
          ),
        ));
  }
}
