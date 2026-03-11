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
            'Tap rising fruits to score points across three exciting game modes. '
            'Collect achievements, upgrade your abilities in the shop, and climb the leaderboard!',
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
