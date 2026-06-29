import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/showcase_asset.dart';
import 'package:ai_pilot/features/workflow/domain/entities/showcase_tag.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';

/// Mock 完成作品タグ。
final List<ShowcaseTag> mockShowcaseTags = [
  ShowcaseTag(id: 'tag_yt_1_1', showcaseId: 'showcase_yt_1', tag: '雑学'),
  ShowcaseTag(id: 'tag_yt_1_2', showcaseId: 'showcase_yt_1', tag: 'ショート動画'),
  ShowcaseTag(id: 'tag_yt_1_3', showcaseId: 'showcase_yt_1', tag: '保存版'),
  ShowcaseTag(id: 'tag_yt_2_1', showcaseId: 'showcase_yt_2', tag: 'コスメ'),
  ShowcaseTag(id: 'tag_yt_2_2', showcaseId: 'showcase_yt_2', tag: 'プチプラ'),
  ShowcaseTag(id: 'tag_yt_2_3', showcaseId: 'showcase_yt_2', tag: '比較'),
  ShowcaseTag(id: 'tag_yt_3_1', showcaseId: 'showcase_yt_3', tag: '法律'),
  ShowcaseTag(id: 'tag_yt_3_2', showcaseId: 'showcase_yt_3', tag: '海外'),
  ShowcaseTag(id: 'tag_yt_3_3', showcaseId: 'showcase_yt_3', tag: 'トリビア'),
  ShowcaseTag(id: 'tag_blog_1_1', showcaseId: 'showcase_blog_1', tag: 'ChatGPT'),
  ShowcaseTag(id: 'tag_blog_1_2', showcaseId: 'showcase_blog_1', tag: '副業'),
  ShowcaseTag(id: 'tag_blog_1_3', showcaseId: 'showcase_blog_1', tag: 'SEO'),
  ShowcaseTag(id: 'tag_blog_2_1', showcaseId: 'showcase_blog_2', tag: '在宅ワーク'),
  ShowcaseTag(id: 'tag_blog_2_2', showcaseId: 'showcase_blog_2', tag: '比較記事'),
  ShowcaseTag(id: 'tag_blog_2_3', showcaseId: 'showcase_blog_2', tag: '2026年版'),
  ShowcaseTag(id: 'tag_blog_3_1', showcaseId: 'showcase_blog_3', tag: 'Notion'),
  ShowcaseTag(id: 'tag_blog_3_2', showcaseId: 'showcase_blog_3', tag: 'タスク管理'),
  ShowcaseTag(id: 'tag_blog_3_3', showcaseId: 'showcase_blog_3', tag: 'How-to'),
  ShowcaseTag(id: 'tag_sns_1_1', showcaseId: 'showcase_sns_1', tag: 'ルーティン'),
  ShowcaseTag(id: 'tag_sns_1_2', showcaseId: 'showcase_sns_1', tag: 'カルーセル'),
  ShowcaseTag(id: 'tag_sns_1_3', showcaseId: 'showcase_sns_1', tag: 'ライフスタイル'),
  ShowcaseTag(id: 'tag_sns_2_1', showcaseId: 'showcase_sns_2', tag: 'AI'),
  ShowcaseTag(id: 'tag_sns_2_2', showcaseId: 'showcase_sns_2', tag: '比較'),
  ShowcaseTag(id: 'tag_sns_2_3', showcaseId: 'showcase_sns_2', tag: 'テック'),
  ShowcaseTag(id: 'tag_sns_3_1', showcaseId: 'showcase_sns_3', tag: '副業'),
  ShowcaseTag(id: 'tag_sns_3_2', showcaseId: 'showcase_sns_3', tag: 'バズ'),
  ShowcaseTag(id: 'tag_sns_3_3', showcaseId: 'showcase_sns_3', tag: '保存版'),
];

/// Mock 完成作品アセット。
final List<ShowcaseAsset> mockShowcaseAssets = [
  ShowcaseAsset(
    id: 'asset_yt_1_1',
    showcaseId: 'showcase_yt_1',
    assetType: ShowcaseAssetType.video,
    url: 'https://example.com/showcase/youtube/dangerous-islands.mp4',
    title: '完成ショート動画',
  ),
  ShowcaseAsset(
    id: 'asset_yt_1_2',
    showcaseId: 'showcase_yt_1',
    assetType: ShowcaseAssetType.prompt,
    url: 'https://example.com/showcase/prompts/dangerous-islands.txt',
    title: '企画・台本プロンプト',
    sortOrder: 1,
  ),
  ShowcaseAsset(
    id: 'asset_yt_2_1',
    showcaseId: 'showcase_yt_2',
    assetType: ShowcaseAssetType.video,
    url: 'https://example.com/showcase/youtube/drugstore-toner.mp4',
    title: '完成ショート動画',
  ),
  ShowcaseAsset(
    id: 'asset_yt_2_2',
    showcaseId: 'showcase_yt_2',
    assetType: ShowcaseAssetType.image,
    url: 'https://placehold.co/1080x1920/2d1b4e/f5e6ff/png?text=Thumbnail',
    title: 'サムネイル画像',
    sortOrder: 1,
  ),
  ShowcaseAsset(
    id: 'asset_yt_3_1',
    showcaseId: 'showcase_yt_3',
    assetType: ShowcaseAssetType.video,
    url: 'https://example.com/showcase/youtube/weird-laws.mp4',
    title: '完成ショート動画',
  ),
  ShowcaseAsset(
    id: 'asset_yt_3_2',
    showcaseId: 'showcase_yt_3',
    assetType: ShowcaseAssetType.prompt,
    url: 'https://example.com/showcase/prompts/weird-laws.txt',
    title: '台本プロンプト',
    sortOrder: 1,
  ),
  ShowcaseAsset(
    id: 'asset_blog_1_1',
    showcaseId: 'showcase_blog_1',
    assetType: ShowcaseAssetType.article,
    url: 'https://example.com/showcase/blog/chatgpt-side-hustle.html',
    title: '完成記事HTML',
  ),
  ShowcaseAsset(
    id: 'asset_blog_1_2',
    showcaseId: 'showcase_blog_1',
    assetType: ShowcaseAssetType.prompt,
    url: 'https://example.com/showcase/prompts/chatgpt-side-hustle.txt',
    title: '構成・執筆プロンプト',
    sortOrder: 1,
  ),
  ShowcaseAsset(
    id: 'asset_blog_2_1',
    showcaseId: 'showcase_blog_2',
    assetType: ShowcaseAssetType.article,
    url: 'https://example.com/showcase/blog/remote-work-2026.html',
    title: '完成記事HTML',
  ),
  ShowcaseAsset(
    id: 'asset_blog_2_2',
    showcaseId: 'showcase_blog_2',
    assetType: ShowcaseAssetType.image,
    url: 'https://placehold.co/1200x630/134e4a/ccfbf1/png?text=OGP',
    title: 'OGP画像',
    sortOrder: 1,
  ),
  ShowcaseAsset(
    id: 'asset_blog_3_1',
    showcaseId: 'showcase_blog_3',
    assetType: ShowcaseAssetType.article,
    url: 'https://example.com/showcase/blog/notion-tasks.html',
    title: '完成記事HTML',
  ),
  ShowcaseAsset(
    id: 'asset_blog_3_2',
    showcaseId: 'showcase_blog_3',
    assetType: ShowcaseAssetType.slide,
    url: 'https://example.com/showcase/blog/notion-tasks-slides.pdf',
    title: '構成スライド',
    sortOrder: 1,
  ),
  ShowcaseAsset(
    id: 'asset_sns_1_1',
    showcaseId: 'showcase_sns_1',
    assetType: ShowcaseAssetType.image,
    url: 'https://placehold.co/1080x1080/fbbf24/78350f/png?text=Slide1',
    title: 'カルーセル画像セット',
  ),
  ShowcaseAsset(
    id: 'asset_sns_1_2',
    showcaseId: 'showcase_sns_1',
    assetType: ShowcaseAssetType.prompt,
    url: 'https://example.com/showcase/prompts/morning-routine.txt',
    title: 'キャプション生成プロンプト',
    sortOrder: 1,
  ),
  ShowcaseAsset(
    id: 'asset_sns_2_1',
    showcaseId: 'showcase_sns_2',
    assetType: ShowcaseAssetType.image,
    url: 'https://placehold.co/1080x1080/6366f1/e0e7ff/png?text=Slide1',
    title: 'カルーセル画像セット',
  ),
  ShowcaseAsset(
    id: 'asset_sns_2_2',
    showcaseId: 'showcase_sns_2',
    assetType: ShowcaseAssetType.prompt,
    url: 'https://example.com/showcase/prompts/ai-compare.txt',
    title: '投稿文プロンプト',
    sortOrder: 1,
  ),
  ShowcaseAsset(
    id: 'asset_sns_3_1',
    showcaseId: 'showcase_sns_3',
    assetType: ShowcaseAssetType.image,
    url: 'https://placehold.co/1080x1350/be123c/ffe4e6/png?text=Feed',
    title: 'フィード画像',
  ),
  ShowcaseAsset(
    id: 'asset_sns_3_2',
    showcaseId: 'showcase_sns_3',
    assetType: ShowcaseAssetType.prompt,
    url: 'https://example.com/showcase/prompts/side-income.txt',
    title: 'バズ狙いキャプション',
    sortOrder: 1,
  ),
];

List<ShowcaseTag> _tagsForShowcase(String showcaseId) {
  return mockShowcaseTags
      .where((tag) => tag.showcaseId == showcaseId)
      .toList();
}

List<ShowcaseAsset> _assetsForShowcase(String showcaseId) {
  return mockShowcaseAssets
      .where((asset) => asset.showcaseId == showcaseId)
      .toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
}

WorkflowShowcase _buildShowcase({
  required String id,
  required String workflowId,
  required String title,
  required String description,
  required String thumbnailUrl,
  required String previewImageUrl,
  String? previewVideoUrl,
  required String completedOutput,
  required String category,
  required ShowcaseDifficulty difficulty,
  required int estimatedTime,
  required bool isFeatured,
  required int sortOrder,
}) {
  return WorkflowShowcase(
    id: id,
    workflowId: workflowId,
    title: title,
    description: description,
    thumbnailUrl: thumbnailUrl,
    previewImageUrl: previewImageUrl,
    previewVideoUrl: previewVideoUrl,
    completedOutput: completedOutput,
    category: category,
    difficulty: difficulty,
    estimatedTime: estimatedTime,
    isFeatured: isFeatured,
    sortOrder: sortOrder,
    tags: _tagsForShowcase(id),
    assets: _assetsForShowcase(id),
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  );
}

/// Mock 完成作品サンプル一覧（Sprint 12.4）。
final List<WorkflowShowcase> mockWorkflowShowcases = [
  _buildShowcase(
    id: 'showcase_yt_1',
    workflowId: 'wf_youtube_short',
    title: '世界一危険な島3選',
    description:
        '60秒で「行ってはいけない島」を3つ紹介するYouTubeショート。冒頭フック→島ごとの恐怖ポイント→保存CTAの定番構成。',
    thumbnailUrl:
        'https://placehold.co/400x711/1a1a2e/eaeaea/png?text=%E5%8D%B1%E9%99%A9%E3%81%AA%E5%B3%B6',
    previewImageUrl:
        'https://placehold.co/1080x1920/1a1a2e/eaeaea/png?text=%E5%B1%B1%E5%B3%B6%E3%83%97%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC',
    previewVideoUrl:
        'https://example.com/showcase/youtube/dangerous-islands.mp4',
    completedOutput: '9:16縦型・58秒・テロップ付き・BGM付きの完成ショート動画',
    category: 'エンタメ',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 40,
    isFeatured: true,
    sortOrder: 0,
  ),
  _buildShowcase(
    id: 'showcase_yt_2',
    workflowId: 'wf_youtube_short',
    title: 'ドラッグストア化粧水3選',
    description:
        'プチプラコスメの比較ショート。価格・成分・使い心地を3本で紹介し、保存・コメントを促す構成。',
    thumbnailUrl:
        'https://placehold.co/400x711/2d1b4e/f5e6ff/png?text=%E5%8C%96%E7%B2%A7%E6%B0%B4',
    previewImageUrl:
        'https://placehold.co/1080x1920/2d1b4e/f5e6ff/png?text=%E3%82%B3%E3%82%B9%E3%83%A1%E3%83%97%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC',
    previewVideoUrl: 'https://example.com/showcase/youtube/drugstore-toner.mp4',
    completedOutput: '9:16縦型・55秒・商品名テロップ・価格表示入りの完成ショート',
    category: 'ライフハック',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 45,
    isFeatured: false,
    sortOrder: 1,
  ),
  _buildShowcase(
    id: 'showcase_yt_3',
    workflowId: 'wf_youtube_short',
    title: '世界の変な法律3選',
    description:
        '「知らないとヤバい」系の雑学ショート。国名→法律→理由の3段構成で視聴維持率を意識。',
    thumbnailUrl:
        'https://placehold.co/400x711/0f3460/e94560/png?text=%E5%A4%89%E3%81%AA%E6%B3%95%E5%BE%8B',
    previewImageUrl:
        'https://placehold.co/1080x1920/0f3460/e94560/png?text=%E9%9B%91%E5%AD%A6%E3%83%97%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC',
    previewVideoUrl: 'https://example.com/showcase/youtube/weird-laws.mp4',
    completedOutput: '9:16縦型・60秒・国旗素材＋テロップの完成ショート',
    category: '雑学',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 35,
    isFeatured: false,
    sortOrder: 2,
  ),
  _buildShowcase(
    id: 'showcase_blog_1',
    workflowId: 'wf_blog',
    title: 'ChatGPTで副業を始める完全ガイド',
    description:
        'SEOを意識した3,500字の入門記事。H2構成・具体的手順・注意点まで網羅した公開可能なブログ記事。',
    thumbnailUrl:
        'https://placehold.co/800x450/1e5128/dcfce7/png?text=ChatGPT%E5%89%AF%E6%A5%AD',
    previewImageUrl:
        'https://placehold.co/1200x630/1e5128/dcfce7/png?text=OGP%E3%83%97%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC',
    completedOutput:
        'WordPressにそのまま貼れるMarkdown/HTML形式の完成記事（約3,500字）',
    category: '副業',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 60,
    isFeatured: true,
    sortOrder: 0,
  ),
  _buildShowcase(
    id: 'showcase_blog_2',
    workflowId: 'wf_blog',
    title: '在宅ワークの始め方【2026年版】',
    description:
        '検索意図「在宅ワーク 始め方」に対応した比較記事。おすすめサービス5選と選び方を解説。',
    thumbnailUrl:
        'https://placehold.co/800x450/134e4a/ccfbf1/png?text=%E5%9C%A8%E5%AE%85%E3%83%AF%E3%83%BC%E3%82%AF',
    previewImageUrl:
        'https://placehold.co/1200x630/134e4a/ccfbf1/png?text=OGP%E3%83%97%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC',
    completedOutput: 'SEO最適化済み・内部リンク案付きの完成記事（約4,200字）',
    category: 'キャリア',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 75,
    isFeatured: false,
    sortOrder: 1,
  ),
  _buildShowcase(
    id: 'showcase_blog_3',
    workflowId: 'wf_blog',
    title: 'Notionでタスク管理を始める手順',
    description:
        '初心者向けHow-to記事。テンプレート選びから日次運用までステップ形式で解説。',
    thumbnailUrl:
        'https://placehold.co/800x450/312e81/e0e7ff/png?text=Notion%E7%AE%A1%E7%90%86',
    previewImageUrl:
        'https://placehold.co/1200x630/312e81/e0e7ff/png?text=OGP%E3%83%97%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC',
    completedOutput: 'スクリーンショット挿入位置指示付きの完成記事（約2,800字）',
    category: '生産性',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 50,
    isFeatured: false,
    sortOrder: 2,
  ),
  _buildShowcase(
    id: 'showcase_sns_1',
    workflowId: 'wf_sns',
    title: '【保存版】朝のルーティン5ステップ',
    description: 'カルーセル5枚＋キャプション＋ハッシュタグ15個のInstagram投稿セット。',
    thumbnailUrl:
        'https://placehold.co/400x400/fbbf24/78350f/png?text=%E6%9C%9D%E3%83%AB%E3%83%BC%E3%83%81%E3%83%B3',
    previewImageUrl:
        'https://placehold.co/1080x1080/fbbf24/78350f/png?text=%E3%82%AB%E3%83%AB%E3%83%BC%E3%82%BB%E3%83%AB1',
    completedOutput: '1080×1080画像5枚＋2200字以内キャプションの完成投稿セット',
    category: 'ライフスタイル',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 25,
    isFeatured: true,
    sortOrder: 0,
  ),
  _buildShowcase(
    id: 'showcase_sns_2',
    workflowId: 'wf_sns',
    title: 'AIツール比較カルーセル',
    description:
        'ChatGPT vs Claude vs Geminiを1スライド1ポイントで比較する保存版投稿。',
    thumbnailUrl:
        'https://placehold.co/400x400/6366f1/e0e7ff/png?text=AI%E6%AF%94%E8%BC%83',
    previewImageUrl:
        'https://placehold.co/1080x1080/6366f1/e0e7ff/png?text=%E3%82%AB%E3%83%AB%E3%83%BC%E3%82%BB%E3%83%AB1',
    completedOutput: '1080×1080画像6枚＋CTA付きキャプションの完成投稿セット',
    category: 'テック',
    difficulty: ShowcaseDifficulty.normal,
    estimatedTime: 30,
    isFeatured: false,
    sortOrder: 1,
  ),
  _buildShowcase(
    id: 'showcase_sns_3',
    workflowId: 'wf_sns',
    title: '副業で月3万円の3つの方法',
    description: '数字フック＋共感ポイント＋保存誘導のバズ狙い投稿。単一画像＋長文キャプション。',
    thumbnailUrl:
        'https://placehold.co/400x400/be123c/ffe4e6/png?text=%E5%89%AF%E6%A5%AD3%E4%B8%87',
    previewImageUrl:
        'https://placehold.co/1080x1350/be123c/ffe4e6/png?text=%E3%83%95%E3%82%A3%E3%83%BC%E3%83%89%E7%94%BB%E5%83%8F',
    completedOutput: '1080×1350画像1枚＋ハッシュタグ戦略付きキャプションの完成投稿',
    category: '副業',
    difficulty: ShowcaseDifficulty.easy,
    estimatedTime: 20,
    isFeatured: false,
    sortOrder: 2,
  ),
];
