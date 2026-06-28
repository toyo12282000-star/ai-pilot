import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_suggestion.dart';
import 'package:ai_pilot/features/advisor/presentation/providers/advisor_providers.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_hero_section.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_input_section.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_suggestion_card.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/shared/widgets/empty_view.dart';
import 'package:ai_pilot/shared/widgets/fade_slide_in.dart';

/// AI Advisor 画面（MVP: ルールベース推薦）。
class AdvisorPage extends ConsumerStatefulWidget {
  const AdvisorPage({super.key});

  @override
  ConsumerState<AdvisorPage> createState() => _AdvisorPageState();
}

class _AdvisorPageState extends ConsumerState<AdvisorPage> {
  final _queryController = TextEditingController();
  bool _isSubmitting = false;
  List<AdvisorSuggestion>? _suggestions;
  bool _hasSubmitted = false;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final query = _queryController.text.trim();
    if (query.isEmpty || _isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _hasSubmitted = true;
    });

    try {
      final workflowsAsync = ref.read(workflowsProvider);
      final recommendationsAsync = ref.read(recommendationsProvider);
      final categoriesAsync = ref.read(categoriesProvider);

      final workflows = workflowsAsync.valueOrNull;
      final recommendations = recommendationsAsync.valueOrNull;
      final categories = categoriesAsync.valueOrNull;

      if (workflows == null || recommendations == null || categories == null) {
        await Future.wait([
          if (workflows == null) ref.read(workflowsProvider.future),
          if (recommendations == null)
            ref.read(recommendationsProvider.future),
          if (categories == null) ref.read(categoriesProvider.future),
        ]);
      }

      final resolvedWorkflows = ref.read(workflowsProvider).valueOrNull ?? [];
      final resolvedRecommendations =
          ref.read(recommendationsProvider).valueOrNull ?? [];
      final resolvedCategories = ref.read(categoriesProvider).valueOrNull ?? [];

      final service = ref.read(workflowAdvisorServiceProvider);
      final suggestions = service.suggest(
        query: query,
        workflows: resolvedWorkflows,
        recommendations: resolvedRecommendations,
        categories: resolvedCategories,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _suggestions = suggestions;
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AIに相談する'),
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.s32),
          children: [
            const FadeSlideIn(
              index: 0,
              child: AdvisorHeroSection(),
            ),
            FadeSlideIn(
              index: 1,
              child: Padding(
                padding: AppSpacing.pageHorizontal,
                child: AdvisorInputSection(
                  controller: _queryController,
                  onSubmit: _submit,
                  isLoading: _isSubmitting,
                ),
              ),
            ),
            if (_hasSubmitted && !_isSubmitting) ...[
              FadeSlideIn(
                index: 2,
                child: Padding(
                  padding: AppSpacing.pageHorizontal.copyWith(
                    top: AppSpacing.s8,
                  ),
                  child: Text(
                    'おすすめWorkflow',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (_suggestions == null)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.s24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_suggestions!.isEmpty)
                FadeSlideIn(
                  index: 3,
                  child: Padding(
                    padding: AppSpacing.pageHorizontal,
                    child: EmptyView(
                      message: '条件に合うWorkflowが見つかりませんでした\n別の言い方で試してください',
                    ),
                  ),
                )
              else
                for (var index = 0; index < _suggestions!.length; index++)
                  FadeSlideIn(
                    index: 3 + index,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.s16,
                        AppSpacing.s12,
                        AppSpacing.s16,
                        0,
                      ),
                      child: AdvisorSuggestionCard(
                        suggestion: _suggestions![index],
                        rank: index + 1,
                        onOpenWorkflow: () {
                          context.push('/workflows/${_suggestions![index].workflow.id}');
                        },
                        onStartWorkflow: () {
                          context.push('/workflows/${_suggestions![index].workflow.id}/run');
                        },
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}
