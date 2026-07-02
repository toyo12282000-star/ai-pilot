import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_session_save_input.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_suggestion.dart';
import 'package:ai_pilot/features/advisor/presentation/controllers/advisor_chat_controller.dart';
import 'package:ai_pilot/features/advisor/presentation/providers/advisor_history_providers.dart';
import 'package:ai_pilot/features/advisor/presentation/providers/advisor_providers.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_chat_header.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_chat_input_bar.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_chat_timeline.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_recent_history_section.dart';
import 'package:ai_pilot/features/advisor/presentation/widgets/advisor_typing_indicator.dart';
import 'package:ai_pilot/features/recommendation/presentation/providers/recommendation_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/workflow_providers.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';

/// 提案中の最低表示時間（Typing 体験用）。
const _minimumSuggestDuration = Duration(milliseconds: 550);

/// AI Advisor v1 — 会話形式の相談体験。
class AdvisorPage extends ConsumerStatefulWidget {
  const AdvisorPage({super.key});

  @override
  ConsumerState<AdvisorPage> createState() => _AdvisorPageState();
}

class _AdvisorPageState extends ConsumerState<AdvisorPage> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  final _chat = AdvisorChatController();
  bool _showAllSuggestions = false;

  @override
  void initState() {
    super.initState();
    _chat.initialize();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  void _notifyChange() {
    if (mounted) {
      setState(_scrollToBottom);
    }
  }

  Future<void> _fetchSuggestions(String query) async {
    if (query.isEmpty) {
      return;
    }

    _chat.setSubmitting(true);
    _notifyChange();

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
      final resolvedCategories = ref.read(categoriesProvider).valueOrNull ?? [];

      final service = ref.read(advisorServiceProvider);
      final suggestions = await service.suggest(
        query: query,
        workflows: resolvedWorkflows,
        categories: resolvedCategories,
      );

      if (!mounted) {
        return;
      }

      _chat.setSuggestions(suggestions);
      _showAllSuggestions = false;

      if (suggestions.isEmpty) {
        _chat.showEmptyResultRetry();
      } else {
        await _saveHistoryIfAuthenticated(query, suggestions);
      }
    } catch (_) {
      if (mounted) {
        _chat.setError('推薦の取得に失敗しました。もう一度お試しください。');
      }
    } finally {
      _notifyChange();
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
      await ref.read(advisorHistoryRepositoryProvider).saveSession(
            AdvisorSessionSaveInput(
              userId: userId,
              query: query,
              path: _chat.path?.name,
              selectedAnswers: List<String>.from(_chat.selectedAnswers),
              suggestedWorkflowIds:
                  suggestions.map((item) => item.workflow.id).toList(),
            ),
          );
      invalidateAdvisorHistories(ref, userId);
    } catch (_) {
      // 履歴保存失敗は提案結果表示を妨げない。
    }
  }

  void _handleQuickReply(String reply) {
    _chat.selectQuickReply(reply);

    if (_chat.isCompleted) {
      _notifyChange();
      _fetchSuggestions(_chat.buildQuery());
      return;
    }

    _notifyChange();
  }

  void _handleSend() {
    final query = _chat.submitText(_inputController.text);
    _inputController.clear();
    _notifyChange();

    if (query != null) {
      _fetchSuggestions(query);
    }
  }

  void _handleExampleSelected(String example) {
    _inputController.text = example;
    _handleSend();
  }

  void _handleHistorySelected(String query) {
    final resolved = _chat.startFromHistoryQuery(query);
    _inputController.clear();
    _notifyChange();
    _fetchSuggestions(resolved);
  }

  void _handleRetry() {
    _chat.resetConversation();
    _showAllSuggestions = false;
    _inputController.clear();
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = _chat.suggestions;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('AIに相談する'),
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (_chat.conversationActive)
            TextButton(
              onPressed: _chat.isSubmitting ? null : _handleRetry,
              child: const Text('最初から'),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: AppSpacing.s16),
              children: [
                const AdvisorChatHeader(),
                AdvisorRecentHistorySection(
                  queryController: _inputController,
                  onHistorySelected: _handleHistorySelected,
                  isLoading: _chat.isSubmitting,
                ),
                AdvisorChatTimeline(
                  messages: _chat.messages,
                  onQuickReply: _handleQuickReply,
                  interactionEnabled: !_chat.isSubmitting,
                ),
                if (_chat.isSubmitting) ...[
                  const SizedBox(height: AppSpacing.s12),
                  const AdvisorTypingIndicator(),
                ],
                if (_chat.errorMessage != null)
                  AdvisorChatErrorBanner(
                    message: _chat.errorMessage!,
                    onRetry: () {
                      final query = _chat.buildQuery();
                      if (query.isNotEmpty) {
                        _fetchSuggestions(query);
                      } else {
                        _handleRetry();
                      }
                    },
                  ),
                if (suggestions != null && suggestions.isEmpty)
                  AdvisorChatEmptyResult(
                    onRetry: _handleRetry,
                    onGoHome: () => context.go('/'),
                  ),
                if (suggestions != null && suggestions.isNotEmpty)
                  AdvisorRecommendationResultSection(
                    suggestions: suggestions,
                    showAllRanks: _showAllSuggestions,
                    onOpenWorkflow: (suggestion) {
                      context.push('/workflows/${suggestion.workflow.id}');
                    },
                    onStartWorkflow: (suggestion) {
                      context.push(
                        '/workflows/${suggestion.workflow.id}/run',
                      );
                    },
                    onShowMore: suggestions.length > 1 && !_showAllSuggestions
                        ? () {
                            setState(() => _showAllSuggestions = true);
                            _scrollToBottom();
                          }
                        : null,
                  ),
              ],
            ),
          ),
          AdvisorChatInputBar(
            controller: _inputController,
            onSend: _handleSend,
            onExampleSelected: _handleExampleSelected,
            enabled: !_chat.isSubmitting,
          ),
        ],
      ),
    );
  }
}
