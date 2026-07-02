import 'package:ai_pilot/features/advisor/domain/entities/advisor_session_suggestion.dart';

/// Advisor の相談履歴 1 件（セッション）。
class AdvisorHistory {
  AdvisorHistory({
    required this.id,
    required this.userId,
    required this.query,
    required this.createdAt,
    this.path,
    this.selectedAnswers = const [],
    this.primaryWorkflowId,
    List<AdvisorSessionSuggestion>? suggestions,
    List<String>? suggestedWorkflowIds,
  }) : suggestions = (suggestions != null && suggestions.isNotEmpty)
            ? suggestions
            : _suggestionsFromIds(id, suggestedWorkflowIds ?? const []);

  /// 一意識別子。
  final String id;

  /// 相談したユーザー ID。
  final String userId;

  /// AdvisorService に渡した最終 query。
  final String query;

  /// 会話 path（enum 名文字列 · 例: `youtube`）。
  final String? path;

  /// 会話で選んだ回答一覧。
  final List<String> selectedAnswers;

  /// 1 位 Workflow ID。
  final String? primaryWorkflowId;

  /// 順位付き提案一覧。
  final List<AdvisorSessionSuggestion> suggestions;

  /// 保存日時。
  final DateTime createdAt;

  /// 提案 Workflow ID 一覧（rank 昇順）。
  List<String> get suggestedWorkflowIds {
    if (suggestions.isEmpty) {
      return const [];
    }
    final sorted = List<AdvisorSessionSuggestion>.from(suggestions)
      ..sort((a, b) => a.rank.compareTo(b.rank));
    return sorted.map((item) => item.workflowId).toList();
  }

  String get pathLabel {
    return switch (path) {
      'youtube' => 'YouTube',
      'instagram' => 'Instagram',
      'blog' => 'ブログ',
      'sideBusiness' => '副業',
      'document' => '資料',
      'undecided' => '未定',
      _ => '',
    };
  }

  String get displayQuery {
    final trimmed = query.trim();
    if (trimmed.length <= 48) {
      return trimmed;
    }
    return '${trimmed.substring(0, 48)}…';
  }

  AdvisorHistory copyWith({
    String? id,
    String? userId,
    String? query,
    String? path,
    List<String>? selectedAnswers,
    String? primaryWorkflowId,
    List<AdvisorSessionSuggestion>? suggestions,
    DateTime? createdAt,
  }) {
    return AdvisorHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      query: query ?? this.query,
      path: path ?? this.path,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      primaryWorkflowId: primaryWorkflowId ?? this.primaryWorkflowId,
      suggestions: suggestions ?? this.suggestions,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static List<AdvisorSessionSuggestion> _suggestionsFromIds(
    String sessionId,
    List<String> workflowIds,
  ) {
    return [
      for (var i = 0; i < workflowIds.length; i++)
        AdvisorSessionSuggestion(
          sessionId: sessionId,
          workflowId: workflowIds[i],
          rank: i + 1,
        ),
    ];
  }
}
