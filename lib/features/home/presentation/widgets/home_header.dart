import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          size.width * 0.06,
          size.height * 0.04,
          size.width * 0.06,
          size.height * 0.02,
        ),
        child: CustomText(
          'Menu',
          style: theme.textTheme.displayLarge,
        ),
      ),
    );
  }
}
