import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tiger_tap_quest/core/data/services/stats_service.dart';
import 'package:tiger_tap_quest/core/domain/bloc/stats_bloc.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';
import 'package:tiger_tap_quest/features/profile/presentation/widgets/profile_stats_content_parts.dart';

class ProfileStatsContent {
  const ProfileStatsContent._();

  static Widget build(
    BuildContext context, {
    required dynamic stats,
    required String profileName,
  }) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          backgroundColor: Colors.black.withValues(alpha: 0.6),
          leading: Semantics(
            label: 'Back button',
            button: true,
            child: IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Colors.transparent,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 160),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
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
                              child: Text('🐯', style: TextStyle(fontSize: 30)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          ProfileStatsContentParts.buildCoins(context, stats),
        const SizedBox(height: 4),
                          Semantics(
                            label: 'Edit player name',
                            button: true,
                            child: GestureDetector(
                              onTap: () => showEditNameDialog(context, initialName: profileName),
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
                                    const Icon(Icons.edit, color: Colors.white, size: 12),
                                  ],
                                ),
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
        SliverPadding(
          padding: EdgeInsets.all(size.width * 0.04),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                ProfileStatsContentParts.buildSectionTitle(context, 'Game Statistics', '📊'),
                const SizedBox(height: 12),
                ProfileStatsContentParts.buildStatsGrid(context, stats),
                const SizedBox(height: 24),
                ProfileStatsContentParts.buildSectionTitle(context, 'Mode Records', '🏆'),
                const SizedBox(height: 12),
                ProfileStatsContentParts.buildModeStats(context, stats),
                const SizedBox(height: 24),
                ProfileStatsContentParts.buildSectionTitle(context, 'Collection', '🎯'),
                const SizedBox(height: 12),
                ProfileStatsContentParts.buildCollectionStats(context, stats),
                const SizedBox(height: 24),
                ProfileStatsContentParts.buildSectionTitle(context, 'Performance', '📈'),
                const SizedBox(height: 12),
                ProfileStatsContentParts.buildPerformanceStats(context, stats),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> showEditNameDialog(BuildContext context, {required String initialName}) async {
    final controller = TextEditingController(text: initialName);
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your name',
            labelText: 'Player name',
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
