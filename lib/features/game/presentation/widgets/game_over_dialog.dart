import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_elevated_button.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';

class GameOverDialog extends StatelessWidget {
  final int score;
  final int bestCombo;
  final int bubblesPopped;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const GameOverDialog({
    super.key,
    required this.score,
    required this.bestCombo,
    required this.bubblesPopped,
    required this.onRestart,
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
              Icons.emoji_events,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            CustomText(
              'Game Over!',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            _buildStatRow(
              context,
              'Score',
              score.toString(),
              Icons.stars,
              theme,
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              context,
              'Best Combo',
              bestCombo.toString(),
              Icons.local_fire_department,
              theme,
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              context,
              'Bubbles Popped',
              bubblesPopped.toString(),
              Icons.bubble_chart,
              theme,
            ),
            const SizedBox(height: 24),
            CustomElevatedButton(
              onPressed: onRestart,
              child: const Text('Play Again'),
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

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomText(
              label,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          CustomText(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
