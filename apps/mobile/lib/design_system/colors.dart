import 'package:flutter/material.dart';

/// AI Pilot カラーパレット（Sprint 13.4 — Apple / Notion / Arc 調）。
abstract final class AppColors {
  static const Color background = Color(0xFFF8F8F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF3F1EC);
  static const Color border = Color(0xFFE8E5DF);

  static const Color primary = Color(0xFFC9A46A);
  static const Color primaryHover = Color(0xFFB88D50);
  static const Color primarySoft = Color(0xFFF5EBDD);

  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF6F6A61);
  static const Color muted = Color(0xFFA39D92);

  static const Color darkNavy = Color(0xFF1E293B);
  static const Color charcoal = Color(0xFF2A2926);

  static const Color success = Color(0xFF2F6F4E);
  static const Color warning = Color(0xFFB7791F);
  static const Color error = Color(0xFFB42318);

  /// 後方互換エイリアス。
  static const Color outline = border;
  static const Color secondary = textSecondary;

  /// Material [ColorScheme] 生成。
  static ColorScheme get colorScheme => const ColorScheme.light(
        primary: primary,
        onPrimary: surface,
        secondary: textSecondary,
        onSecondary: textPrimary,
        surface: background,
        onSurface: textPrimary,
        error: error,
        onError: surface,
        outline: border,
        surfaceContainerLowest: surface,
        surfaceContainerHighest: surfaceMuted,
        onSurfaceVariant: textSecondary,
      );
}
