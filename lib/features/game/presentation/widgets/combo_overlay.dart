import 'package:flutter/material.dart';
import 'package:tiger_tap_quest/core/theme/app_theme.dart';

class ComboOverlay extends StatefulWidget {
  final int combo;
  final int multiplier;

  const ComboOverlay({
    super.key,
    required this.combo,
    required this.multiplier,
  });

  @override
  State<ComboOverlay> createState() => _ComboOverlayState();
}

class _ComboOverlayState extends State<ComboOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  int _lastShownCombo = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.3), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ComboOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.combo >= 5 && widget.combo != _lastShownCombo &&
        widget.combo % 5 == 0) {
      _lastShownCombo = widget.combo;
      _controller.forward(from: 0);
    }
  }

  String get _comboText {
    if (widget.combo >= 20) return 'INSANE!';
    if (widget.combo >= 15) return 'AMAZING!';
    if (widget.combo >= 10) return 'GREAT!';
    return 'COMBO!';
  }

  Color get _comboColor {
    if (widget.combo >= 20) return const Color(0xFFFF1744);
    if (widget.combo >= 15) return const Color(0xFFFF9100);
    if (widget.combo >= 10) return AppTheme.gold;
    return AppTheme.orange;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (_opacity.value <= 0.01) return const SizedBox.shrink();
        return Positioned(
          top: MediaQuery.sizeOf(context).height * 0.15,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Opacity(
              opacity: _opacity.value,
              child: Transform.scale(
                scale: _scale.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _comboText,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: _comboColor,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            color: _comboColor.withValues(alpha: 0.6),
                            blurRadius: 20,
                          ),
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'x${widget.combo} · ${widget.multiplier}x',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.9),
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
