import 'package:flutter/material.dart';

import 'package:ai_pilot/app/app_text_styles.dart';
import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/icons.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// AI Pilot アプリテーマ。
final ThemeData appTheme = _buildAppTheme();

ThemeData _buildAppTheme() {
  final colorScheme = AppColors.colorScheme;
  final textTheme = AppTypography.textTheme;

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: textTheme,
    extensions: [AppTextStyles.fromTypography()],
    splashFactory: InkRipple.splashFactory,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppTypography.titleLarge,
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      height: 72,
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primarySoft,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.labelLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          );
        }
        return AppTypography.labelMedium;
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: AppColors.primary,
            size: AppIcons.sizeLg,
          );
        }
        return const IconThemeData(
          color: AppColors.textSecondary,
          size: AppIcons.sizeLg,
        );
      }),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        minimumSize: const Size(64, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.pill),
        textStyle: AppTypography.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.surface,
        ),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        minimumSize: const Size(64, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.pill),
        side: const BorderSide(color: AppColors.border),
        textStyle: AppTypography.labelLarge.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.labelLarge,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceMuted,
      selectedColor: AppColors.primarySoft,
      labelStyle: AppTypography.labelMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      secondaryLabelStyle: AppTypography.labelMedium,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.pill),
      side: const BorderSide(color: AppColors.border),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
    ),
    searchBarTheme: SearchBarThemeData(
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(AppColors.surface),
      side: WidgetStatePropertyAll(
        BorderSide(color: AppColors.border),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.pill),
      ),
      textStyle: WidgetStatePropertyAll(AppTypography.bodyMedium),
      hintStyle: WidgetStatePropertyAll(
        AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.darkNavy,
      contentTextStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.surface,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: AppIcons.sizeMd,
    ),
  );
}
