import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';

class GamePlaceholder extends StatelessWidget {
  const GamePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return SliverToBoxAdapter(
      child: SizedBox(
        width: size.width,
        height: size.height * 0.75,
        child: Center(
          child: CustomText(
            'Game',
            style: theme.textTheme.displayLarge,
          ),
        ),
      ),
    );
  }
}
