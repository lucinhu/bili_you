import 'dart:math';

import 'package:bili_you/common/models/local/reply/official_verify.dart';
import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:bili_you/index.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget(
      {super.key,
      required this.avatarUrl,
      required this.radius,
      this.onPressed,
      this.cacheWidthHeight,
      this.officialVerifyType});
  final String avatarUrl;
  final double radius;
  final Function()? onPressed;
  final int? cacheWidthHeight;
  final OfficialVerifyType? officialVerifyType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipOval(
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  cacheWidth: cacheWidthHeight ??
                      (MediaQuery.of(context).devicePixelRatio * radius * 2)
                          .toInt(),
                  cacheHeight: cacheWidthHeight ??
                      (MediaQuery.of(context).devicePixelRatio * radius * 2)
                          .toInt(),
                  placeholder: () => Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                  imageUrl: avatarUrl,
                  cacheManager: CacheUtils.othersFaceCacheManager),
            ),
            if (officialVerifyType != null &&
                officialVerifyType != OfficialVerifyType.none)
              Positioned(
                  left: radius - radius / 3 + radius * sin(pi / 4),
                  top: radius - radius / 3 + radius * sin(pi / 4),
                  width: radius * 2 / 3,
                  height: radius * 2 / 3,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                        shape: CircleBorder(
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.background,
                                width: 2)),
                        color: officialVerifyType == OfficialVerifyType.person
                            ? Colors.amber
                            : Colors.blue),
                    child: Icon(
                      Icons.electric_bolt_rounded,
                      size: radius / 3,
                      color: Colors.white,
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
