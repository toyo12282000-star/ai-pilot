import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';

/// Run 画面 AI Companion 用の Mock コピー（UI のみ · 会話調）。
abstract final class WorkflowRunCompanionMockData {
  static const Map<String, List<String>> _messagesByStepId = {
    'step_short_1': [
      'まずは今回のテーマを確認しましょう。',
      '「世界一危険な島3選」の雑学ショートです。',
    ],
    'step_short_2': [
      'ここで紹介する3つの島を決めます。',
      '困ったら下のPromptをそのまま使ってください。',
    ],
    'step_short_3': [
      '順調です。',
      '3位→2位→1位の流れを決めましょう。',
    ],
    'step_short_4': [
      'ここで動画の土台になる台本を作ります。',
      'まずはそのままプロンプトを使ってみましょう。',
    ],
    'step_short_5': [
      '冒頭3秒だけ強化すればOKです。',
      '台本全体は書き直さなくて大丈夫。',
    ],
    'step_short_6': [
      '読み上げ原稿に整えましょう。',
      '難しい漢字は読み仮名を添えると自然です。',
    ],
    'step_short_7': [
      'テロップは短く。',
      'CapCut編集時にコピペできる一覧にしましょう。',
    ],
    'step_short_8': [
      '原稿ができたら、読み上げツールで音声にします。',
      'まずは1回試してみましょう。',
    ],
    'step_short_9': [
      '音声の長さを確認しましょう。',
      '35〜50秒が目安です。',
    ],
    'step_short_10': [
      '素材リストを作ります。',
      '自分で集めても、AIで作ってもOKです。',
    ],
    'step_short_11': [
      '素材集めはここが一番時間がかかるかも。',
      '1島1枚でも進められます。',
    ],
    'step_short_12': [
      'BGMは1つ決めればOK。',
      'ナレーションより小さく。',
    ],
    'step_short_13': [
      '編集は音声から置くとラクです。',
      'まずは映像より先に音声をタイムラインへ入れましょう。',
    ],
    'step_short_14': [
      '映像を音声に合わせて配置しましょう。',
      '15秒ごとにカットを入れると見やすいです。',
    ],
    'step_short_15': [
      'テロップは大きめ・白文字黒縁が読みやすいです。',
      'Step 7の一覧を横に置いて進めましょう。',
    ],
    'step_short_16': [
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
