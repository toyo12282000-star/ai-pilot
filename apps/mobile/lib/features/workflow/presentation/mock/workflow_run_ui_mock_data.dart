import 'package:ai_pilot/features/workflow/domain/entities/prompt_variant.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';

/// Run 画面 UI 専用 Mock（Presentation のみ · Repository 非依存）。
abstract final class WorkflowRunUiMockData {
  static const Map<String, String> _hintsByStepId = {
    'step_short_1': 'まずはPromptをそのまま使ってみましょう。',
    'step_short_2': 'ここでは完璧を目指さなくてOKです。',
    'step_short_3': '困ったら下のPromptをそのまま使ってください。',
    'step_short_4': '慣れたら後からアレンジできます。',
    'step_short_5': '最後の仕上げ。サムネとタイトルを整えましょう。',
  };

  static const List<String> _defaultHints = [
    'ここでは完璧を目指さなくてOKです。',
    'まずはPromptをそのまま使ってみましょう。',
    '慣れたら後からアレンジできます。',
  ];

  /// Step ごとの AI Pilot ヒント。
  static String hintFor(WorkflowStep step, int stepIndex) {
    return _hintsByStepId[step.id] ??
        _defaultHints[stepIndex % _defaultHints.length];
  }

  /// Step ごとのチェックリスト（UI のみ）。
  static List<String> checklistFor(WorkflowStep step, {String? aiToolName}) {
    final tool = aiToolName ?? 'AIツール';
    return [
      '$toolを開く',
      'Promptをコピー',
      '出力する',
      '保存する',
    ];
  }

  /// 残り時間（分）の Mock 計算。
  static int remainingMinutes({
    required int? totalEstimatedMinutes,
    required int currentStepIndex,
    required int totalSteps,
  }) {
    if (totalSteps <= 0) {
      return 0;
    }
    final total = totalEstimatedMinutes ?? totalSteps * 8;
    final remainingSteps = (totalSteps - currentStepIndex).clamp(0, totalSteps);
    if (remainingSteps <= 0) {
      return 1;
    }
    return ((total * remainingSteps / totalSteps).ceil()).clamp(1, total);
  }

  /// プロンプト variant のおすすめ度（1〜5）。
  static int recommendationScore(PromptVariantType type) {
    return switch (type) {
      PromptVariantType.beginner => 5,
      PromptVariantType.highQuality => 4,
      PromptVariantType.shortTime => 3,
      PromptVariantType.viral => 4,
      PromptVariantType.professional => 4,
      PromptVariantType.seo => 3,
      PromptVariantType.sns => 4,
    };
  }

  /// Step 完了時の達成メッセージ。
  static WorkflowRunAchievementCopy achievementFor({
    required int completedStepIndex,
    required int totalSteps,
  }) {
    final stepNumber = completedStepIndex + 1;
    final remaining = totalSteps - stepNumber;
    return WorkflowRunAchievementCopy(
      title: 'Step$stepNumber 完了！',
      encouragement: 'いい感じです！',
      remainingMessage: remaining > 0 ? 'あと${remaining}Stepです。' : '最後のStepです！',
    );
  }
}

/// Step 完了達成表示用コピー。
class WorkflowRunAchievementCopy {
  const WorkflowRunAchievementCopy({
    required this.title,
    required this.encouragement,
    required this.remainingMessage,
  });

  final String title;
  final String encouragement;
  final String remainingMessage;
}
