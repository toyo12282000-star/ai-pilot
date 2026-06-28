import 'package:flutter/material.dart';

/// AI Pilot アニメーション定数。
abstract final class AppAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;

  static const Duration pageTransition = normal;
  static const Curve pageTransitionCurve = easeInOut;
}
