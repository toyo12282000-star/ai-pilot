import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_suggestion.dart';
import 'package:ai_pilot/features/advisor/presentation/providers/advisor_history_providers.dart';
import 'package:ai_pilot/features/advisor/presentation/providers/advisor_providers.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_empty_section.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_hero_section.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_input_section.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_loading_section.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_recent_history_section.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_suggestion_card.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';
import 'package:ai_pilot/shared/widgets/fade_slide_in.dart';

/// 提案中の最低表示時間（体験用・短め）。
const _minimumSuggestDuration = Duration(milliseconds: 450);

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
      _suggestions = null;
    });

    try {
      final minimumDelay = Future<void>.delayed(_minimumSuggestDuration);

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
          minimumDelay,
        ]);
      } else {
        await minimumDelay;
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

      await _saveHistoryIfAuthenticated(query, suggestions);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _saveHistoryIfAuthenticated(
    String query,
    List<AdvisorSuggestion> suggestions,
  ) async {
    if (!ref.read(isAuthenticatedProvider)) {
      return;
    }

    final userId = ref.read(authenticatedUserIdProvider);
    if (userId == null) {
      return;
    }

    try {
      await ref.read(advisorHistoryRepositoryProvider).addHistory(
            userId,
            query,
            suggestions.map((item) => item.workflow.id).toList(),
          );
      invalidateAdvisorHistories(ref, userId);
    } catch (_) {
      // 履歴保存失敗は提案結果表示を妨げない。
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
            FadeSlideIn(
              index: 2,
              child: AdvisorRecentHistorySection(
                queryController: _queryController,
                onHistorySelected: (query) {
                  _queryController.text = query;
                  _submit();
                },
                isLoading: _isSubmitting,
              ),
            ),
            if (_hasSubmitted && _isSubmitting)
              const FadeSlideIn(
                index: 3,
                child: AdvisorLoadingSection(),
              ),
            if (_hasSubmitted && !_isSubmitting && _suggestions != null) ...[
              if (_suggestions!.isEmpty)
                FadeSlideIn(
                  index: 3,
                  child: AdvisorEmptySection(
                    controller: _queryController,
                    isLoading: _isSubmitting,
                    onExampleSelected: (_) {},
                  ),
                )
              else ...[
                FadeSlideIn(
                  index: 3,
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
                for (var index = 0; index < _suggestions!.length; index++)
                  FadeSlideIn(
                    index: 4 + index,
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
                          context.push(
                            '/workflows/${_suggestions![index].workflow.id}',
                          );
                        },
                        onStartWorkflow: () {
                          context.push(
                            '/workflows/${_suggestions![index].workflow.id}/run',
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
