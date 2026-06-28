import 'package:flutter/material.dart';

/// AI Pilot カラーパレット。
abstract final class AppColors {
  static const Color primary = Color(0xFF5B5CEB);
  static const Color secondary = Color(0xFF6DD5FA);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  /// Material [ColorScheme] 生成。
  static ColorScheme get colorScheme => const ColorScheme.light(
        primary: primary,
        onPrimary: surface,
        secondary: secondary,
        onSecondary: textPrimary,
        surface: background,
        onSurface: textPrimary,
        error: error,
        onError: surface,
        outline: outline,
        surfaceContainerLowest: surface,
        surfaceContainerHighest: background,
        onSurfaceVariant: textSecondary,
      );
}
