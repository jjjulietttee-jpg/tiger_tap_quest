import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/card_widget.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';

class ProfileUserSection extends StatelessWidget {
  const ProfileUserSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          size.width * 0.06,
          size.height * 0.02,
          size.width * 0.06,
          size.height * 0.03,
        ),
        child: CardWidget(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: size.height * 0.02),
              Container(
                width: (size.width * 0.35).clamp(64.0, 120.0),
                height: (size.width * 0.35).clamp(64.0, 120.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
                child: Icon(
                  Icons.person,
                  size: (size.width * 0.18).clamp(32.0, 60.0),
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              CustomText(
                'User',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.008),
              Text(
                'Member',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
