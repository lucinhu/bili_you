import 'package:bili_you/common/api/video_info_api.dart';
import 'package:bili_you/common/models/local/dynamic/dynamic_content.dart';
import 'package:bili_you/common/values/hero_tag_id.dart';
import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:bili_you/pages/bili_video/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class DynamicVideoCard extends StatelessWidget {
  const DynamicVideoCard(
      {super.key,
      required this.content,
      required this.cacheManager,
      required this.heroTagId});
  final AVDynamicContent content;
  final playInfoTextStyle = const TextStyle(
      color: Colors.white, fontSize: 12, overflow: TextOverflow.ellipsis);
  final CacheManager cacheManager;
  final int heroTagId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HeroTagId.lastId = heroTagId;
        int cid = 0;
        Navigator.of(context).push(GetPageRoute(
          page: () => FutureBuilder(future: Future(() async {
            cid = (await VideoInfoApi.getVideoParts(bvid: content.bvid))
                .first
                .cid;
          }), builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done) {
              return BiliVideoPage(bvid: content.bvid, cid: cid);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: LayoutBuilder(builder: (context, boxConstraints) {
                    return Hero(
                        tag: heroTagId,
                        transitionOnUserGestures: true,
                        child: CachedNetworkImage(
                          cacheWidth: boxConstraints.maxHeight *
                              MediaQuery.of(context).devicePixelRatio *
                              16 ~/
                              10,
                          cacheHeight: (boxConstraints.maxHeight *
                                  MediaQuery.of(context).devicePixelRatio)
                              .toInt(),
                          cacheManager: cacheManager,
                          fit: BoxFit.cover,
                          imageUrl: content.picUrl,
                          placeholder: () => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          errorWidget: () => const Icon(Icons.error),
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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.slideshow_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        Text(
                          " ${content.playCount}  ",
                          maxLines: 1,
                          style: playInfoTextStyle,
                        ),
                        const Icon(
                          Icons.format_list_bulleted_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        Text(
                          " ${content.damakuCount}",
                          maxLines: 1,
                          style: playInfoTextStyle,
                        ),
                        const Spacer(),
                        Text(
                          content.duration,
                          maxLines: 1,
                          style: playInfoTextStyle,
                        ),
                      ]),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              content.title,
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}
