import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/cat.dart';
import 'loading_indicator.dart';
import 'cat_bottom_sheet.dart';

class CatCard extends StatelessWidget {
  final Cat cat;
  final bool showLoader;
  final VoidCallback onImageLoaded;

  const CatCard({
    super.key,
    required this.cat,
    required this.showLoader,
    required this.onImageLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: CachedNetworkImage(
        imageUrl: cat.imageUrl,
        fit: BoxFit.cover,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,

        placeholder:
            (_, __) =>
                showLoader ? const LoadingIndicator() : const SizedBox.shrink(),

        errorWidget:
            (_, __, ___) =>
                showLoader ? const LoadingIndicator() : const SizedBox.shrink(),

        imageBuilder: (_, imageProvider) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onImageLoaded();
          });

          return GestureDetector(
            onTap:
                () => showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  isScrollControlled: true,
                  backgroundColor:
                      Theme.of(context).bottomSheetTheme.backgroundColor,
                  shape: Theme.of(context).bottomSheetTheme.shape,
                  builder: (_) => CatBottomSheet(cat: cat),
                ),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image(image: imageProvider, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
