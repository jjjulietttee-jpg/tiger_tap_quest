import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiger_tap_quest/features/onboarding/presentation/widgets/onboarding_layout.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage && mounted) setState(() => _currentPage = page);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/menu');
    }
  }

  void _onSkip() {
    context.go('/menu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingLayout(
        pageController: _pageController,
        onNext: _onNext,
        onSkip: _onSkip,
        currentPage: _currentPage,
      ),
    );
  }
}
