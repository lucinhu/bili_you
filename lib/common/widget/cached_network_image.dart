// import 'dart:async';
// import 'dart:ui';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart' as image;
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedNetworkImage extends image.CachedNetworkImage {
  CachedNetworkImage(
      {super.key,
      required String imageUrl,
      super.cacheManager,
      final Map<String, String>? headers,
      super.width,
      super.height,
      super.fit,
      super.filterQuality,
      Widget Function()? placeholder,
      Widget Function()? errorWidget,
      int? cacheWidth,
      int? cacheHeight})
      : super(
            imageUrl: imageUrl.startsWith('http://')
                ? imageUrl.replaceFirst('http://', 'https://')
                : imageUrl,
            httpHeaders: headers,
            placeholder:
                placeholder == null ? null : (context, url) => placeholder(),
            errorWidget:
                errorWidget == null ? null : (_, __, ___) => errorWidget(),
            memCacheWidth: cacheWidth,
            memCacheHeight: cacheHeight,
            fadeInDuration: const Duration(milliseconds: 200),
            fadeOutDuration: const Duration(milliseconds: 200),
            cacheKey: imageUrl);
}

// class CachedNetworkImage extends StatelessWidget {
//   const CachedNetworkImage(
//       {super.key,
//       required this.imageUrl,
//       required this.cacheManager,
//       this.headers,
//       this.width,
//       this.height,
//       this.fit,
//       this.filterQuality = FilterQuality.none,
//       this.placeholder,
//       this.errorWidget,
//       this.cacheWidth,
//       this.cacheHeight});
//   final String imageUrl;
//   final CacheManager cacheManager;
//   final Map<String, String>? headers;
//   final Widget Function()? placeholder;
//   final Widget Function()? errorWidget;
//   final int? cacheWidth;
//   final int? cacheHeight;
//   final double? width;
//   final double? height;
//   final BoxFit? fit;
//   final FilterQuality filterQuality;
//   @override
//   Widget build(BuildContext context) {
//     return image.CachedNetworkImage(
//       fadeInDuration: const Duration(milliseconds: 200),
//       fadeOutDuration: const Duration(milliseconds: 200),
//       imageUrl: imageUrl,
//       cacheManager: cacheManager,
//       cacheKey: imageUrl,
//       httpHeaders: headers,
//       filterQuality: filterQuality,
//       placeholder:
//           placeholder == null ? null : (context, url) => placeholder!(),
//       errorWidget: errorWidget == null ? null : (_, __, ___) => errorWidget!(),
//       width: width,
//       height: height,
//       memCacheWidth: cacheWidth,
//       memCacheHeight: cacheHeight,
//     );
//   }
// }

// class CachedNetworkImage extends Image {
//   CachedNetworkImage(
//       {super.key,
//       required String imageUrl,
//       required CacheManager cacheManager,
//       final Map<String, String>? headers,
//       super.semanticLabel,
//       super.width,
//       super.height,
//       super.fit,
//       super.filterQuality,
//       double scale = 1.0,
//       Widget Function()? placeholder,
//       Widget Function()? errorWidget,
//       int? cacheWidth,
//       int? cacheHeight})
//       : super(
//           image: ResizeImage.resizeIfNeeded(
//             cacheWidth,
//             cacheHeight,
//             _CachedNetworkImage(imageUrl,
//                 cacheManager: cacheManager, scale: scale, headers: headers),
//           ),
//           frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
//             return SizedBox(
//               width: width,
//               height: height,
//               child: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 200),
//                 child: frame != null
//                     ? child
//                     : placeholder?.call() ?? const SizedBox(),
//                 layoutBuilder: (currentChild, previousChildren) => Stack(
//                   fit: StackFit.expand,
//                   alignment: Alignment.center,
//                   children: [
//                     if (placeholder != null) placeholder(),
//                     ...previousChildren,
//                     if (currentChild != null) currentChild,
//                   ],
//                 ),
//               ),
//             );
//           },
//           errorBuilder: (context, error, stackTrace) => SizedBox(
//             width: width,
//             height: height,
//             child: errorWidget?.call(),
//           ),
//         );
// }

// class _CachedNetworkImage extends ImageProvider<NetworkImage>
//     implements NetworkImage {
//   const _CachedNetworkImage(
//     this.url, {
//     this.scale = 1.0,
//     required this.cacheManager,
//     this.headers,
//   });
//   @override
//   final String url;

//   @override
//   final double scale;

//   @override
//   final Map<String, String>? headers;

//   final CacheManager cacheManager;

//   @override
//   Future<NetworkImage> obtainKey(ImageConfiguration configuration) {
//     return SynchronousFuture<NetworkImage>(this);
//   }

//   @override
//   ImageStreamCompleter load(NetworkImage key, DecoderCallback decode) {
//     // Ownership of this controller is handed off to [_loadAsync]; it is that
//     // method's responsibility to close the controller's stream when the image
//     // has been loaded or an error is thrown.
//     final StreamController<ImageChunkEvent> chunkEvents =
//         StreamController<ImageChunkEvent>();

//     return MultiFrameImageStreamCompleter(
//       codec: _loadAsync(key, chunkEvents, null, decode),
//       chunkEvents: chunkEvents.stream,
//       scale: key.scale,
//       debugLabel: key.url,
//       informationCollector: () => <DiagnosticsNode>[
//         DiagnosticsProperty<ImageProvider>('Image provider', this),
//         DiagnosticsProperty<NetworkImage>('Image key', key),
//       ],
//     );
//   }

//   @override
//   ImageStreamCompleter loadBuffer(
//       NetworkImage key, DecoderBufferCallback decode) {
//     // Ownership of this controller is handed off to [_loadAsync]; it is that
//     // method's responsibility to close the controller's stream when the image
//     // has been loaded or an error is thrown.
//     final StreamController<ImageChunkEvent> chunkEvents =
//         StreamController<ImageChunkEvent>();

//     return MultiFrameImageStreamCompleter(
//       codec: _loadAsync(key, chunkEvents, decode, null),
//       chunkEvents: chunkEvents.stream,
//       scale: key.scale,
//       debugLabel: key.url,
//       informationCollector: () => <DiagnosticsNode>[
//         DiagnosticsProperty<ImageProvider>('Image provider', this),
//         DiagnosticsProperty<NetworkImage>('Image key', key),
//       ],
//     );
//   }

//   Future<Codec> _loadAsync(
//     NetworkImage key,
//     StreamController<ImageChunkEvent> chunkEvents,
//     DecoderBufferCallback? decode,
//     DecoderCallback? decodeDepreacted,
//   ) async {
//     try {
//       assert(key == this);
//       final Uint8List bytes =
//           await (await cacheManager.getSingleFile(url, headers: headers))
//               .readAsBytes();

//       // late final Uint8List bytes;
//       // FileInfo? file = (await cacheManager.getFileFromCache(url));
//       // if (file != null) {
//       //   //缓存中存在该图片
//       //   bytes = await file.file.readAsBytes();
//       // } else {
//       //   bytes = (await MyDio.dio.get(
//       //     url,
//       //     options: Options(responseType: ResponseType.bytes, headers: headers),
//       //     onReceiveProgress: (count, total) {
//       //       chunkEvents.add(ImageChunkEvent(
//       //         cumulativeBytesLoaded: count,
//       //         expectedTotalBytes: total,
//       //       ));
//       //     },
//       //   ))
//       //       .data;
//       //   cacheManager.putFile(url, bytes);
//       // }

//       if (bytes.lengthInBytes == 0) {
//         throw Exception('NetworkImage is an empty file: $url');
//       }

//       if (decode != null) {
//         final ImmutableBuffer buffer =
//             await ImmutableBuffer.fromUint8List(bytes);
//         return decode(buffer);
//       } else {
//         assert(decodeDepreacted != null);
//         return decodeDepreacted!(bytes);
//       }
//     } catch (e) {
//       // Depending on where the exception was thrown, the image cache may not
//       // have had a chance to track the key in the cache at all.
//       // Schedule a microtask to give the cache a chance to add the key.
//       scheduleMicrotask(() {
//         PaintingBinding.instance.imageCache.evict(key);
//       });
//       rethrow;
//     } finally {
//       chunkEvents.close();
//     }
//   }

//   @override
//   bool operator ==(Object other) {
//     if (other.runtimeType != runtimeType) {
//       return false;
//     }
//     return other is NetworkImage && other.url == url && other.scale == scale;
//   }

//   @override
//   int get hashCode => Object.hash(url, scale);

//   @override
//   String toString() =>
//       '${objectRuntimeType(this, 'NetworkImage')}("$url", scale: $scale)';
// }
