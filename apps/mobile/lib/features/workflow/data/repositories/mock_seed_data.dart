import 'package:ai_pilot/features/workflow/domain/entities/ai_tool.dart';
import 'package:ai_pilot/features/workflow/domain/entities/category.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_template.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';
import 'package:ai_pilot/features/favorite/domain/entities/favorite.dart';
import 'package:ai_pilot/features/profile/domain/entities/user_profile.dart';

/// Mock Repository 共通の擬似ネットワーク遅延。
const Duration mockNetworkDelay = Duration(milliseconds: 300);

/// Mock 用固定日時。
final DateTime mockBaseDate = DateTime(2026, 1, 15);

/// Mock カテゴリ一覧。
final List<Category> mockCategories = [
  Category(
    id: 'cat_video',
    name: '動画制作',
    description: '動画・ショート動画の企画から編集まで',
    sortOrder: 1,
    iconName: 'video',
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  Category(
    id: 'cat_writing',
    name: '文章作成',
    description: 'ブログ・SNS・記事などの文章制作',
    sortOrder: 2,
    iconName: 'edit',
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  Category(
    id: 'cat_image',
    name: '画像生成',
    description: 'サムネイル・イラスト・ビジュアル素材の作成',
    sortOrder: 3,
    iconName: 'image',
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  Category(
    id: 'cat_research',
    name: '調査',
    description: '情報収集・調査・レポート作成',
    sortOrder: 4,
    iconName: 'search',
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  Category(
    id: 'cat_dev',
    name: '開発',
    description: 'アプリ・Web 開発の AI 活用',
    sortOrder: 5,
    iconName: 'code',
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
];

/// Mock AI ツール一覧。
final List<AITool> mockAITools = [
  AITool(
    id: 'tool_chatgpt',
    name: 'ChatGPT',
    type: AIToolType.chat,
    description: 'OpenAI の対話型 AI',
    url: 'https://chat.openai.com',
    iconName: 'chatgpt',
  ),
  AITool(
    id: 'tool_claude',
    name: 'Claude',
    type: AIToolType.chat,
    description: 'Anthropic の対話型 AI',
    url: 'https://claude.ai',
    iconName: 'claude',
  ),
  AITool(
    id: 'tool_gemini',
    name: 'Gemini',
    type: AIToolType.chat,
    description: 'Google の対話型 AI',
    url: 'https://gemini.google.com',
    iconName: 'gemini',
  ),
  AITool(
    id: 'tool_perplexity',
    name: 'Perplexity',
    type: AIToolType.chat,
    description: 'AI 検索・調査ツール',
    url: 'https://www.perplexity.ai',
    iconName: 'perplexity',
  ),
  AITool(
    id: 'tool_canva',
    name: 'Canva',
    type: AIToolType.image,
    description: 'デザイン・画像作成ツール',
    url: 'https://www.canva.com',
    iconName: 'canva',
  ),
  AITool(
    id: 'tool_elevenlabs',
    name: 'ElevenLabs',
    type: AIToolType.audio,
    description: 'AI 音声合成ツール',
    url: 'https://elevenlabs.io',
    iconName: 'elevenlabs',
  ),
  AITool(
    id: 'tool_capcut',
    name: 'CapCut',
    type: AIToolType.other,
    description: '動画編集ツール',
    url: 'https://www.capcut.com',
    iconName: 'capcut',
  ),
  AITool(
    id: 'tool_cursor',
    name: 'Cursor',
    type: AIToolType.code,
    description: 'AI 搭載コードエディタ',
    url: 'https://cursor.com',
    iconName: 'cursor',
  ),
  AITool(
    id: 'tool_ideogram',
    name: 'Ideogram',
    type: AIToolType.image,
    description: 'テキストから高品質な画像・ロゴを生成',
    url: 'https://ideogram.ai',
    iconName: 'ideogram',
  ),
  AITool(
    id: 'tool_vrew',
    name: 'Vrew',
    type: AIToolType.other,
    description: 'テキストから自動で字幕付き動画を生成',
    url: 'https://vrew.voyagerx.com',
    iconName: 'vrew',
  ),
  AITool(
    id: 'tool_voicevox',
    name: 'VOICEVOX',
    type: AIToolType.audio,
    description: '無料の日本語 AI 音声合成',
    url: 'https://voicevox.hiroshiba.jp',
    iconName: 'voicevox',
  ),
];

/// Mock プロンプトテンプレート一覧。
final List<PromptTemplate> mockPromptTemplates = [
  PromptTemplate(
    id: 'prompt_short_idea',
    title: 'ショート動画アイデア生成',
    content:
        'テーマ「{{theme}}」について、YouTubeショート向けの企画案を5つ提案してください。',
    description: '動画の企画段階で使用',
    recommendedAiToolId: 'tool_chatgpt',
    variableNames: ['theme'],
    tags: ['動画', '企画'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_short_script',
    title: 'ショート動画台本作成',
    content: '以下の企画案から、60秒以内の台本を作成してください。\n企画: {{idea}}',
    recommendedAiToolId: 'tool_claude',
    variableNames: ['idea'],
    tags: ['動画', '台本'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_blog_outline',
    title: 'ブログ記事構成',
    content: '「{{topic}}」について、SEOを意識したブログ記事の見出し構成を作成してください。',
    recommendedAiToolId: 'tool_chatgpt',
    variableNames: ['topic'],
    tags: ['ブログ', '構成'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_blog_body',
    title: 'ブログ本文執筆',
    content: '以下の見出し構成に沿って、読みやすいブログ記事本文を執筆してください。\n{{outline}}',
    recommendedAiToolId: 'tool_claude',
    variableNames: ['outline'],
    tags: ['ブログ', '執筆'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_sns_caption',
    title: 'SNS投稿文作成',
    content:
        '{{platform}}向けの投稿文を3パターン作成してください。トーン: {{tone}}',
    recommendedAiToolId: 'tool_gemini',
    variableNames: ['platform', 'tone'],
    tags: ['SNS', '投稿'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_sns_image',
    title: 'SNS用ビジュアル指示',
    content: '以下の投稿文に合う画像の Canva デザイン指示を作成してください。\n{{caption}}',
    recommendedAiToolId: 'tool_canva',
    variableNames: ['caption'],
    tags: ['SNS', '画像'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_research_query',
    title: '調査クエリ設計',
    content: '「{{subject}}」について調査するための検索クエリを10個提案してください。',
    recommendedAiToolId: 'tool_perplexity',
    variableNames: ['subject'],
    tags: ['調査', '検索'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_research_report',
    title: '調査レポート作成',
    content: '以下の調査結果をもとに、要点を整理したレポートを作成してください。\n{{findings}}',
    recommendedAiToolId: 'tool_claude',
    variableNames: ['findings'],
    tags: ['調査', 'レポート'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_app_spec',
    title: 'アプリ仕様整理',
    content:
        '「{{appName}}」の MVP 機能一覧と画面構成を整理してください。目的: {{goal}}',
    recommendedAiToolId: 'tool_chatgpt',
    variableNames: ['appName', 'goal'],
    tags: ['開発', '仕様'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_app_implement',
    title: 'Flutter 実装支援',
    content:
        '以下の仕様に基づき、Flutter の Widget 構成と実装方針を提案してください。\n{{spec}}',
    recommendedAiToolId: 'tool_cursor',
    variableNames: ['spec'],
    tags: ['開発', 'Flutter'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_video_narration',
    title: 'ナレーション原稿',
    content: '以下の台本から、ElevenLabs 用のナレーション原稿を作成してください。\n{{script}}',
    recommendedAiToolId: 'tool_elevenlabs',
    variableNames: ['script'],
    tags: ['動画', '音声'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_video_edit',
    title: '動画編集指示',
    content: '以下の素材リストから、CapCut での編集手順をステップ形式で作成してください。\n{{assets}}',
    recommendedAiToolId: 'tool_capcut',
    variableNames: ['assets'],
    tags: ['動画', '編集'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
];

/// Mock ワークフロー一覧。
final List<Workflow> mockWorkflows = [
  Workflow(
    id: 'wf_youtube_short',
    title: 'YouTubeショートを作る',
    description: '企画から台本、ナレーション、編集までの一連の手順',
    categoryId: 'cat_video',
    estimatedMinutes: 45,
    tags: ['YouTube', 'ショート', '動画'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
    steps: [
      WorkflowStep(
        id: 'step_short_1',
        workflowId: 'wf_youtube_short',
        order: 1,
        title: '企画を考える',
        instruction: 'テーマを決め、ChatGPT で企画案を生成してください。',
        promptTemplateId: 'prompt_short_idea',
        aiToolId: 'tool_chatgpt',
      ),
      WorkflowStep(
        id: 'step_short_2',
        workflowId: 'wf_youtube_short',
        order: 2,
        title: '台本を作成する',
        instruction: '企画案をもとに Claude で台本を作成してください。',
        promptTemplateId: 'prompt_short_script',
        aiToolId: 'tool_claude',
      ),
      WorkflowStep(
        id: 'step_short_3',
        workflowId: 'wf_youtube_short',
        order: 3,
        title: 'ナレーションを生成する',
        instruction: 'ElevenLabs でナレーション音声を生成してください。',
        promptTemplateId: 'prompt_video_narration',
        aiToolId: 'tool_elevenlabs',
      ),
      WorkflowStep(
        id: 'step_short_4',
        workflowId: 'wf_youtube_short',
        order: 4,
        title: '動画を編集する',
        instruction: 'CapCut で素材を組み合わせて仕上げてください。',
        promptTemplateId: 'prompt_video_edit',
        aiToolId: 'tool_capcut',
      ),
    ],
  ),
  Workflow(
    id: 'wf_blog',
    title: 'ブログ記事を書く',
    description: 'テーマ設定から構成、本文執筆までの執筆フロー',
    categoryId: 'cat_writing',
    estimatedMinutes: 60,
    tags: ['ブログ', 'SEO', '記事'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
    steps: [
      WorkflowStep(
        id: 'step_blog_1',
        workflowId: 'wf_blog',
        order: 1,
        title: '記事構成を作る',
        instruction: 'ChatGPT で見出し構成を作成してください。',
        promptTemplateId: 'prompt_blog_outline',
        aiToolId: 'tool_chatgpt',
      ),
      WorkflowStep(
        id: 'step_blog_2',
        workflowId: 'wf_blog',
        order: 2,
        title: '本文を執筆する',
        instruction: 'Claude で本文を執筆してください。',
        promptTemplateId: 'prompt_blog_body',
        aiToolId: 'tool_claude',
      ),
    ],
  ),
  Workflow(
    id: 'wf_sns',
    title: 'SNS投稿を作る',
    description: '投稿文とビジュアルをセットで作成するフロー',
    categoryId: 'cat_image',
    estimatedMinutes: 30,
    tags: ['SNS', 'Instagram', 'X'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
    steps: [
      WorkflowStep(
        id: 'step_sns_1',
        workflowId: 'wf_sns',
        order: 1,
        title: '投稿文を作成する',
        instruction: 'Gemini でプラットフォーム別の投稿文を作成してください。',
        promptTemplateId: 'prompt_sns_caption',
        aiToolId: 'tool_gemini',
      ),
      WorkflowStep(
        id: 'step_sns_2',
        workflowId: 'wf_sns',
        order: 2,
        title: 'ビジュアルを作成する',
        instruction: 'Canva で投稿用ビジュアルを作成してください。',
        promptTemplateId: 'prompt_sns_image',
        aiToolId: 'tool_canva',
      ),
    ],
  ),
  Workflow(
    id: 'wf_research',
    title: '調査レポートを作る',
    description: 'テーマ調査からレポート執筆までの調査フロー',
    categoryId: 'cat_research',
    estimatedMinutes: 50,
    tags: ['調査', 'レポート', 'リサーチ'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
    steps: [
      WorkflowStep(
        id: 'step_research_1',
        workflowId: 'wf_research',
        order: 1,
        title: '調査クエリを設計する',
        instruction: 'Perplexity で調査クエリを設計・実行してください。',
        promptTemplateId: 'prompt_research_query',
        aiToolId: 'tool_perplexity',
      ),
      WorkflowStep(
        id: 'step_research_2',
        workflowId: 'wf_research',
        order: 2,
        title: 'レポートを執筆する',
        instruction: 'Claude で調査結果をレポートにまとめてください。',
        promptTemplateId: 'prompt_research_report',
        aiToolId: 'tool_claude',
      ),
    ],
  ),
  Workflow(
    id: 'wf_flutter_app',
    title: 'Flutterアプリを作る',
    description: '仕様整理から Cursor を使った実装までの開発フロー',
    categoryId: 'cat_dev',
    estimatedMinutes: 120,
    tags: ['Flutter', '開発', 'アプリ'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
    steps: [
      WorkflowStep(
        id: 'step_dev_1',
        workflowId: 'wf_flutter_app',
        order: 1,
        title: '仕様を整理する',
        instruction: 'ChatGPT で MVP の機能と画面構成を整理してください。',
        promptTemplateId: 'prompt_app_spec',
        aiToolId: 'tool_chatgpt',
      ),
      WorkflowStep(
        id: 'step_dev_2',
        workflowId: 'wf_flutter_app',
        order: 2,
        title: '実装方針を決める',
        instruction: 'Cursor で Widget 構成と実装方針を提案してください。',
        promptTemplateId: 'prompt_app_implement',
        aiToolId: 'tool_cursor',
      ),
    ],
  ),
];

/// Mock ユーザープロフィール。
final UserProfile mockCurrentUser = UserProfile(
  id: 'user-1',
  displayName: 'AI Pilot ユーザー',
  email: 'demo@ai-pilot.app',
  createdAt: mockBaseDate,
  updatedAt: mockBaseDate,
);

/// Mock お気に入り初期データ。
final List<Favorite> mockInitialFavorites = [
  Favorite(
    id: 'fav-1',
    userId: 'user-1',
    workflowId: 'wf_youtube_short',
    createdAt: mockBaseDate,
  ),
  Favorite(
    id: 'fav-2',
    userId: 'user-1',
    workflowId: 'wf_flutter_app',
    createdAt: mockBaseDate,
  ),
];

/// ID から [PromptTemplate] を取得する（Mock 内部用）。
PromptTemplate? findMockPromptTemplateById(String id) {
  for (final template in mockPromptTemplates) {
    if (template.id == id) {
      return template;
    }
  }
  return null;
}
