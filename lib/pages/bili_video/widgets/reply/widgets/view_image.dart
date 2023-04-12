import 'package:bili_you/common/values/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class ViewImagePage extends StatefulWidget {
  const ViewImagePage({super.key, required this.urls, this.initIndex = 0});
  final List<String> urls;
  final int initIndex;

  @override
  State<ViewImagePage> createState() => _ViewImagePageState();
}

class _ViewImagePageState extends State<ViewImagePage> {
  late RxInt currentIndex;
  @override
  void initState() {
    currentIndex = widget.initIndex.obs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('查看图片'),
        actions: [
          Obx(() => Text('${currentIndex.value + 1}/${widget.urls.length}')),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('分享'),
                onTap: () async {
                  Share.shareXFiles([
                    XFile((await CacheManager(Config(CacheKeys.bigImageKey))
                            .getFileFromCache(widget.urls[currentIndex.value]))!
                        .file
                        .path)
                  ]);
                },
              )
            ],
          )
        ],
      ),
      body: Swiper(
          loop: false,
          index: currentIndex.value,
          onIndexChanged: (value) => currentIndex.value = value,
          itemBuilder: (context, index) {
            return RepaintBoundary(
              child: PhotoView(
                filterQuality: FilterQuality.high,
                imageProvider: CachedNetworkImageProvider(widget.urls[index],
                    cacheManager: CacheManager(Config(CacheKeys.bigImageKey))),
                heroAttributes:
                    PhotoViewHeroAttributes(tag: widget.urls[index]),
              ),
            );
          },
          itemCount: widget.urls.length),
    );
  }
}
