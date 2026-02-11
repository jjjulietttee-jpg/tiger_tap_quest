import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_elevated_button.dart';

class OnboardingControls extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final int currentPage;
  final int pageCount;

  const OnboardingControls({
    super.key,
    required this.onNext,
    required this.onSkip,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : size.width;
        final h = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : size.height;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            w * 0.06,
            h * 0.03,
            w * 0.06,
            h * 0.05,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pageCount,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: w * 0.01),
                    width: w * 0.04,
                    height: w * 0.04,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == currentPage
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              SizedBox(height: h * 0.035),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: h * 0.06),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                        child: CustomElevatedButton(
                          onPressed: onNext,
                          child: Text(
                            currentPage == pageCount - 1 ? 'Start' : 'Next',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
