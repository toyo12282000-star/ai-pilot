/// 会話の分岐パス（UI のみ · AdvisorService は変更しない）。
enum AdvisorIntentPath {
  youtube,
  instagram,
  blog,
  sideBusiness,
  document,
  undecided,
}

/// 追加質問 1 件。
class AdvisorFollowUpQuestion {
  const AdvisorFollowUpQuestion({
    required this.text,
    required this.quickReplies,
  });

  final String text;
  final List<String> quickReplies;
}

/// Advisor 会話フロー定義と query 組み立て。
abstract final class AdvisorConversationFlow {
  static const initialGreeting =
      'こんにちは。今日は何を作りたいですか？ Advisorが合うWorkflowを一緒に探します。';

  static const initialQuickReplies = [
    'YouTube動画を作りたい',
    'Instagram投稿を作りたい',
    'ブログ記事を書きたい',
    '副業を始めたい',
    '資料を作りたい',
    'まだ決まっていない',
  ];

  static const completionMessage =
      'ありがとうございます。あなたに合いそうなWorkflowを探しますね。';

  static AdvisorIntentPath? pathForInitialReply(String reply) {
    return switch (reply.trim()) {
      'YouTube動画を作りたい' => AdvisorIntentPath.youtube,
      'Instagram投稿を作りたい' => AdvisorIntentPath.instagram,
      'ブログ記事を書きたい' => AdvisorIntentPath.blog,
      '副業を始めたい' => AdvisorIntentPath.sideBusiness,
      '資料を作りたい' => AdvisorIntentPath.document,
      'まだ決まっていない' => AdvisorIntentPath.undecided,
      _ => null,
    };
  }

  static List<AdvisorFollowUpQuestion> followUpsFor(AdvisorIntentPath path) {
    return switch (path) {
      AdvisorIntentPath.youtube => const [
          AdvisorFollowUpQuestion(
            text: 'どんなジャンルですか？',
            quickReplies: ['雑学', '美容', 'ゲーム', '旅行', '副業', 'AI'],
          ),
          AdvisorFollowUpQuestion(
            text: 'どのくらいの時間で作りたいですか？',
            quickReplies: ['15分', '30分', '1時間', 'じっくり作りたい'],
          ),
        ],
      AdvisorIntentPath.instagram => const [
          AdvisorFollowUpQuestion(
            text: 'どんな投稿を作りたいですか？',
            quickReplies: ['カルーセル', '商品紹介', '美容', '名言', 'ノウハウ'],
          ),
        ],
      AdvisorIntentPath.blog => const [
          AdvisorFollowUpQuestion(
            text: '目的は何ですか？',
            quickReplies: ['SEO', 'アフィリエイト', 'レビュー', '集客', '副業'],
          ),
        ],
      AdvisorIntentPath.sideBusiness => const [
          AdvisorFollowUpQuestion(
            text: 'どんな方向に興味がありますか？',
            quickReplies: ['SNS', 'ブログ', '動画', 'フリーランス', 'まだ決めていない'],
          ),
        ],
      AdvisorIntentPath.document => const [
          AdvisorFollowUpQuestion(
            text: 'どんな資料を作りますか？',
            quickReplies: ['調査レポート', 'プレゼン資料', '議事録', 'その他'],
          ),
        ],
      AdvisorIntentPath.undecided => const [
          AdvisorFollowUpQuestion(
            text: '今の目的に近いものはどれですか？',
            quickReplies: [
              '収益化したい',
              'SNSを伸ばしたい',
              '作業を効率化したい',
              'AIを学びたい',
              'とりあえず試したい',
            ],
          ),
        ],
    };
  }

  /// 会話回答を AdvisorService 向け query にまとめる。
  static String buildQuery(List<String> answers) {
    if (answers.isEmpty) {
      return '';
    }

    final normalized = answers.map((a) => a.trim()).where((a) => a.isNotEmpty);
    return normalized.join(' ');
  }
}
