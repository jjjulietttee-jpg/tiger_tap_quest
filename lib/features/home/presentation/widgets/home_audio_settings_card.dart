import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiger_tap_quest/core/domain/bloc/music_cubit.dart';
import 'package:tiger_tap_quest/core/domain/bloc/music_state.dart';
import 'package:tiger_tap_quest/core/shared/widgets/card_widget.dart';

class HomeAudioSettingsCard extends StatelessWidget {
  const HomeAudioSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<MusicCubit>();

    return BlocBuilder<MusicCubit, MusicState>(
      builder: (context, state) {
        return CardWidget(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Music',
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
                    ),
                    Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: !state.isMuted,
                      onChanged: (value) => cubit.setMuted(!value),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Slider(
                  value: state.volume,
                  min: 0,
                  max: 1,
                  divisions: 20,
                  label: '${(state.volume * 100).round()}%',
                  onChanged: state.isMuted ? null : (value) => cubit.setVolume(value),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Effects',
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
                    ),
                    Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: !state.isEffectsMuted,
                      onChanged: (value) => cubit.setEffectsMuted(!value),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Slider(
                  value: state.effectsVolume,
                  min: 0,
                  max: 1,
                  divisions: 20,
                  label: '${(state.effectsVolume * 100).round()}%',
                  onChanged: state.isEffectsMuted
                      ? null
                      : (value) => cubit.setEffectsVolume(value),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
