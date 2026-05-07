import 'package:equatable/equatable.dart';

class GameStats extends Equatable {
  final int bestScore;
  final int totalGamesPlayed;
  final int totalGamesCompleted;
  final int totalFruitsCollected;
  final int bestCombo;
  final int totalBombsUsed;
  final int totalPowerUpsCollected;
  final int coins;

  final int survivalBestScore;
  final int clearBestTime;
  final int scoreRushBestScore;

  const GameStats({
    this.bestScore = 0,
    this.totalGamesPlayed = 0,
    this.totalGamesCompleted = 0,
    this.totalFruitsCollected = 0,
    this.bestCombo = 0,
    this.totalBombsUsed = 0,
    this.totalPowerUpsCollected = 0,
    this.coins = 0,
    this.survivalBestScore = 0,
    this.clearBestTime = 0,
    this.scoreRushBestScore = 0,
  });

  GameStats copyWith({
    int? bestScore,
    int? totalGamesPlayed,
    int? totalGamesCompleted,
    int? totalFruitsCollected,
    int? bestCombo,
    int? totalBombsUsed,
    int? totalPowerUpsCollected,
    int? coins,
    int? survivalBestScore,
    int? clearBestTime,
    int? scoreRushBestScore,
  }) {
    return GameStats(
      bestScore: bestScore ?? this.bestScore,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      totalGamesCompleted: totalGamesCompleted ?? this.totalGamesCompleted,
      totalFruitsCollected: totalFruitsCollected ?? this.totalFruitsCollected,
      bestCombo: bestCombo ?? this.bestCombo,
      totalBombsUsed: totalBombsUsed ?? this.totalBombsUsed,
      totalPowerUpsCollected: totalPowerUpsCollected ?? this.totalPowerUpsCollected,
      coins: coins ?? this.coins,
      survivalBestScore: survivalBestScore ?? this.survivalBestScore,
      clearBestTime: clearBestTime ?? this.clearBestTime,
      scoreRushBestScore: scoreRushBestScore ?? this.scoreRushBestScore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bestScore': bestScore,
      'totalGamesPlayed': totalGamesPlayed,
      'totalGamesCompleted': totalGamesCompleted,
      'totalFruitsCollected': totalFruitsCollected,
      'bestCombo': bestCombo,
      'totalBombsUsed': totalBombsUsed,
      'totalPowerUpsCollected': totalPowerUpsCollected,
      'coins': coins,
      'survivalBestScore': survivalBestScore,
      'clearBestTime': clearBestTime,
      'scoreRushBestScore': scoreRushBestScore,
    };
  }

  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      bestScore: json['bestScore'] as int? ?? 0,
      totalGamesPlayed: json['totalGamesPlayed'] as int? ?? 0,
      totalGamesCompleted: json['totalGamesCompleted'] as int? ?? 0,
      totalFruitsCollected: json['totalFruitsCollected'] as int? ?? 0,
      bestCombo: json['bestCombo'] as int? ?? 0,
      totalBombsUsed: json['totalBombsUsed'] as int? ?? 0,
      totalPowerUpsCollected: json['totalPowerUpsCollected'] as int? ?? 0,
      coins: json['coins'] as int? ?? 0,
      survivalBestScore: json['survivalBestScore'] as int? ?? 0,
      clearBestTime: json['clearBestTime'] as int? ?? 0,
      scoreRushBestScore: json['scoreRushBestScore'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        bestScore,
        totalGamesPlayed,
        totalGamesCompleted,
        totalFruitsCollected,
        bestCombo,
        totalBombsUsed,
        totalPowerUpsCollected,
        coins,
        survivalBestScore,
        clearBestTime,
        scoreRushBestScore,
      ];
}
