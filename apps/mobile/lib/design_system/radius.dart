import 'package:flutter/material.dart';

/// AI Pilot 角丸スケール（Sprint 13.4）。
abstract final class AppRadius {
  static const double r8 = 8;
  static const double r12 = 12;
  static const double r14 = 14;
  static const double r16 = 16;
  static const double r18 = 18;
  static const double r20 = 20;
  static const double r22 = 22;
  static const double r24 = 24;
  static const double r28 = 28;
  static const double r32 = 32;
  static const double pillRadius = 999;

  /// 後方互換エイリアス。
  static const double sm = r8;
  static const double md = r12;
  static const double lg = r16;

  static const BorderRadius small = BorderRadius.all(Radius.circular(r8));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(r12));
  static const BorderRadius large = BorderRadius.all(Radius.circular(r16));
  static const BorderRadius xLarge = BorderRadius.all(Radius.circular(r20));
  static const BorderRadius hero = BorderRadius.all(Radius.circular(r28));
  static const BorderRadius card = BorderRadius.all(Radius.circular(r20));
  static const BorderRadius button = BorderRadius.all(Radius.circular(r16));
  static const BorderRadius chip = BorderRadius.all(Radius.circular(pillRadius));
  static const BorderRadius search = BorderRadius.all(Radius.circular(r16));

  /// 後方互換エイリアス。
  static const BorderRadius pill = chip;
}
