import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';

/// ゲストユーザー向けのログイン案内 BottomSheet。
Future<void> showLoginPromptSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.s16)),
    ),
    builder: (context) {
      final bottomPadding = MediaQuery.paddingOf(context).bottom;

      return Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.s24,
          0,
          AppSpacing.s24,
          AppSpacing.s24 + bottomPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '保存するにはログインが必要です',
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              'ログインすると、お気に入りや実行履歴を複数端末で同期できます',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/login');
              },
              child: const Text('ログインする'),
            ),
            const SizedBox(height: AppSpacing.s8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('あとで'),
            ),
          ],
        ),
      );
    },
  );
}
