import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';

class ProfileStatsContentParts {
  const ProfileStatsContentParts._();

  static Widget buildCoins(BuildContext context, dynamic stats) {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Current coins',
      value: '${stats.coins}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🪙', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            CustomText(
              stats.coins.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildSectionTitle(BuildContext context, String title, String emoji) {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Section $title',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 8),
            CustomText(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildStatsGrid(BuildContext context, dynamic stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        buildStatCard(context, 'Best Score', stats.bestScore.toString(), '⭐'),
        buildStatCard(context, 'Games Played', stats.totalGamesPlayed.toString(), '🎮'),
        buildStatCard(context, 'Games Won', stats.totalGamesCompleted.toString(), '🏅'),
        buildStatCard(context, 'Best Combo', stats.bestCombo.toString(), '🔥'),
      ],
    );
  }

  static Widget buildModeStats(BuildContext context, dynamic stats) {
    return Column(
      children: [
        buildModeCard(
          context,
          'Survival Mode',
          'Best Score: ${stats.survivalBestScore}',
          '💪',
          Colors.red,
        ),
        const SizedBox(height: 12),
        buildModeCard(
          context,
          'Clear Mode',
          stats.clearBestTime > 0
              ? 'Best Time: ${stats.clearBestTime}s'
              : 'Not played yet',
          '⚡',
          Colors.blue,
        ),
        const SizedBox(height: 12),
        buildModeCard(
          context,
          'Score Rush',
          'Best Score: ${stats.scoreRushBestScore}',
          '🚀',
          Colors.purple,
        ),
      ],
    );
  }

  static Widget buildCollectionStats(BuildContext context, dynamic stats) {
    return Column(
      children: [
        buildProgressCard(context, 'Fruits Collected', stats.totalFruitsCollected, '🍎'),
        const SizedBox(height: 12),
        buildProgressCard(context, 'Power-Ups Used', stats.totalPowerUpsCollected, '💎'),
        const SizedBox(height: 12),
        buildProgressCard(context, 'Bombs Exploded', stats.totalBombsUsed, '💣'),
      ],
    );
  }

  static Widget buildPerformanceStats(BuildContext context, dynamic stats) {
    final winRate = stats.totalGamesPlayed > 0
        ? ((stats.totalGamesCompleted / stats.totalGamesPlayed) * 100).toStringAsFixed(1)
        : '0.0';
    final avgScore = stats.totalGamesPlayed > 0
        ? (stats.bestScore / stats.totalGamesPlayed).toStringAsFixed(0)
        : '0';

    return Column(
      children: [
        buildStatRow(context, 'Win Rate', '$winRate%', '🎯'),
        const SizedBox(height: 12),
        buildStatRow(context, 'Average Score', avgScore, '📊'),
        const SizedBox(height: 12),
        buildStatRow(context, 'Total Playtime', '${stats.totalGamesPlayed * 2} min', '⏱️'),
      ],
    );
  }

  static Widget buildStatRow(BuildContext context, String label, String value, String emoji) {
    final theme = Theme.of(context);
    return Semantics(
      label: '$label: $value',
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A).withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: CustomText(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                ),
              ),
            ),
            CustomText(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildStatCard(BuildContext context, String label, String value, String emoji) {
    final theme = Theme.of(context);
    return Semantics(
      label: '$label: $value',
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A).withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 6),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomText(
                      value,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CustomText(
                        label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static Widget buildModeCard(
      BuildContext context, String title, String subtitle, String emoji, Color color) {
    final theme = Theme.of(context);
    return Semantics(
      label: '$title, $subtitle',
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A).withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 32))),
          ),
          title: CustomText(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: CustomText(
              subtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildProgressCard(BuildContext context, String label, int value, String emoji) {
    final theme = Theme.of(context);
    return Semantics(
      label: '$label: $value',
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A).withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 32))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    label,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    value.toString(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
