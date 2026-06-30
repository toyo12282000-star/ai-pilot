import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';

/// Run 画面 AI Companion 用の Mock コピー（UI のみ）。
abstract final class WorkflowRunCompanionMockData {
  static const Map<String, List<String>> _messagesByStepId = {
    'step_short_1': [
      'まずはタイトルを考えましょう。',
      '下のボタンを押すだけです。',
    ],
    'step_short_2': [
      '企画が決まったら、台本に落とし込みましょう。',
      '迷ったらこのプロンプトを使えばOKです。',
    ],
    'step_short_3': [
      'ここは30秒で終わります。',
      '音声を生成したら、次の編集ステップへ進みましょう。',
    ],
    'step_short_4': [
      'CapCutで素材を組み合わせるだけです。',
      '完成したら次へ進みましょう。',
    ],
    'step_short_5': [
      '最後の仕上げです。サムネとタイトルを整えましょう。',
      '完成したら「完了」を押してください。',
    ],
  };

  static const List<List<String>> _fallbackMessages = [
    ['ここは30秒で終わります。', '迷ったらこのプロンプトを使えばOKです。'],
    ['一つずつ進めれば大丈夫です。', '下のボタンからAIを開けます。'],
    ['完成したら次へ進みましょう。', '困ったらプロンプトをコピーしてください。'],
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
