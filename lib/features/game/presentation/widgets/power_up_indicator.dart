import 'package:flutter/material.dart';
import 'dart:math' as math;

class PowerUpIndicator extends StatefulWidget {
  final String emoji;
  final Color color;
  final Duration remainingTime;
  final Duration totalDuration;

  const PowerUpIndicator({
    super.key,
    required this.emoji,
    required this.color,
    required this.remainingTime,
    required this.totalDuration,
  });

  @override
  State<PowerUpIndicator> createState() => _PowerUpIndicatorState();
}

class _PowerUpIndicatorState extends State<PowerUpIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.remainingTime.inMilliseconds /
                     widget.totalDuration.inMilliseconds;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Stack(
            alignment: Alignment.center,
            children: [

              CustomPaint(
                size: const Size(60, 60),
                painter: _ProgressCirclePainter(
                  progress: progress,
                  color: widget.color,
                ),
              ),

              Container(
                width: 50 + (_controller.value * 4),
                height: 50 + (_controller.value * 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.2 * (1 - _controller.value)),
                ),
              ),

              Text(
                widget.emoji,
                style: TextStyle(
                  fontSize: 28,
                  height: 1.0,
                  shadows: [
                    Shadow(
                      color: widget.color.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.remainingTime.inSeconds}s',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProgressCirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ProgressCirclePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius - 2, bgPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 2),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ProgressCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
