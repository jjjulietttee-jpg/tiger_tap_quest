import 'package:flutter/material.dart';

enum BubbleType {
  // Обычные фрукты
  banana,      // Банан
  coconut,     // Кокос
  mango,       // Манго
  pineapple,   // Ананас
  watermelon,  // Арбуз
  
  // Спецэлементы
  bomb,        // 💣 Бомба - взрывает все вокруг
  tiger,       // 🐯 Тигр - убирает все фрукты одного типа
  slowmo,      // ⏱️ Замедлитель - замедляет все на 5 сек
  freeze,      // ❄️ Заморозка - останавливает все на 3 сек
  lightning,   // ⚡ Молния - убирает все фрукты одного типа (как тигр)
  star,        // 🌟 Звезда - x2 очки на 10 секунд
  diamond,     // 💎 Алмаз - дает много очков
}

class Bubble {
  final String id;
  final BubbleType type;
  final Offset position;
  final double size;
  final DateTime spawnTime;
  final double speed; // Pixels per second upward

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
