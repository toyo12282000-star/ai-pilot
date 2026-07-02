import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/home/presentation/providers/home_providers.dart';
import 'package:ai_pilot/features/home/presentation/widgets/ai_recommendation_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/featured_showcase_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_advisor_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_category_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_content_layout.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_hero_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_section_header.dart';
import 'package:ai_pilot/features/home/presentation/widgets/favorite_workflow_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/recent_workflow_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/workflow_card.dart';
import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_providers.dart';
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

  bool get _showDiscoverySections =>
      !_isSearchActive &&
      _selectedCategoryId == null &&
      _selectedRecommendation == null;

  bool get _showCategorySection => !_isSearchActive;

  bool get _showRecommendations => !_isSearchActive;

  void _retry() {
    ref.invalidate(categoriesProvider);
    ref.invalidate(workflowsProvider);
    ref.invalidate(recommendationsProvider);
    ref.invalidate(featuredShowcasesProvider);
    invalidateHomeDashboard(ref);
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
      ref.read(featuredShowcasesProvider.future),
      if (_showDiscoverySections &&
          _selectedCategoryId == null &&
          _selectedRecommendation == null &&
          !_isSearchActive)
        ref.read(popularHomeWorkflowsProvider.future),
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

  String _emptyMessage() {
    if (_selectedRecommendation != null) {
      return 'この目的に合うワークフローがありません';
    }
    if (_isSearchActive || _selectedCategoryId != null) {
      return '条件に合うワークフローがありません';
    }
    return 'ワークフローがありません';
  }

  bool get _showEmptyReload {
    return _selectedRecommendation == null &&
        !_isSearchActive &&
        _selectedCategoryId == null;
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
    required AsyncValue<List<Workflow>>? popularWorkflowsAsync,
    required AsyncValue<List<Workflow>>? searchAsync,
  }) {
    if (!_isSearchActive) {
      final source = _usePopularWorkflowOrder && popularWorkflowsAsync != null
          ? popularWorkflowsAsync
          : allWorkflowsAsync;
      return (
        workflows: source.valueOrNull ?? allWorkflowsAsync.valueOrNull ?? const [],
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

  bool get _usePopularWorkflowOrder =>
      !_isSearchActive &&
      _selectedCategoryId == null &&
      _selectedRecommendation == null;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final allWorkflowsAsync = ref.watch(workflowsProvider);
    final popularWorkflowsAsync =
        _usePopularWorkflowOrder ? ref.watch(popularHomeWorkflowsProvider) : null;
    final searchAsync = _isSearchActive
        ? ref.watch(searchWorkflowsProvider(_debouncedSearchQuery))
        : null;
    final resolved = _resolveWorkflowList(
      allWorkflowsAsync: allWorkflowsAsync,
      popularWorkflowsAsync: popularWorkflowsAsync,
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
            title: 'カテゴリの読み込みに失敗しました',
            description: '通信状況を確認して、もう一度お試しください',
            onRetry: _retry,
            debugDetails: categoriesAsync.error,
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
            title: 'ワークフローの読み込みに失敗しました',
            description: '通信状況を確認して、もう一度お試しください',
            onRetry: _retry,
            debugDetails: allWorkflowsAsync.error,
          ),
        ),
      );
    }

    if (!_isSearchActive &&
        _usePopularWorkflowOrder &&
        popularWorkflowsAsync != null &&
        popularWorkflowsAsync.isLoading &&
        !popularWorkflowsAsync.hasValue &&
        allWorkflowsAsync.hasValue) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: _HomeLoadingSkeleton()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _HomeBody(
          searchController: _searchController,
          searchQuery: _searchQuery,
          showRecommendations: _showRecommendations,
          showDiscoverySections: _showDiscoverySections,
          showCategorySection: _showCategorySection,
          selectedRecommendation: _selectedRecommendation,
          workflows: filteredWorkflows,
          listSectionTitle: _listSectionTitle(),
          selectedCategoryId: _selectedCategoryId,
          emptyMessage: _emptyMessage(),
          showEmptyReload: _showEmptyReload,
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
          onAdvisorTap: () => context.push('/advisor'),
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
        SkeletonShowcaseSection(),
        SkeletonHomeCategorySection(),
        SkeletonHomeAdvisorSection(),
        SizedBox(height: AppSpacing.s32),
        SkeletonHomeRecommendationSection(),
        SkeletonHomeWorkflowSection(),
      ],
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.searchController,
    required this.searchQuery,
    required this.showRecommendations,
    required this.showDiscoverySections,
    required this.showCategorySection,
    required this.selectedRecommendation,
    required this.workflows,
    required this.listSectionTitle,
    required this.selectedCategoryId,
    required this.emptyMessage,
    required this.showEmptyReload,
    required this.showSearchError,
    required this.showInlineSearchLoading,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.onRecommendationSelected,
    required this.onCategorySelected,
    required this.onRefresh,
    required this.onRetry,
    required this.onAdvisorTap,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final bool showRecommendations;
  final bool showDiscoverySections;
  final bool showCategorySection;
  final Recommendation? selectedRecommendation;
  final List<Workflow> workflows;
  final String listSectionTitle;
  final String? selectedCategoryId;
  final String emptyMessage;
  final bool showEmptyReload;
  final bool showSearchError;
  final bool showInlineSearchLoading;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final ValueChanged<Recommendation?> onRecommendationSelected;
  final ValueChanged<String?> onCategorySelected;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final VoidCallback onAdvisorTap;

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
              onAdvisorTap: onAdvisorTap,
            ),
          ),
          if (showDiscoverySections)
            const FadeSlideIn(
              index: 1,
              child: FeaturedShowcaseSection(),
            ),
          if (showCategorySection)
            FadeSlideIn(
              index: showDiscoverySections ? 2 : 1,
              child: HomeCategorySection(
                selectedCategoryId: selectedCategoryId,
                onCategorySelected: onCategorySelected,
              ),
            ),
          if (showDiscoverySections)
            FadeSlideIn(
              index: 3,
              child: HomeAdvisorSection(onAdvisorTap: onAdvisorTap),
            ),
          if (showRecommendations)
            FadeSlideIn(
              index: showDiscoverySections ? 4 : 2,
              child: AiRecommendationSection(
                selectedRecommendationId: selectedRecommendation?.id,
                onRecommendationSelected: onRecommendationSelected,
              ),
            ),
          if (showDiscoverySections)
            const FadeSlideIn(
              index: 5,
              child: RecentWorkflowSection(),
            ),
          if (showDiscoverySections)
            const FadeSlideIn(
              index: 6,
              child: FavoriteWorkflowSection(),
            ),
          if (showSearchError)
            HomeContentLayout.constrain(
              context: context,
              child: ErrorView(
                title: '検索に失敗しました',
                description: '通信状況を確認して、もう一度お試しください',
                onRetry: onRetry,
              ),
            )
          else if (showInlineSearchLoading && workflows.isEmpty)
            HomeContentLayout.constrain(
              context: context,
              child: const SkeletonListView(itemCount: 2, showSectionHeader: false),
            )
          else if (workflows.isEmpty)
            HomeContentLayout.constrain(
              context: context,
              child: EmptyView(
                message: emptyMessage,
                actionLabel: showEmptyReload ? '再読み込み' : null,
                onAction: showEmptyReload ? onRetry : null,
              ),
            )
          else ...[
            FadeSlideIn(
              index: showDiscoverySections ? 7 : 3,
              child: HomeContentLayout.constrain(
                context: context,
                child: HomeSectionHeader(
                  title: listSectionTitle,
                  trailing: showInlineSearchLoading
                      ? '検索中...'
                      : '${workflows.length}件',
                ),
              ),
            ),
            HomeContentLayout.constrain(
              context: context,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final twoColumns =
                      constraints.maxWidth >= HomeContentLayout.tabletBreakpoint;
                  final cardWidth = twoColumns
                      ? (constraints.maxWidth - AppSpacing.s12) / 2
                      : constraints.maxWidth;

                  return Wrap(
                    spacing: AppSpacing.s12,
                    runSpacing: AppSpacing.s12,
                    children: [
                      for (var index = 0; index < workflows.length; index++)
                        SizedBox(
                          width: cardWidth,
                          child: FadeSlideIn(
                            index: (showDiscoverySections ? 8 : 4) + index,
                            child: WorkflowCard(
                              workflow: workflows[index],
                              onTap: () => context.push(
                                '/workflows/${workflows[index].id}',
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
