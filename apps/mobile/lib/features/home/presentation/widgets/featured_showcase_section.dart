import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_section_header.dart';
import 'package:ai_pilot/features/home/presentation/widgets/showcase_card.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_providers.dart';
import 'package:ai_pilot/shared/widgets/skeleton_card.dart';

/// おすすめ完成作品の横スクロールセクション。
class FeaturedShowcaseSection extends ConsumerWidget {
  const FeaturedShowcaseSection({super.key});

  static double listHeight(BuildContext context) => ShowcaseCard.cardHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showcasesAsync = ref.watch(featuredShowcasesProvider);

    return showcasesAsync.when(
      loading: () => const SkeletonShowcaseSection(),
      error: (_, _) => const SizedBox.shrink(),
      data: (showcases) {
        if (showcases.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeContentLayout.constrain(
              context: context,
              child: const HomeSectionHeader(
                title: '完成作品から選ぶ',
                trailing: '完成イメージから始める',
              ),
            ),
            SizedBox(
              height: listHeight(context),
              child: HomeContentLayout.constrain(
                context: context,
                padding: EdgeInsets.zero,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: HomeContentLayout.horizontalPadding(context),
                  itemCount: showcases.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.s12),
                  itemBuilder: (context, index) {
                    final showcase = showcases[index];
                    return ShowcaseCard(
                      showcase: showcase,
                      onTap: () =>
                          context.push('/workflows/${showcase.workflowId}'),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
          ],
        );
      },
    );
  }
}
