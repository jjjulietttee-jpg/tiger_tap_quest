import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_elevated_button.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';

class PauseDialog extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onExit;

  const PauseDialog({
    super.key,
    required this.onResume,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.06),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pause_circle_outline,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            CustomText(
              'Paused',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            CustomElevatedButton(
              onPressed: onResume,
              child: const Text('Resume'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onExit,
              child: CustomText(
                'Exit to Menu',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
