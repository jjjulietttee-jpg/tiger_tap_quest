import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/features/game/domain/models/tap_element.dart';

class TapFeedbackWidget extends StatefulWidget {
  final Offset position;
  final BubbleType? type; // null means miss tap
  final VoidCallback onComplete;

  const TapFeedbackWidget({
    super.key,
    required this.position,
    required this.type,
    required this.onComplete,
  });

  @override
  State<TapFeedbackWidget> createState() => _TapFeedbackWidgetState();
}

class _TapFeedbackWidgetState extends State<TapFeedbackWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    // Miss taps are faster
    final duration = widget.type == null 
        ? const Duration(milliseconds: 300)
        : const Duration(milliseconds: 400);
    
    _controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    if (widget.type == null) {
      // Miss tap: expand slightly
      _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
    } else if (widget.type == BubbleType.bomb) {
      // Bomb: big explosion
      _scaleAnimation = Tween<double>(begin: 1.0, end: 2.5).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
    } else {
      // Normal bubble: pop and expand
      _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
    }

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - 40,
      top: widget.position.dy - 40,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: _buildFeedback(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedback() {
    // Miss tap: ripple effect with particles
    if (widget.type == null) {
      return SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Expanding ripple circle
            Container(
              width: 60 * (1 + _controller.value * 0.5),
              height: 60 * (1 + _controller.value * 0.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6 * (1 - _controller.value)),
                  width: 2,
                ),
              ),
            ),
            // Inner circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.3 * (1 - _controller.value)),
              ),
            ),
            // Particles radiating outward
            ...List.generate(8, (index) {
              final distance = 35.0 * _controller.value;
              final dx = distance * (index % 2 == 0 ? 1 : -1) * (index < 4 ? 1 : -1);
              final dy = distance * (index < 4 ? -1 : 1);
              
              return Positioned(
                left: 50 + dx,
                top: 50 + dy,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7 * (1 - _controller.value)),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      );
    }
    
    // Bubble pop effect
    Color color = _getBubbleColor();
    final particleCount = widget.type == BubbleType.bomb ? 16 : 12;
    
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pop particles
          ...List.generate(particleCount, (index) {
            final distance = (widget.type == BubbleType.bomb ? 60.0 : 45.0) * _controller.value;
            final dx = distance * (index % 3 == 0 ? 1.2 : 1.0) * (index % 2 == 0 ? 1 : -1);
            final dy = distance * (index < particleCount / 2 ? -1 : 1) * (index % 3 == 0 ? 1.2 : 1.0);
            
            return Positioned(
              left: 50 + dx,
              top: 50 + dy,
              child: Container(
                width: widget.type == BubbleType.bomb ? 10 : (index % 2 == 0 ? 8 : 6),
                height: widget.type == BubbleType.bomb ? 10 : (index % 2 == 0 ? 8 : 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 1.0 - _controller.value * 0.3),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getBubbleColor() {
    switch (widget.type!) {
      case BubbleType.banana:
        return const Color(0xFFFFEB3B); // Yellow
      case BubbleType.coconut:
        return const Color(0xFF8D6E63); // Brown
      case BubbleType.mango:
        return const Color(0xFFFF9800); // Orange
      case BubbleType.pineapple:
        return const Color(0xFFFDD835); // Golden yellow
      case BubbleType.watermelon:
        return const Color(0xFFE91E63); // Pink/Red
      case BubbleType.bomb:
        return const Color(0xFFFF6F00); // Orange explosion
      case BubbleType.tiger:
        return const Color(0xFFFF6F00); // Tiger orange
      case BubbleType.slowmo:
        return const Color(0xFF9C27B0); // Purple
      case BubbleType.freeze:
        return const Color(0xFF03A9F4); // Light blue
      case BubbleType.lightning:
        return const Color(0xFFFFEB3B); // Yellow
      case BubbleType.star:
        return const Color(0xFFFFC107); // Amber
      case BubbleType.diamond:
        return const Color(0xFF00BCD4); // Cyan
    }
  }
}
