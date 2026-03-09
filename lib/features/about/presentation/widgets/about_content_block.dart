import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/card_widget.dart';

class AboutContentBlock extends StatelessWidget {
  const AboutContentBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
        child: CardWidget(
          child: Text(
            'A score-focused mobile game with tapping mechanics, '
            'collectibles and progression through achievements, '
            'modes, and power-up upgrades.',
            style: theme.textTheme.bodyLarge,
            semanticsLabel:
                'Additional information about the app and gameplay',
          ),
        ),
      ),
    );
  }
}
