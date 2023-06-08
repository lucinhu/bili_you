import 'package:bili_you/common/models/local/history/video_view_history_item.dart';
import 'package:bili_you/common/utils/index.dart';
import 'package:bili_you/common/values/hero_tag_id.dart';
import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:bili_you/pages/bili_video/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class VideoViewHistoryTile extends StatelessWidget {
  const VideoViewHistoryTile(
      {super.key,
      required this.videoViewHistoryItem,
      required this.cacheManager,
      required this.heroTagId});
  final int heroTagId;
  final VideoViewHistoryItem videoViewHistoryItem;
  final CacheManager cacheManager;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        HeroTagId.lastId = heroTagId;
        Navigator.of(context).push(GetPageRoute(
          page: () => BiliVideoPage(
            bvid: videoViewHistoryItem.bvid,
            cid: videoViewHistoryItem.cid,
            progress: videoViewHistoryItem.progress,
          ),
        ));
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
                alignment: Alignment.bottomRight,
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
                          imageUrl: videoViewHistoryItem.cover,
                          cacheManager: cacheManager,
                          placeholder: () => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                        ));
                  }),
                  if (videoViewHistoryItem.isFinished)
                    const Text('已看完',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            shadows: [
                              BoxShadow(
                                  color: Colors.black87,
                                  blurRadius: 10,
                                  spreadRadius: 10)
                            ]))
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${StringFormatUtils.timeLengthFormat(videoViewHistoryItem.progress)}/${StringFormatUtils.timeLengthFormat(videoViewHistoryItem.duration)}',
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
                        SizedBox(
                          height: 4,
                          child: LinearProgressIndicator(
                            value: videoViewHistoryItem.progress /
                                videoViewHistoryItem.duration,
                          ),
                        )
                      ],
                    ),
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
                      videoViewHistoryItem.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      videoViewHistoryItem.authorName,
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).hintColor),
                    ),
                    Text(
                      StringFormatUtils.timeStampToAgoDate(
                          videoViewHistoryItem.viewAt),
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).hintColor),
                    )
                  ],
                )),
          )
        ]),
      ),
    );
  }
}
