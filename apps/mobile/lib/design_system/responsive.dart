import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/breakpoints.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// [BuildContext] から画面幅・デバイス種別を取得する。
extension AppResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  bool get isMobile => AppBreakpoints.isMobile(screenWidth);

  bool get isTablet => AppBreakpoints.isTablet(screenWidth);

  bool get isDesktop => AppBreakpoints.isDesktop(screenWidth);
}

/// モバイル / デスクトップで切り替える余白。
abstract final class AppResponsiveSpacing {
  static double pageHorizontal(BuildContext context) =>
      context.isMobile ? AppSpacing.s16 : AppSpacing.s24;

  static double section(BuildContext context) =>
      context.isMobile ? AppSpacing.s32 : AppSpacing.section;

  static double card(BuildContext context) =>
      context.isMobile ? AppSpacing.s16 : AppSpacing.card;

  static double heroVertical(BuildContext context) =>
      context.isMobile ? AppSpacing.s32 : AppSpacing.hero;

  static double cardGap(BuildContext context) =>
      context.isMobile ? AppSpacing.s16 : AppSpacing.s24;

  static EdgeInsets pagePadding(BuildContext context) => EdgeInsets.symmetric(
        horizontal: pageHorizontal(context),
      );
}

/// モバイル / デスクトップで切り替えるタイポグラフィ。
abstract final class AppResponsiveTypography {
  static TextStyle heroTitle(BuildContext context) {
    return AppTypography.heroTitle.copyWith(
      fontSize: context.isMobile ? 28 : 32,
      letterSpacing: context.isMobile ? -0.35 : -0.45,
      height: context.isMobile ? 1.22 : 1.22,
    );
  }

  static TextStyle sectionTitle(BuildContext context) {
    return AppTypography.sectionTitle.copyWith(
      fontSize: context.isMobile ? 22 : 24,
    );
  }

  static TextStyle detailHeadline(BuildContext context) {
    return AppTypography.titleLarge.copyWith(
      fontSize: context.isMobile ? 24 : 28,
      fontWeight: FontWeight.w700,
      letterSpacing: context.isMobile ? -0.25 : -0.3,
    );
  }

  static TextStyle body(BuildContext context) {
    return AppTypography.bodyMedium.copyWith(
      fontSize: context.isMobile ? 14 : 15,
    );
  }

  static TextStyle caption(BuildContext context) {
    return AppTypography.captionMedium.copyWith(
      fontSize: context.isMobile ? 13 : 13,
    );
  }

  static TextStyle beforeAfterTitle(BuildContext context) {
    return AppTypography.titleLarge.copyWith(
      fontSize: context.isMobile ? 22 : 24,
      fontWeight: FontWeight.w700,
    );
  }
}
