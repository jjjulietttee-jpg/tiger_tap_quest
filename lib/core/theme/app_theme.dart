import 'package:flutter/material.dart';

class AppTheme {
  static const String _bgAsset = 'assets/images/bg.jpg';
  static const String _fontFamily = 'Fredoka';

  static String get bgAsset => _bgAsset;

  static const Color orange = Color(0xFFFF8C42);
  static const Color gold = Color(0xFFFFD54F);
  static const Color jungleGreen = Color(0xFF4CAF50);
  static const Color deepGreen = Color(0xFF1B5E20);
  static const Color cream = Color(0xFFFFF8E1);

  static ColorScheme get _colorScheme => ColorScheme.dark(
        primary: orange,
        onPrimary: Colors.white,
        secondary: jungleGreen,
        onSecondary: Colors.white,
        surface: deepGreen,
        onSurface: cream,
        tertiary: gold,
        error: Colors.red.shade400,
        onError: Colors.white,
      );

  static TextTheme get _textTheme {
    const f = _fontFamily;
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: f,
        color: cream,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      displayMedium: TextStyle(
        fontFamily: f,
        color: cream,
        fontWeight: FontWeight.w600,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      headlineLarge: const TextStyle(
        fontFamily: f,
        color: cream,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: const TextStyle(
        fontFamily: f,
        color: cream,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: const TextStyle(
        fontFamily: f,
        color: cream,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: const TextStyle(
        fontFamily: f,
        color: cream,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: const TextStyle(fontFamily: f, color: cream),
      bodyMedium: TextStyle(
        fontFamily: f,
        color: cream.withValues(alpha: 0.9),
      ),
      bodySmall: TextStyle(
        fontFamily: f,
        color: cream.withValues(alpha: 0.7),
      ),
      labelLarge: const TextStyle(
        fontFamily: f,
        color: cream,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: _colorScheme,
        scaffoldBackgroundColor: _colorScheme.surface,
        textTheme: _textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: _colorScheme.onSurface),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return orange;
            return Colors.grey.shade400;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return orange.withValues(alpha: 0.4);
            }
            return Colors.grey.shade700;
          }),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: orange,
          thumbColor: orange,
          inactiveTrackColor: Colors.white24,
          overlayColor: orange.withValues(alpha: 0.2),
        ),
      );
}
