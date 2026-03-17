import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiger_tap_quest/core/domain/bloc/stats_bloc.dart';
import 'package:tiger_tap_quest/core/theme/app_theme.dart';

class HomeStatsSection extends StatelessWidget {
  const HomeStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const SizedBox(height: 80);
        }
        final stats = state.stats;
        return Row(
          children: [
            Expanded(
              child: _GlassStatCard(
                icon: Icons.star_rounded,
                iconColor: AppTheme.gold,
                value: stats.bestScore.toString(),
                label: 'Best',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _GlassStatCard(
                icon: Icons.sports_esports_rounded,
                iconColor: AppTheme.jungleGreen,
                value: stats.totalGamesPlayed.toString(),
                label: 'Games',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _GlassStatCard(
                icon: Icons.local_fire_department_rounded,
                iconColor: AppTheme.orange,
                value: stats.bestCombo.toString(),
                label: 'Combo',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _GlassStatCard(
                icon: Icons.catching_pokemon_rounded,
                iconColor: const Color(0xFFAB47BC),
                value: stats.totalFruitsCollected.toString(),
                label: 'Fruits',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GlassStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _GlassStatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
