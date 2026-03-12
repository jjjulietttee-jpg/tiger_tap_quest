import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiger_tap_quest/features/game/domain/bloc/game_event.dart';
import 'package:tiger_tap_quest/features/game/domain/bloc/game_state.dart';
import 'package:tiger_tap_quest/features/game/domain/models/tap_element.dart';
import 'package:tiger_tap_quest/features/game/domain/models/game_mode.dart';
import 'package:tiger_tap_quest/core/domain/bloc/stats_bloc.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  Timer? _gameTimer;
  final Random _random = Random();
  DateTime _lastSpawnTime = DateTime.now();
  final StatsBloc? statsBloc;
  int _bombsUsedCount = 0;
  int _powerUpsCollectedCount = 0;

  GameBloc({this.statsBloc}) : super(const GameState()) {
    on<StartGame>(_onStartGame);
    on<PauseGame>(_onPauseGame);
    on<ResumeGame>(_onResumeGame);
    on<TapOnElement>(_onTapBubble);
    on<MissTap>(_onMissTap);
    on<GameTick>(_onGameTick);
    on<EndGame>(_onEndGame);
  }

  void _onStartGame(StartGame event, Emitter<GameState> emit) {
    _gameTimer?.cancel();
    _lastSpawnTime = DateTime.now();
    _bombsUsedCount = 0;
    _powerUpsCollectedCount = 0;


    statsBloc?.add(const IncrementGamesPlayed());

    emit(
      GameState(
        status: GameStatus.playing,
        mode: event.mode,
        lives: event.mode.initialLives,
        startTime: DateTime.now(),
        remainingTime: event.mode.timeLimit,
        screenHeight: event.screenSize.height,
      ),
    );


    _gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!isClosed && state.isPlaying) {
        add(GameTick(event.screenSize));
      }
    });
  }

  void _onPauseGame(PauseGame event, Emitter<GameState> emit) {
    if (state.isPlaying) {
      emit(state.copyWith(status: GameStatus.paused));
    }
  }

  void _onResumeGame(ResumeGame event, Emitter<GameState> emit) {
    if (state.isPaused) {
      emit(state.copyWith(status: GameStatus.playing));
    }
  }

  void _onTapBubble(TapOnElement event, Emitter<GameState> emit) {
    final bubble = state.bubbles.firstWhere(
      (b) => b.id == event.bubbleId,
      orElse: () => Bubble(
        id: '',
        type: BubbleType.banana,
        position: Offset.zero,
        size: 0,
        spawnTime: DateTime.now(),
        speed: 0,
      ),
    );

    if (bubble.id.isEmpty) return;

    final newBubbles = List<Bubble>.from(state.bubbles);
    int newScore = state.score;
    int newCombo = state.combo;
    int newBestCombo = state.bestCombo;
    int newBubblesPopped = state.bubblesPopped + 1;
    DateTime? newSlowmoEndTime = state.slowmoEndTime;
    DateTime? newFreezeEndTime = state.freezeEndTime;
    DateTime? newStarEndTime = state.starEndTime;
    List<String> explodingIds = [];


    if (bubble.type == BubbleType.bomb) {

      _bombsUsedCount++;
      final bombRadius = 150.0;
      final bubblesInRadius = newBubbles.where((b) {
        final dx = b.position.dx - bubble.position.dx;
        final dy = b.position.dy - bubble.position.dy;
        final distance = sqrt(dx * dx + dy * dy);
        return distance <= bombRadius;
      }).toList();

      explodingIds = bubblesInRadius.map((b) => b.id).toList();

      for (final b in bubblesInRadius) {
        newBubbles.remove(b);
        newScore += 5 * state.comboMultiplier;
        newBubblesPopped++;
      }
      newCombo += 5;
    } else if (bubble.type == BubbleType.tiger || bubble.type == BubbleType.lightning) {

      newBubbles.remove(bubble);
      final nearestType = _findNearestBubbleType(bubble, newBubbles);
      if (nearestType != null) {
        final bubblesOfType = newBubbles.where((b) => b.type == nearestType).toList();
        explodingIds = bubblesOfType.map((b) => b.id).toList();

        for (final b in bubblesOfType) {
          newBubbles.remove(b);
          newScore += 3 * state.comboMultiplier;
          newBubblesPopped++;
        }
        newCombo += bubblesOfType.length;
      }
    } else if (bubble.type == BubbleType.slowmo) {

      newBubbles.remove(bubble);
      newSlowmoEndTime = DateTime.now().add(const Duration(seconds: 5));
      newScore += 10 * state.comboMultiplier;
      newCombo += 1;
    } else if (bubble.type == BubbleType.freeze) {

      newBubbles.remove(bubble);
      newFreezeEndTime = DateTime.now().add(const Duration(seconds: 3));
      newScore += 15 * state.comboMultiplier;
      newCombo += 1;
    } else if (bubble.type == BubbleType.star) {

      newBubbles.remove(bubble);
      newStarEndTime = DateTime.now().add(const Duration(seconds: 10));
      newScore += 20 * state.comboMultiplier;
      newCombo += 1;
    } else if (bubble.type == BubbleType.diamond) {

      newBubbles.remove(bubble);
      newScore += 100 * state.comboMultiplier;
      newCombo += 1;
    } else {

      newBubbles.remove(bubble);
      final group = _findConnectedBubbles(bubble, newBubbles);

      if (group.isNotEmpty) {

        explodingIds = group.map((b) => b.id).toList();
        for (final b in group) {
          newBubbles.remove(b);
        }
        final groupSize = group.length + 1;
        newScore += groupSize * 2 * state.comboMultiplier;
        newBubblesPopped += groupSize;
        newCombo += groupSize;
      } else {

        newScore += 1 * state.comboMultiplier;
        newCombo += 1;
      }
    }

    newBestCombo = max(newBestCombo, newCombo);

    emit(
      state.copyWith(
        bubbles: newBubbles,
        score: newScore,
        combo: newCombo,
        bestCombo: newBestCombo,
        bubblesPopped: newBubblesPopped,
        slowmoEndTime: newSlowmoEndTime,
        freezeEndTime: newFreezeEndTime,
        starEndTime: newStarEndTime,
        explodingBubbles: explodingIds,
      ),
    );


    if (explodingIds.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!isClosed) {
          emit(state.copyWith(explodingBubbles: []));
        }
      });
    }


    if (state.targetReached) {
      add(const EndGame());
    }
  }

  BubbleType? _findNearestBubbleType(Bubble tiger, List<Bubble> bubbles) {
    if (bubbles.isEmpty) return null;

    Bubble? nearest;
    double minDistance = double.infinity;

    for (final bubble in bubbles) {

      if (bubble.type == BubbleType.bomb ||
          bubble.type == BubbleType.tiger ||
          bubble.type == BubbleType.slowmo ||
          bubble.type == BubbleType.freeze ||
          bubble.type == BubbleType.lightning ||
          bubble.type == BubbleType.star ||
          bubble.type == BubbleType.diamond) {
        continue;
      }
      final dx = bubble.position.dx - tiger.position.dx;
      final dy = bubble.position.dy - tiger.position.dy;
      final distance = sqrt(dx * dx + dy * dy);
      if (distance < minDistance) {
        minDistance = distance;
        nearest = bubble;
      }
    }

    return nearest?.type;
  }

  List<Bubble> _findConnectedBubbles(Bubble target, List<Bubble> bubbles) {
    final connected = <Bubble>[];
    final groupRadius = 100.0;

    for (final bubble in bubbles) {
      if (bubble.type != target.type) continue;

      if (bubble.type == BubbleType.bomb ||
          bubble.type == BubbleType.tiger ||
          bubble.type == BubbleType.slowmo ||
          bubble.type == BubbleType.freeze ||
          bubble.type == BubbleType.lightning ||
          bubble.type == BubbleType.star ||
          bubble.type == BubbleType.diamond) {
        continue;
      }

      final dx = bubble.position.dx - target.position.dx;
      final dy = bubble.position.dy - target.position.dy;
      final distance = sqrt(dx * dx + dy * dy);

      if (distance <= groupRadius) {
        connected.add(bubble);
      }
    }

    return connected;
  }

  void _onMissTap(MissTap event, Emitter<GameState> emit) {

    emit(state.copyWith(combo: 0));
  }

  void _onGameTick(GameTick event, Emitter<GameState> emit) {

    Duration? newRemainingTime = state.remainingTime;
    if (state.mode.timeLimit != null && state.startTime != null) {
      final elapsed = DateTime.now().difference(state.startTime!);
      newRemainingTime = state.mode.timeLimit! - elapsed;

      if (newRemainingTime.isNegative) {
        add(const EndGame());
        return;
      }
    }


    final now = DateTime.now();
    final activeBubbles = <Bubble>[];
    int newLives = state.lives;
    int newCombo = state.combo;

    for (final bubble in state.bubbles) {
      final elapsed = now.difference(bubble.spawnTime).inMilliseconds / 1000.0;


      double speedMultiplier = 1.0;
      if (state.isFreezeActive) {
        speedMultiplier = 0.0;
      } else if (state.isSlowmoActive) {
        speedMultiplier = 0.3;
      }

      final newY = bubble.position.dy - (bubble.speed * elapsed * speedMultiplier);


      if (newY <= 50) {

        if (state.mode == GameMode.survival) {
          newLives -= 1;
          newCombo = 0;
        }
      } else {
        activeBubbles.add(
          bubble.copyWith(position: Offset(bubble.position.dx, newY)),
        );
      }
    }


    final playTime = state.startTime != null
        ? DateTime.now().difference(state.startTime!).inSeconds
        : 0;
    final newDifficulty =
        1.0 + (playTime / 20.0) * 0.4;


    final timeSinceLastSpawn = now.difference(_lastSpawnTime).inMilliseconds;
    final spawnInterval = _calculateSpawnInterval(newDifficulty);


    final maxBubbles = min(10 + (newDifficulty * 2).round(), 18);

    if (timeSinceLastSpawn >= spawnInterval &&
        activeBubbles.length < maxBubbles) {

      final newBubble = _createRandomBubbleWithOffset(
        event.screenSize,
        newDifficulty,
        0,
      );
      activeBubbles.add(newBubble);
      _lastSpawnTime = now;
    }

    emit(
      state.copyWith(
        bubbles: activeBubbles,
        lives: newLives,
        combo: newCombo,
        remainingTime: newRemainingTime,
        difficulty: newDifficulty,
      ),
    );


    if (newLives <= 0 && state.mode == GameMode.survival) {
      add(const EndGame());
    }
  }

  int _calculateSpawnInterval(double difficulty) {

    final baseInterval = 800;
    final minInterval = 400;
    final interval = (baseInterval - (difficulty - 1.0) * 100).round();
    return max(interval, minInterval);
  }

  Bubble _createRandomBubbleWithOffset(
    Size screenSize,
    double difficulty,
    double yOffset,
  ) {
    final type = _randomBubbleType(difficulty);


    final sizeVariation = _random.nextDouble();
    final size = 60.0 + (sizeVariation * 30.0);

    final x = size / 2 + _random.nextDouble() * (screenSize.width - size);
    final y =
        screenSize.height + size + yOffset;
    final speed = 2.0 + (difficulty * 0.5);

    return Bubble(
      id:
          DateTime.now().millisecondsSinceEpoch.toString() +
          _random.nextInt(10000).toString(),
      type: type,
      position: Offset(x, y),
      size: size,
      spawnTime: DateTime.now(),
      speed: speed,
    );
  }

  BubbleType _randomBubbleType(double difficulty) {
    final rand = _random.nextDouble();


    final bombChance = min(0.03 + (difficulty - 1.0) * 0.01, 0.06);
    final tigerChance = min(0.02 + (difficulty - 1.0) * 0.01, 0.05);
    final slowmoChance = min(0.02 + (difficulty - 1.0) * 0.005, 0.04);
    final freezeChance = min(0.015 + (difficulty - 1.0) * 0.005, 0.03);
    final lightningChance = min(0.02 + (difficulty - 1.0) * 0.005, 0.04);
    final starChance = min(0.025 + (difficulty - 1.0) * 0.01, 0.05);
    final diamondChance = min(0.01 + (difficulty - 1.0) * 0.005, 0.03);

    double cumulative = 0;

    cumulative += bombChance;
    if (rand < cumulative) return BubbleType.bomb;

    cumulative += tigerChance;
    if (rand < cumulative) return BubbleType.tiger;

    cumulative += slowmoChance;
    if (rand < cumulative) return BubbleType.slowmo;

    cumulative += freezeChance;
    if (rand < cumulative) return BubbleType.freeze;

    cumulative += lightningChance;
    if (rand < cumulative) return BubbleType.lightning;

    cumulative += starChance;
    if (rand < cumulative) return BubbleType.star;

    cumulative += diamondChance;
    if (rand < cumulative) return BubbleType.diamond;


    final normalRand = _random.nextDouble();
    if (normalRand < 0.20) return BubbleType.banana;
    if (normalRand < 0.40) return BubbleType.coconut;
    if (normalRand < 0.60) return BubbleType.mango;
    if (normalRand < 0.80) return BubbleType.pineapple;
    return BubbleType.watermelon;
  }

  void _onEndGame(EndGame event, Emitter<GameState> emit) {
    _gameTimer?.cancel();
    emit(state.copyWith(status: GameStatus.gameOver));


    if (statsBloc != null) {
      final completed = state.targetReached ||
                       (state.mode == GameMode.score && state.remainingTime != null);

      String modeStr = 'survival';
      int? clearTime;

      switch (state.mode) {
        case GameMode.survival:
          modeStr = 'survival';
          break;
        case GameMode.clear:
          modeStr = 'clear';
          if (completed && state.startTime != null) {
            clearTime = DateTime.now().difference(state.startTime!).inSeconds;
          }
          break;
        case GameMode.score:
          modeStr = 'score';
          break;
      }

      statsBloc!.add(UpdateGameResult(
        score: state.score,
        fruitsCollected: state.bubblesPopped,
        bestCombo: state.bestCombo,
        bombsUsed: _bombsUsedCount,
        powerUpsCollected: _powerUpsCollectedCount,
        completed: completed,
        mode: modeStr,
        clearTime: clearTime,
      ));
    }
  }

  @override
  Future<void> close() {
    _gameTimer?.cancel();
    return super.close();
  }
}
