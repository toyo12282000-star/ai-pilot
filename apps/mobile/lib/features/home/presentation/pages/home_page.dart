import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/favorite/presentation/providers/favorite_providers.dart';
import 'package:ai_pilot/features/home/presentation/widgets/ai_recommendation_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/category_chip_list.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_hero_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_section_header.dart';
import 'package:ai_pilot/features/home/presentation/widgets/recent_workflow_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/recommended_workflow_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/workflow_card.dart';
import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/category.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_run_history_providers.dart';
import 'package:ai_pilot/shared/widgets/empty_view.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/fade_slide_in.dart';
import 'package:ai_pilot/shared/widgets/loading_view.dart';

/// ホーム兼ワークフロー一覧画面。
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategoryId;
  Recommendation? _selectedRecommendation;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _trimmedSearchQuery => _searchQuery.trim();

  bool get _isSearching => _trimmedSearchQuery.isNotEmpty;

  bool get _showBrowseSections =>
      !_isSearching &&
      _selectedCategoryId == null &&
      _selectedRecommendation == null;

  bool get _showAiRecommendations => !_isSearching;

  void _retry() {
    ref.invalidate(categoriesProvider);
    ref.invalidate(workflowsProvider);
    ref.invalidate(recommendationsProvider);
    if (_isSearching) {
      ref.invalidate(searchWorkflowsProvider(_trimmedSearchQuery));
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      if (value.isNotEmpty) {
        _selectedRecommendation = null;
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  List<Workflow> _filterByCategory(List<Workflow> workflows) {
    if (_selectedCategoryId == null) {
      return workflows;
    }
    return workflows
        .where((workflow) => workflow.categoryId == _selectedCategoryId)
        .toList();
  }

  List<Workflow> _filterWorkflows(List<Workflow> workflows) {
    var result = _filterByCategory(workflows);

    final recommendation = _selectedRecommendation;
    if (recommendation != null) {
      final ids = recommendation.recommendedWorkflowIds.toSet();
      result = result.where((workflow) => ids.contains(workflow.id)).toList();
    }

    return result;
  }

  List<Workflow> _recommendedWorkflows(List<Workflow> allWorkflows) {
    return allWorkflows.take(3).toList();
  }

  String _emptyMessage() {
    if (_selectedRecommendation != null) {
      return 'この目的に合うワークフローがありません';
    }
    if (_isSearching || _selectedCategoryId != null) {
      return '条件に合うワークフローがありません';
    }
    return 'ワークフローがありません';
  }

  String _listSectionTitle() {
    return _selectedRecommendation?.title ?? 'すべてのWorkflow';
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(recentWorkflowHistoriesProvider(mockCurrentUserId));
    final workflowsAsync = _isSearching
        ? ref.watch(searchWorkflowsProvider(_trimmedSearchQuery))
        : ref.watch(workflowsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final allWorkflows =
        ref.watch(workflowsProvider).valueOrNull ?? const <Workflow>[];
    final recommendedWorkflows = _recommendedWorkflows(allWorkflows);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: workflowsAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            message: _isSearching
                ? '検索に失敗しました'
                : 'ワークフローの読み込みに失敗しました',
            onRetry: _retry,
          ),
          data: (workflows) => categoriesAsync.when(
            loading: () => const LoadingView(),
            error: (_, _) => ErrorView(
              message: 'カテゴリの読み込みに失敗しました',
              onRetry: _retry,
            ),
            data: (categories) => _HomeBody(
              searchController: _searchController,
              searchQuery: _searchQuery,
              showAiRecommendations: _showAiRecommendations,
              showBrowseSections: _showBrowseSections,
              selectedRecommendation: _selectedRecommendation,
              recommendedWorkflows: recommendedWorkflows,
              workflows: _filterWorkflows(workflows),
              listSectionTitle: _listSectionTitle(),
              categories: categories,
              selectedCategoryId: _selectedCategoryId,
              emptyMessage: _emptyMessage(),
              onSearchChanged: _onSearchChanged,
              onSearchClear: _clearSearch,
              onRecommendationSelected: (recommendation) {
                setState(() {
                  _selectedRecommendation = recommendation;
                  _selectedCategoryId = null;
                });
              },
              onCategorySelected: (categoryId) {
                setState(() {
                  _selectedCategoryId = categoryId;
                  _selectedRecommendation = null;
                });
              },
              onRetry: _retry,
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.searchController,
    required this.searchQuery,
    required this.showAiRecommendations,
    required this.showBrowseSections,
    required this.selectedRecommendation,
    required this.recommendedWorkflows,
    required this.workflows,
    required this.listSectionTitle,
    required this.categories,
    required this.selectedCategoryId,
    required this.emptyMessage,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.onRecommendationSelected,
    required this.onCategorySelected,
    required this.onRetry,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final bool showAiRecommendations;
  final bool showBrowseSections;
  final Recommendation? selectedRecommendation;
  final List<Workflow> recommendedWorkflows;
  final List<Workflow> workflows;
  final String listSectionTitle;
  final List<Category> categories;
  final String? selectedCategoryId;
  final String emptyMessage;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final ValueChanged<Recommendation?> onRecommendationSelected;
  final ValueChanged<String?> onCategorySelected;
  final VoidCallback onRetry;

  int get _categorySectionIndex {
    var index = 1;
    if (showAiRecommendations) {
      index++;
    }
    if (showBrowseSections) {
      index += 2;
    }
    return index;
  }

  int get _listSectionIndex => _categorySectionIndex + 1;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.s32),
      children: [
        FadeSlideIn(
          index: 0,
          child: HomeHeroSection(
            searchController: searchController,
            onSearchChanged: onSearchChanged,
            onSearchClear: onSearchClear,
            showClearButton: searchQuery.isNotEmpty,
          ),
        ),
        if (showAiRecommendations)
          FadeSlideIn(
            index: 1,
            child: AiRecommendationSection(
              selectedRecommendationId: selectedRecommendation?.id,
              onRecommendationSelected: onRecommendationSelected,
            ),
          ),
        if (showBrowseSections)
          FadeSlideIn(
            index: showAiRecommendations ? 2 : 1,
            child: RecommendedWorkflowSection(workflows: recommendedWorkflows),
          ),
        if (showBrowseSections)
          FadeSlideIn(
            index: showAiRecommendations ? 3 : 2,
            child: const RecentWorkflowSection(),
          ),
        FadeSlideIn(
          index: _categorySectionIndex,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategoryChipList(
                categories: categories,
                selectedCategoryId: selectedCategoryId,
                onSelected: onCategorySelected,
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
        if (workflows.isEmpty)
          EmptyView(
            message: emptyMessage,
            actionLabel: '再読み込み',
            onAction: onRetry,
          )
        else ...[
          FadeSlideIn(
            index: _listSectionIndex,
            child: HomeSectionHeader(
              title: listSectionTitle,
              trailing: '${workflows.length}件',
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          for (var index = 0; index < workflows.length; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.s16),
            Padding(
              padding: AppSpacing.pageHorizontal,
              child: FadeSlideIn(
                index: _listSectionIndex + index + 1,
                child: WorkflowCard(
                  workflow: workflows[index],
                  onTap: () =>
                      context.push('/workflows/${workflows[index].id}'),
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
