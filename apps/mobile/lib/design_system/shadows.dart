import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';

/// AI Pilot シャドウ（最小限 — Border 主体 UI）。
abstract final class AppShadows {
  static List<BoxShadow> get small => [
        BoxShadow(
          color: AppColors.charcoal.withValues(alpha: 0.03),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get medium => [
        BoxShadow(
          color: AppColors.charcoal.withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get large => [
        BoxShadow(
          color: AppColors.charcoal.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 3),
        ),
      ];

  /// シャドウなし（推奨デフォルト）。
  static const List<BoxShadow> none = [];
}
