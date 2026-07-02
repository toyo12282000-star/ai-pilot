/// AI Pilot レスポンシブブレークポイント（Sprint 14.2 · Mobile First）。
abstract final class AppBreakpoints {
  /// Mobile: width < 600
  static const double mobileMax = 599;

  /// Tablet: 600〜899
  static const double tabletMin = 600;
  static const double tabletMax = 899;

  /// Desktop: >= 900
  static const double desktopMin = 900;

  static bool isMobile(double width) => width <= mobileMax;

  static bool isTablet(double width) =>
      width >= tabletMin && width <= tabletMax;

  static bool isDesktop(double width) => width >= desktopMin;
}
