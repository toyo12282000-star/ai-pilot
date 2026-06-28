import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/home/presentation/widgets/category_chip_list.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_hero_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/home_section_header.dart';
import 'package:ai_pilot/features/home/presentation/widgets/recommended_workflow_section.dart';
import 'package:ai_pilot/features/home/presentation/widgets/workflow_card.dart';
import 'package:ai_pilot/features/workflow/domain/entities/category.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
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
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _trimmedSearchQuery => _searchQuery.trim();

  bool get _isSearching => _trimmedSearchQuery.isNotEmpty;

  bool get _showRecommended =>
      !_isSearching && _selectedCategoryId == null;

  void _retry() {
    ref.invalidate(categoriesProvider);
    ref.invalidate(workflowsProvider);
    if (_isSearching) {
      ref.invalidate(searchWorkflowsProvider(_trimmedSearchQuery));
    }
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
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

  List<Workflow> _recommendedWorkflows(List<Workflow> allWorkflows) {
    return allWorkflows.take(3).toList();
  }

  String _emptyMessage() {
    if (_isSearching || _selectedCategoryId != null) {
      return '条件に合うワークフローがありません';
    }
    return 'ワークフローがありません';
  }

  @override
  Widget build(BuildContext context) {
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
              showRecommended: _showRecommended,
              recommendedWorkflows: recommendedWorkflows,
              workflows: _filterByCategory(workflows),
              categories: categories,
              selectedCategoryId: _selectedCategoryId,
              emptyMessage: _emptyMessage(),
              onSearchChanged: _onSearchChanged,
              onSearchClear: _clearSearch,
              onCategorySelected: (categoryId) {
                setState(() => _selectedCategoryId = categoryId);
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
    required this.showRecommended,
    required this.recommendedWorkflows,
    required this.workflows,
    required this.categories,
    required this.selectedCategoryId,
    required this.emptyMessage,
    required this.onSearchChanged,
    required this.onSearchClear,
    required this.onCategorySelected,
    required this.onRetry,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final bool showRecommended;
  final List<Workflow> recommendedWorkflows;
  final List<Workflow> workflows;
  final List<Category> categories;
  final String? selectedCategoryId;
  final String emptyMessage;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final ValueChanged<String?> onCategorySelected;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        if (showRecommended)
          FadeSlideIn(
            index: 1,
            child: RecommendedWorkflowSection(workflows: recommendedWorkflows),
          ),
        FadeSlideIn(
          index: showRecommended ? 2 : 1,
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
        Expanded(
          child: workflows.isEmpty
              ? EmptyView(
                  message: emptyMessage,
                  actionLabel: '再読み込み',
                  onAction: onRetry,
                )
              : FadeSlideIn(
                  index: showRecommended ? 3 : 2,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s16,
                      0,
                      AppSpacing.s16,
                      AppSpacing.s32,
                    ),
                    itemCount: workflows.length + 1,
                    separatorBuilder: (context, index) {
                      if (index == 0) {
                        return const SizedBox(height: AppSpacing.s4);
                      }
                      return const SizedBox(height: AppSpacing.s16);
                    },
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return HomeSectionHeader(
                          title: 'すべてのWorkflow',
                          trailing: '${workflows.length}件',
                        );
                      }
                      final workflow = workflows[index - 1];
                      return WorkflowCard(
                        workflow: workflow,
                        onTap: () => context.push('/workflows/${workflow.id}'),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
