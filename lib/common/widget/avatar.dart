import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:bili_you/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    required this.avatarUrl,
    required this.radius,
    this.onPressed,
    this.cacheWidthHeight,
  });
  final String avatarUrl;
  final double radius;
  final Function()? onPressed;
  final int? cacheWidthHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: ClipOval(
          child: CachedNetworkImage(
              fit: BoxFit.cover,
              cacheWidth: cacheWidthHeight,
              cacheHeight: cacheWidthHeight,
              placeholder: () => Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
              imageUrl: avatarUrl,
              cacheManager: CacheManager(Config(CacheKeys.othersFaceKey))),
        ),
      ),
    );
  }
}
