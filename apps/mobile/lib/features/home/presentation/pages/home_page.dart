import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
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
import 'package:ai_pilot/shared/widgets/empty_view.dart';
import 'package:ai_pilot/shared/widgets/error_view.dart';
import 'package:ai_pilot/shared/widgets/fade_slide_in.dart';
import 'package:ai_pilot/shared/widgets/skeleton_card.dart';
import 'package:ai_pilot/shared/widgets/skeleton_list_view.dart';

const _searchDebounceDuration = Duration(milliseconds: 400);
const _minSearchQueryLength = 2;

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
  String _debouncedSearchQuery = '';
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  bool get _isSearchActive => _debouncedSearchQuery.length >= _minSearchQueryLength;

  bool get _showBrowseSections =>
      !_isSearchActive &&
      _selectedCategoryId == null &&
      _selectedRecommendation == null;

  bool get _showAiRecommendations => !_isSearchActive;

  void _retry() {
    ref.invalidate(categoriesProvider);
    ref.invalidate(workflowsProvider);
    ref.invalidate(recommendationsProvider);
    if (_isSearchActive) {
      ref.invalidate(searchWorkflowsProvider(_debouncedSearchQuery));
    }
  }

  Future<void> _refresh() async {
    _retry();
    await Future.wait([
      ref.read(categoriesProvider.future),
      ref.read(workflowsProvider.future),
      ref.read(recommendationsProvider.future),
      if (_isSearchActive)
        ref.read(searchWorkflowsProvider(_debouncedSearchQuery).future),
    ]);
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      if (value.isNotEmpty) {
        _selectedRecommendation = null;
      }
    });

    _debounceTimer?.cancel();
    final trimmed = value.trim();
    if (trimmed.length < _minSearchQueryLength) {
      setState(() => _debouncedSearchQuery = '');
      return;
    }

    _debounceTimer = Timer(_searchDebounceDuration, () {
      if (!mounted) {
        return;
      }
      final current = _searchController.text.trim();
      if (current.length >= _minSearchQueryLength) {
        setState(() => _debouncedSearchQuery = current);
      }
    });
  }

  void _clearSearch() {
    _debounceTimer?.cancel();
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _debouncedSearchQuery = '';
    });
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
    if (_isSearchActive || _selectedCategoryId != null) {
      return '条件に合うワークフローがありません';
    }
    return 'ワークフローがありません';
  }

  String _listSectionTitle() {
    return _selectedRecommendation?.title ?? 'すべてのWorkflow';
  }

  ({
    List<Workflow> workflows,
    bool showSearchError,
    bool showInlineSearchLoading,
  }) _resolveWorkflowList({
    required AsyncValue<List<Workflow>> allWorkflowsAsync,
    required AsyncValue<List<Workflow>>? searchAsync,
  }) {
    if (!_isSearchActive) {
      return (
        workflows: allWorkflowsAsync.valueOrNull ?? const [],
        showSearchError: false,
        showInlineSearchLoading: false,
      );
    }

    final search = searchAsync!;
    if (search.hasValue) {
      return (
        workflows: search.value!,
        showSearchError: false,
        showInlineSearchLoading: false,
      );
    }

    if (search.hasError) {
      return (
        workflows: allWorkflowsAsync.valueOrNull ?? const [],
        showSearchError: true,
        showInlineSearchLoading: false,
      );
    }

    return (
      workflows: allWorkflowsAsync.valueOrNull ?? const [],
      showSearchError: false,
      showInlineSearchLoading: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final allWorkflowsAsync = ref.watch(workflowsProvider);
    final searchAsync = _isSearchActive
        ? ref.watch(searchWorkflowsProvider(_debouncedSearchQuery))
        : null;
    final allWorkflows =
        allWorkflowsAsync.valueOrNull ?? const <Workflow>[];
    final recommendedWorkflows = _recommendedWorkflows(allWorkflows);
    final resolved = _resolveWorkflowList(
      allWorkflowsAsync: allWorkflowsAsync,
      searchAsync: searchAsync,
    );
    final filteredWorkflows = _filterWorkflows(resolved.workflows);

    if (categoriesAsync.isLoading && !categoriesAsync.hasValue) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: _HomeLoadingSkeleton()),
      );
    }

    if (!categoriesAsync.hasValue && categoriesAsync.hasError) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ErrorView(
            message: 'カテゴリの読み込みに失敗しました',
            onRetry: _retry,
          ),
        ),
      );
    }

    if (!_isSearchActive &&
        allWorkflowsAsync.isLoading &&
        !allWorkflowsAsync.hasValue) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: _HomeLoadingSkeleton()),
      );
    }

    if (!_isSearchActive &&
        allWorkflowsAsync.hasError &&
        !allWorkflowsAsync.hasValue) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ErrorView(
            message: 'ワークフローの読み込みに失敗しました',
            onRetry: _retry,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _HomeBody(
          searchController: _searchController,
          searchQuery: _searchQuery,
          showAiRecommendations: _showAiRecommendations,
          showBrowseSections: _showBrowseSections,
          selectedRecommendation: _selectedRecommendation,
          recommendedWorkflows: recommendedWorkflows,
          workflows: filteredWorkflows,
          listSectionTitle: _listSectionTitle(),
          categories: categoriesAsync.value ?? const [],
          selectedCategoryId: _selectedCategoryId,
          emptyMessage: _emptyMessage(),
          showSearchError: resolved.showSearchError,
          showInlineSearchLoading: resolved.showInlineSearchLoading,
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
          onRefresh: _refresh,
          onRetry: _retry,
        ),
      ),
    );
  }
}

class _HomeLoadingSkeleton extends StatelessWidget {
  const _HomeLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.s32),
      children: const [
        SkeletonHomeHero(),
        SizedBox(height: AppSpacing.s16),
        SkeletonChipRow(),
        SizedBox(height: AppSpacing.s16),
        SkeletonListView(itemCount: 4),
      ],
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
    required this.showSearchError,
    required this.showInlineSearchLoading,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.onRecommendationSelected,
    required this.onCategorySelected,
    required this.onRefresh,
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
  final bool showSearchError;
  final bool showInlineSearchLoading;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final ValueChanged<Recommendation?> onRecommendationSelected;
  final ValueChanged<String?> onCategorySelected;
  final Future<void> Function() onRefresh;
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
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
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
        if (showSearchError)
          ErrorView(
            message: '検索に失敗しました',
            onRetry: onRetry,
          )
        else if (showInlineSearchLoading && workflows.isEmpty)
          const Padding(
            padding: AppSpacing.pageHorizontal,
            child: SkeletonListView(itemCount: 2, showSectionHeader: false),
          )
        else if (workflows.isEmpty)
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
              trailing: showInlineSearchLoading
                  ? '検索中...'
                  : '${workflows.length}件',
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
      ),
    );
  }
}
