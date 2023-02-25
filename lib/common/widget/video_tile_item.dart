import 'package:bili_you/common/utils/string_format_utils.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoTileItem extends StatelessWidget {
  const VideoTileItem({
    super.key,
    required this.picUrl,
    required this.bvid,
    required this.title,
    required this.upName,
    required this.duration,
    required this.playNum,
    required this.pubDate,
    required this.cacheManager,
    required this.onTap,
  });
  final String picUrl;
  final String bvid;
  final String title;
  final String upName;
  final String duration;
  final int playNum;
  final int pubDate;
  final CacheManager cacheManager;
  final Function(BuildContext context) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
        child: SizedBox(
          height: 90,
          child: Row(children: [
            SizedBox(
              width: 160,
              height: 90,
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Stack(
                  children: [
                    Hero(
                      tag: "BiliVideoPlayer:$bvid",
                      child: CachedNetworkImage(
                        filterQuality: FilterQuality.none,
                        width: 160,
                        height: 90,
                        fit: BoxFit.cover,
                        imageUrl: picUrl,
                        cacheManager: cacheManager,
                        placeholder: (context, url) => Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        duration,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            shadows: [
                              BoxShadow(
                                  color: Colors.black87,
                                  blurRadius: 10,
                                  spreadRadius: 10)
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        upName,
                        style: TextStyle(
                            fontSize: 12, color: Theme.of(context).hintColor),
                      ),
                      Row(
                        children: [
                          Icon(Icons.slideshow_rounded,
                              size: 14, color: Theme.of(context).hintColor),
                          Text(
                            StringFormatUtils.numFormat(playNum),
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).hintColor),
                          ),
                          const Text("  "),
                          Text(
                            StringFormatUtils.timeStampToAgoDate(pubDate),
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).hintColor),
                          )
                        ],
                      )
                    ],
                  )),
            )
          ]),
        ),
      ),
    );
  }
}
