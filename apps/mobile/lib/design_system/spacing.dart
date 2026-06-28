import 'package:flutter/material.dart';

/// AI Pilot スペーシングスケール。
abstract final class AppSpacing {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s48 = 48;
  static const double s64 = 64;

  /// 後方互換エイリアス。
  static const double xs = s4;
  static const double sm = s8;
  static const double md = s16;
  static const double lg = s24;
  static const double xl = s32;

  static const double listItemGap = s12;

  static const EdgeInsets page = EdgeInsets.all(s16);
  static const EdgeInsets pageHorizontal = EdgeInsets.symmetric(horizontal: s16);
  static const EdgeInsets card = EdgeInsets.all(s16);
  static const EdgeInsets section = EdgeInsets.symmetric(horizontal: s16);
}
