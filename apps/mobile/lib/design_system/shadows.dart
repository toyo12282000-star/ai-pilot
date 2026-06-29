import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';

/// AI Pilot シャドウ（最小限 — ボーダー中心 UI 向け）。
abstract final class AppShadows {
  static List<BoxShadow> get small => [
        BoxShadow(
          color: AppColors.darkNavy.withValues(alpha: 0.03),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get medium => [
        BoxShadow(
          color: AppColors.darkNavy.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get large => [
        BoxShadow(
          color: AppColors.darkNavy.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  /// シャドウなし（推奨デフォルト）。
  static const List<BoxShadow> none = [];
}
