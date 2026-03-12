import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiger_tap_quest/core/shared/widgets/card_widget.dart';
import 'package:tiger_tap_quest/features/home/presentation/widgets/home_play_button.dart';
import 'package:tiger_tap_quest/features/home/presentation/widgets/home_stats_section.dart';
import 'package:tiger_tap_quest/features/home/presentation/widgets/home_audio_settings_card.dart';

class HomeMenuColumn extends StatelessWidget {
  const HomeMenuColumn({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = size.width * 0.08;
    final verticalSpacing = size.height * 0.02;
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  size.height * 0.02,
                  0,
                  verticalSpacing,
                ),
                child: const HomePlayButton(),
              );
            }
            if (index == 1) {
              return const HomeStatsSection();
            }
            if (index == 2) {
              return Padding(
                padding: EdgeInsets.only(bottom: verticalSpacing),
                child: CardWidget(
                  onTap: () => context.push('/shop'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🛒', style: TextStyle(fontSize: 28)),
                        SizedBox(width: 12),
                        Text(
                          'Shop',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            if (index == 3) {
              return Padding(
                padding: EdgeInsets.only(bottom: verticalSpacing),
                child: CardWidget(
                  onTap: () => context.push('/profile'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🐯', style: TextStyle(fontSize: 28)),
                        SizedBox(width: 12),
                        Text(
                          'Profile',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            if (index == 4) {
              return Padding(
                padding: EdgeInsets.only(bottom: verticalSpacing),
                child: CardWidget(
                  onTap: () => context.push('/achievements'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🏆', style: TextStyle(fontSize: 28)),
                        SizedBox(width: 12),
                        Text(
                          'Achievements',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.04),
              child: const HomeAudioSettingsCard(),
            );
          },
          childCount: 6,
        ),
      ),
    );
  }
}
