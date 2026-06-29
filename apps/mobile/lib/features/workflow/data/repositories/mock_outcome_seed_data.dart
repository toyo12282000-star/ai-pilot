import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool_alternative.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_variant.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_outcome.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step_tool_option.dart';

/// Mock Workflow Outcome 一覧。
final List<WorkflowOutcome> mockWorkflowOutcomes = [
  WorkflowOutcome(
    id: 'outcome_youtube_short',
    workflowId: 'wf_youtube_short',
    title: '60秒のYouTubeショート動画',
    description: '企画から編集まで、ショート動画1本が完成します',
    outcomeType: OutcomeType.video,
    expectedResult: '投稿可能な縦型ショート動画が1本完成する',
    targetUsers: ['動画初心者', 'YouTubeを始めたい人'],
    useCases: ['YouTubeデビュー', 'SNS拡散'],
    sortOrder: 0,
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  WorkflowOutcome(
    id: 'outcome_blog',
    workflowId: 'wf_blog',
    title: 'SEOを意識したブログ記事',
    description: '構成から本文まで、公開可能な記事が完成します',
    outcomeType: OutcomeType.article,
    expectedResult: 'そのまま公開できるブログ記事1本が完成する',
    targetUsers: ['ブログ初心者'],
    useCases: ['情報発信', '副業'],
    sortOrder: 0,
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  WorkflowOutcome(
    id: 'outcome_research',
    workflowId: 'wf_research',
    title: '調査レポート・営業資料',
    description: '調査結果を整理したレポートが完成します',
    outcomeType: OutcomeType.slide,
    expectedResult: '根拠付きの調査レポートが完成する',
    targetUsers: ['ビジネスパーソン', '資料を作りたい人'],
    useCases: ['営業資料', '社内提案'],
    sortOrder: 0,
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
];

/// Mock Step ツール候補。
final List<WorkflowStepToolOption> mockWorkflowStepToolOptions = [
  WorkflowStepToolOption(
    id: 'step_tool_short_1_chatgpt',
    workflowStepId: 'step_short_1',
    aiToolId: 'tool_chatgpt',
    isRecommended: true,
    recommendationReason: '企画案の壁打ちに最適',
    difficulty: StepToolDifficulty.easy,
    pricingNote: '無料プランあり',
    sortOrder: 0,
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  WorkflowStepToolOption(
    id: 'step_tool_short_1_claude',
    workflowStepId: 'step_short_1',
    aiToolId: 'tool_claude',
    isRecommended: false,
    recommendationReason: 'より長い企画文が必要な場合',
    difficulty: StepToolDifficulty.normal,
    sortOrder: 1,
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  WorkflowStepToolOption(
    id: 'step_tool_research_1_perplexity',
    workflowStepId: 'step_research_1',
    aiToolId: 'tool_perplexity',
    isRecommended: true,
    recommendationReason: '最新情報の調査に強い',
    difficulty: StepToolDifficulty.easy,
    sortOrder: 0,
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
];

/// Mock プロンプトバリエーション。
final List<PromptVariant> mockPromptVariants = [
  PromptVariant(
    id: 'variant_short_1_beginner',
    workflowStepId: 'step_short_1',
    promptTemplateId: 'prompt_short_idea',
    title: '初心者向け企画プロンプト',
    variantType: PromptVariantType.beginner,
    content: 'テーマ「{{theme}}」でYouTubeショートの企画案を3つ、初心者向けに簡潔に提案してください。',
    expectedOutput: '3つの企画案（タイトル + 概要）',
    usageTips: 'テーマは具体的なジャンル名を入れると精度が上がります',
    variables: ['theme'],
    sortOrder: 0,
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptVariant(
    id: 'variant_short_1_quality',
    workflowStepId: 'step_short_1',
    title: '高品質企画プロンプト',
    variantType: PromptVariantType.highQuality,
    content:
        'テーマ「{{theme}}」について、視聴維持率を意識したYouTubeショート企画を5つ。フック・構成・CTAまで詳細に。',
    expectedOutput: '詳細な企画書5件',
    variables: ['theme'],
    sortOrder: 1,
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptVariant(
    id: 'variant_short_1_short',
    workflowStepId: 'step_short_1',
    title: '時短企画プロンプト',
    variantType: PromptVariantType.shortTime,
    content: 'テーマ「{{theme}}」のYouTubeショート企画を1つだけ、30秒以内で作れる内容で提案して。',
    expectedOutput: '即実行可能な企画1件',
    variables: ['theme'],
    sortOrder: 2,
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptVariant(
    id: 'variant_research_1_beginner',
    workflowStepId: 'step_research_1',
    promptTemplateId: 'prompt_research_query',
    title: '初心者向け調査プロンプト',
    variantType: PromptVariantType.beginner,
    content: '「{{subject}}」について、初心者でも理解できる調査クエリを5つ提案してください。',
    expectedOutput: '調査クエリ5件',
    variables: ['subject'],
    sortOrder: 0,
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
];

/// Mock AI ツール代替候補。
final List<AIToolAlternative> mockAIToolAlternatives = [
  AIToolAlternative(
    aiToolId: 'tool_chatgpt',
    alternativeAiToolId: 'tool_claude',
    reason: '長文生成や丁寧な文体が必要な場合',
    sortOrder: 0,
  ),
  AIToolAlternative(
    aiToolId: 'tool_chatgpt',
    alternativeAiToolId: 'tool_gemini',
    reason: 'Google 連携やマルチモーダルが必要な場合',
    sortOrder: 1,
  ),
  AIToolAlternative(
    aiToolId: 'tool_claude',
    alternativeAiToolId: 'tool_chatgpt',
    reason: '汎用的な壁打ちやアイデア出し',
    sortOrder: 0,
  ),
];
