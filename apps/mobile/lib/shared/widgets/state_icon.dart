import 'package:flutter/material.dart';

import 'package:ai_pilot/core/constants/app_radius.dart';

/// Loading / Empty / Error 共通のアイコン背景。
class StateIcon extends StatelessWidget {
  const StateIcon({
    super.key,
    required this.icon,
    required this.color,
    this.backgroundColor,
  });

  final IconData icon;
  final Color color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? color.withValues(alpha: 0.12);

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.card,
      ),
      child: Icon(icon, size: 36, color: color),
    );
  }
}
