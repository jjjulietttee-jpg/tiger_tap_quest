import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';

class AboutHeader extends StatelessWidget {
  const AboutHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          size.width * 0.02,
          size.height * 0.04,
          size.width * 0.04,
          size.height * 0.02,
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/menu');
                }
              },
            ),
            Expanded(
              child: CustomText(
                'About',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
