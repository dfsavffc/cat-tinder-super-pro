import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Center(
        child: Image.asset(
          'assets/images/loading_cat.png',
          width: 160,
          height: 160,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
