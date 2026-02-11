import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiger_tap_quest/core/data/models/game_stats.dart';
import 'package:tiger_tap_quest/core/data/models/achievement.dart';
import 'package:tiger_tap_quest/core/data/services/stats_service.dart';

// Events
abstract class StatsEvent extends Equatable {
  const StatsEvent();

  @override
  List<Object?> get props => [];
}

class LoadStats extends StatsEvent {
  const LoadStats();
}

class UpdateStats extends StatsEvent {
  final GameStats stats;

  const UpdateStats(this.stats);

  @override
  List<Object?> get props => [stats];
}

class IncrementGamesPlayed extends StatsEvent {
  const IncrementGamesPlayed();
}

class UpdateGameResult extends StatsEvent {
  final int score;
  final int fruitsCollected;
  final int bestCombo;
  final int bombsUsed;
  final int powerUpsCollected;
  final bool completed;
  final String mode; // 'survival', 'clear', 'score'
  final int? clearTime; // for clear mode

  const UpdateGameResult({
    required this.score,
    required this.fruitsCollected,
    required this.bestCombo,
    required this.bombsUsed,
    required this.powerUpsCollected,
    required this.completed,
    required this.mode,
    this.clearTime,
  });

  @override
  List<Object?> get props => [
        score,
        fruitsCollected,
        bestCombo,
        bombsUsed,
        powerUpsCollected,
        completed,
        mode,
        clearTime,
      ];
}

class LoadAchievements extends StatsEvent {
  const LoadAchievements();
}

class SetOnboardingCompleted extends StatsEvent {
  const SetOnboardingCompleted();
}

// State
class StatsState extends Equatable {
  final GameStats stats;
  final List<Achievement> achievements;
  final bool isLoading;
  final String? profileName;

  const StatsState({
    required this.stats,
    this.achievements = const [],
    this.isLoading = false,
    this.profileName,
  });

  StatsState copyWith({
    GameStats? stats,
    List<Achievement>? achievements,
    bool? isLoading,
    String? profileName,
  }) {
    return StatsState(
      stats: stats ?? this.stats,
      achievements: achievements ?? this.achievements,
      isLoading: isLoading ?? this.isLoading,
      profileName: profileName ?? this.profileName,
    );
  }

  @override
  List<Object?> get props => [stats, achievements, isLoading, profileName];
}

// Bloc
class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final StatsService _statsService;

  StatsBloc(this._statsService)
      : super(const StatsState(stats: GameStats(), isLoading: true)) {
    on<LoadStats>(_onLoadStats);
    on<UpdateStats>(_onUpdateStats);
    on<IncrementGamesPlayed>(_onIncrementGamesPlayed);
    on<UpdateGameResult>(_onUpdateGameResult);
    on<LoadAchievements>(_onLoadAchievements);
    on<SetOnboardingCompleted>(_onSetOnboardingCompleted);
  }

  Future<void> _onSetOnboardingCompleted(
    SetOnboardingCompleted event,
    Emitter<StatsState> emit,
  ) async {
    await _statsService.setOnboardingCompleted();
  }

  Future<void> _onLoadStats(LoadStats event, Emitter<StatsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final stats = await _statsService.loadStats();
      final achievements = await _statsService.loadAchievements();
      final profileName = await _statsService.loadProfileName();
      emit(state.copyWith(
        stats: stats,
        achievements: achievements,
        profileName: profileName,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        stats: const GameStats(),
        achievements: Achievements.all,
        isLoading: false,
      ));
    }
  }

  Future<void> _onUpdateStats(
      UpdateStats event, Emitter<StatsState> emit) async {
    emit(state.copyWith(stats: event.stats));
    await _statsService.saveStats(event.stats);
  }

  Future<void> _onIncrementGamesPlayed(
      IncrementGamesPlayed event, Emitter<StatsState> emit) async {
    final newStats = state.stats.copyWith(
      totalGamesPlayed: state.stats.totalGamesPlayed + 1,
    );
    emit(state.copyWith(stats: newStats));
    await _statsService.saveStats(newStats);
    await _updateAchievements(emit);
  }

  Future<void> _onUpdateGameResult(
      UpdateGameResult event, Emitter<StatsState> emit) async {
    // Calculate coins earned (score / 10 + bonus for completion)
    int coinsEarned = (event.score / 10).floor();
    if (event.completed) {
      coinsEarned += 50; // Bonus for completing game
    }
    
    var newStats = state.stats.copyWith(
      totalFruitsCollected:
          state.stats.totalFruitsCollected + event.fruitsCollected,
      totalBombsUsed: state.stats.totalBombsUsed + event.bombsUsed,
      totalPowerUpsCollected:
          state.stats.totalPowerUpsCollected + event.powerUpsCollected,
      coins: state.stats.coins + coinsEarned,
    );

    // Update best score
    if (event.score > newStats.bestScore) {
      newStats = newStats.copyWith(bestScore: event.score);
    }

    // Update best combo
    if (event.bestCombo > newStats.bestCombo) {
      newStats = newStats.copyWith(bestCombo: event.bestCombo);
    }

    // Update completed games count
    if (event.completed) {
      newStats = newStats.copyWith(
        totalGamesCompleted: newStats.totalGamesCompleted + 1,
      );
    }

    // Update mode-specific stats
    switch (event.mode) {
      case 'survival':
        if (event.score > newStats.survivalBestScore) {
          newStats = newStats.copyWith(survivalBestScore: event.score);
        }
        break;
      case 'clear':
        if (event.clearTime != null &&
            (newStats.clearBestTime == 0 ||
                event.clearTime! < newStats.clearBestTime)) {
          newStats = newStats.copyWith(clearBestTime: event.clearTime);
        }
        break;
      case 'score':
        if (event.score > newStats.scoreRushBestScore) {
          newStats = newStats.copyWith(scoreRushBestScore: event.score);
        }
        break;
    }

    emit(state.copyWith(stats: newStats));
    await _statsService.saveStats(newStats);
    await _updateAchievements(emit);
  }

  Future<void> _onLoadAchievements(
      LoadAchievements event, Emitter<StatsState> emit) async {
    final achievements = await _statsService.loadAchievements();
    emit(state.copyWith(achievements: achievements));
  }

  Future<void> _updateAchievements(Emitter<StatsState> emit) async {
    final stats = state.stats;
    final updatedAchievements = state.achievements.map((achievement) {
      int currentProgress = achievement.currentProgress;
      bool isCompleted = achievement.isCompleted;

      switch (achievement.id) {
        case 'first_steps':
          currentProgress = stats.totalGamesPlayed;
          break;
        case 'fruit_collector':
          currentProgress = stats.totalFruitsCollected;
          break;
        case 'fruit_master':
          currentProgress = stats.totalFruitsCollected;
          break;
        case 'combo_starter':
          currentProgress = stats.bestCombo;
          break;
        case 'combo_master':
          currentProgress = stats.bestCombo;
          break;
        case 'score_hunter':
          currentProgress = stats.bestScore;
          break;
        case 'score_legend':
          currentProgress = stats.bestScore;
          break;
        case 'dedicated_player':
          currentProgress = stats.totalGamesPlayed;
          break;
        case 'power_user':
          currentProgress = stats.totalPowerUpsCollected;
          break;
        case 'bomb_expert':
          currentProgress = stats.totalBombsUsed;
          break;
      }

      if (currentProgress >= achievement.targetValue) {
        isCompleted = true;
      }

      return achievement.copyWith(
        currentProgress: currentProgress,
        isCompleted: isCompleted,
      );
    }).toList();

    emit(state.copyWith(achievements: updatedAchievements));
    await _statsService.saveAchievements(updatedAchievements);
  }
}
