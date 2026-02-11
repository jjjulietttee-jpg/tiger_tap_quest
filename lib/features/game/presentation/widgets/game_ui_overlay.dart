import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';
import 'package:tiger_tap_quest/features/game/presentation/widgets/power_up_indicator.dart';

class GameUIOverlay extends StatelessWidget {
  final int score;
  final int lives;
  final int combo;
  final int comboMultiplier;
  final Duration? remainingTime;
  final int bubblesPopped;
  final int? targetBubbles;
  final VoidCallback onPause;
  final DateTime? slowmoEndTime;
  final DateTime? freezeEndTime;
  final DateTime? starEndTime;

  const GameUIOverlay({
    super.key,
    required this.score,
    required this.lives,
    required this.combo,
    required this.comboMultiplier,
    this.remainingTime,
    required this.bubblesPopped,
    this.targetBubbles,
    required this.onPause,
    this.slowmoEndTime,
    this.freezeEndTime,
    this.starEndTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return IgnorePointer(
      ignoring: false,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Score (non-interactive)
                  IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.stars,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            score.toString(),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Pause button (interactive)
                  IconButton(
                    onPressed: onPause,
                    icon: Icon(
                      Icons.pause_circle,
                      color: theme.colorScheme.onSurface,
                      size: 36,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Power-ups row - non-interactive
              if (_hasActivePowerUps())
                IgnorePointer(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (slowmoEndTime != null && DateTime.now().isBefore(slowmoEndTime!))
                            PowerUpIndicator(
                              emoji: '⏱️',
                              color: const Color(0xFF9C27B0),
                              remainingTime: slowmoEndTime!.difference(DateTime.now()),
                              totalDuration: const Duration(seconds: 5),
                            ),
                          if (freezeEndTime != null && DateTime.now().isBefore(freezeEndTime!))
                            PowerUpIndicator(
                              emoji: '❄️',
                              color: const Color(0xFF03A9F4),
                              remainingTime: freezeEndTime!.difference(DateTime.now()),
                              totalDuration: const Duration(seconds: 3),
                            ),
                          if (starEndTime != null && DateTime.now().isBefore(starEndTime!))
                            PowerUpIndicator(
                              emoji: '🌟',
                              color: const Color(0xFFFFC107),
                              remainingTime: starEndTime!.difference(DateTime.now()),
                              totalDuration: const Duration(seconds: 10),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              // Lives (if not unlimited) - non-interactive
              if (lives < 100)
                IgnorePointer(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          lives,
                          (index) => Icon(
                            Icons.favorite,
                            color: Colors.red.shade400,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              // Timer (if time attack mode) - non-interactive
              if (remainingTime != null) ...[
                const SizedBox(height: 8),
                IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer,
                          color: remainingTime!.inSeconds < 10
                              ? Colors.red.shade400
                              : theme.colorScheme.secondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          '${remainingTime!.inSeconds}s',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: remainingTime!.inSeconds < 10
                                ? Colors.red.shade400
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const Spacer(),
              // Bubbles popped counter (for Clear mode)
              if (targetBubbles != null)
                IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bubble_chart,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          '$bubblesPopped / $targetBubbles',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              // Combo indicator - non-interactive
              if (combo > 0)
                IgnorePointer(
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey(combo), // Restart animation on combo change
                    tween: Tween(begin: 0.8, end: 1.0),
                    duration: const Duration(milliseconds: 200),
                    builder: (context, scale, child) {
                      // More intense effects for higher combos
                      final isHighCombo = combo >= 10;
                      final isMediumCombo = combo >= 5;
                      
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isHighCombo
                                  ? [
                                      Colors.purple,
                                      Colors.pink,
                                      Colors.orange,
                                    ]
                                  : isMediumCombo
                                      ? [
                                          theme.colorScheme.primary,
                                          Colors.orange,
                                        ]
                                      : [
                                          theme.colorScheme.primary,
                                          theme.colorScheme.secondary,
                                        ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: (isHighCombo
                                        ? Colors.purple
                                        : theme.colorScheme.primary)
                                    .withValues(alpha: 0.6),
                                blurRadius: isHighCombo ? 30 : 20,
                                spreadRadius: isHighCombo ? 4 : 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isHighCombo
                                    ? Icons.whatshot
                                    : Icons.local_fire_department,
                                color: Colors.white,
                                size: isHighCombo ? 32 : 28,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                'COMBO x$comboMultiplier',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isHighCombo ? 22 : 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                combo.toString(),
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isHighCombo ? 32 : 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasActivePowerUps() {
    final now = DateTime.now();
    return (slowmoEndTime != null && now.isBefore(slowmoEndTime!)) ||
           (freezeEndTime != null && now.isBefore(freezeEndTime!)) ||
           (starEndTime != null && now.isBefore(starEndTime!));
  }
}
