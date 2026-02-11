import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? emoji;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final paddingH = constraints.maxWidth * 0.1;
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingH),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  // Emoji only
                  if (emoji != null)
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji!,
                          style: TextStyle(fontSize: 70),
                        ),
                      ),
                    ),
                  SizedBox(height: constraints.maxHeight * 0.06),
                  // Title
                  CustomText(
                    title,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 30,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  // Subtitle with proper wrapping
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
                    child: Text(
                      subtitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        height: 1.5,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 10,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
