import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/favorite/presentation/providers/favorite_providers.dart';
import 'package:ai_pilot/features/favorite/presentation/widgets/favorites_hero_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/workflow_card.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/fade_slide_in.dart';
import 'package:ai_pilot/shared/widgets/login_required_view.dart';
import 'package:ai_pilot/shared/widgets/rich_empty_view.dart';
import 'package:ai_pilot/shared/widgets/skeleton_card.dart';
import 'package:ai_pilot/shared/widgets/skeleton_list_view.dart';

/// お気に入りワークフロー一覧画面。
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  void _retry(WidgetRef ref) {
    invalidateFavorites(ref);
  }

  Future<void> _refresh(WidgetRef ref) async {
    invalidateFavorites(ref);
    await ref.read(favoriteWorkflowsProvider.future);
  }

  Widget _buildGuestPrompt() {
    return const LoginRequiredView();
  }

  Widget _buildLoadingSkeleton() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        SkeletonFavoritesHero(),
        SkeletonListView(itemCount: 3),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<Workflow> workflows,
  ) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => _refresh(ref),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: FadeSlideIn(
              index: 0,
              child: FavoritesHeroSection(count: workflows.length),
            ),
          ),
          if (workflows.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: RichEmptyView(
                icon: Icons.favorite_border,
                title: 'お気に入りはまだありません',
                subtitle: '気になるWorkflowを保存すると、ここからすぐに開けます',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s16,
                AppSpacing.s8,
                AppSpacing.s16,
                AppSpacing.s32,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '保存一覧',
                                style: AppTypography.titleMedium,
                              ),
                            ),
                            Text(
                              '${workflows.length}件',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final workflow = workflows[index - 1];
                    return Padding(
                      padding: EdgeInsets.only(
                        top: index == 1 ? 0 : AppSpacing.s16,
                      ),
                      child: FadeSlideIn(
                        index: index,
                        child: WorkflowCard(
                          workflow: workflow,
                          onTap: () =>
                              context.push('/workflows/${workflow.id}'),
                        ),
                      ),
                    );
                  },
                  childCount: workflows.length + 1,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    if (!isAuthenticated) {
      return SafeArea(child: _buildGuestPrompt());
    }

    final favoriteWorkflowsAsync = ref.watch(favoriteWorkflowsProvider);

    return SafeArea(
      child: favoriteWorkflowsAsync.when(
        loading: () => _buildLoadingSkeleton(),
        error: (error, _) => ErrorView(
          title: 'お気に入りの読み込みに失敗しました',
          description: '保存したWorkflowを取得できませんでした',
          onRetry: () => _retry(ref),
          debugDetails: error,
        ),
        data: (workflows) => _buildContent(context, ref, workflows),
      ),
    );
  }
}
