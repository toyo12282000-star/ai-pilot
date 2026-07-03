import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/profile/presentation/widgets/profile_document_page.dart';
import 'package:ai_pilot/shared/config/beta_config.dart';
import 'package:ai_pilot/shared/widgets/meta_badge.dart';

/// AI Pilot β版の案内とフィードバック導線。
class BetaFeedbackPage extends StatelessWidget {
  const BetaFeedbackPage({super.key});

  static const _sections = [
    ProfileDocumentSection(
      heading: 'AI Pilot β版について',
      paragraphs: [
        'AI Pilot は、作りたい成果物から AI 活用手順を案内するアプリです。',
        '現在は β版として、完成作品の閲覧、AI Advisor、Workflow 実行などの'
        'コア体験をお試しいただいています。',
      ],
    ),
    ProfileDocumentSection(
      heading: 'できること',
      paragraphs: [
        '完成作品（Showcase）の閲覧、AI への相談と Workflow 提案、'
        'ステップごとの Run 体験、お気に入り保存（ログイン時）など。',
      ],
    ),
    ProfileDocumentSection(
      heading: 'まだ未実装・改善中',
      paragraphs: [
        '有料プラン、チーム利用、Workflow の自作・公開、'
        '通知機能などは今後追加予定です。',
      ],
    ),
    ProfileDocumentSection(
      heading: '利用上の注意',
      paragraphs: [
        'β版のため、表示内容や機能は予告なく変更される場合があります。',
        '重要なデータはバックアップを取ってからご利用ください。',
      ],
    ),
  ];

  Future<void> _launchUri(BuildContext context, Uri uri) async {
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('メールアプリを開けませんでした')),
      );
    }
  }

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
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primarySoft,
                    AppColors.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.s16),
                border: Border.all(color: AppColors.outline),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'β版フィードバック',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    const MetaBadge(
                      icon: Icons.info_outline,
                      label: 'MVP Preview',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            for (var index = 0; index < _sections.length; index++) ...[
              if (index > 0) const SizedBox(height: AppSpacing.s24),
              _SectionBlock(section: _sections[index]),
            ],
            const SizedBox(height: AppSpacing.s24),
            _FeedbackActionCard(
              icon: Icons.bug_report_outlined,
              title: '不具合・改善要望を送る',
              subtitle: '使いにくかった点やバグを教えてください',
              onTap: () => _launchUri(context, BetaConfig.feedbackUri),
            ),
            const SizedBox(height: AppSpacing.s12),
            _FeedbackActionCard(
              icon: Icons.lightbulb_outline_rounded,
              title: '欲しい Workflow をリクエスト',
              subtitle: '作りたい成果物や業界のニーズを送れます',
              onTap: () => _launchUri(context, BetaConfig.workflowRequestUri),
            ),
            const SizedBox(height: AppSpacing.s12),
            _FeedbackActionCard(
              icon: Icons.rate_review_outlined,
              title: 'β版の感想を送る',
              subtitle: '良かった点もぜひ教えてください',
              onTap: () => _launchUri(
                context,
                BetaConfig.mailtoFeedback(
                  subject: 'AI Pilot β版の感想',
                  bodyPrefix: 'β版を使ってみた感想:\n',
                ),
              ),
            ),
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

class _FeedbackActionCard extends StatelessWidget {
  const _FeedbackActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.large,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.large,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadius.large,
            border: Border.all(color: AppColors.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 22),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.open_in_new_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
