import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiger_tap_quest/core/data/services/stats_service.dart';
import 'package:tiger_tap_quest/features/splash/presentation/widgets/splash_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAway();
  }

  Future<void> _navigateAway() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final service = StatsService();
    final privacyAccepted = await service.isPrivacyAccepted();
    if (!mounted) return;

    if (!privacyAccepted) {
      context.go('/privacy');
      return;
    }

    final onboardingDone = await service.isOnboardingCompleted();
    if (!mounted) return;

    if (onboardingDone) {
      context.go('/menu');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashLayout(),
    );
  }
}
