import 'package:bili_you/common/utils/cache_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';

class ShowDialog {
  ///显示图片
  static showImageViewer(
      {required BuildContext context,
      required List<String> urls,
      int initIndex = 0}) {
    var controller = PageController(initialPage: initIndex);
    var currentIndex = initIndex;
    showDialog(
        useSafeArea: false,
        context: context,
        builder: (context) => Container(
              color: Colors.black,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Stack(
                    children: [
                      PhotoViewGallery.builder(
                          onPageChanged: (index) =>
                              setState(() => currentIndex = index),
                          scrollPhysics: const BouncingScrollPhysics(),
                          itemCount: urls.length,
                          pageController: controller,
                          builder: (context, index) =>
                              PhotoViewGalleryPageOptions(
                                filterQuality: FilterQuality.high,
                                minScale: PhotoViewComputedScale.contained,
                                maxScale:
                                    PhotoViewComputedScale.contained * 6.0,
                                initialScale: PhotoViewComputedScale.contained,
                                heroAttributes:
                                    PhotoViewHeroAttributes(tag: urls[index]),
                                imageProvider: CachedNetworkImageProvider(
                                    urls[index],
                                    cacheManager:
                                        CacheUtils.bigImageCacheManager),
                              )),
                      Container(
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                                offset: Offset(0, -20),
                                color: Colors.black12,
                                blurRadius: 20,
                                spreadRadius: 20)
                          ]),
                          child: SafeArea(
                            bottom: false,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close,
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyMedium!
                                          .color,
                                      shadows: const [
                                        Shadow(
                                            color: Colors.black54,
                                            blurRadius: 2),
                                      ]),
                                ),
                                const Spacer(),
                                Text(
                                    style: TextStyle(
                                      shadows: const [
                                        Shadow(
                                            color: Colors.black54,
                                            blurRadius: 2),
                                      ],
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyMedium!
                                          .color,
                                    ),
                                    '${currentIndex + 1}/${urls.length}'),
                                PopupMenuButton(
                                  icon: Icon(Icons.more_vert_rounded,
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyMedium!
                                          .color,
                                      shadows: const [
                                        Shadow(
                                            color: Colors.black54,
                                            blurRadius: 2),
                                      ]),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: const Text('分享'),
                                      onTap: () async {
                                        Share.shareXFiles([
                                          XFile((await CacheUtils
                                                  .bigImageCacheManager
                                                  .getFileFromCache(
                                                      urls[currentIndex]))!
                                              .file
                                              .path)
                                        ]);
                                      },
                                    ),
                                    PopupMenuItem(
                                        child: const Text('保存到相册'),
                                        onTap: () async {
                                          var cachedFile = await CacheUtils
                                              .bigImageCacheManager
                                              .getFileFromCache(
                                                  urls[currentIndex]);
                                          //保存圖片到相冊
                                          final result =
                                              await ImageGallerySaver.saveFile(
                                                  cachedFile!.file.path);
                                          //圖片保存成功
                                          if (result['isSuccess']) {
                                            Get.rawSnackbar(message: "保存成功");
                                          } else{
                                            Get.rawSnackbar(message: "保存失敗");
                                          }
                                        })
                                  ],
                                )
                              ],
                            ),
                          )),
                    ],
                  );
                },
              ),
            ));
  }
}
