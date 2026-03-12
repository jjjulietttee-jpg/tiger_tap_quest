import 'package:equatable/equatable.dart';

class MusicState extends Equatable {
  final bool isMuted;
  final bool isEffectsMuted;
  final double volume;
  final double effectsVolume;
  final bool isPlaying;

  const MusicState({
    this.isMuted = false,
    this.isEffectsMuted = false,
    this.volume = 0.6,
    this.effectsVolume = 0.7,
    this.isPlaying = false,
  });

  MusicState copyWith({
    bool? isMuted,
    bool? isEffectsMuted,
    double? volume,
    double? effectsVolume,
    bool? isPlaying,
  }) {
    return MusicState(
      isMuted: isMuted ?? this.isMuted,
      isEffectsMuted: isEffectsMuted ?? this.isEffectsMuted,
      volume: volume ?? this.volume,
      effectsVolume: effectsVolume ?? this.effectsVolume,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  List<Object?> get props => [
        isMuted,
        isEffectsMuted,
        volume,
        effectsVolume,
        isPlaying,
      ];
}
