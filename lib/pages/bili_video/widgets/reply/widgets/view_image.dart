import 'package:bili_you/common/values/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatelessWidget {
  const ViewImage({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('查看图片'),
      ),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(url,
            cacheManager: CacheManager(Config(CacheKeys.replyImageKey))),
        enableRotation: true,
        heroAttributes: PhotoViewHeroAttributes(tag: url),
      ),
    );
  }
}
