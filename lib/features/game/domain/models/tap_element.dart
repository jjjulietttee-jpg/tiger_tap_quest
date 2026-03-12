import 'package:flutter/material.dart';

enum BubbleType {
  banana,
  coconut,
  mango,
  pineapple,
  watermelon,

  bomb,
  tiger,
  slowmo,
  freeze,
  lightning,
  star,
  diamond,
}

class Bubble {
  final String id;
  final BubbleType type;
  final Offset position;
  final double size;
  final DateTime spawnTime;
  final double speed;

  Bubble({
    required this.id,
    required this.type,
    required this.position,
    required this.size,
    required this.spawnTime,
    required this.speed,
  });

  Bubble copyWith({
    String? id,
    BubbleType? type,
    Offset? position,
    double? size,
    DateTime? spawnTime,
    double? speed,
  }) {
    return Bubble(
      id: id ?? this.id,
      type: type ?? this.type,
      position: position ?? this.position,
      size: size ?? this.size,
      spawnTime: spawnTime ?? this.spawnTime,
      speed: speed ?? this.speed,
    );
  }
}
