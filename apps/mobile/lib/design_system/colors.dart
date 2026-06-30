import 'package:flutter/material.dart';

/// AI Pilot カラーパレット（Sprint 13.1 — Notion / Linear 調）。
abstract final class AppColors {
  static const Color background = Color(0xFFF8F9FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF2F4F7);
  static const Color primary = Color(0xFF4F46E5);
  static const Color primarySoft = Color(0xFFEEF2FF);
  static const Color secondary = Color(0xFF94A3B8);
  static const Color accentCyan = Color(0xFF7DD3FC);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
  static const Color border = Color(0xFFE7EAF0);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color muted = Color(0xFF9CA3AF);
  static const Color darkNavy = Color(0xFF101828);

  /// 後方互換エイリアス。
  static const Color outline = border;

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
        outline: border,
        surfaceContainerLowest: surface,
        surfaceContainerHighest: surfaceMuted,
        onSurfaceVariant: textSecondary,
      );
}
