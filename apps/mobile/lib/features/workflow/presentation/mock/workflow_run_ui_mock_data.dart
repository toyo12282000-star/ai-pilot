import 'package:ai_pilot/features/workflow/domain/entities/prompt_variant.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';

/// Run 画面 UI 専用 Mock（Presentation のみ · Repository 非依存）。
abstract final class WorkflowRunUiMockData {
  static const Map<String, String> _hintsByStepId = {
    'step_short_1': '完成イメージはShowcaseの「世界一危険な島3選」を参考にしましょう。',
    'step_short_2':
        '危険度だけでなく“見た目のインパクト”がある島を入れると、ショート動画向きになります',
    'step_short_3': '1位は最もインパクトのある島にしましょう。',
    'step_short_4': 'ここで動画の土台になる台本を作ります。まずはPromptをそのまま使ってみましょう。',
    'step_short_5': '台本全体は書き直さず、冒頭1〜2文だけ強化すればOKです。',
    'step_short_6': '読み上げ原稿は、難しい漢字をそのままにしない方が自然です',
    'step_short_7': '1テロップ10文字前後がスマホで読みやすいです。',
    'step_short_8':
        'ElevenLabs / VOICEVOX など、使う読み上げツールでまず1回試してみましょう。',
    'step_short_9': '35〜50秒が目安。長い場合は台本を短く調整します。',
    'step_short_10': '素材は自分で集める / AIで作る、どちらでもOKです。',
    'step_short_11': 'ここは自分で画像を探してもOK、画像生成AIで作ってもOK',
    'step_short_12': 'BGMはナレーションより小さく（20%以下）',
    'step_short_13': 'CapCut編集は、音声→素材→テロップの順に進めると迷いにくいです',
    'step_short_14': '15秒ごとにカット・ズームを入れると視聴維持率が上がりやすい',
    'step_short_15': 'テロップは画面中央・大きめ・白文字黒縁が読みやすい',
    'step_short_16': '書き出し前にスマホ実機でプレビューしましょう。',
  };

  static const Map<String, List<String>> _checklistsByStepId = {
    'step_short_1': [
      'テーマを確認した',
      '35〜50秒の尺を理解した',
      '次のStepに進む',
    ],
    'step_short_8': [
      '読み上げツールを開いた',
      'ナレーション原稿を貼り付けた',
      '音声ファイルを保存した',
      '尺をメモした',
    ],
    'step_short_9': [
      '音声の長さを確認した',
      '想定尺をメモした',
    ],
    'step_short_11': [
      '3島分の素材を集めた',
      'ファイルをフォルダに整理した',
    ],
    'step_short_13': [
      'CapCutで9:16プロジェクトを作成した',
      '音声をタイムラインに配置した',
    ],
    'step_short_16': [
      'BGM音量を調整した',
      '1080×1920で書き出した',
      'スマホでプレビューした',
    ],
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
    final custom = _checklistsByStepId[step.id];
    if (custom != null) {
      return custom;
    }

    if (step.promptTemplateId == null && step.aiToolId == null) {
      return [
        'やることを確認した',
        '必要なファイルを用意した',
        '次のStepに進む',
      ];
    }

    final tool = aiToolName ?? 'AIツール';
    if (step.promptTemplateId == null) {
      return [
        '$toolを開く',
        '手順どおりに進める',
        '出力を保存する',
      ];
    }

    return [
      'Promptをコピーした',
      '$toolを開いた',
      '出力を確認した',
      '次の工程で使うため保存した',
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
