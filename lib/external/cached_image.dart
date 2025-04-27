import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_flicks/core/theme/colors.dart';

/// A generic, reusable CachedImage widget for displaying network images
/// with placeholder, error widget, and customization options.
class CachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder:
          (_, __) =>
              placeholder ??
              Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorWidget:
          (_, __, ___) =>
              errorWidget ?? Icon(Icons.error, color: AppColors.error),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    } else {
      return image;
    }
  }
}
