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

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Get.to(
              () => BiliVideoPage(
                bvid: bvid,
                cid: cid,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      cacheManager: cacheManager,
                      fit: BoxFit.cover,
                      imageUrl: imageUrl,
                      placeholder: (_, __) => const SizedBox(),
                      errorWidget: (_, __, ___) => const Center(
                        child: Icon(Icons.error),
                      ),
                      filterQuality: FilterQuality.none,
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(right: 5, left: 5),
                      color: const Color.fromARGB(98, 0, 0, 0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.slideshow_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          Text(
                            " $playNum  ",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                          ),
                          const Icon(
                            Icons.format_list_bulleted_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          Text(
                            " $danmakuNum",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                          ),
                          const Spacer(),
                          Text(
                            timeLength,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.white),
                          )
                        ],
                      )),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 5, right: 5, bottom: 2),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
    //    OutlinedButton(
    //   clipBehavior: Clip.antiAlias,
    //   // padding: const EdgeInsets.all(0),
    //   // elevation: 0,
    //   // color: Theme.of(context).colorScheme.secondaryContainer,
    //   style: const ButtonStyle(
    //       padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
    //       shape: MaterialStatePropertyAll(RoundedRectangleBorder(
    //           borderRadius: BorderRadius.all(Radius.circular(20))))),
    //   // shape:  const RoundedRectangleBorder(
    //   //     borderRadius: BorderRadius.all(Radius.circular(20))),
    //   onPressed: () {
    //     Get.to(
    //       () => BiliVideoPage(
    //         bvid: bvid,
    //         cid: cid,
    //       ),
    //     );
    //   },
    //   child: ,
    // );
  }
}
