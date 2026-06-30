import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';

/// Showcase / Hero 向け CTA 文言（心理的ハードルを下げる）。
abstract final class ShowcaseCtaCopy {
  static String cardLabel(WorkflowShowcase showcase) {
    final minutes = showcase.estimatedTime ?? 30;
    if (minutes <= 20) {
      return '$minutes分で完成';
    }
    if (minutes <= 45) {
      return '3ステップで作る';
    }
    return '無料で始める';
  }

  static String heroLabel({
    required WorkflowShowcase? showcase,
    required Workflow workflow,
  }) {
    final minutes =
        showcase?.estimatedTime ?? workflow.estimatedMinutes ?? 30;
    if (minutes <= 25) {
      return '$minutes分でこの作品を作る';
    }
    return '3ステップでこの作品を作る';
  }

  static String heroSubtitle(WorkflowShowcase? showcase) {
    if (showcase == null) {
      return '完成イメージを見ながら、AI・プロンプト・手順まで進められます。';
    }
    return '約${showcase.estimatedTime ?? 30}分 · ${_difficulty(showcase)}';
  }

  static String _difficulty(WorkflowShowcase showcase) {
    switch (showcase.difficulty) {
      case ShowcaseDifficulty.easy:
        return 'かんたん';
      case ShowcaseDifficulty.normal:
        return 'ふつう';
      case ShowcaseDifficulty.hard:
        return 'むずかしい';
      case null:
        return 'はじめやすい';
    }
  }
}
