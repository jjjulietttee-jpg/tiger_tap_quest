import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const CardWidget({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
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
    _scale = Tween<double>(begin: 1, end: 0.98).animate(
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final child = Container(
              padding: widget.padding ??
                  EdgeInsets.all(
                    (constraints.maxWidth * 0.06).clamp(16.0, 32.0),
                  ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.colorScheme.surface.withValues(alpha: 0.6),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: widget.child,
        );
        if (widget.onTap == null) return child;
        final borderRadius = BorderRadius.circular(16);
        return AnimatedBuilder(
          animation: _scale,
          builder: (context, _) => Transform.scale(
            scale: _scale.value,
            child: GestureDetector(
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) => _controller.reverse(),
              onTapCancel: () => _controller.reverse(),
              onTap: widget.onTap,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  child,
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: borderRadius,
                      child: InkWell(
                        borderRadius: borderRadius,
                        onTap: widget.onTap,
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
