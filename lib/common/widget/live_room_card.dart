import 'package:bili_you/common/models/local/live/live_room_card_info.dart';
import 'package:bili_you/common/utils/cache_util.dart';
import 'package:bili_you/common/utils/index.dart';
import 'package:bili_you/common/values/hero_tag_id.dart';
import 'package:bili_you/common/widget/avatar.dart';
import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:bili_you/pages/bili_live/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/default_route.dart';

class LiveRoomCard extends StatelessWidget {
  const LiveRoomCard({super.key, required this.info, required this.heroTagId});
  final LiveRoomCardInfo info;
  final int heroTagId;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Stack(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16.0 / 10.0,
                  child: LayoutBuilder(builder: (context, boxConstraints) {
                    return Hero(
                      tag: heroTagId,
                      child: CachedNetworkImage(
                        cacheWidth: (boxConstraints.maxWidth *
                                MediaQuery.of(context).devicePixelRatio)
                            .toInt(),
                        cacheHeight: (boxConstraints.maxHeight *
                                MediaQuery.of(context).devicePixelRatio)
                            .toInt(),
                        cacheManager: CacheUtils.recommendItemCoverCacheManager,
                        imageUrl: info.cover,
                        fit: BoxFit.cover,
                        placeholder: () => Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        errorWidget: () => const Center(
                          child: Icon(Icons.error),
                        ),
                        filterQuality: FilterQuality.none,
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                child: SizedBox(
                    height: 50 * MediaQuery.of(context).textScaleFactor,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 4, left: 2, top: 4, bottom: 6),
                          child: AvatarWidget(
                              avatarUrl: info.userFace,
                              radius:
                                  20 * MediaQuery.of(context).textScaleFactor),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                info.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      info.uname,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 12,
                                          color: Theme.of(context).hintColor),
                                    ),
                                  ),
                                  Text(
                                    "${StringFormatUtils.numFormat(info.watchNum)}人气",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 12,
                                        color: Theme.of(context).hintColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              )
            ],
          ),
          Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onTap(context),
              ))
        ],
      ),
    );
  }

  void onTap(BuildContext context) {
    HeroTagId.lastId = heroTagId;
    Navigator.of(context).push(GetPageRoute(
      page: () => BiliLivePage(
        key: ValueKey('BiliLivePage:${info.roomId}'),
        info: info,
      ),
    ));
  }
}
