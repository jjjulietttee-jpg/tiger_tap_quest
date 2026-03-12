import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/features/game/domain/models/game_mode.dart';
import 'package:tiger_tap_quest/features/game/domain/models/tap_element.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class StartGame extends GameEvent {
  final GameMode mode;
  final Size screenSize;

  const StartGame(this.mode, this.screenSize);

  @override
  List<Object?> get props => [mode, screenSize];
}

class PauseGame extends GameEvent {
  const PauseGame();
}

class ResumeGame extends GameEvent {
  const ResumeGame();
}

class TapOnElement extends GameEvent {
  final String bubbleId;

  const TapOnElement(this.bubbleId);

  @override
  List<Object?> get props => [bubbleId];
}

class MissTap extends GameEvent {
  const MissTap();
}

class GameTick extends GameEvent {
  final Size screenSize;

  const GameTick(this.screenSize);

  @override
  List<Object?> get props => [screenSize];
}

class EndGame extends GameEvent {
  const EndGame();
}

class ExplodeBubbles extends GameEvent {
  final List<String> bubbleIds;
  final BubbleType triggerType;

  const ExplodeBubbles(this.bubbleIds, this.triggerType);

  @override
  List<Object?> get props => [bubbleIds, triggerType];
}
