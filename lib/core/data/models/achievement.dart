import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int targetValue;
  final bool isCompleted;
  final int currentProgress;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.targetValue,
    this.isCompleted = false,
    this.currentProgress = 0,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? emoji,
    int? targetValue,
    bool? isCompleted,
    int? currentProgress,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      targetValue: targetValue ?? this.targetValue,
      isCompleted: isCompleted ?? this.isCompleted,
      currentProgress: currentProgress ?? this.currentProgress,
    );
  }

  double get progress => currentProgress / targetValue;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isCompleted': isCompleted,
      'currentProgress': currentProgress,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json, Achievement template) {
    return template.copyWith(
      isCompleted: json['isCompleted'] as bool? ?? false,
      currentProgress: json['currentProgress'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        emoji,
        targetValue,
        isCompleted,
        currentProgress,
      ];
}

// Predefined achievements
class Achievements {
  static final List<Achievement> all = [
    // Beginner achievements
    const Achievement(
      id: 'first_steps',
      title: 'First Steps',
      description: 'Play your first game',
      emoji: '🎮',
      targetValue: 1,
    ),
    const Achievement(
      id: 'getting_started',
      title: 'Getting Started',
      description: 'Play 5 games',
      emoji: '🌱',
      targetValue: 5,
    ),
    const Achievement(
      id: 'dedicated_player',
      title: 'Dedicated Player',
      description: 'Play 50 games',
      emoji: '🏆',
      targetValue: 50,
    ),
    const Achievement(
      id: 'veteran',
      title: 'Veteran',
      description: 'Play 100 games',
      emoji: '🎖️',
      targetValue: 100,
    ),
    const Achievement(
      id: 'legend',
      title: 'Legend',
      description: 'Play 250 games',
      emoji: '👑',
      targetValue: 250,
    ),
    
    // Fruit collection achievements
    const Achievement(
      id: 'fruit_collector',
      title: 'Fruit Collector',
      description: 'Collect 100 fruits',
      emoji: '🍎',
      targetValue: 100,
    ),
    const Achievement(
      id: 'fruit_master',
      title: 'Fruit Master',
      description: 'Collect 1000 fruits',
      emoji: '🍇',
      targetValue: 1000,
    ),
    const Achievement(
      id: 'fruit_legend',
      title: 'Fruit Legend',
      description: 'Collect 5000 fruits',
      emoji: '🍉',
      targetValue: 5000,
    ),
    const Achievement(
      id: 'fruit_god',
      title: 'Fruit God',
      description: 'Collect 10000 fruits',
      emoji: '🍍',
      targetValue: 10000,
    ),
    
    // Combo achievements
    const Achievement(
      id: 'combo_starter',
      title: 'Combo Starter',
      description: 'Reach a combo of 10',
      emoji: '🔥',
      targetValue: 10,
    ),
    const Achievement(
      id: 'combo_master',
      title: 'Combo Master',
      description: 'Reach a combo of 25',
      emoji: '⚡',
      targetValue: 25,
    ),
    const Achievement(
      id: 'combo_god',
      title: 'Combo God',
      description: 'Reach a combo of 50',
      emoji: '💥',
      targetValue: 50,
    ),
    const Achievement(
      id: 'combo_legend',
      title: 'Combo Legend',
      description: 'Reach a combo of 100',
      emoji: '🌟',
      targetValue: 100,
    ),
    
    // Score achievements
    const Achievement(
      id: 'score_hunter',
      title: 'Score Hunter',
      description: 'Score 1000 points in one game',
      emoji: '🎯',
      targetValue: 1000,
    ),
    const Achievement(
      id: 'score_legend',
      title: 'Score Legend',
      description: 'Score 5000 points in one game',
      emoji: '👑',
      targetValue: 5000,
    ),
    const Achievement(
      id: 'score_master',
      title: 'Score Master',
      description: 'Score 10000 points in one game',
      emoji: '💫',
      targetValue: 10000,
    ),
    const Achievement(
      id: 'score_god',
      title: 'Score God',
      description: 'Score 20000 points in one game',
      emoji: '🌠',
      targetValue: 20000,
    ),
    
    // Power-up achievements
    const Achievement(
      id: 'power_user',
      title: 'Power User',
      description: 'Collect 20 power-ups',
      emoji: '💎',
      targetValue: 20,
    ),
    const Achievement(
      id: 'power_master',
      title: 'Power Master',
      description: 'Collect 50 power-ups',
      emoji: '✨',
      targetValue: 50,
    ),
    const Achievement(
      id: 'power_legend',
      title: 'Power Legend',
      description: 'Collect 100 power-ups',
      emoji: '🌈',
      targetValue: 100,
    ),
    const Achievement(
      id: 'bomb_expert',
      title: 'Bomb Expert',
      description: 'Use 10 bombs',
      emoji: '💣',
      targetValue: 10,
    ),
    const Achievement(
      id: 'bomb_master',
      title: 'Bomb Master',
      description: 'Use 30 bombs',
      emoji: '🧨',
      targetValue: 30,
    ),
    const Achievement(
      id: 'demolition_expert',
      title: 'Demolition Expert',
      description: 'Use 100 bombs',
      emoji: '💥',
      targetValue: 100,
    ),
    
    // Win achievements
    const Achievement(
      id: 'first_victory',
      title: 'First Victory',
      description: 'Complete your first game',
      emoji: '🥇',
      targetValue: 1,
    ),
    const Achievement(
      id: 'winner',
      title: 'Winner',
      description: 'Complete 10 games',
      emoji: '🥈',
      targetValue: 10,
    ),
    const Achievement(
      id: 'champion',
      title: 'Champion',
      description: 'Complete 25 games',
      emoji: '🥉',
      targetValue: 25,
    ),
    const Achievement(
      id: 'unstoppable',
      title: 'Unstoppable',
      description: 'Complete 50 games',
      emoji: '🏅',
      targetValue: 50,
    ),
    
    // Special achievements
    const Achievement(
      id: 'speed_demon',
      title: 'Speed Demon',
      description: 'Complete Clear mode in under 30 seconds',
      emoji: '⚡',
      targetValue: 1,
    ),
    const Achievement(
      id: 'survivor',
      title: 'Survivor',
      description: 'Score 3000+ in Survival mode',
      emoji: '🛡️',
      targetValue: 3000,
    ),
    const Achievement(
      id: 'perfectionist',
      title: 'Perfectionist',
      description: 'Complete a game without missing a tap',
      emoji: '💯',
      targetValue: 1,
    ),
  ];
}
