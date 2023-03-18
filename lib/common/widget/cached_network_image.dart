import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedNetworkImage extends StatelessWidget {
  CachedNetworkImage(
      {super.key,
      required this.imageUrl,
      required this.cacheManager,
      this.semanticLabel,
      this.width,
      this.height,
      this.fit,
      this.placeholder,
      this.errorWidget,
      this.filterQuality = FilterQuality.low})
      : _cachedNetworkImage =
            _CachedNetworkImage(imageUrl, cacheManager: cacheManager);
  final String imageUrl;
  final CacheManager cacheManager;
  final String? semanticLabel;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext context)? placeholder;
  final Widget Function(BuildContext context)? errorWidget;
  final FilterQuality filterQuality;
  final _CachedNetworkImage _cachedNetworkImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: Image(
          image: _cachedNetworkImage,
          semanticLabel: semanticLabel,
          width: width,
          height: height,
          fit: fit,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: frame != null
                  ? child
                  : placeholder?.call(context) ?? const SizedBox(),
              layoutBuilder: (currentChild, previousChildren) => Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: <Widget>[
                  placeholder?.call(context) ??
                      const SizedBox(), //placeholder放在最底层，防止背景颜色突变过渡不自然
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              ),
            );
          },
          errorBuilder: errorWidget == null
              ? null
              : (context, error, stackTrace) =>
                  errorWidget?.call(context) ?? const SizedBox(),
          filterQuality: filterQuality,
        ));
  }
}

class _CachedNetworkImage extends ImageProvider<NetworkImage>
    implements NetworkImage {
  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments [url] and [scale] must not be null.
  const _CachedNetworkImage(
    this.url, {
    this.scale = 1.0,
    required this.cacheManager,
    this.headers,
  });

  @override
  final String url;

  @override
  final double scale;

  @override
  final Map<String, String>? headers;

  final CacheManager cacheManager;

  @override
  Future<NetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<NetworkImage>(this);
  }

  @override
  ImageStreamCompleter load(NetworkImage key, DecoderCallback decode) {
    // Ownership of this controller is handed off to [_loadAsync]; it is that
    // method's responsibility to close the controller's stream when the image
    // has been loaded or an error is thrown.
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, null, decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<NetworkImage>('Image key', key),
      ],
    );
  }

  @override
  ImageStreamCompleter loadBuffer(
      NetworkImage key, DecoderBufferCallback decode) {
    // Ownership of this controller is handed off to [_loadAsync]; it is that
    // method's responsibility to close the controller's stream when the image
    // has been loaded or an error is thrown.
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode, null),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<NetworkImage>('Image key', key),
      ],
    );
  }

  Future<Codec> _loadAsync(
    NetworkImage key,
    StreamController<ImageChunkEvent> chunkEvents,
    DecoderBufferCallback? decode,
    DecoderCallback? decodeDepreacted,
  ) async {
    try {
      assert(key == this);
      final Uint8List bytes =
          await (await cacheManager.getSingleFile(url, headers: headers))
              .readAsBytes();
      chunkEvents.add(ImageChunkEvent(
        cumulativeBytesLoaded: bytes.length,
        expectedTotalBytes: bytes.length,
      ));
      if (bytes.lengthInBytes == 0) {
        throw Exception('NetworkImage is an empty file: $url');
      }

      if (decode != null) {
        final ImmutableBuffer buffer =
            await ImmutableBuffer.fromUint8List(bytes);
        return decode(buffer);
      } else {
        assert(decodeDepreacted != null);
        return decodeDepreacted!(bytes);
      }
    } catch (e) {
      // Depending on where the exception was thrown, the image cache may not
      // have had a chance to track the key in the cache at all.
      // Schedule a microtask to give the cache a chance to add the key.
      scheduleMicrotask(() {
        PaintingBinding.instance.imageCache.evict(key);
      });
      rethrow;
    } finally {
      chunkEvents.close();
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is NetworkImage && other.url == url && other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(url, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'NetworkImage')}("$url", scale: $scale)';
}
