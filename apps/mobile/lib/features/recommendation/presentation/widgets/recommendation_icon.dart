import 'package:flutter/material.dart';

import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';

/// [Recommendation.icon] を Material アイコンに変換する。
IconData recommendationIconFromName(String iconName) {
  switch (iconName) {
    case 'video':
      return Icons.play_circle_outline;
    case 'work':
      return Icons.work_outline;
    case 'edit':
      return Icons.edit_outlined;
    case 'share':
      return Icons.share_outlined;
    case 'description':
      return Icons.description_outlined;
    case 'auto_awesome':
      return Icons.auto_awesome;
    default:
      return Icons.lightbulb_outline;
  }
}

/// HEX 文字列（`#RRGGBB`）を [Color] に変換する。
Color recommendationColorFromHex(String hex) {
  final value = hex.replaceFirst('#', '');
  return Color(int.parse('FF$value', radix: 16));
}
