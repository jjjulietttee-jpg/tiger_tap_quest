import 'package:equatable/equatable.dart';

enum ShopItemType {
  powerUpBoost,
  scoreMultiplier,
  extraLife,
  slowMotion,
  bombRadius,
  comboBonus,
}

class ShopItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final int price;
  final ShopItemType type;
  final int level;
  final int maxLevel;
  final bool isPurchased;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.price,
    required this.type,
    this.level = 0,
    this.maxLevel = 5,
    this.isPurchased = false,
  });

  ShopItem copyWith({
    String? id,
    String? name,
    String? description,
    String? emoji,
    int? price,
    ShopItemType? type,
    int? level,
    int? maxLevel,
    bool? isPurchased,
  }) {
    return ShopItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      price: price ?? this.price,
      type: type ?? this.type,
      level: level ?? this.level,
      maxLevel: maxLevel ?? this.maxLevel,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }

  bool get isMaxLevel => level >= maxLevel;

  int get nextLevelPrice => price + (level * (price ~/ 2));

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'isPurchased': isPurchased,
    };
  }

  factory ShopItem.fromJson(Map<String, dynamic> json, ShopItem template) {
    return template.copyWith(
      level: json['level'] as int? ?? 0,
      isPurchased: json['isPurchased'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        emoji,
        price,
        type,
        level,
        maxLevel,
        isPurchased,
      ];
}

class ShopItems {
  static final List<ShopItem> all = [
    const ShopItem(
      id: 'power_up_boost',
      name: 'Power-Up Boost',
      description: 'Increase power-up spawn rate',
      emoji: '💎',
      price: 100,
      type: ShopItemType.powerUpBoost,
      maxLevel: 5,
    ),
    const ShopItem(
      id: 'score_multiplier',
      name: 'Score Multiplier',
      description: 'Earn more points per fruit',
      emoji: '⭐',
      price: 150,
      type: ShopItemType.scoreMultiplier,
      maxLevel: 5,
    ),
    const ShopItem(
      id: 'extra_life',
      name: 'Extra Life',
      description: 'Start with more lives in Survival',
      emoji: '❤️',
      price: 200,
      type: ShopItemType.extraLife,
      maxLevel: 3,
    ),
    const ShopItem(
      id: 'slow_motion',
      name: 'Slow Motion+',
      description: 'Slowmo lasts longer',
      emoji: '⏱️',
      price: 120,
      type: ShopItemType.slowMotion,
      maxLevel: 5,
    ),
    const ShopItem(
      id: 'bomb_radius',
      name: 'Bomb Radius',
      description: 'Bombs explode larger area',
      emoji: '💣',
      price: 180,
      type: ShopItemType.bombRadius,
      maxLevel: 5,
    ),
    const ShopItem(
      id: 'combo_bonus',
      name: 'Combo Bonus',
      description: 'Get combo multiplier faster',
      emoji: '🔥',
      price: 160,
      type: ShopItemType.comboBonus,
      maxLevel: 5,
    ),
  ];
}
