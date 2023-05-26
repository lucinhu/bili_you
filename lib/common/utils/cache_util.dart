import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheUtils {
  static const String userFaceKey = 'userFace';
  static const String othersFaceKey = 'othersFace';
  static const String recommendItemCoverKey = 'recommendItemCover';
  static const String searchResultItemCoverKey = 'searchResultItemCover';
  static const String relatedVideosItemCoverKey = 'relatedVideosItemCover';
  static const String dynamicVideoItemCoverKey = 'dynamicVideoItemCover';
  static const String emoteKey = 'emote';
  static const String bigImageKey = 'bigImageKey';

  static final CacheManager userFaceCacheManager =
      CacheManager(Config(userFaceKey));
  static final CacheManager othersFaceCacheManager =
      CacheManager(Config(othersFaceKey));
  static final CacheManager recommendItemCoverCacheManager =
      CacheManager(Config(recommendItemCoverKey));
  static final CacheManager searchResultItemCoverCacheManager =
      CacheManager(Config(searchResultItemCoverKey));
  static final CacheManager relatedVideosItemCoverCacheManager =
      CacheManager(Config(relatedVideosItemCoverKey));
  static final CacheManager dynamicVideoItemCoverCacheManager =
      CacheManager(Config(dynamicVideoItemCoverKey));
  static final CacheManager emoteCacheManager = CacheManager(Config(emoteKey));
  static final CacheManager bigImageCacheManager =
      CacheManager(Config(bigImageKey));
  static final List<CacheManager> cacheMangerList = [
    userFaceCacheManager,
    othersFaceCacheManager,
    recommendItemCoverCacheManager,
    searchResultItemCoverCacheManager,
    relatedVideosItemCoverCacheManager,
    dynamicVideoItemCoverCacheManager,
    emoteCacheManager,
    bigImageCacheManager
  ];

  ///释放所有图像内存
  static void clearAllCacheImageMem() {
    for (var cacheManager in cacheMangerList) {
      cacheManager.store.emptyMemoryCache();
    }
  }

  ///删除所有图片缓存（除了用户头像缓存）
  static Future<void> deleteAllCacheImage() async {
    for (var cacheManager in cacheMangerList) {
      //不删除用户头像
      if (cacheManager == userFaceCacheManager) continue;
      await cacheManager.store.emptyCache();
    }
  }
}
