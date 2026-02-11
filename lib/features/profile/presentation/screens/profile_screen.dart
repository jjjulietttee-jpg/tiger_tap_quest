import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';
import 'package:tiger_tap_quest/core/domain/bloc/stats_bloc.dart';
import 'package:tiger_tap_quest/core/data/services/stats_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.75),
            ),
          ),
          // Content
          SafeArea(
            child: BlocBuilder<StatsBloc, StatsState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final stats = state.stats;
                final profileName = state.profileName ?? 'Player';

                return CustomScrollView(
                  slivers: [
                    // App Bar - transparent with bg.png visible
                    SliverAppBar(
                      expandedHeight: 160,
                      pinned: true,
                      backgroundColor: Colors.black.withValues(alpha: 0.6),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          color: Colors.transparent,
                          child: SafeArea(
                            child: SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: 160,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 20),
                                      // Avatar with glow
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: theme.colorScheme.primary.withValues(alpha: 0.4),
                                              blurRadius: 20,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '🐯',
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      // Coins display
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF2A2A2A).withValues(alpha: 0.8),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: Colors.white.withValues(alpha: 0.2),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('🪙', style: TextStyle(fontSize: 14)),
                                            SizedBox(width: 4),
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
                                      const SizedBox(height: 4),
                                      // Name with edit button
                                      GestureDetector(
                                        onTap: () => _showEditNameDialog(context),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.white.withValues(alpha: 0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: CustomText(
                                                  profileName,
                                                  style: theme.textTheme.bodyMedium?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Content
                    SliverPadding(
                      padding: EdgeInsets.all(size.width * 0.04),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Stats Section
                          _buildSectionTitle(context, 'Game Statistics', '📊'),
                          const SizedBox(height: 12),
                          _buildStatsGrid(context, stats),
                          const SizedBox(height: 24),
                          
                          // Mode Stats
                          _buildSectionTitle(context, 'Mode Records', '🏆'),
                          const SizedBox(height: 12),
                          _buildModeStats(context, stats),
                          const SizedBox(height: 24),
                          
                          // Collection Stats
                          _buildSectionTitle(context, 'Collection', '🎯'),
                          const SizedBox(height: 12),
                          _buildCollectionStats(context, stats),
                          const SizedBox(height: 24),
                          
                          // Additional Stats
                          _buildSectionTitle(context, 'Performance', '📈'),
                          const SizedBox(height: 12),
                          _buildPerformanceStats(context, stats),
                          const SizedBox(height: 24),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, String emoji) {
    final theme = Theme.of(context);
    return Container(
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
    );
  }

  Widget _buildStatsGrid(BuildContext context, stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(context, 'Best Score', stats.bestScore.toString(), '⭐'),
        _buildStatCard(context, 'Games Played', stats.totalGamesPlayed.toString(), '🎮'),
        _buildStatCard(context, 'Games Won', stats.totalGamesCompleted.toString(), '🏅'),
        _buildStatCard(context, 'Best Combo', stats.bestCombo.toString(), '🔥'),
      ],
    );
  }

  Widget _buildModeStats(BuildContext context, stats) {
    return Column(
      children: [
        _buildModeCard(
          context,
          'Survival Mode',
          'Best Score: ${stats.survivalBestScore}',
          '💪',
          Colors.red,
        ),
        const SizedBox(height: 12),
        _buildModeCard(
          context,
          'Clear Mode',
          stats.clearBestTime > 0 
              ? 'Best Time: ${stats.clearBestTime}s'
              : 'Not played yet',
          '⚡',
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildModeCard(
          context,
          'Score Rush',
          'Best Score: ${stats.scoreRushBestScore}',
          '🚀',
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildCollectionStats(BuildContext context, stats) {
    return Column(
      children: [
        _buildProgressCard(
          context,
          'Fruits Collected',
          stats.totalFruitsCollected,
          '🍎',
        ),
        const SizedBox(height: 12),
        _buildProgressCard(
          context,
          'Power-Ups Used',
          stats.totalPowerUpsCollected,
          '💎',
        ),
        const SizedBox(height: 12),
        _buildProgressCard(
          context,
          'Bombs Exploded',
          stats.totalBombsUsed,
          '💣',
        ),
      ],
    );
  }

  Widget _buildPerformanceStats(BuildContext context, stats) {
    final winRate = stats.totalGamesPlayed > 0
        ? ((stats.totalGamesCompleted / stats.totalGamesPlayed) * 100).toStringAsFixed(1)
        : '0.0';
    final avgScore = stats.totalGamesPlayed > 0
        ? (stats.bestScore / stats.totalGamesPlayed).toStringAsFixed(0)
        : '0';
    
    return Column(
      children: [
        _buildStatRow(context, 'Win Rate', '$winRate%', '🎯'),
        const SizedBox(height: 12),
        _buildStatRow(context, 'Average Score', avgScore, '📊'),
        const SizedBox(height: 12),
        _buildStatRow(context, 'Total Playtime', '${stats.totalGamesPlayed * 2} min', '⏱️'),
      ],
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, String emoji) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A).withValues(alpha: 0.7),
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
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, String emoji) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A).withValues(alpha: 0.7),
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
    );
  }

  Widget _buildModeCard(
      BuildContext context, String title, String subtitle, String emoji, Color color) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A).withValues(alpha: 0.7),
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
            color: Color(0xFF3A3A3A).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
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
    );
  }

  Widget _buildProgressCard(BuildContext context, String label, int value, String emoji) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A).withValues(alpha: 0.7),
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
              color: Color(0xFF3A3A3A).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 32)),
            ),
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
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final controller = TextEditingController(
      text: context.read<StatsBloc>().state.profileName ?? 'Player',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your name',
            border: OutlineInputBorder(),
          ),
          maxLength: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                await StatsService().saveProfileName(name);
                if (context.mounted) {
                  context.read<StatsBloc>().add(const LoadStats());
                }
              }
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
