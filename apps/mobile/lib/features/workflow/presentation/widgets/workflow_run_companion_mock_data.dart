import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';

/// Run 画面 AI Companion 用の Mock コピー（UI のみ · 会話調）。
abstract final class WorkflowRunCompanionMockData {
  static const Map<String, List<String>> _messagesByStepId = {
    'step_short_1': [
      'ここは30秒で終わります。',
      '困ったら下のPromptをそのまま使ってください。',
    ],
    'step_short_2': [
      '順調です。',
      '企画が決まったら、台本に落とし込みましょう。',
    ],
    'step_short_3': [
      '次は音声生成ですね。',
      'Promptをコピーして、そのまま貼り付けてOKです。',
    ],
    'step_short_4': [
      'あと少しです。',
      'CapCutで素材を組み合わせるだけです。',
    ],
    'step_short_5': [
      '最後の仕上げです。',
      '完成したら「完了」を押してください。',
    ],
  };

  static const List<List<String>> _fallbackMessages = [
    ['ここは30秒で終わります。', '困ったら下のPromptをそのまま使ってください。'],
    ['順調です。', '一つずつ進めれば大丈夫です。'],
    ['次のStepも同じ流れです。', '迷ったらPromptをコピーしてください。'],
  ];

  /// ステップに応じた Companion メッセージ（1〜2行）を返す。
  static List<String> messagesFor(WorkflowStep step, int stepIndex) {
    final custom = _messagesByStepId[step.id];
    if (custom != null && custom.isNotEmpty) {
      return custom;
    }
    return _fallbackMessages[stepIndex % _fallbackMessages.length];
  }
}
