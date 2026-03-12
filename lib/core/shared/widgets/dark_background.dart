import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/utils/asset_paths.dart';

class DarkBackground extends StatelessWidget {
  final double darkenOpacity;

  const DarkBackground({super.key, this.darkenOpacity = 0.78});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Image.asset(
            AssetPaths.bgImage,
            fit: BoxFit.cover,
            excludeFromSemantics: true,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: darkenOpacity),
          ),
        ),
      ],
    );
  }
}
