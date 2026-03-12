import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiger_tap_quest/core/domain/bloc/stats_bloc.dart';
import 'package:tiger_tap_quest/features/profile/presentation/widgets/profile_stats_content.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.75),
            ),
          ),

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
                        tooltip: 'Back',
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
}
