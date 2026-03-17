import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/theme/app_theme.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const Text('🐯', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 4),
        Text(
          'Tiger Tap Quest',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            shadows: [
              Shadow(
                color: AppTheme.orange.withValues(alpha: 0.6),
                blurRadius: 16,
              ),
              Shadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
