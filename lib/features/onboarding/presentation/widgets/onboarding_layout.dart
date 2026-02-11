import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/dark_background.dart';
import 'package:tiger_tap_quest/features/onboarding/presentation/widgets/onboarding_controls.dart';
import 'package:tiger_tap_quest/features/onboarding/presentation/widgets/onboarding_page.dart';

class OnboardingLayout extends StatelessWidget {
  final PageController pageController;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final int currentPage;

  const OnboardingLayout({
    super.key,
    required this.pageController,
    required this.onNext,
    required this.onSkip,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DarkBackground(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.02,
                    right: size.width * 0.04,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: onSkip,
                        child: Text('Skip'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final titles = [
                        'Welcome to\nTiger Tap Quest!',
                        'Pop Jungle\nFruits',
                        'Collect Power-Ups\n& Combos'
                      ];
                      final subtitles = [
                        'Embark on an exciting jungle adventure where you tap colorful fruits and unlock amazing achievements!',
                        'Tap rising fruits before they escape! Each fruit gives you points. Create combos for bonus scores!',
                        'Discover special power-ups like bombs, freeze, and stars. Build massive combos to become a legend!',
                      ];
                      final icons = [
                        Icons.auto_awesome,
                        Icons.touch_app,
                        Icons.stars,
                      ];
                      final emojis = ['🐯', '🍌', '💎'];
                      
                      return OnboardingPage(
                        title: titles[index],
                        subtitle: subtitles[index],
                        icon: icons[index],
                        emoji: emojis[index],
                      );
                    },
                  ),
                ),
                OnboardingControls(
                  onNext: onNext,
                  onSkip: onSkip,
                  currentPage: currentPage,
                  pageCount: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
