import 'package:flutter/material.dart';
import 'dart:math' as math;

class JungleBackground extends StatefulWidget {
  const JungleBackground({super.key});

  @override
  State<JungleBackground> createState() => _JungleBackgroundState();
}

class _JungleBackgroundState extends State<JungleBackground>
    with TickerProviderStateMixin {
  late AnimationController _leafController;
  late AnimationController _particleController;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();


    _leafController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);


    _particleController = AnimationController(
      duration: const Duration(seconds: 40),
      vsync: this,
    )..repeat();


    _generateParticles();
  }

  void _generateParticles() {
    for (int i = 0; i < 15; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: 0.01 + _random.nextDouble() * 0.015,
        size: 2 + _random.nextDouble() * 3,
        isFirefly: _random.nextBool(),
        phase: _random.nextDouble() * 2 * math.pi,
      ));
    }
  }

  @override
  void dispose() {
    _leafController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.cover,
            excludeFromSemantics: true,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.5),
                Colors.black.withValues(alpha: 0.4),
                Colors.black.withValues(alpha: 0.5),
              ],
            ),
          ),
        ),

        AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return CustomPaint(
              painter: _ParticlePainter(
                particles: _particles,
                animation: _particleController.value,
              ),
              size: Size.infinite,
            );
          },
        ),

        Positioned(
          top: -20,
          left: -30,
          child: AnimatedBuilder(
            animation: _leafController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _leafController.value * 0.1,
                child: Opacity(
                  opacity: 0.3,
                  child: Icon(
                    Icons.eco,
                    size: 120,
                    color: Colors.green.shade900,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 100,
          right: -40,
          child: AnimatedBuilder(
            animation: _leafController,
            builder: (context, child) {
              return Transform.rotate(
                angle: -_leafController.value * 0.15,
                child: Opacity(
                  opacity: 0.25,
                  child: Icon(
                    Icons.eco,
                    size: 150,
                    color: Colors.green.shade800,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Particle {
  final double x;
  double y;
  final double speed;
  final double size;
  final bool isFirefly;
  final double phase;

  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.isFirefly,
    required this.phase,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double animation;

  _ParticlePainter({
    required this.particles,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {

      particle.y = (particle.y + particle.speed * animation) % 1.0;

      final x = particle.x * size.width +
                math.sin(animation * 2 * math.pi + particle.phase) * 20;
      final y = particle.y * size.height;

      if (particle.isFirefly) {

        final glowPaint = Paint()
          ..color = Colors.yellow.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(Offset(x, y), particle.size * 2, glowPaint);

        final paint = Paint()
          ..color = Colors.yellow.withValues(
            alpha: 0.6 + 0.4 * math.sin(animation * 4 * math.pi + particle.phase),
          );
        canvas.drawCircle(Offset(x, y), particle.size, paint);
      } else {

        final paint = Paint()
          ..color = Colors.lightGreen.withValues(alpha: 0.4);


        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(animation * 2 * math.pi + particle.phase);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: particle.size * 2,
            height: particle.size * 3,
          ),
          paint,
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}
