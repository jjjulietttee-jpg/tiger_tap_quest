import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/card_widget.dart';

class ProfileCardList extends StatelessWidget {
  const ProfileCardList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.02),
              child: CardWidget(
                child: Text(
                  'Item ${index + 1}',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            );
          },
          childCount: 3,
        ),
      ),
    );
  }
}
