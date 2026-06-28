import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// Advisor が返す Workflow 提案 1 件。
class AdvisorSuggestion {
  AdvisorSuggestion({
    required this.workflow,
    required this.reason,
    required this.difficulty,
    required this.score,
  });

  /// 提案対象の Workflow。
  final Workflow workflow;

  /// ユーザー向けの推薦理由。
  final String reason;

  /// 難易度ラベル（例: かんたん / ふつう / ステップ多め）。
  final String difficulty;

  /// 内部スコア（降順ソート用）。
  final int score;
}
