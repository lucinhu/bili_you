import 'package:bili_you/common/utils/cache_util.dart';
import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:flutter/material.dart';

class BangumiTileItem extends StatelessWidget {
  const BangumiTileItem(
      {super.key,
      required this.coverUrl,
      required this.title,
      required this.describe,
      required this.score,
      required this.onTap});
  final String coverUrl;
  final String title;
  final String describe;
  final double score;
  final Function(BuildContext context) onTap;
  final double _height = 120;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(context),
      child: SizedBox(
          height: _height,
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                cacheWidth: 300,
                cacheHeight: 400,
                imageUrl: coverUrl,
                height: _height,
                width: _height * (3 / 4),
                cacheManager: CacheUtils.searchResultItemCoverCacheManager,
                placeholder: () => Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        describe,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 12),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      //分数为0时不显示
                      score != 0 ? "$score分" : "",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )
                  ],
                ),
              ),
            )
          ])),
    );
  }
}
