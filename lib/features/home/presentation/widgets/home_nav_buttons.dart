import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tiger_tap_quest/core/theme/app_theme.dart';

class HomeNavButtons extends StatelessWidget {
  const HomeNavButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.7,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: const [
            _NavCard(
              icon: Icons.storefront_rounded,
              label: 'Shop',
              route: '/shop',
              accentColor: AppTheme.gold,
            ),
            _NavCard(
              icon: Icons.emoji_events_rounded,
              label: 'Trophies',
              route: '/achievements',
              accentColor: Color(0xFFFFB74D),
            ),
            _NavCard(
              icon: Icons.person_rounded,
              label: 'Profile',
              route: '/profile',
              accentColor: AppTheme.jungleGreen,
            ),
            _NavCard(
              icon: Icons.settings_rounded,
              label: 'Settings',
              route: '/settings',
              accentColor: Color(0xFF90A4AE),
            ),
          ],
        );
      },
    );
  }
}

class _NavCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String route;
  final Color accentColor;

  const _NavCard({
    required this.icon,
    required this.label,
    required this.route,
    required this.accentColor,
  });

  @override
  State<_NavCard> createState() => _NavCardState();
}

class _NavCardState extends State<_NavCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) => Transform.scale(
        scale: _scale.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: () {
          HapticFeedback.selectionClick();
          context.push(widget.route);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.accentColor.withValues(alpha: 0.18),
                    Colors.white.withValues(alpha: 0.06),
                  ],
                ),
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 32,
                    color: widget.accentColor,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
