import 'package:flutter/material.dart';

class AssetImageWithFallback extends StatelessWidget {
  const AssetImageWithFallback({
    super.key,
    required this.assetPath,
    required this.fallbackEmoji,
    this.fit = BoxFit.contain,
    this.emojiFontSize = 96,
  });

  final String assetPath;
  final String fallbackEmoji;
  final BoxFit fit;
  final double emojiFontSize;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Center(
        child: Text(
          fallbackEmoji,
          style: TextStyle(fontSize: emojiFontSize),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
