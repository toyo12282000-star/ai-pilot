import 'package:flutter/material.dart';

/// AI Pilot 角丸スケール。
abstract final class AppRadius {
  static const double r8 = 8;
  static const double r12 = 12;
  static const double r16 = 16;
  static const double r20 = 20;
  static const double r24 = 24;

  /// 後方互換エイリアス。
  static const double sm = r8;
  static const double md = r12;
  static const double lg = r16;

  static const BorderRadius small = BorderRadius.all(Radius.circular(r8));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(r12));
  static const BorderRadius large = BorderRadius.all(Radius.circular(r16));
  static const BorderRadius xLarge = BorderRadius.all(Radius.circular(r20));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(r24));

  static const BorderRadius card = large;
  static const BorderRadius button = medium;
  static const BorderRadius chip = small;
}
