import 'package:flutter/material.dart';

import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/shared/widgets/hover_scale_surface.dart';

/// 「AI相談」誘導カードセクション。
class HomeAdvisorSection extends StatelessWidget {
  const HomeAdvisorSection({
    super.key,
    required this.onAdvisorTap,
  });

  final VoidCallback onAdvisorTap;

  @override
  Widget build(BuildContext context) {
    return HomeContentLayout.constrain(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HoverScaleSurface(
            padding: const EdgeInsets.all(AppSpacing.card),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '何を作ればいいか迷っていますか？',
                  style: AppTypography.titleMedium.copyWith(
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  '作りたいものを伝えるだけで、最適な Workflow を提案します。',
                  style: AppTypography.caption.copyWith(height: 1.5),
                ),
                const SizedBox(height: AppSpacing.s16),
                OutlinedButton.icon(
                  onPressed: onAdvisorTap,
                  icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                  label: const Text('AIに相談する'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: HomeContentLayout.sectionSpacing),
        ],
      ),
    );
  }
}
