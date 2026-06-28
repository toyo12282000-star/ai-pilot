import 'package:ai_pilot/features/advisor/domain/entities/advisor_suggestion.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// Advisor 例文チップ向けの Workflow 解決。
///
/// Supabase 移行後も [Workflow.title] で照合するため、Workflow.id が UUID でも動作する。
class AdvisorExampleQueryResolver {
  AdvisorExampleQueryResolver._();

  /// Advisor 画面の例文チップ（この順序で表示）。
  static const exampleQueries = [
    'YouTubeを始めたい',
    '副業を始めたい',
    'AIを学びたい',
    'ブログを書きたい',
    'SNSを伸ばしたい',
    '資料を作りたい',
  ];

  static const Map<String, List<String>> _workflowTitlesByQuery = {
    'YouTubeを始めたい': ['YouTubeショートを作る'],
    '副業を始めたい': ['SNS投稿を作る', 'ブログ記事を書く'],
    'AIを学びたい': ['調査レポートを作る', 'Flutterアプリを作る'],
    'ブログを書きたい': ['ブログ記事を書く'],
    'SNSを伸ばしたい': ['SNS投稿を作る'],
    '資料を作りたい': ['調査レポートを作る'],
  };

  static const Map<String, String> _reasonByQuery = {
    'YouTubeを始めたい': 'YouTubeショート制作に最適なWorkflowです',
    '副業を始めたい': '副業の土台づくりに役立つWorkflowです',
    'AIを学びたい': 'AI活用の第一歩としておすすめのWorkflowです',
    'ブログを書きたい': 'ブログ執筆に最適なWorkflowです',
    'SNSを伸ばしたい': 'SNS運用に役立つWorkflowです',
    '資料を作りたい': '調査から資料化までのWorkflowです',
  };

  static bool isExampleQuery(String query) {
    return _workflowTitlesByQuery.containsKey(query.trim());
  }

  /// 例文 [query] に対応する [workflows] 内の Workflow を優先順で返す。
  static List<Workflow> resolveWorkflows({
    required String query,
    required List<Workflow> workflows,
    int limit = 3,
  }) {
    final titles = _workflowTitlesByQuery[query.trim()];
    if (titles == null || workflows.isEmpty) {
      return const [];
    }

    final workflowByTitle = {
      for (final workflow in workflows) workflow.title: workflow,
    };
    final matched = <Workflow>[];

    for (final title in titles) {
      final workflow = workflowByTitle[title];
      if (workflow != null && !matched.any((item) => item.id == workflow.id)) {
        matched.add(workflow);
      }
    }

    return matched.take(limit).toList();
  }

  static String reasonForQuery(String query) {
    return _reasonByQuery[query.trim()] ??
        '例文に合うWorkflowとして選びました';
  }

  static List<AdvisorSuggestion> buildSuggestions({
    required String query,
    required List<Workflow> workflows,
    required String Function(Workflow workflow) difficultyLabel,
    int limit = 3,
  }) {
    final resolved = resolveWorkflows(
      query: query,
      workflows: workflows,
      limit: limit,
    );
    if (resolved.isEmpty) {
      return const [];
    }

    final reason = reasonForQuery(query);
    return [
      for (var index = 0; index < resolved.length; index++)
        AdvisorSuggestion(
          workflow: resolved[index],
          reason: reason,
          difficulty: difficultyLabel(resolved[index]),
          score: resolved.length - index,
        ),
    ];
  }
}
