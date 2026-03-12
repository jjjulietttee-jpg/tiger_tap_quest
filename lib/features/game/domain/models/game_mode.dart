enum GameMode {
  survival,
  clear,
  score,
}

extension GameModeExtension on GameMode {
  String get displayName {
    switch (this) {
      case GameMode.survival:
        return 'Survival';
      case GameMode.clear:
        return 'Clear Mode';
      case GameMode.score:
        return 'Score Rush';
    }
  }

  String get description {
    switch (this) {
      case GameMode.survival:
        return 'Tap fruits • Don\'t let them reach top';
      case GameMode.clear:
        return 'Collect 100 fruits • As fast as you can';
      case GameMode.score:
        return '60 seconds • Maximum score';
    }
  }

  int get initialLives {
    switch (this) {
      case GameMode.survival:
        return 3;
      case GameMode.clear:
      case GameMode.score:
        return 999;
    }
  }

  Duration? get timeLimit {
    switch (this) {
      case GameMode.score:
        return const Duration(seconds: 60);
      case GameMode.survival:
      case GameMode.clear:
        return null;
    }
  }

  int? get targetBubbles {
    switch (this) {
      case GameMode.clear:
        return 100;
      case GameMode.survival:
      case GameMode.score:
        return null;
    }
  }
}
