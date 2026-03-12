import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiger_tap_quest/core/data/models/game_stats.dart';
import 'package:tiger_tap_quest/core/data/models/achievement.dart';

class StatsService {
  static const String _statsKey = 'game_stats';
  static const String _profileNameKey = 'profile_name';
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _gameTutorialCompletedKey = 'game_tutorial_completed';
  static const String _achievementsKey = 'achievements';
  static const String _shopItemsKey = 'shop_items';

  Future<GameStats> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_statsKey);

    if (statsJson == null) {
      return const GameStats();
    }

    try {
      final Map<String, dynamic> decoded = json.decode(statsJson);
      return GameStats.fromJson(decoded);
    } catch (e) {
      return const GameStats();
    }
  }

  Future<void> saveStats(GameStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = json.encode(stats.toJson());
    await prefs.setString(_statsKey, statsJson);
  }

  Future<String?> loadProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileNameKey);
  }

  Future<void> saveProfileName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileNameKey, name);
  }

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  Future<bool> isGameTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_gameTutorialCompletedKey) ?? false;
  }

  Future<void> setGameTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_gameTutorialCompletedKey, true);
  }

  Future<List<Achievement>> loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    dynamic achievementsData;
    try {
      achievementsData = prefs.get(_achievementsKey);
    } catch (_) {
      return Achievements.all;
    }

    if (achievementsData == null || achievementsData is! String) {
      if (achievementsData != null) {
        await prefs.remove(_achievementsKey);
      }
      return Achievements.all;
    }

    try {
      final Map<String, dynamic> decoded = json.decode(achievementsData);
      return Achievements.all.map((template) {
        final savedData = decoded[template.id] as Map<String, dynamic>?;
        if (savedData != null) {
          return Achievement.fromJson(savedData, template);
        }
        return template;
      }).toList();
    } catch (e) {
      return Achievements.all;
    }
  }

  Future<void> saveAchievements(List<Achievement> achievements) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> achievementsMap = {};

    for (final achievement in achievements) {
      achievementsMap[achievement.id] = achievement.toJson();
    }

    final achievementsJson = json.encode(achievementsMap);
    await prefs.setString(_achievementsKey, achievementsJson);
  }

  Future<List<Map<String, dynamic>>> loadShopItems() async {
    final prefs = await SharedPreferences.getInstance();
    final shopItemsJson = prefs.getString(_shopItemsKey);

    if (shopItemsJson == null) {
      return [];
    }

    try {
      final List<dynamic> decoded = json.decode(shopItemsJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveShopItems(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    final shopItemsJson = json.encode(items);
    await prefs.setString(_shopItemsKey, shopItemsJson);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
