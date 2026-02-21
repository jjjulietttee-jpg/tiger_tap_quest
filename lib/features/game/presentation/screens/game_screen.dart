import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tiger_tap_quest/core/domain/bloc/stats_bloc.dart';
import 'package:tiger_tap_quest/features/game/domain/bloc/game_bloc.dart';
import 'package:tiger_tap_quest/features/game/domain/bloc/game_event.dart';
import 'package:tiger_tap_quest/features/game/domain/bloc/game_state.dart';
import 'package:tiger_tap_quest/features/game/domain/models/game_mode.dart';
import 'package:tiger_tap_quest/features/game/domain/models/tap_element.dart';
import 'package:tiger_tap_quest/features/game/presentation/widgets/game_ui_overlay.dart';
import 'package:tiger_tap_quest/features/game/presentation/widgets/bubble_widget.dart';
import 'package:tiger_tap_quest/features/game/presentation/widgets/tap_feedback_widget.dart';
import 'package:tiger_tap_quest/features/game/presentation/widgets/game_over_dialog.dart';
import 'package:tiger_tap_quest/features/game/presentation/widgets/game_tutorial_overlay.dart';
import 'package:tiger_tap_quest/features/game/presentation/widgets/pause_dialog.dart';
import 'package:tiger_tap_quest/features/game/presentation/widgets/jungle_background.dart';

class GameScreen extends StatefulWidget {
  final GameMode mode;

  const GameScreen({super.key, required this.mode});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameBloc _gameBloc;
  late StatsBloc _statsBloc;
  final List<Widget> _feedbackWidgets = [];
  bool _showTutorial = false;
  bool _initialCheckDone = false;

  @override
  void initState() {
    super.initState();
    _statsBloc = context.read<StatsBloc>();
    _gameBloc = GameBloc(statsBloc: _statsBloc);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialCheckDone && _gameBloc.state.status == GameStatus.initial) {
      _initialCheckDone = true;
      final completed = _statsBloc.state.gameTutorialCompleted;
      if (completed) {
        final size = MediaQuery.sizeOf(context);
        _gameBloc.add(StartGame(widget.mode, size));
      } else {
        setState(() => _showTutorial = true);
      }
    }
  }

  void _onTutorialComplete() {
    _statsBloc.add(const SetGameTutorialCompleted());
    final size = MediaQuery.sizeOf(context);
    _gameBloc.add(StartGame(widget.mode, size));
    setState(() => _showTutorial = false);
  }

  @override
  void dispose() {
    _gameBloc.close();
    super.dispose();
  }

  void _handleTap(Bubble bubble) {
    // Add feedback animation
    setState(() {
      _feedbackWidgets.add(
        TapFeedbackWidget(
          key: ValueKey('feedback_${bubble.id}'),
          position: bubble.position,
          type: bubble.type,
          onComplete: () {
            setState(() {
              _feedbackWidgets.removeWhere(
                (w) => (w.key as ValueKey).value == 'feedback_${bubble.id}',
              );
            });
          },
        ),
      );
    });

    // Process tap
    _gameBloc.add(TapOnElement(bubble.id));
  }

  void _handleMissTap(Offset position) {
    // Reset combo
    _gameBloc.add(const MissTap());

    // Add miss feedback animation
    final missId = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _feedbackWidgets.add(
        TapFeedbackWidget(
          key: ValueKey('feedback_miss_$missId'),
          position: position,
          type: null, // null means miss
          onComplete: () {
            setState(() {
              _feedbackWidgets.removeWhere(
                (w) => (w.key as ValueKey).value == 'feedback_miss_$missId',
              );
            });
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _gameBloc,
      child: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
          if (state.isGameOver) {
            _showGameOverDialog(context, state);
          }
        },
        builder: (context, state) {
          if (_showTutorial) {
            return Scaffold(
              body: Stack(
                children: [
                  const JungleBackground(),
                  GameTutorialOverlay(onComplete: _onTutorialComplete),
                ],
              ),
            );
          }
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop && state.isPlaying) {
                _gameBloc.add(const PauseGame());
                _showPauseDialog(context);
              }
            },
            child: Scaffold(
              body: Stack(
                children: [
                  const JungleBackground(),
                  // Game area with tap detection
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTapDown: (details) {
                        if (!state.isPlaying) return;

                        // Check if tap hit any bubble
                        bool hitBubble = false;
                        for (final bubble in state.bubbles) {
                          final dx =
                              details.localPosition.dx - bubble.position.dx;
                          final dy =
                              details.localPosition.dy - bubble.position.dy;
                          final distance = (dx * dx + dy * dy);
                          final radius = bubble.size / 2;

                          if (distance <= radius * radius) {
                            hitBubble = true;
                            _handleTap(bubble);
                            break;
                          }
                        }

                        // If no bubble was hit, show miss feedback
                        if (!hitBubble) {
                          _handleMissTap(details.localPosition);
                        }
                      },
                      child: Stack(
                        children: [
                          // Bubbles (without GestureDetector)
                          ...state.bubbles.map(
                            (bubble) => Positioned(
                              left: bubble.position.dx - bubble.size / 2,
                              top: bubble.position.dy - bubble.size / 2,
                              child: IgnorePointer(
                                child: BubbleWidget(
                                  bubble: bubble,
                                  onTap: () {}, // Not used anymore
                                ),
                              ),
                            ),
                          ),
                          // Feedback animations
                          ..._feedbackWidgets,
                        ],
                      ),
                    ),
                  ),
                  // UI Overlay (only pause button is interactive)
                  Positioned.fill(
                    child: GameUIOverlay(
                      score: state.score,
                      lives: state.lives,
                      combo: state.combo,
                      comboMultiplier: state.comboMultiplier,
                      remainingTime: state.remainingTime,
                      bubblesPopped: state.bubblesPopped,
                      targetBubbles: state.mode.targetBubbles,
                      slowmoEndTime: state.slowmoEndTime,
                      freezeEndTime: state.freezeEndTime,
                      starEndTime: state.starEndTime,
                      onPause: () {
                        _gameBloc.add(const PauseGame());
                        _showPauseDialog(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPauseDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: _gameBloc,
        child: PauseDialog(
          onResume: () {
            Navigator.of(dialogContext).pop();
            _gameBloc.add(const ResumeGame());
          },
          onExit: () {
            // Save stats before exiting
            final state = _gameBloc.state;
            _statsBloc.add(
              UpdateGameResult(
                score: state.score,
                fruitsCollected: state.bubblesPopped,
                bestCombo: state.bestCombo,
                bombsUsed: state.bombsUsed,
                powerUpsCollected: state.powerUpsCollected,
                completed: false, // Not completed, just quit
                mode: widget.mode.name,
              ),
            );
            Navigator.of(dialogContext).pop();
            context.pop();
          },
        ),
      ),
    );
  }

  void _showGameOverDialog(BuildContext context, GameState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => GameOverDialog(
        score: state.score,
        bestCombo: state.bestCombo,
        bubblesPopped: state.bubblesPopped,
        onRestart: () {
          Navigator.of(dialogContext).pop();
          final size = MediaQuery.sizeOf(context);
          _gameBloc.add(StartGame(widget.mode, size));
        },
        onExit: () {
          Navigator.of(dialogContext).pop();
          context.pop();
        },
      ),
    );
  }
}
