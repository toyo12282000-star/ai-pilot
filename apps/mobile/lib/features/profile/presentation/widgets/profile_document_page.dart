import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/shared/widgets/hero_gradient_card.dart';
import 'package:ai_pilot/shared/widgets/meta_badge.dart';

/// プロフィール系ドキュメントページのセクション。
class ProfileDocumentSection {
  const ProfileDocumentSection({
    this.heading,
    required this.paragraphs,
  });

  final String? heading;
  final List<String> paragraphs;
}

/// 透明 AppBar + Hero + 本文セクションの共通レイアウト。
class ProfileDocumentPage extends StatelessWidget {
  const ProfileDocumentPage({
    super.key,
    required this.title,
    required this.sections,
    this.showPreviewBadge = false,
  });

  final String title;
  final List<ProfileDocumentSection> sections;
  final bool showPreviewBadge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s16,
          kToolbarHeight + AppSpacing.s8,
          AppSpacing.s16,
          AppSpacing.s32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeroGradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (showPreviewBadge) ...[
                    const SizedBox(height: AppSpacing.s16),
                    const MetaBadge(
                      icon: Icons.info_outline,
                      label: 'MVP Preview',
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            for (var index = 0; index < sections.length; index++) ...[
              if (index > 0) const SizedBox(height: AppSpacing.s24),
              _SectionBlock(section: sections[index]),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({required this.section});

  final ProfileDocumentSection section;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (section.heading != null) ...[
              Text(
                section.heading!,
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppSpacing.s12),
            ],
            for (var index = 0; index < section.paragraphs.length; index++) ...[
              if (index > 0) const SizedBox(height: AppSpacing.s12),
              Text(
                section.paragraphs[index],
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
