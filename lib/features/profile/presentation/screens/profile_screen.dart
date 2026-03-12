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
            child: Container(color: Colors.black.withValues(alpha: 0.75)),
          ),

          SafeArea(
            child: BlocBuilder<StatsBloc, StatsState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final stats = state.stats;
                final profileName = state.profileName ?? 'Player';

                return ProfileStatsContent.build(
                  context,
                  stats: stats,
                  profileName: profileName,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
