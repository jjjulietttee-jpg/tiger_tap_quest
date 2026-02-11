import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/card_widget.dart';

class AchievementCard extends StatelessWidget {
  final int index;

  const AchievementCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.02),
      child: CardWidget(
        child: Text(
          'Achievement ${index + 1}',
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}
