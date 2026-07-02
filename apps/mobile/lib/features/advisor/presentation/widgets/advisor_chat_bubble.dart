import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/advisor/presentation/models/advisor_chat_message.dart';

/// Assistant / User 吹き出し。
class AdvisorChatBubble extends StatelessWidget {
  const AdvisorChatBubble({
    super.key,
    required this.message,
  });

  final AdvisorChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isAssistant = message.role == AdvisorChatMessageRole.assistant;

    return Align(
      alignment: isAssistant ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isAssistant) ...[
              _Avatar(isAssistant: true),
              const SizedBox(width: AppSpacing.s8),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s12,
                  vertical: AppSpacing.s12,
                ),
                decoration: BoxDecoration(
                  color: isAssistant
                      ? AppColors.surfaceMuted
                      : AppColors.primarySoft,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(AppRadius.r16),
                    topRight: const Radius.circular(AppRadius.r16),
                    bottomLeft: Radius.circular(
                      isAssistant ? AppRadius.r8 : AppRadius.r16,
                    ),
                    bottomRight: Radius.circular(
                      isAssistant ? AppRadius.r16 : AppRadius.r8,
                    ),
                  ),
                  border: Border.all(
                    color: isAssistant
                        ? AppColors.border
                        : AppColors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  message.text,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.charcoal,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            if (!isAssistant) ...[
              const SizedBox(width: AppSpacing.s8),
              _Avatar(isAssistant: false),
            ],
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.isAssistant});

  final bool isAssistant;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isAssistant ? AppColors.primarySoft : AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: isAssistant
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.border,
        ),
      ),
      child: Icon(
        isAssistant ? Icons.auto_awesome_rounded : Icons.person_outline_rounded,
        size: 14,
        color: AppColors.primary,
      ),
    );
  }
}
