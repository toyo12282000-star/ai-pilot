import 'package:ai_pilot/features/advisor/domain/entities/advisor_suggestion.dart';
import 'package:ai_pilot/features/recommendation/domain/entities/recommendation.dart';
import 'package:ai_pilot/features/workflow/domain/entities/category.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// 既存コンテンツから入力に近い Workflow を推薦する（MVP / 非 AI）。
class WorkflowAdvisorService {
  /// 入力 [query] に最も近い Workflow を最大 [limit] 件返す。
  List<AdvisorSuggestion> suggest({
    required String query,
    required List<Workflow> workflows,
    required List<Recommendation> recommendations,
    required List<Category> categories,
    int limit = 3,
  }) {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) {
      return const [];
    }

    final keywords = _extractKeywords(normalizedQuery);
    final intentCore = _stripIntentSuffix(normalizedQuery);
    final categoryById = {for (final category in categories) category.id: category};
    final scored = <_ScoredWorkflow>[
      for (final workflow in workflows)
        _ScoredWorkflow(workflow: workflow),
    ];
    final scoredById = {for (final item in scored) item.workflow.id: item};

    for (final recommendation in recommendations) {
      final recommendationScore = _recommendationMatchScore(
        normalizedQuery,
        intentCore,
        keywords,
        recommendation.title,
        recommendation.description,
      );
      if (recommendationScore <= 0) {
        continue;
      }

      for (final workflowId in recommendation.recommendedWorkflowIds) {
        final item = scoredById[workflowId];
        if (item == null) {
          continue;
        }
        item.score += recommendationScore + 30;
        item.matchedRecommendationTitle ??= recommendation.title;
      }
    }

    for (final item in scored) {
      final workflow = item.workflow;
      final category = categoryById[workflow.categoryId];

      if (_containsKeywordMatch(workflow.title, normalizedQuery, keywords, intentCore)) {
        item.score += 40;
        item.titleMatch = true;
      }
      if (_containsKeywordMatch(workflow.description, normalizedQuery, keywords, intentCore)) {
        item.score += 25;
        item.descriptionMatch = true;
      }
      if (category != null) {
        if (_containsKeywordMatch(category.name, normalizedQuery, keywords, intentCore)) {
          item.score += 30;
          item.matchedCategoryName ??= category.name;
        }
        final description = category.description;
        if (description != null &&
            _containsKeywordMatch(description, normalizedQuery, keywords, intentCore)) {
          item.score += 15;
          item.matchedCategoryName ??= category.name;
        }
      }
      for (final tag in workflow.tags) {
        if (_containsKeywordMatch(tag, normalizedQuery, keywords, intentCore) ||
            _containsJapaneseFragment(tag, normalizedQuery, intentCore)) {
          item.score += 20;
          item.matchedTags.add(tag);
        }
      }
    }

    scored.sort((a, b) => b.score.compareTo(a.score));

    return scored
        .where((item) => item.score > 0)
        .take(limit)
        .map(
          (item) => AdvisorSuggestion(
            workflow: item.workflow,
            reason: _buildReason(item),
            difficulty: _difficultyLabel(item.workflow),
            score: item.score,
          ),
        )
        .toList();
  }

  String _normalize(String value) => value.toLowerCase().trim();

  String _stripIntentSuffix(String query) {
    return query
        .replaceAll(
          RegExp(
            r'(を始めたい|を作りたい|を書きたい|を伸ばしたい|したい|始めたい|作りたい|学びたい|運用したい)$',
          ),
          '',
        )
        .trim();
  }

  List<String> _extractKeywords(String query) {
    final keywords = <String>{};

    final parts = query
        .split(RegExp(r'[\s、。！？,.]+'))
        .map((part) => part.trim())
        .where((part) => part.length >= 2);
    keywords.addAll(parts);

    final stripped = _stripIntentSuffix(query);
    if (stripped.length >= 2) {
      keywords.add(stripped);
    }

    if (keywords.isEmpty && query.length >= 2) {
      keywords.add(query);
    }

    return keywords.toList();
  }

  int _recommendationMatchScore(
    String normalizedQuery,
    String intentCore,
    List<String> keywords,
    String title,
    String description,
  ) {
    final normalizedTitle = _normalize(title);
    final normalizedDescription = _normalize(description);

    if (normalizedTitle == normalizedQuery) {
      return 100;
    }
    if (normalizedTitle.contains(normalizedQuery)) {
      return 80;
    }
    if (intentCore.length >= 2 && normalizedTitle.contains(intentCore)) {
      return 70;
    }

    for (final keyword in keywords) {
      if (keyword.length >= 3 && normalizedTitle.contains(keyword)) {
        return 60;
      }
    }

    var score = 0;
    for (final keyword in keywords) {
      if (keyword.length >= 2 && normalizedDescription.contains(keyword)) {
        score += 20;
      }
    }
    if (score == 0 &&
        _containsJapaneseFragment(description, normalizedQuery, intentCore)) {
      score = 25;
    }
    return score;
  }

  bool _containsKeywordMatch(
    String text,
    String normalizedQuery,
    List<String> keywords,
    String intentCore,
  ) {
    final normalizedText = _normalize(text);
    if (normalizedText.contains(normalizedQuery)) {
      return true;
    }
    if (intentCore.length >= 2 && normalizedText.contains(intentCore)) {
      return true;
    }
    for (final keyword in keywords) {
      if (keyword.length >= 2 && normalizedText.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  bool _containsJapaneseFragment(
    String text,
    String normalizedQuery,
    String intentCore,
  ) {
    if (!_isMostlyJapanese(normalizedQuery)) {
      return false;
    }

    final normalizedText = _normalize(text);
    final source = intentCore.length >= 2 ? intentCore : normalizedQuery;
    if (source.length < 4) {
      return false;
    }

    for (var index = 0; index < source.length - 1; index++) {
      final fragment = source.substring(index, index + 2);
      if (normalizedText.contains(fragment)) {
        return true;
      }
    }
    return false;
  }

  bool _isMostlyJapanese(String value) {
    final japanesePattern = RegExp(r'[\u3040-\u309f\u30a0-\u30ff\u4e00-\u9faf]');
    final matches = japanesePattern.allMatches(value).length;
    return matches >= value.length ~/ 2;
  }

  String _buildReason(_ScoredWorkflow item) {
    if (item.matchedRecommendationTitle != null) {
      return '「${item.matchedRecommendationTitle}」の目的に近いWorkflowです';
    }
    if (item.titleMatch) {
      return '入力内容とWorkflowのタイトルが一致しています';
    }
    if (item.matchedTags.isNotEmpty) {
      return '「${item.matchedTags.first}」に関連するタグが一致しました';
    }
    if (item.matchedCategoryName != null) {
      return '「${item.matchedCategoryName}」カテゴリが関連しています';
    }
    if (item.descriptionMatch) {
      return 'Workflowの概要が入力内容と関連しています';
    }
    return '入力内容に最も近いWorkflowです';
  }

  String _difficultyLabel(Workflow workflow) {
    final stepCount = workflow.steps.length;
    final minutes = workflow.estimatedMinutes ?? 0;

    if (stepCount <= 2 && minutes <= 40) {
      return 'かんたん';
    }
    if (stepCount <= 3 && minutes <= 60) {
      return 'ふつう';
    }
    return 'ステップ多め';
  }
}

class _ScoredWorkflow {
  _ScoredWorkflow({required this.workflow});

  final Workflow workflow;
  int score = 0;
  String? matchedRecommendationTitle;
  String? matchedCategoryName;
  final List<String> matchedTags = [];
  bool titleMatch = false;
  bool descriptionMatch = false;
}
