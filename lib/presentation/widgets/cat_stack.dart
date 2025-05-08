import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/cat.dart';
import 'cat_card.dart';

class CatStack extends StatelessWidget {
  final List<Cat> cats;
  final ValueChanged<bool> onSwipe;
  final VoidCallback onTopLoaded;

  final bool isLoading;

  const CatStack({
    super.key,
    required this.cats,
    required this.onSwipe,
    required this.onTopLoaded,
    this.isLoading = false,
  });

  static const _duration = Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context) {
    final count = math.min(3, cats.length);
    final width = MediaQuery.of(context).size.width * 0.9;
    final height = width * 4 / 3 + 40;

    return SizedBox(
      width: width,
      height: height + 24,
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(count, (i) {
          final depth = count - i - 1;
          final cat = cats[depth];
          final offset = depth * 12.0;
          final scale = depth == 0 ? 1.0 : 1 - depth * 0.05;

          final card =
              depth == 0
                  ? Dismissible(
                    key: ObjectKey(cat),
                    direction: DismissDirection.horizontal,
                    onDismissed:
                        (dir) => onSwipe(
                          dir == DismissDirection.endToStart ? false : true,
                        ),
                    child: CatCard(
                      cat: cat,
                      showLoader: isLoading,
                      onImageLoaded: onTopLoaded,
                    ),
                  )
                  : CatCard(cat: cat, showLoader: false, onImageLoaded: () {});

          return AnimatedPositioned(
            key: ObjectKey(cat),
            duration: _duration,
            curve: Curves.easeOutExpo,
            left: 0,
            right: 0,
            bottom: offset,
            child: AnimatedScale(
              scale: scale,
              duration: _duration,
              curve: Curves.easeOutExpo,
              alignment: Alignment.bottomCenter,
              child: SizedBox(width: width, height: height, child: card),
            ),
          );
        }),
      ),
    );
  }
}
