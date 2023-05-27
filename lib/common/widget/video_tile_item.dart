import 'package:bili_you/common/models/local/video_tile/video_tile_info.dart';
import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/widget/cached_network_image.dart';

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
    required this.heroTagId,
  });
  VideoTileItem.fromVideoTileInfo(VideoTileInfo info,
      {super.key,
      required this.cacheManager,
      required this.onTap,
      required this.heroTagId})
      : picUrl = info.coverUrl,
        bvid = info.bvid,
        title = info.title,
        upName = info.upName,
        duration = StringFormatUtils.timeLengthFormat(info.timeLength),
        playNum = info.playNum,
        pubDate = info.pubDate;
  final String picUrl;
  final String bvid;
  final String title;
  final String upName;
  final String duration;
  final int playNum;
  final int pubDate;
  final CacheManager cacheManager;
  final Function(BuildContext context) onTap;
  final int heroTagId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        onTap(context);
      },
      child: SizedBox(
        height: 90,
        child: Row(children: [
          SizedBox(
            width: 160,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Stack(
                children: [
                  LayoutBuilder(builder: (context, box) {
                    return Hero(
                        tag: heroTagId,
                        transitionOnUserGestures: true,
                        child: CachedNetworkImage(
                          cacheWidth: (box.maxWidth *
                                  MediaQuery.of(context).devicePixelRatio)
                              .toInt(),
                          cacheHeight: (box.maxHeight *
                                  MediaQuery.of(context).devicePixelRatio)
                              .toInt(),
                          filterQuality: FilterQuality.none,
                          width: 160,
                          height: 100,
                          fit: BoxFit.cover,
                          imageUrl: picUrl,
                          cacheManager: cacheManager,
                          placeholder: () => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                        ));
                  }),
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
                padding: const EdgeInsets.only(left: 8, right: 8),
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
                              fontSize: 12, color: Theme.of(context).hintColor),
                        ),
                        const Text("  "),
                        Text(
                          StringFormatUtils.timeStampToAgoDate(pubDate),
                          style: TextStyle(
                              fontSize: 12, color: Theme.of(context).hintColor),
                        )
                      ],
                    )
                  ],
                )),
          )
        ]),
      ),
    );
  }
}
