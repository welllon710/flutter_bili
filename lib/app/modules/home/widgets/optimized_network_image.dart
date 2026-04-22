import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OptimizedNetworkImage extends StatelessWidget {
  const OptimizedNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  final String url;
  final BoxFit fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (url.trim().isEmpty) {
      return _ImageStateBox(
        color: theme.colorScheme.surfaceContainerHighest,
        icon: Icons.image_not_supported_outlined,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double dpr = MediaQuery.devicePixelRatioOf(context);
        final int? memCacheWidth =
            constraints.maxWidth.isFinite
                ? (constraints.maxWidth * dpr).round()
                : null;
        final int? memCacheHeight =
            constraints.maxHeight.isFinite
                ? (constraints.maxHeight * dpr).round()
                : null;

        return CachedNetworkImage(
          imageUrl: url,
          fit: fit,
          alignment: alignment,
          filterQuality: FilterQuality.low,
          memCacheWidth: memCacheWidth,
          memCacheHeight: memCacheHeight,
          maxWidthDiskCache: memCacheWidth,
          maxHeightDiskCache: memCacheHeight,
          fadeInDuration: const Duration(milliseconds: 120),
          fadeOutDuration: Duration.zero,
          placeholder: (context, _) {
            return _ImageStateBox(
              color: theme.colorScheme.surfaceContainerHighest,
              icon: Icons.image_outlined,
            );
          },
          errorWidget: (context, _, __) {
            return _ImageStateBox(
              color: theme.colorScheme.surfaceContainerHighest,
              icon: Icons.broken_image_outlined,
            );
          },
        );
      },
    );
  }
}

class _ImageStateBox extends StatelessWidget {
  const _ImageStateBox({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Center(
        child: Icon(
          icon,
          size: 22,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}
