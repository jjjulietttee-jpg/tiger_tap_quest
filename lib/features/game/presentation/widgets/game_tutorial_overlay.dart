import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_elevated_button.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';

class GameTutorialOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const GameTutorialOverlay({
    super.key,
    required this.onComplete,
  });

  @override
  State<GameTutorialOverlay> createState() => _GameTutorialOverlayState();
}

class _GameTutorialOverlayState extends State<GameTutorialOverlay> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _pageCount = 2;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Material(
      color: Colors.black54,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 400,
                maxHeight: size.height * 0.78,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.35),
                    blurRadius: 32,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 48,
                    spreadRadius: -4,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) =>
                            setState(() => _currentPage = index),
                        children: const [
                          _TapFruitsPage(),
                          _AvoidBombsPage(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        size.width * 0.06,
                        12,
                        size.width * 0.06,
                        size.height * 0.028,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _pageCount,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5),
                                width: _currentPage == index ? 28 : 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: _currentPage == index
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.35),
                                  boxShadow: _currentPage == index
                                      ? [
                                          BoxShadow(
                                            color: theme.colorScheme.primary
                                                .withValues(alpha: 0.5),
                                            blurRadius: 8,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.022),
                          CustomElevatedButton(
                            onPressed: _onNext,
                            child: Text(
                              _currentPage < _pageCount - 1
                                  ? 'Next'
                                  : "Got it!",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TapFruitsPage extends StatelessWidget {
  const _TapFruitsPage();

  static const List<MapEntry<String, Color>> _fruits = [
    MapEntry('🍌', Color(0xFFFFEB3B)),
    MapEntry('🥭', Color(0xFFFF9800)),
    MapEntry('🍍', Color(0xFFFDD835)),
    MapEntry('🍉', Color(0xFFE91E63)),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.07,
        vertical: size.height * 0.035,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            'Tap the fruits',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              fontSize: 26,
            ),
            textAlign: TextAlign.center,
            glow: true,
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            'Tap on fruits to collect points and build combos.\n\n'
            'The more you tap in a row without missing, the higher your combo multiplier and the more points you earn.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
              height: 1.5,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height * 0.032),
          LayoutBuilder(
            builder: (context, constraints) {
              const count = 4;
              const spacing = 6.0;
              const horizontalPadding = 12.0;
              final maxW = constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : size.width * 0.75;
              final availableWidth =
                  maxW - horizontalPadding * 2 - spacing * (count - 1);
              final bubbleSize = (availableWidth / count).clamp(32.0, 52.0);

              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: size.height * 0.018,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tap these',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: size.height * 0.012),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: _fruits.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: spacing / 2),
                          child: _ExampleBubble(
                            emoji: e.key,
                            color: e.value,
                            size: bubbleSize,
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      '+ points  •  + combo',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AvoidBombsPage extends StatelessWidget {
  const _AvoidBombsPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    const bombColor = Color(0xFF424242);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.07,
        vertical: size.height * 0.035,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            'Avoid the bombs',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              fontSize: 26,
            ),
            textAlign: TextAlign.center,
            glow: true,
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            "Don't tap bombs or you'll lose a life.\n\n"
            'Stay focused and tap only the fruits. Miss too many lives and the game is over.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
              height: 1.5,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height * 0.032),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxW = constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : size.width * 0.75;
              final bombSize = (maxW * 0.35).clamp(48.0, 64.0);

              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: size.height * 0.02,
                ),
                decoration: BoxDecoration(
                  color: bombColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: bombColor.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don't tap",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: const Color(0xFFE53935),
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: size.height * 0.014),
                    _ExampleBubble(
                      emoji: '💣',
                      color: bombColor,
                      size: bombSize,
                    ),
                    SizedBox(height: size.height * 0.008),
                    Text(
                      '−1 life',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ExampleBubble extends StatelessWidget {
  final String emoji;
  final Color color;
  final double size;

  const _ExampleBubble({
    required this.emoji,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.3),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.45),
            blurRadius: 12,
            spreadRadius: 0.5,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(
            fontSize: size * 0.52,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
