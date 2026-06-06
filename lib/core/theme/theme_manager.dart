import 'package:another_iptv_player/core/theme/app_theme.dart';
import 'package:another_iptv_player/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData buildTheme(BingieThemePalette palette) {
    final scheme = ColorScheme.fromSeed(
      seedColor: palette.primary,
      brightness: Brightness.dark,
      primary: palette.primary,
      secondary: palette.secondary,
      surface: palette.surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme.copyWith(
        background: palette.background,
        onSurface: palette.text,
      ),
      scaffoldBackgroundColor: palette.background,
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: palette.primary.withValues(alpha: 0.22)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.text,
        elevation: 0,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.text,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      extensions: [
        BingieThemeExtension(
          brandGradient: LinearGradient(
            colors: [palette.primary, palette.secondary, palette.accent],
          ),
          focusGlow: palette.accent,
          glassBorder: palette.primary.withValues(alpha: 0.35),
        ),
      ],
    );
  }
}
