import 'package:flutter/material.dart';

class AboutPopupContent extends StatelessWidget {
  const AboutPopupContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Tiger Tap Quest',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          semanticsLabel: 'App name Tiger Tap Quest',
        ),
        SizedBox(height: size.height * 0.015),
        Text(
          'Version 1.0.0+2',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
          semanticsLabel: 'App version 1 point 0 point 0 plus 2',
        ),
        SizedBox(height: size.height * 0.025),
        Text(
          'Fast arcade tapping game in a jungle setting. Tap fruits, activate power-ups,'
              ' and climb your best score in multiple modes.',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
          semanticsLabel:
              'Game description: fast arcade tapping game in jungle theme with multiple modes and power-ups',
        ),
      ],
    );
  }
}
