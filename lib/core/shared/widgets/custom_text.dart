import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool glow;
  final bool shadow;
  final int? maxLines;

  const CustomText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.glow = false,
    this.shadow = true,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.bodyLarge ?? const TextStyle();
    final effectiveStyle = (style ?? baseStyle).copyWith(
      shadows: [
        if (shadow)
          Shadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        if (glow)
          Shadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.6),
            blurRadius: 8,
          ),
      ],
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: effectiveStyle,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: maxLines != null ? TextOverflow.ellipsis : null,
          ),
        );
      },
    );
  }
}
