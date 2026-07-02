/// Sprint 14.0 · Workflow 詳細「作品紹介ページ」向け Mock データ（UI のみ）。
library;

/// Before → After 比較 1 行。
class WorkflowBeforeAfterPair {
  const WorkflowBeforeAfterPair({
    required this.before,
    required this.after,
  });

  final String before;
  final String after;
}

List<String> outcomeBenefitsForWorkflow(String workflowId) {
  return _benefitsByWorkflow[workflowId] ?? _defaultBenefits;
}

List<WorkflowBeforeAfterPair> beforeAfterPairsForWorkflow(String workflowId) {
  return _beforeAfterByWorkflow[workflowId] ?? _defaultBeforeAfter;
}

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
