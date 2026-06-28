import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/typography.dart';

/// AI Pilot 用 ThemeExtension（セマンティック TextStyle）。
@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.sectionTitle,
    required this.cardTitle,
    required this.captionLabel,
  });

  final TextStyle sectionTitle;
  final TextStyle cardTitle;
  final TextStyle captionLabel;

  factory AppTextStyles.fromTypography() {
    return const AppTextStyles(
      sectionTitle: AppTypography.titleMedium,
      cardTitle: AppTypography.titleMedium,
      captionLabel: AppTypography.labelMedium,
    );
  }

  @override
  AppTextStyles copyWith({
    TextStyle? sectionTitle,
    TextStyle? cardTitle,
    TextStyle? captionLabel,
  }) {
    return AppTextStyles(
      sectionTitle: sectionTitle ?? this.sectionTitle,
      cardTitle: cardTitle ?? this.cardTitle,
      captionLabel: captionLabel ?? this.captionLabel,
    );
  }

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) {
      return this;
    }
    return AppTextStyles(
      sectionTitle: TextStyle.lerp(sectionTitle, other.sectionTitle, t)!,
      cardTitle: TextStyle.lerp(cardTitle, other.cardTitle, t)!,
      captionLabel: TextStyle.lerp(captionLabel, other.captionLabel, t)!,
    );
  }
}

extension AppTextStylesX on ThemeData {
  AppTextStyles get appText =>
      extension<AppTextStyles>() ?? AppTextStyles.fromTypography();
}
