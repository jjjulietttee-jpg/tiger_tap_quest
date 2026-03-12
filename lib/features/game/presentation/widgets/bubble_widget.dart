import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/features/game/domain/models/tap_element.dart';

class BubbleWidget extends StatefulWidget {
  final Bubble bubble;
  final VoidCallback onTap;

  const BubbleWidget({
    super.key,
    required this.bubble,
    required this.onTap,
  });

  @override
  State<BubbleWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );


    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward().then((_) {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {

        final scale = _scaleAnimation.isCompleted
            ? _pulseAnimation.value
            : _scaleAnimation.value;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.bubble.size,
            height: widget.bubble.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getBackgroundColor(),
              boxShadow: [
                BoxShadow(
                  color: _getColor().withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getEmoji(),
                style: TextStyle(
                  fontSize: widget.bubble.size * 0.55,
                  height: 1.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getColor() {
    switch (widget.bubble.type) {
      case BubbleType.banana:
        return const Color(0xFFFFEB3B);
      case BubbleType.coconut:
        return const Color(0xFF8D6E63);
      case BubbleType.mango:
        return const Color(0xFFFF9800);
      case BubbleType.pineapple:
        return const Color(0xFFFDD835);
      case BubbleType.watermelon:
        return const Color(0xFFE91E63);
      case BubbleType.bomb:
        return const Color(0xFF424242);
      case BubbleType.tiger:
        return const Color(0xFFFF6F00);
      case BubbleType.slowmo:
        return const Color(0xFF9C27B0);
      case BubbleType.freeze:
        return const Color(0xFF03A9F4);
      case BubbleType.lightning:
        return const Color(0xFFFFEB3B);
      case BubbleType.star:
        return const Color(0xFFFFC107);
      case BubbleType.diamond:
        return const Color(0xFF00BCD4);
    }
  }

  Color _getBackgroundColor() {

    return _getColor().withValues(alpha: 0.3);
  }

  String _getEmoji() {
    switch (widget.bubble.type) {
      case BubbleType.banana:
        return '🍌';
      case BubbleType.coconut:
        return '🥥';
      case BubbleType.mango:
        return '🥭';
      case BubbleType.pineapple:
        return '🍍';
      case BubbleType.watermelon:
        return '🍉';
      case BubbleType.bomb:
        return '💣';
      case BubbleType.tiger:
        return '🐯';
      case BubbleType.slowmo:
        return '⏱️';
      case BubbleType.freeze:
        return '❄️';
      case BubbleType.lightning:
        return '⚡';
      case BubbleType.star:
        return '🌟';
      case BubbleType.diamond:
        return '💎';
    }
  }
}
