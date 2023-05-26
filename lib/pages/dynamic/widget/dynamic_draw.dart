import 'package:bili_you/common/models/local/dynamic/dynamic_content.dart';
import 'package:bili_you/common/utils/show_dialog.dart';
import 'package:bili_you/common/utils/cache_util.dart';
import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class DynamicDrawWidget extends StatelessWidget {
  DynamicDrawWidget({super.key, required this.content});
  final DrawDynamicContent content;
  final CacheManager cacheManager = CacheUtils.bigImageCacheManager;

  @override
  Widget build(BuildContext context) {
    if (content.draws.isEmpty) return const SizedBox();
    double ratio = content.draws[0].width / content.draws[0].height;
    double newRatio = ratio >= 1
        ? ((ratio < 1.8) ? ratio : 1.8)
        : (ratio > 0.77 ? ratio : 0.7);
    if (content.draws.length == 1) {
      return GestureDetector(
        onTap: () => ShowDialog.showImageViewer(
          context: context,
          urls: content.draws.map((e) => e.picUrl).toList(),
          initIndex: 0,
        ),
        child: SizedBox(
          width: (newRatio == 1.9 || newRatio == 0.7)
              ? MediaQuery.of(context).size.width * 2 / 3
              : content.draws.first.width.toDouble() /
                  MediaQuery.of(context).devicePixelRatio,
          child: AspectRatio(
            aspectRatio: newRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LayoutBuilder(builder: (context, box) {
                return Hero(
                  tag: content.draws[0].picUrl,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: content.draws[0].picUrl,
                    cacheWidth:
                        (box.maxWidth * MediaQuery.of(context).devicePixelRatio)
                            .toInt(),
                    cacheHeight: (box.maxWidth /
                            ratio *
                            MediaQuery.of(context).devicePixelRatio)
                        .toInt(),
                    cacheManager: cacheManager,
                  ),
                );
              }),
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 0.9 * 0.75 / newRatio,
        child: Swiper(
            loop: false,
            scale: 0.9,
            viewportFraction: 0.75,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () => ShowDialog.showImageViewer(
                        context: context,
                        urls: content.draws.map((e) => e.picUrl).toList(),
                        initIndex: index,
                      ),
                  child: RepaintBoundary(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LayoutBuilder(
                        builder: (context, box) {
                          return Hero(
                              tag: content.draws[index].picUrl,
                              child: CachedNetworkImage(
                                imageUrl: content.draws[index].picUrl,
                                cacheManager: cacheManager,
                                cacheWidth: (box.maxWidth *
                                        MediaQuery.of(context).devicePixelRatio)
                                    .toInt(),
                                cacheHeight: (box.maxWidth *
                                        content.draws[index].height /
                                        content.draws[index].width *
                                        MediaQuery.of(context).devicePixelRatio)
                                    .toInt(),
                                fit: BoxFit.cover,
                              ));
                        },
                      ),
                    ),
                  ));
            },
            itemCount: content.draws.length),
      );
    }
  }
}
