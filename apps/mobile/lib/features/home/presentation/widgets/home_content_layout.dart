import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/spacing.dart';

/// ホーム画面の PC 向け最大コンテンツ幅。
abstract final class HomeContentLayout {
  static const double maxWidth = 1200;

  static const double sectionSpacing = AppSpacing.s32;

  static EdgeInsets horizontalPadding(BuildContext context) {
    return AppSpacing.pageHorizontal;
  }

  /// Hero / 完成作品セクションなど横幅を揃えるラッパー。
  static Widget constrain({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? horizontalPadding(context),
          child: child,
        ),
      ),
    );
  }
}
