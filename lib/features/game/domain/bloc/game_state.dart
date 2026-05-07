import 'package:equatable/equatable.dart';
import 'package:tiger_tap_quest/features/game/domain/models/tap_element.dart';
import 'package:tiger_tap_quest/features/game/domain/models/game_mode.dart';

enum GameStatus {
  initial,
  playing,
  paused,
  gameOver,
}

class GameState extends Equatable {
  final GameStatus status;
  final GameMode mode;
  final int score;
  final int lives;
  final int bubblesPopped;
  final int combo;
  final int bestCombo;
  final List<Bubble> bubbles;
  final DateTime? startTime;
  final Duration? remainingTime;
  final double difficulty;
  final double screenHeight;
  final int bombsUsed;
  final int powerUpsCollected;

  final DateTime? slowmoEndTime;
  final DateTime? freezeEndTime;
  final DateTime? starEndTime;
  final List<String> explodingBubbles;

  const GameState({
    this.status = GameStatus.initial,
    this.mode = GameMode.survival,
    this.score = 0,
    this.lives = 3,
    this.bubblesPopped = 0,
    this.combo = 0,
    this.bestCombo = 0,
    this.bubbles = const [],
    this.startTime,
    this.remainingTime,
    this.difficulty = 1.0,
    this.screenHeight = 0,
    this.bombsUsed = 0,
    this.powerUpsCollected = 0,
    this.slowmoEndTime,
    this.freezeEndTime,
    this.starEndTime,
    this.explodingBubbles = const [],
  });

  int get comboMultiplier {
    int multiplier = 1;
    if (combo >= 10) {
      multiplier = 3;
    } else if (combo >= 5) {
      multiplier = 2;
    }

    if (starEndTime != null && DateTime.now().isBefore(starEndTime!)) {
      multiplier *= 2;
    }

    return multiplier;
  }

  bool get isGameOver => status == GameStatus.gameOver;
  bool get isPlaying => status == GameStatus.playing;
  bool get isPaused => status == GameStatus.paused;

  bool get isSlowmoActive => slowmoEndTime != null && DateTime.now().isBefore(slowmoEndTime!);
  bool get isFreezeActive => freezeEndTime != null && DateTime.now().isBefore(freezeEndTime!);
  bool get isStarActive => starEndTime != null && DateTime.now().isBefore(starEndTime!);

  bool get targetReached {
    final target = mode.targetBubbles;
    return target != null && bubblesPopped >= target;
  }

  GameState copyWith({
    GameStatus? status,
    GameMode? mode,
    int? score,
    int? lives,
    int? bubblesPopped,
    int? combo,
    int? bestCombo,
    List<Bubble>? bubbles,
    DateTime? startTime,
    Duration? remainingTime,
    double? difficulty,
    double? screenHeight,
    int? bombsUsed,
    int? powerUpsCollected,
    DateTime? slowmoEndTime,
    DateTime? freezeEndTime,
    DateTime? starEndTime,
    List<String>? explodingBubbles,
  }) {
    return GameState(
      status: status ?? this.status,
      mode: mode ?? this.mode,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      bubblesPopped: bubblesPopped ?? this.bubblesPopped,
      combo: combo ?? this.combo,
      bestCombo: bestCombo ?? this.bestCombo,
      bubbles: bubbles ?? this.bubbles,
      startTime: startTime ?? this.startTime,
      remainingTime: remainingTime ?? this.remainingTime,
      difficulty: difficulty ?? this.difficulty,
      screenHeight: screenHeight ?? this.screenHeight,
      bombsUsed: bombsUsed ?? this.bombsUsed,
      powerUpsCollected: powerUpsCollected ?? this.powerUpsCollected,
      slowmoEndTime: slowmoEndTime,
      freezeEndTime: freezeEndTime,
      starEndTime: starEndTime,
      explodingBubbles: explodingBubbles ?? this.explodingBubbles,
    );
  }

  @override
  List<Object?> get props => [
        status,
        mode,
        score,
        lives,
        bubblesPopped,
        combo,
        bestCombo,
        bubbles,
        startTime,
        remainingTime,
        difficulty,
        screenHeight,
        bombsUsed,
        powerUpsCollected,
        slowmoEndTime,
        freezeEndTime,
        starEndTime,
        explodingBubbles,
      ];
}
