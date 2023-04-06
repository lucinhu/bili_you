import 'package:bili_you/common/values/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class ViewImage extends StatelessWidget {
  const ViewImage({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('查看图片'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('分享'),
                onTap: () async {
                  Share.shareXFiles([
                    XFile((await CacheManager(Config(CacheKeys.replyImageKey))
                            .getFileFromCache(url))!
                        .file
                        .path)
                  ]);
                },
              )
            ],
          )
        ],
      ),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(url,
            cacheManager: CacheManager(Config(CacheKeys.replyImageKey))),
        // enableRotation: true,
        heroAttributes: PhotoViewHeroAttributes(tag: url),
      ),
    );
  }
}
