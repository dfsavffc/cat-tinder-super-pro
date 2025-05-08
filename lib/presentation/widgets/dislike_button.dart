import 'package:flutter/material.dart';

class DislikeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DislikeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final imageAsset =
        brightness == Brightness.dark
            ? 'assets/images/dislike_light.png'
            : 'assets/images/dislike_dark.png';

    return IconButton(
      onPressed: onPressed,
      icon: SizedBox(
        width: 60,
        height: 60,
        child: Image.asset(imageAsset, fit: BoxFit.contain),
      ),
    );
  }
}
