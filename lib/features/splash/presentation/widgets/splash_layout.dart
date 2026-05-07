import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';
import 'package:tiger_tap_quest/core/shared/widgets/dark_background.dart';
import 'dart:math' as math;

class SplashLayout extends StatefulWidget {
  const SplashLayout({super.key});

  @override
  State<SplashLayout> createState() => _SplashLayoutState();
}

class _SplashLayoutState extends State<SplashLayout>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<double> _rotate;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );
    _scale = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _rotate = Tween<double>(begin: 0, end: 2 * math.pi).animate(_rotateController);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DarkBackground(),

          AnimatedBuilder(
            animation: _rotate,
            builder: (context, child) {
              return Stack(
                children: [

                  Positioned(
                    top: size.height * 0.15,
                    right: -50 + math.sin(_rotate.value) * 20,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.3),
                            theme.colorScheme.primary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: size.height * 0.2,
                    left: -70 + math.cos(_rotate.value) * 20,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            theme.colorScheme.secondary.withValues(alpha: 0.3),
                            theme.colorScheme.secondary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          AnimatedBuilder(
            animation: _rotate,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: size.height * 0.25 + math.sin(_rotate.value * 0.5) * 15,
                    left: size.width * 0.15,
                    child: Opacity(
                      opacity: 0.6,
                      child: Text('🐯', style: TextStyle(fontSize: 40)),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.7 + math.cos(_rotate.value * 0.7) * 20,
                    right: size.width * 0.2,
                    child: Opacity(
                      opacity: 0.5,
                      child: Text('🍌', style: TextStyle(fontSize: 35)),
                    ),
                  ),
                  Positioned(
                    bottom: size.height * 0.3 + math.sin(_rotate.value * 0.6) * 18,
                    left: size.width * 0.75,
                    child: Opacity(
                      opacity: 0.5,
                      child: Text('🥭', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                ],
              );
            },
          ),

          Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    AnimatedBuilder(
                      animation: _pulse,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulse.value,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '🐯',
                                style: TextStyle(fontSize: 70),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 30),
                    CustomText(
                      'Tiger Tap Quest',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 36,
                        letterSpacing: 1.2,
                      ),
                      glow: true,
                    ),
                    SizedBox(height: 12),
                    CustomText(
                      'Jungle Adventure Awaits',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        color: theme.colorScheme.secondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: size.height * 0.1,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fade,
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
