import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_section_header.dart';
import 'package:ai_pilot/features/home/presentation/widgets/showcase_card.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_providers.dart';
import 'package:ai_pilot/shared/widgets/skeleton_card.dart';

/// 人気完成作品の横スクロールセクション。
class FeaturedShowcaseSection extends ConsumerWidget {
  const FeaturedShowcaseSection({super.key});

  static double get _listHeight => ShowcaseCard.listExtent;

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
                title: '人気の完成作品',
              ),
            ),
            SizedBox(
              height: _listHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: HomeContentLayout.horizontalPadding(context),
                scrollCacheExtent:
                    ScrollCacheExtent.pixels(ShowcaseCard.cardWidth * 2),
                itemCount: showcases.length,
                itemBuilder: (context, index) {
                  final showcase = showcases[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < showcases.length - 1 ? AppSpacing.s12 : 0,
                    ),
                    child: ShowcaseCard(
                      showcase: showcase,
                      onTap: () =>
                          context.push('/workflows/${showcase.workflowId}'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: HomeContentLayout.sectionSpacing),
          ],
        );
      },
    );
  }
}
