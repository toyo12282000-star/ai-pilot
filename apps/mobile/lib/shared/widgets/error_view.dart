import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/shared/widgets/state_icon.dart';

/// エラー発生時の共通表示。
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.title,
    this.description,
    this.onRetry,
    this.debugDetails,
  });

  final String title;
  final String? description;
  final VoidCallback? onRetry;

  /// 開発ビルドのみ折りたたみで表示する詳細情報。
  final Object? debugDetails;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final details = debugDetails?.toString();

    return Center(
      child: Padding(
        padding: AppSpacing.page,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            StateIcon(
              icon: Icons.error_outline_rounded,
              color: colorScheme.error,
              backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.35),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.titleMedium,
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.s8),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.s24),
              FilledButton.tonal(
                onPressed: onRetry,
                child: const Text('再試行'),
              ),
            ],
            if (kDebugMode && details != null && details.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s16),
              _DebugDetailsPanel(details: details),
            ],
          ],
        ),
      ),
    );
  }
}

class _DebugDetailsPanel extends StatelessWidget {
  const _DebugDetailsPanel({required this.details});

  final String details;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(bottom: AppSpacing.s8),
          title: Text(
            '詳細（開発中のみ）',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SelectableText(
                details,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
