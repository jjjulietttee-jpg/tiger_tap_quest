import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiger_tap_quest/features/about/presentation/screens/about_screen.dart';
import 'package:tiger_tap_quest/features/achievements/presentation/screens/achievements_screen.dart';
import 'package:tiger_tap_quest/features/game/domain/models/game_mode.dart';
import 'package:tiger_tap_quest/features/game/presentation/screens/game_screen.dart';
import 'package:tiger_tap_quest/features/game/presentation/screens/play_setup_screen.dart';
import 'package:tiger_tap_quest/features/home/presentation/screens/home_screen.dart';
import 'package:tiger_tap_quest/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tiger_tap_quest/features/profile/presentation/screens/profile_screen.dart';
import 'package:tiger_tap_quest/features/settings/presentation/screens/settings_screen.dart';
import 'package:tiger_tap_quest/features/privacy/presentation/screens/privacy_gate_screen.dart';
import 'package:tiger_tap_quest/features/splash/presentation/screens/splash_screen.dart';
import 'package:tiger_tap_quest/features/shop/presentation/screens/shop_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyGateScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/menu',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/play',
        builder: (context, state) => const PlaySetupScreen(),
      ),
      GoRoute(
        path: '/game',
        builder: (context, state) {
          final mode = state.extra as GameMode? ?? GameMode.survival;
          return GameScreen(mode: mode);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/shop',
        builder: (context, state) => const ShopScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
}
