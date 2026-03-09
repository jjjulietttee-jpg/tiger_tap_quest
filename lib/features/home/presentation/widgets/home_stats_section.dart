import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiger_tap_quest/core/shared/widgets/card_widget.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';
import 'package:tiger_tap_quest/core/domain/bloc/stats_bloc.dart';

class HomeStatsSection extends StatelessWidget {
  const HomeStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final spacing = size.width * 0.03;

    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = state.stats;

        return Padding(
          padding: EdgeInsets.only(
            top: size.height * 0.01,
            bottom: size.height * 0.025,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: size.width * 0.02,
                  bottom: size.height * 0.015,
                ),
                child: Row(
                  children: [
                    Text('📊', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 8),
                    CustomText(
                      'Your Stats',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Best Score',
                      value: stats.bestScore.toString(),
                      emoji: '⭐',
                      theme: theme,
                      size: size,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: _StatCard(
                      label: 'Games',
                      value: stats.totalGamesPlayed.toString(),
                      emoji: '🎮',
                      theme: theme,
                      size: size,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: _StatCard(
                      label: 'Best Combo',
                      value: stats.bestCombo.toString(),
                      emoji: '🔥',
                      theme: theme,
                      size: size,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;
  final ThemeData theme;
  final Size size;

  const _StatCard({
    required this.label,
    required this.value,
    required this.emoji,
    required this.theme,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.02,
        vertical: size.height * 0.018,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: 28)),
          SizedBox(height: size.height * 0.008),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.006),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
