import 'package:flutter/material.dart';

class AppTheme {
  static const String _bgAsset = 'assets/images/bg.png';

  static String get bgAsset => _bgAsset;

  static ColorScheme get _colorScheme => ColorScheme.dark(
        primary: const Color(0xFFFF8C42),
        onPrimary: Colors.white,
        secondary: const Color(0xFF4CAF50),
        onSecondary: Colors.white,
        surface: const Color(0xFF1B5E20),
        onSurface: const Color(0xFFFFF8E1),
        error: Colors.red.shade400,
        onError: Colors.white,
      );

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
      );

  static TextTheme get _textTheme => TextTheme(
        displayLarge: TextStyle(
          color: _colorScheme.onSurface,
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
          color: _colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        headlineMedium: TextStyle(
          color: _colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: _colorScheme.onSurface),
        bodyMedium: TextStyle(color: _colorScheme.onSurface.withValues(alpha: 0.9)),
        labelLarge: TextStyle(
          color: _colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      );
}
