import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/breakpoints.dart';
import 'package:ai_pilot/design_system/responsive.dart';

/// ホーム画面の PC 向け最大コンテンツ幅。
abstract final class HomeContentLayout {
  static const double maxWidth = 1200;

  /// @deprecated Use [AppBreakpoints.tabletMin].
  static const double tabletBreakpoint = AppBreakpoints.tabletMin;

  static const double desktopBreakpoint = AppBreakpoints.desktopMin;

  static EdgeInsets horizontalPadding(BuildContext context) {
    return AppResponsiveSpacing.pagePadding(context);
  }

  static double sectionSpacing(BuildContext context) =>
      AppResponsiveSpacing.section(context);

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
