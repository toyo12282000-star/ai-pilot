/// Mock 用の Step 拡張フィールド（Supabase 006 と同期）。
class MockStepEnrichment {
  const MockStepEnrichment({
    required this.goal,
    required this.outputExample,
    required this.completionCriteria,
    required this.tips,
    required this.commonMistakes,
  });

  final String goal;
  final String outputExample;
  final String completionCriteria;
  final List<String> tips;
  final List<String> commonMistakes;
}

const Map<String, MockStepEnrichment> _mockYoutubeShortStepEnrichment = {
  'step_short_1': MockStepEnrichment(
    goal: '今回作る動画が「世界一危険な島3選」であることを確認する',
    outputExample: 'テーマ: 危険な島3選 / 尺: 35〜50秒 / 構成: フック→3位→2位→1位→締め',
    completionCriteria: 'テーマ・動画の方向性が理解できている',
    tips: [
      '完成イメージはShowcaseの「世界一危険な島3選」を参考にすると迷いにくい',
      '1本目は完璧より「投稿まで」を優先しましょう',
    ],
    commonMistakes: [
      'テーマを理解せずに台本作成から始めてしまう',
      '尺の目安（35〜50秒）を決めずに進める',
    ],
  ),
  'step_short_2': MockStepEnrichment(
    goal: '紹介する危険な島を3つ確定する',
    outputExample: '例: 北 Sentinel島 / イルカ島 / レンチョ島（各1行の危険ポイント付き）',
    completionCriteria: '紹介する島が3つ決まっている',
    tips: [
      '危険度だけでなく“見た目のインパクト”がある島を入れると、ショート動画向きになります',
      '3案出して、一番作りやすい組み合わせを選ぶ',
    ],
    commonMistakes: [
      '4つ以上出して決めきれない',
      '素材が見つからなさそうな島だけ選んでしまう',
    ],
  ),
  'step_short_3': MockStepEnrichment(
    goal: '3位→2位→1位の順番と全体構成を決める',
    outputExample: '冒頭フック / 3位紹介 / 2位紹介 / 1位紹介 / 保存CTA',
    completionCriteria: '冒頭・ランキング順・締めが決まっている',
    tips: [
      '1位は最もインパクトのある島にする',
      '各ランク15秒前後を目安に',
    ],
    commonMistakes: [
      '順番がバラバラで視聴者が混乱する',
      '締めのCTAを入れ忘れる',
    ],
  ),
  'step_short_4': MockStepEnrichment(
    goal: '35〜50秒程度の読み上げ用台本を作る',
    outputExample: '【冒頭】世界一危険な島、知ってる？…【3位】…【2位】…【1位】…【締め】保存してね',
    completionCriteria: '読み上げ用の元台本が完成している',
    tips: [
      '1文15〜20文字程度に区切るとナレーションが聞き取りやすい',
      'テロップ用キーワードを【】で明示しておく',
    ],
    commonMistakes: [
      '60秒を大幅に超える長さの台本',
      '書き言葉のまま台本にする',
    ],
  ),
  'step_short_5': MockStepEnrichment(
    goal: '最初の3秒で視聴者を止める冒頭文にする',
    outputExample: '「この島に降りた瞬間、命の危険——世界一危険な島3選」',
    completionCriteria: '冒頭の1〜2文が改善されている',
    tips: [
      '台本全体は書き直さず、冒頭だけを強化する',
      '数字・疑問形・衝撃事実が効きやすい',
    ],
    commonMistakes: [
      '台本全体を書き直して時間がかかる',
      'フックが弱く最初の3秒で離脱される',
    ],
  ),
  'step_short_6': MockStepEnrichment(
    goal: '読み上げツールで使いやすい原稿に整える',
    outputExample: '読み仮名・句読点・間付きのナレーション原稿（350文字前後）',
    completionCriteria: '読みやすいナレーション原稿が完成している',
    tips: [
      '読み上げ原稿は、難しい漢字をそのままにしない方が自然です',
      '使う読み上げツールに貼り付けて試読する',
    ],
    commonMistakes: [
      'ElevenLabs専用の表記にしすぎて他ツールで使えない',
      '読み間違いしやすい固有名詞の確認を忘れる',
    ],
  ),
  'step_short_7': MockStepEnrichment(
    goal: '動画に載せる短いテロップ文を用意する',
    outputExample: '冒頭: 危険な島3選 / 3位: ○○島 / 2位: △△島 / 1位: ××島',
    completionCriteria: '各シーンごとの短いテロップが用意できている',
    tips: [
      '1テロップ10文字前後がスマホで読みやすい',
      'CapCut編集時にコピペできるよう一覧で保存',
    ],
    commonMistakes: [
      '台本全文をそのままテロップにする',
      '文字数が多すぎて画面に収まらない',
    ],
  ),
  'step_short_8': MockStepEnrichment(
    goal: 'ナレーション原稿を音声化する',
    outputExample: '台本全文を読み上げたMP3/WAV（35〜50秒）',
    completionCriteria: 'mp3 / wav などの音声ファイルが完成している',
    tips: [
      'ElevenLabs / VOICEVOX など、使う読み上げツールでまず1回試す',
      '同じ原稿で2パターン生成し、トーンが合うものを選ぶ',
    ],
    commonMistakes: [
      '台本修正後に音声を再生成し忘れる',
      '音量が小さすぎて後の編集で苦労する',
    ],
  ),
  'step_short_9': MockStepEnrichment(
    goal: '音声の長さから完成動画の想定尺を把握する',
    outputExample: '想定尺: 42秒（音声ファイルの長さをメモ）',
    completionCriteria: 'おおよその動画尺が分かっている',
    tips: [
      '35〜50秒が目安。長い場合は台本を短く調整',
      'スマホのボイスメモ等で長さを確認してもOK',
    ],
    commonMistakes: [
      '尺を確認せず編集に入って後から調整が大変になる',
    ],
  ),
  'step_short_10': MockStepEnrichment(
    goal: '各シーンで必要な画像 / 映像素材を明確にする',
    outputExample: '冒頭: 海の空撮 / 3位: 島Aの写真 / 2位: 島B / 1位: 島C / 締め: 地図',
    completionCriteria: '素材リストができている',
    tips: [
      '素材は自分で集める / AIで作る、どちらでもOK',
      '無料素材サイトと画像生成AIの両方を候補に',
    ],
    commonMistakes: [
      'リストなしで素材集めを始めて不足が出る',
      '著作権不明の素材を使う',
    ],
  ),
  'step_short_11': MockStepEnrichment(
    goal: '動画に使う素材を実際に揃える',
    outputExample: '3島分＋冒頭 / 締め用の画像 or 動画クリップ一式',
    completionCriteria: '3島分の素材が最低限そろっている',
    tips: [
      'ここは自分で画像を探してもOK、画像生成AIで作ってもOK',
      '1島1枚でも進められる。後から差し替え可能',
    ],
    commonMistakes: [
      '高解像度すぎてCapCutが重くなる',
      '横型素材のまま使って縦型で見切れる',
    ],
  ),
  'step_short_12': MockStepEnrichment(
    goal: '動画の雰囲気に合うBGM / 効果音を決める',
    outputExample: 'BGM: 緊張感のあるループ音源（CapCut内蔵）',
    completionCriteria: '少なくともBGMが1つ決まっている',
    tips: [
      '雑学系は少し緊張感のあるBGMが合いやすい',
      'ナレーションより小さく（20%以下）',
    ],
    commonMistakes: [
      'BGMが大きすぎてナレーションが聞こえない',
      '著作権フリーか確認しない',
    ],
  ),
  'step_short_13': MockStepEnrichment(
    goal: '音声を先に置いて、動画全体のベースを作る',
    outputExample: '9:16プロジェクトにナレーション音声が配置されたタイムライン',
    completionCriteria: '音声がタイムラインに入り、プロジェクトが始められている',
    tips: [
      'CapCut編集は、音声→素材→テロップの順に進めると迷いにくいです',
      '編集は音声から置くとラクです',
    ],
    commonMistakes: [
      '映像から入って音声と合わなくなる',
      '横型（16:9）のまま始める',
    ],
  ),
  'step_short_14': MockStepEnrichment(
    goal: '各セリフに対応する映像 / 画像を配置する',
    outputExample: '3位→2位→1位の順に、音声に合わせた映像配置済みタイムライン',
    completionCriteria: '全体の映像配置が一通り終わっている',
    tips: [
      '15秒ごとにカット・ズームを入れると視聴維持率が上がりやすい',
      '素材が足りない箇所は同じ画像を短く使い回してもOK',
    ],
    commonMistakes: [
      '音声と映像のタイミングがズレる',
      '1シーンが長すぎて単調になる',
    ],
  ),
  'step_short_15': MockStepEnrichment(
    goal: '主要なセリフに対応するテロップを入れる',
    outputExample: '島名・ランキング・キーワードが白文字黒縁で表示された動画',
    completionCriteria: '主要なテロップが入っている',
    tips: [
      'テロップは画面中央・大きめ・白文字黒縁が読みやすい',
      'Step 7の一覧を横に置いてコピペ',
    ],
    commonMistakes: [
      '文字が小さすぎてスマホで読めない',
      'テロップが多すぎて画面がごちゃごちゃ',
    ],
  ),
  'step_short_16': MockStepEnrichment(
    goal: '最後の仕上げをして完成動画を書き出す',
    outputExample: '1080×1920、35〜50秒、BGM付きのMP4ファイル',
    completionCriteria: '投稿できる動画ファイルが完成している',
    tips: [
      '書き出し前にスマホ実機でプレビュー',
      'BGM音量はナレーションの20%以下を目安に',
    ],
    commonMistakes: [
      'BGMが大きすぎる',
      '1080×1920以外で書き出してしまう',
    ],
  ),
};

const Map<String, MockStepEnrichment> mockStepEnrichmentById = {
  ..._mockYoutubeShortStepEnrichment,
  'step_blog_1': MockStepEnrichment(
    goal: 'SEOを意識した記事の見出し構成（アウトライン）を確定する',
    outputExample:
        'H1: ChatGPTで副業を始める完全ガイド\nH2: なぜChatGPTが副業に向いているのか\nH2: 始める前に準備すること\n  H3: 必要なアカウント...\nH2: まとめ',
    completionCriteria:
        'H1・H2（3〜5個）・必要に応じてH3を含む構成案があり、検索意図に沿っている',
    tips: [
      'メインキーワードはH1と最初のH2に自然に含める',
      'Perplexityで競合記事の見出しを調査し、抜けている角度を構成に加える',
      '各H2に「読者が得られること」を1行メモしておくと執筆が速い',
      '文字数目安（例: 各H2=800字）を構成段階で決めておく',
    ],
    commonMistakes: [
      '見出しが抽象的すぎて、本文で何を書くか不明確',
      'キーワードの詰め込みすぎで不自然な見出しになる',
      '競合と同じ構成のコピーで、オリジナリティがない',
      'H2の数が多すぎて記事が散漫になる（5〜7が目安）',
    ],
  ),
  'step_blog_2': MockStepEnrichment(
    goal: '構成案に沿って、公開可能なブログ本文を執筆する',
    outputExample:
        '3000〜5000字程度の本文。各見出し下に具体例・手順・注意点を含む読みやすい記事',
    completionCriteria:
        '全見出しに本文があり、誤字脱字を修正済みで、そのままCMSに貼れる状態',
    tips: [
      'Claudeは長文の一貫性に強い。見出しごとに分割生成してから統合する',
      '「です・ます調」で統一し、一文60文字以内を目安にする',
      '具体例・数字・手順を各セクションに最低1つ入れる',
      '執筆後にPerplexityで事実関係をファクトチェックする',
    ],
    commonMistakes: [
      'AI生成文をそのまま公開し、独自の経験や具体例が入っていない',
      '見出しと本文の内容がズレている',
      '同じ言い回し・接続詞の繰り返しが多い',
      'メタディスクリプション・内部リンク・画像挿入位置の指示を忘れる',
    ],
  ),
  'step_sns_1': MockStepEnrichment(
    goal: 'Instagram向けの投稿文（キャプション）を完成させる',
    outputExample:
        '【保存版】ChatGPTで副業を始める3ステップ\n\n1️⃣ アカウント作成\n2️⃣ プロンプト設計\n...\n\n#ChatGPT #副業 #AI活用\n\n保存して後で見返してね👆',
    completionCriteria: '本文・ハッシュタグ・CTAを含む投稿文が完成し、2200文字以内である',
    tips: [
      '最初の1行（約40文字）でスクロール停止させるフックを書く',
      '絵文字は3〜5個程度に抑え、読みやすさを優先する',
      'ハッシュタグは大・中・小の3段階で5〜15個選ぶ',
      'GeminiはSNS文案に強い。トーン（カジュアル/プロ）を明示する',
    ],
    commonMistakes: [
      'ハッシュタグだけ並べて本文が薄い',
      'フックが弱く、タイムラインでスルーされる',
      'Instagram以外のプラットフォーム用の文体のまま投稿する',
      'CTA（保存・コメント・プロフィールリンク）がない',
    ],
  ),
  'step_sns_2': MockStepEnrichment(
    goal: '投稿文に合ったInstagram用ビジュアル（1080×1080または1080×1350）を作成する',
    outputExample:
        'テキスト入りのカルーセル1枚目、または単一画像。ブランドカラー統一、文字が読みやすい',
    completionCriteria:
        '1080px以上の画像ファイルが完成し、投稿文の内容と視覚的に一致している',
    tips: [
      'CanvaのInstagramテンプレート（1080×1080）から始めるとサイズミスを防げる',
      'Ideogramは文字入り画像生成に強い。サムネ風の1枚目に使える',
      'フォントは2種類まで、背景と文字のコントラストを確保する',
      'カルーセル投稿なら1枚目にタイトル・2枚目以降に詳細を配置する',
    ],
    commonMistakes: [
      '文字が小さすぎてスマホのフィードで読めない',
      '投稿文と画像のメッセージが一致していない',
      'Canva無料素材の著作権・商用利用条件を確認していない',
      '低解像度のまま書き出して、画質が粗い',
    ],
  ),
};
