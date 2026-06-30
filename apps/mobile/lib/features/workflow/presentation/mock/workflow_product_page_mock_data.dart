/// Sprint 14.0 · Workflow 詳細「作品紹介ページ」向け Mock データ（UI のみ）。
library;

/// 人気・メタ情報。
class WorkflowProductStats {
  const WorkflowProductStats({
    required this.popularityScore,
    required this.saveCount,
    required this.userCount,
    required this.estimatedMinutes,
    required this.difficultyLabel,
    required this.pricingLabel,
    required this.category,
  });

  /// 5段階評価（例: 4.5）。
  final double popularityScore;
  final int saveCount;
  final int userCount;
  final int estimatedMinutes;
  final String difficultyLabel;
  final String pricingLabel;
  final String category;
}

/// Before → After 比較 1 行。
class WorkflowBeforeAfterPair {
  const WorkflowBeforeAfterPair({
    required this.before,
    required this.after,
  });

  final String before;
  final String after;
}

/// 最近作られた作品（Social Proof）。
class WorkflowRecentCreation {
  const WorkflowRecentCreation({
    required this.userLabel,
    required this.timeLabel,
  });

  final String userLabel;
  final String timeLabel;
}

/// Workflow ID ごとの作品紹介ページ Mock。
WorkflowProductStats productStatsForWorkflow(String workflowId) {
  return _statsByWorkflow[workflowId] ?? _defaultStats;
}

List<String> outcomeBenefitsForWorkflow(String workflowId) {
  return _benefitsByWorkflow[workflowId] ?? _defaultBenefits;
}

List<WorkflowBeforeAfterPair> beforeAfterPairsForWorkflow(String workflowId) {
  return _beforeAfterByWorkflow[workflowId] ?? _defaultBeforeAfter;
}

List<WorkflowRecentCreation> recentCreationsForWorkflow(String workflowId) {
  return _recentByWorkflow[workflowId] ?? _defaultRecent;
}

const _defaultStats = WorkflowProductStats(
  popularityScore: 4.0,
  saveCount: 8420,
  userCount: 1532,
  estimatedMinutes: 45,
  difficultyLabel: '初心者',
  pricingLabel: '無料',
  category: '完成作品',
);

const _statsByWorkflow = <String, WorkflowProductStats>{
  'wf_youtube_short': WorkflowProductStats(
    popularityScore: 4.5,
    saveCount: 12481,
    userCount: 2304,
    estimatedMinutes: 40,
    difficultyLabel: '初心者',
    pricingLabel: '無料',
    category: 'YouTubeショート',
  ),
  'wf_sns': WorkflowProductStats(
    popularityScore: 4.3,
    saveCount: 9876,
    userCount: 1890,
    estimatedMinutes: 25,
    difficultyLabel: '初心者',
    pricingLabel: '無料',
    category: 'Instagram',
  ),
  'wf_blog': WorkflowProductStats(
    popularityScore: 4.2,
    saveCount: 7654,
    userCount: 1420,
    estimatedMinutes: 60,
    difficultyLabel: '初級',
    pricingLabel: '無料',
    category: 'ブログ',
  ),
};

const _defaultBenefits = [
  '完成品をそのまま公開できる',
  'AI初心者でもOK',
  'スマホだけでも作れる',
  '無料ツールだけで完成',
  '副業・収益化にも使える',
];

const _benefitsByWorkflow = <String, List<String>>{
  'wf_youtube_short': [
    'YouTubeへそのまま投稿できる',
    '60秒以内で完成する',
    'スマホだけでも作れる',
    'AI初心者でもOK',
    '収益化にも使える',
  ],
  'wf_sns': [
    'Instagramにそのまま投稿できる',
    'カルーセル5枚を一気に完成',
    'スマホだけで作れる',
    'AI初心者でもOK',
    'フォロワー増加に使える',
  ],
  'wf_blog': [
    'WordPressにそのまま貼れる',
    'SEOを意識した構成',
    'PC・スマホどちらでもOK',
    'AI初心者でもOK',
    '副業・収益化にも使える',
  ],
};

const _defaultBeforeAfter = [
  WorkflowBeforeAfterPair(
    before: '何を作ればいいか分からない',
    after: '30分で企画完成',
  ),
  WorkflowBeforeAfterPair(
    before: 'AIの使い方が分からない',
    after: 'プロンプト付きで迷わない',
  ),
  WorkflowBeforeAfterPair(
    before: '完成まで時間がかかる',
    after: 'ステップ通りで最短完成',
  ),
];

const _beforeAfterByWorkflow = <String, List<WorkflowBeforeAfterPair>>{
  'wf_youtube_short': [
    WorkflowBeforeAfterPair(
      before: '企画が思いつかない',
      after: '30秒で企画完成',
    ),
    WorkflowBeforeAfterPair(
      before: '台本が書けない',
      after: 'ChatGPTで3分',
    ),
    WorkflowBeforeAfterPair(
      before: '編集が難しい',
      after: 'Vrewだけで完成',
    ),
  ],
  'wf_sns': [
    WorkflowBeforeAfterPair(
      before: 'ネタが思いつかない',
      after: '5枚分の構成が完成',
    ),
    WorkflowBeforeAfterPair(
      before: 'キャプションが書けない',
      after: 'AIで3分で完成',
    ),
    WorkflowBeforeAfterPair(
      before: 'デザインが苦手',
      after: 'Canvaテンプレで仕上げ',
    ),
  ],
  'wf_blog': [
    WorkflowBeforeAfterPair(
      before: '構成が作れない',
      after: '見出しまで3分',
    ),
    WorkflowBeforeAfterPair(
      before: '本文が書けない',
      after: 'AIで下書き完成',
    ),
    WorkflowBeforeAfterPair(
      before: 'SEOが分からない',
      after: 'キーワード込みで完成',
    ),
  ],
};

const _defaultRecent = [
  WorkflowRecentCreation(userLabel: 'たろうさん', timeLabel: '今日作成'),
  WorkflowRecentCreation(userLabel: 'はなこさん', timeLabel: '昨日'),
  WorkflowRecentCreation(userLabel: 'けんさん', timeLabel: '2日前'),
];

const _recentByWorkflow = <String, List<WorkflowRecentCreation>>{
  'wf_youtube_short': [
    WorkflowRecentCreation(userLabel: 'ゆうきさん', timeLabel: '今日作成'),
    WorkflowRecentCreation(userLabel: 'みさきさん', timeLabel: '今日作成'),
    WorkflowRecentCreation(userLabel: 'たくやさん', timeLabel: '昨日'),
    WorkflowRecentCreation(userLabel: 'あやかさん', timeLabel: '昨日'),
  ],
  'wf_sns': [
    WorkflowRecentCreation(userLabel: 'りなさん', timeLabel: '今日作成'),
    WorkflowRecentCreation(userLabel: 'そうたさん', timeLabel: '昨日'),
    WorkflowRecentCreation(userLabel: 'めいさん', timeLabel: '2日前'),
  ],
  'wf_blog': [
    WorkflowRecentCreation(userLabel: 'ひろさん', timeLabel: '今日作成'),
    WorkflowRecentCreation(userLabel: 'さくらさん', timeLabel: '昨日'),
    WorkflowRecentCreation(userLabel: 'だいすけさん', timeLabel: '3日前'),
  ],
};
