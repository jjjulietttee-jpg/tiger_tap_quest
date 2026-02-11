import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiger_tap_quest/core/shared/widgets/card_widget.dart';

class HomeNavigationGrid extends StatelessWidget {
  const HomeNavigationGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.06,
        vertical: size.height * 0.02,
      ),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final items = [
              ('Profile', '/profile'),
              ('Achievements', '/achievements'),
              ('About', '/about'),
            ];
            final item = items[index];
            return CardWidget(
              onTap: () => context.push(item.$2),
              child: Center(
                child: Text(
                  item.$1,
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            );
          },
          childCount: 3,
        ),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.5,
        ),
      ),
    );
  }
}
