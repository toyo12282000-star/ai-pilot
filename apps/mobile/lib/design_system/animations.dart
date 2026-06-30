import 'package:flutter/material.dart';

/// AI Pilot アニメーション定数（Sprint 13.1）。
abstract final class AppAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration interactive = Duration(milliseconds: 200);
  static const Duration normal = interactive;
  static const Duration slow = Duration(milliseconds: 400);

  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;

  static const double hoverScale = 1.02;
  static const double pressedOpacity = 0.88;

  static const Duration pageTransition = normal;
  static const Curve pageTransitionCurve = easeInOut;
}
