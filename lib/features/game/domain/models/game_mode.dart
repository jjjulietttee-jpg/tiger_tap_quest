enum GameMode {
  survival,
  clear,
  score,
  daily,
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
      case GameMode.daily:
        return 'Daily Challenge';
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
      case GameMode.daily:
        return 'Same challenge every day • Beat your best';
    }
  }

  int get initialLives {
    switch (this) {
      case GameMode.survival:
      case GameMode.daily:
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
      case GameMode.daily:
        return const Duration(seconds: 90);
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
      case GameMode.daily:
        return null;
    }
  }

  int get dailySeed {
    final now = DateTime.now();
    return now.year * 10000 + now.month * 100 + now.day;
  }
}
