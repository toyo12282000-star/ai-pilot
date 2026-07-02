import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ai_pilot/design_system/responsive.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_image_placeholder.dart';

/// Storage / アセット解決済み URL を Lazy Load + Cache 付きで表示する。
class ShowcaseNetworkImage extends StatelessWidget {
  const ShowcaseNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.borderRadius,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  static const String assetScheme = 'asset:';

  final String? imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final BorderRadius? borderRadius;
  final int? memCacheWidth;
  final int? memCacheHeight;

  @override
  Widget build(BuildContext context) {
    final fadeDuration = context.isMobile
        ? const Duration(milliseconds: 140)
        : const Duration(milliseconds: 200);

    final fallback = placeholder ??
        ShowcaseImagePlaceholder(
          borderRadius: borderRadius,
        );

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _wrap(fallback);
    }

    if (imageUrl!.startsWith(assetScheme)) {
      final assetPath = imageUrl!.substring(assetScheme.length);
      return _wrap(
        SvgPicture.asset(
          assetPath,
          fit: fit,
          width: width ?? memCacheWidth?.toDouble(),
          height: height ?? memCacheHeight?.toDouble(),
          placeholderBuilder: (_) => fallback,
        ),
      );
    }

    return _wrap(
      CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: fit,
        width: width,
        height: height,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        fadeInDuration: fadeDuration,
        placeholder: (_, _) => fallback,
        errorWidget: (_, _, _) => fallback,
      ),
    );
  }

  Widget _wrap(Widget child) {
    if (borderRadius == null) {
      return SizedBox(width: width, height: height, child: child);
    }
    return ClipRRect(
      borderRadius: borderRadius!,
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}
