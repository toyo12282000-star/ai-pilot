import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';

/// Sprint 13.3 完成作品ライブラリの 1 エントリ定義。
class ShowcaseLibraryEntry {
  const ShowcaseLibraryEntry({
    required this.id,
    required this.supabaseId,
    required this.workflowId,
    required this.storageFolder,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.estimatedTime,
    required this.isFeatured,
    required this.sortOrder,
    required this.tags,
    this.previewVideoUrl,
  });

  final String id;
  final String supabaseId;
  final String workflowId;
  final String storageFolder;
  final String title;
  final String description;
  final String category;
  final ShowcaseDifficulty difficulty;
  final int estimatedTime;
  final bool isFeatured;
  final int sortOrder;
  final List<String> tags;
  final String? previewVideoUrl;

  String get thumbnailStoragePath =>
      '$storageFolder/$workflowId/$id/thumbnail.webp';

  String get previewStoragePath =>
      '$storageFolder/$workflowId/$id/preview.webp';

  String get assetThumbnailPath =>
      'assets/showcases/$storageFolder/$workflowId/$id/thumbnail.svg';

  String get assetPreviewPath =>
      'assets/showcases/$storageFolder/$workflowId/$id/preview.svg';
}

/// Sprint 13.3 完成作品ライブラリ（30 件）の単一ソース。
const List<ShowcaseLibraryEntry> showcaseLibraryCatalog = [
  // ---------------------------------------------------------------------------
  // YouTube ショート (wf_youtube_short) — showcase_yt_1 .. showcase_yt_10
  // ---------------------------------------------------------------------------
  ShowcaseLibraryEntry(
    id: 'showcase_yt_1',
    supabaseId: '90000000-0000-4000-8000-000000000001',
    workflowId: 'wf_youtube_short',
    storageFolder: 'youtube',
    title: '世界一危険な島3選',
    description:
        '60秒で「行ってはいけない島」を3つ紹介するYouTubeショート。'
        '冒頭フック→島ごとの恐怖ポイント→保存CTAの定番構成。',
    category: '雑学',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 40,
    isFeatured: true,
    sortOrder: 0,
    tags: ['雑学', 'ショート動画'],
    previewVideoUrl:
        'https://example.com/showcase/youtube/dangerous-islands.mp4',
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_yt_2',
    supabaseId: '90000000-0000-4000-8000-000000000002',
    workflowId: 'wf_youtube_short',
    storageFolder: 'youtube',
    title: 'ドラッグストア化粧水3選',
    description:
        'プチプラコスメの比較ショート。'
        '価格・成分・使い心地を3本で紹介し、保存・コメントを促す構成。',
    category: '美容',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 45,
    isFeatured: false,
    sortOrder: 1,
    tags: ['コスメ', 'プチプラ'],
    previewVideoUrl: 'https://example.com/showcase/youtube/drugstore-toner.mp4',
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_yt_3',
    supabaseId: '90000000-0000-4000-8000-000000000003',
    workflowId: 'wf_youtube_short',
    storageFolder: 'youtube',
    title: '世界の変な法律3選',
    description:
        '「知らないとヤバい」系の歴史トリビアショート。'
        '国名→法律→理由の3段構成で視聴維持率を意識。',
    category: '歴史',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 35,
    isFeatured: false,
    sortOrder: 2,
    tags: ['法律', 'トリビア'],
    previewVideoUrl: 'https://example.com/showcase/youtube/weird-laws.mp4',
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_yt_4',
    supabaseId: '90000000-0000-4000-8000-000000000010',
    workflowId: 'wf_youtube_short',
    storageFolder: 'youtube',
    title: '2026年おすすめガジェット3選',
    description:
        '最新ガジェットを3点比較するショート。'
        '機能・価格・こんな人におすすめの順でテンポよく紹介。',
    category: 'ガジェット',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 42,
    isFeatured: false,
    sortOrder: 3,
    tags: ['テック', '比較'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_yt_5',
    supabaseId: '90000000-0000-4000-8000-000000000011',
    workflowId: 'wf_youtube_short',
    storageFolder: 'youtube',
    title: '週末に行ける絶景スポット3選',
    description:
        '関東から日帰りで行ける絶景スポットを3つ厳選。'
        'アクセス・ベストシーズン・撮影ポイントを短くまとめる構成。',
    category: '旅行',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 38,
    isFeatured: false,
    sortOrder: 4,
    tags: ['国内旅行', '週末'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_yt_6',
    supabaseId: '90000000-0000-4000-8000-000000000012',
    workflowId: 'wf_youtube_short',
    storageFolder: 'youtube',
    title: '令和に遊びたい神ゲー3選',
    description:
        '話題のゲームタイトルを3本紹介するエンタメショート。'
        'ジャンル・魅力・こんな人向けを1本15秒で区切る構成。',
    category: 'ゲーム',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 36,
    isFeatured: false,
    sortOrder: 5,
    tags: ['ゲーム', 'おすすめ'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_yt_7',
    supabaseId: '90000000-0000-4000-8000-000000000013',
    workflowId: 'wf_youtube_short',
    storageFolder: 'youtube',
    title: '今すぐできる節約術3選',
    description:
        '今日から実践できる節約テクニックを3つ紹介。'
        '数字フック→具体策→効果の順で共感を取る構成。',
    category: 'お金',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 30,
    isFeatured: false,
    sortOrder: 6,
    tags: ['節約', '家計'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_yt_8',
    supabaseId: '90000000-0000-4000-8000-000000000014',
    workflowId: 'wf_youtube_short',
    storageFolder: 'youtube',
    title: '月1万円の始め方ショート',
    description:
        '副業初心者向けに月1万円を目指す3ステップを解説。'
        'ハードルを下げつつ、次のアクションを促すCTA付き。',
    category: '副業',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 40,
    isFeatured: false,
    sortOrder: 7,
    tags: ['副業', '初心者'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_yt_9',
    supabaseId: '90000000-0000-4000-8000-000000000015',
    workflowId: 'wf_youtube_short',
    storageFolder: 'youtube',
    title: 'ChatGPT活用アイデア3選',
    description:
        '日常や仕事ですぐ使えるChatGPT活用法を3つ紹介。'
        '課題→プロンプト例→成果の流れで実用性を訴求。',
    category: 'AI',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 35,
    isFeatured: false,
    sortOrder: 8,
    tags: ['ChatGPT', '活用'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_yt_10',
    supabaseId: '90000000-0000-4000-8000-000000000016',
    workflowId: 'wf_youtube_short',
    storageFolder: 'youtube',
    title: '15分で作る時短レシピ3選',
    description:
        '忙しい平日でも作れる15分レシピを3品紹介。'
        '材料→手順→完成シーンのテンポで食欲を刺激する構成。',
    category: '料理',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 32,
    isFeatured: false,
    sortOrder: 9,
    tags: ['時短', 'レシピ'],
  ),

  // ---------------------------------------------------------------------------
  // Instagram (wf_sns) — showcase_sns_1 .. showcase_sns_10
  // ---------------------------------------------------------------------------
  ShowcaseLibraryEntry(
    id: 'showcase_sns_1',
    supabaseId: '90000000-0000-4000-8000-000000000007',
    workflowId: 'wf_sns',
    storageFolder: 'instagram',
    title: '【保存版】朝のルーティン5ステップ',
    description:
        'カルーセル5枚で朝の習慣を解説するInstagram投稿。'
        '1スライド1ステップ＋保存を促すキャプション付き。',
    category: 'カルーセル',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 25,
    isFeatured: true,
    sortOrder: 0,
    tags: ['カルーセル', 'ルーティン'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_sns_2',
    supabaseId: '90000000-0000-4000-8000-000000000008',
    workflowId: 'wf_sns',
    storageFolder: 'instagram',
    title: '忙しい人のための時間管理術',
    description:
        'ビジネスパーソン向けの時間管理Tipsを6枚のカルーセルで紹介。'
        '共感フック→具体策→実践チェックリストの流れ。',
    category: 'ビジネス',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 30,
    isFeatured: false,
    sortOrder: 1,
    tags: ['時間管理', '仕事術'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_sns_3',
    supabaseId: '90000000-0000-4000-8000-000000000009',
    workflowId: 'wf_sns',
    storageFolder: 'instagram',
    title: '副業で月3万円の3つの方法',
    description:
        '数字フック＋共感ポイント＋保存誘導の副業投稿。'
        '単一画像＋長文キャプションでバズを狙う構成。',
    category: '副業',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 20,
    isFeatured: false,
    sortOrder: 2,
    tags: ['副業', '収入'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_sns_4',
    supabaseId: '90000000-0000-4000-8000-000000000017',
    workflowId: 'wf_sns',
    storageFolder: 'instagram',
    title: '挑戦を後押しする名言10選',
    description:
        'モチベーションが上がる名言を10枚のカルーセルで配信。'
        '背景デザインと短い解説文で保存率を高める。',
    category: '名言',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 22,
    isFeatured: false,
    sortOrder: 3,
    tags: ['名言', 'モチベ'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_sns_5',
    supabaseId: '90000000-0000-4000-8000-000000000018',
    workflowId: 'wf_sns',
    storageFolder: 'instagram',
    title: '乾燥肌におすすめスキンケア3ステップ',
    description:
        '美容系カルーセルでスキンケア手順を3ステップに整理。'
        'Before/Afterイメージと商品選びのポイントを添える。',
    category: '美容',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 28,
    isFeatured: false,
    sortOrder: 4,
    tags: ['スキンケア', '乾燥肌'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_sns_6',
    supabaseId: '90000000-0000-4000-8000-000000000019',
    workflowId: 'wf_sns',
    storageFolder: 'instagram',
    title: '週末国内旅行の計画立て方',
    description:
        '旅行好き向けに週末トリップの計画術を5枚で解説。'
        'エリア選び→予算→持ち物→撮影スポットの順で構成。',
    category: '旅行',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 26,
    isFeatured: false,
    sortOrder: 5,
    tags: ['国内旅行', '週末'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_sns_7',
    supabaseId: '90000000-0000-4000-8000-000000000020',
    workflowId: 'wf_sns',
    storageFolder: 'instagram',
    title: '都内おすすめカフェ5選',
    description:
        '写真映えするカフェを5店舗紹介するカルーセル投稿。'
        '店名・エリア・おすすめメニューを1スライド1店舗でまとめる。',
    category: 'カフェ',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 24,
    isFeatured: false,
    sortOrder: 6,
    tags: ['カフェ', '東京'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_sns_8',
    supabaseId: '90000000-0000-4000-8000-000000000021',
    workflowId: 'wf_sns',
    storageFolder: 'instagram',
    title: '冬の必須アイテム3選',
    description:
        '商品紹介系のカルーセルで冬の必需品を3点ピックアップ。'
        '特徴・使い方・購入リンク案をコンパクトに載せる。',
    category: '商品紹介',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 27,
    isFeatured: false,
    sortOrder: 7,
    tags: ['商品紹介', '冬'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_sns_9',
    supabaseId: '90000000-0000-4000-8000-000000000022',
    workflowId: 'wf_sns',
    storageFolder: 'instagram',
    title: '続く習慣3つ',
    description:
        'ダイエットを続けるための小さな習慣を3つ紹介。'
        '共感→具体策→継続のコツで保存を促すレシピ系投稿。',
    category: 'ダイエット',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 23,
    isFeatured: false,
    sortOrder: 8,
    tags: ['ダイエット', '習慣'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_sns_10',
    supabaseId: '90000000-0000-4000-8000-000000000023',
    workflowId: 'wf_sns',
    storageFolder: 'instagram',
    title: '毎日5分で身につく英語',
    description:
        '英語学習のミニ習慣を7日分のカルーセルで提示。'
        '1日5分でできるフレーズと発音のコツを添える。',
    category: '英語',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 25,
    isFeatured: false,
    sortOrder: 9,
    tags: ['英語', '学習'],
  ),

  // ---------------------------------------------------------------------------
  // ブログ (wf_blog) — showcase_blog_1 .. showcase_blog_10
  // ---------------------------------------------------------------------------
  ShowcaseLibraryEntry(
    id: 'showcase_blog_1',
    supabaseId: '90000000-0000-4000-8000-000000000004',
    workflowId: 'wf_blog',
    storageFolder: 'blog',
    title: '初心者向けSEO対策の完全ガイド',
    description:
        '検索流入を増やすためのSEO基礎を3,500字で解説。'
        'キーワード選定・見出し構成・内部リンクまで網羅した入門記事。',
    category: 'SEO',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 60,
    isFeatured: true,
    sortOrder: 0,
    tags: ['SEO', '入門'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_blog_2',
    supabaseId: '90000000-0000-4000-8000-000000000005',
    workflowId: 'wf_blog',
    storageFolder: 'blog',
    title: 'ChatGPTで副業を始める完全ガイド',
    description:
        'AIを活用した副業の始め方を具体例付きで解説。'
        '案件獲得から納品までの流れと注意点をまとめた実践記事。',
    category: '副業',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 65,
    isFeatured: false,
    sortOrder: 1,
    tags: ['副業', 'ChatGPT'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_blog_3',
    supabaseId: '90000000-0000-4000-8000-000000000006',
    workflowId: 'wf_blog',
    storageFolder: 'blog',
    title: 'Notionでタスク管理を始める手順',
    description:
        'Notionを使ったタスク管理の入門How-to記事。'
        'テンプレート選びから日次運用までステップ形式で解説。',
    category: 'AI',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 50,
    isFeatured: false,
    sortOrder: 2,
    tags: ['Notion', '生産性'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_blog_4',
    supabaseId: '90000000-0000-4000-8000-000000000024',
    workflowId: 'wf_blog',
    storageFolder: 'blog',
    title: '2026年おすすめガジェット比較',
    description:
        '話題のガジェット5製品を用途別に比較した記事。'
        'スペック表・選び方・価格帯の目安まで網羅。',
    category: 'ガジェット',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 55,
    isFeatured: false,
    sortOrder: 3,
    tags: ['ガジェット', '比較'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_blog_5',
    supabaseId: '90000000-0000-4000-8000-000000000025',
    workflowId: 'wf_blog',
    storageFolder: 'blog',
    title: '人気コワーキングスペース徹底レビュー',
    description:
        '都内のコワーキング5施設を実際に利用したレビュー記事。'
        '料金・設備・アクセス・向いている人を表形式で比較。',
    category: 'レビュー',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 70,
    isFeatured: false,
    sortOrder: 4,
    tags: ['レビュー', 'コワーキング'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_blog_6',
    supabaseId: '90000000-0000-4000-8000-000000000026',
    workflowId: 'wf_blog',
    storageFolder: 'blog',
    title: '投資初心者が最初に読むべき記事',
    description:
        '資産形成の第一歩として押さえるべき投資の基礎を解説。'
        'リスク・分散・口座開設まで初心者向けに平易にまとめる。',
    category: '投資',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 58,
    isFeatured: false,
    sortOrder: 5,
    tags: ['投資', '初心者'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_blog_7',
    supabaseId: '90000000-0000-4000-8000-000000000027',
    workflowId: 'wf_blog',
    storageFolder: 'blog',
    title: '国内一人旅おすすめエリア5選',
    description:
        '初めてでも安心な国内一人旅スポットを5エリア紹介。'
        '交通・宿・モデルプラン付きで検索意図に応える旅行記事。',
    category: '旅行',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 52,
    isFeatured: false,
    sortOrder: 6,
    tags: ['一人旅', '国内'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_blog_8',
    supabaseId: '90000000-0000-4000-8000-000000000028',
    workflowId: 'wf_blog',
    storageFolder: 'blog',
    title: '転職成功のための履歴書の書き方',
    description:
        '書類選考を通過する履歴書の書き方を具体例付きで解説。'
        '職務経歴の書き方・自己PR・よくあるNG例まで網羅。',
    category: '転職',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 62,
    isFeatured: false,
    sortOrder: 7,
    tags: ['転職', '履歴書'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_blog_9',
    supabaseId: '90000000-0000-4000-8000-000000000029',
    workflowId: 'wf_blog',
    storageFolder: 'blog',
    title: 'プログラミング独学の始め方',
    description:
        '未経験からプログラミングを学ぶためのロードマップ記事。'
        '言語選び・学習リソース・ポートフォリオ作成まで段階的に解説。',
    category: 'プログラミング',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 68,
    isFeatured: false,
    sortOrder: 8,
    tags: ['プログラミング', '独学'],
  ),
  ShowcaseLibraryEntry(
    id: 'showcase_blog_10',
    supabaseId: '90000000-0000-4000-8000-000000000030',
    workflowId: 'wf_blog',
    storageFolder: 'blog',
    title: '毎日を快適にするライフハック10選',
    description:
        '日常の小さな不便を解消するライフハックを10個紹介。'
        '家事・仕事・健康管理などカテゴリ横断で実践的にまとめる。',
    category: 'ライフハック',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 48,
    isFeatured: false,
    sortOrder: 9,
    tags: ['ライフハック', '時短'],
  ),
];
