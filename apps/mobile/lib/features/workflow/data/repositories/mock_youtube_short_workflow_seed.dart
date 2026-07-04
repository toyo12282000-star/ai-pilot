import 'package:ai_pilot/features/workflow/domain/entities/prompt_template.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step.dart';

import 'mock_seed_data.dart';

/// 「世界一危険な島3選」Workflow 専用プロンプト（Sprint 18.0）。
final List<PromptTemplate> mockYoutubeShortPromptTemplates = [
  PromptTemplate(
    id: 'prompt_short_islands',
    title: '危険な島3つ提案',
    content:
        '「世界一危険な島3選」のYouTubeショート / TikTok動画向けに、'
        '視聴者の興味を引く危険な島を3つ提案してください。\n'
        '各島について: 島名 / 危険ポイント（1行） / 見た目のインパクト（1行）を含めてください。',
    description: '紹介する3つの島を決める',
    recommendedAiToolId: 'tool_chatgpt',
    variableNames: const [],
    tags: const ['動画', '企画', '雑学'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_short_structure',
    title: 'ショート動画構成',
    content:
        '以下の3つの島を使い、35〜50秒の雑学ショート動画の構成を作ってください。\n'
        '島: {{islands}}\n\n'
        '含めること: 冒頭フック / 3位→2位→1位の順番 / 各ランクの紹介ポイント / 締めのCTA',
    description: '動画の流れを決める',
    recommendedAiToolId: 'tool_chatgpt',
    variableNames: const ['islands'],
    tags: const ['動画', '構成'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_short_script_danger',
    title: '雑学ショート台本',
    content:
        '以下の構成に沿って、35〜50秒で読み上げ可能なショート動画台本を作成してください。\n'
        '構成: {{structure}}\n\n'
        '条件: 話し言葉 / 3位→2位→1位 / 冒頭3秒のフック / 締めに保存CTA',
    description: '台本本文を作る',
    recommendedAiToolId: 'tool_chatgpt',
    variableNames: const ['structure'],
    tags: const ['動画', '台本'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_short_hook',
    title: '冒頭フック改善',
    content:
        '以下の台本の冒頭1〜2文だけを、最初の3秒で視聴者を止める強いフックに書き換えてください。\n'
        '台本全体は書き直さず、冒頭部分のみ改善してください。\n\n'
        '台本: {{script}}',
    description: '冒頭3秒を強化する',
    recommendedAiToolId: 'tool_chatgpt',
    variableNames: const ['script'],
    tags: const ['動画', 'フック'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_short_narration_format',
    title: 'ナレーション原稿整形',
    content:
        '以下の台本を、読み上げやすいナレーション原稿に整えてください。\n'
        '読みやすさを優先し、ひらがな・カタカナ表記、句読点、間、必要に応じた読み仮名を調整してください。\n\n'
        '台本: {{script}}',
    description: '読み上げ用原稿に整える',
    recommendedAiToolId: 'tool_chatgpt',
    variableNames: const ['script'],
    tags: const ['動画', 'ナレーション'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_short_telop',
    title: 'テロップ短文抽出',
    content:
        '以下の台本から、動画に載せる短いテロップ文をシーンごとに抜き出してください。\n'
        '1テロップ10文字前後、一覧形式で出力してください。\n\n'
        '台本: {{script}}',
    description: 'テロップ一覧を作る',
    recommendedAiToolId: 'tool_chatgpt',
    variableNames: const ['script'],
    tags: const ['動画', 'テロップ'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
  PromptTemplate(
    id: 'prompt_short_assets',
    title: '素材リスト作成',
    content:
        '以下の台本とテロップ一覧から、各シーンで必要な画像 / 映像素材のリストを作成してください。\n'
        '素材は自分で集めても、画像生成AIで作ってもOKです。\n\n'
        '台本: {{script}}\n'
        'テロップ: {{telops}}',
    description: '必要素材を洗い出す',
    recommendedAiToolId: 'tool_chatgpt',
    variableNames: const ['script', 'telops'],
    tags: const ['動画', '素材'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  ),
];

/// Sprint 18.0 · 16 Step 構成。
final List<WorkflowStep> mockYoutubeShortSteps = [
  WorkflowStep(
    id: 'step_short_1',
    workflowId: 'wf_youtube_short',
    order: 1,
    title: '動画テーマを確認する',
    instruction: '今回作る動画のテーマと完成イメージを確認しましょう。',
    description:
        '今回は「世界一危険な島3選」の雑学ショート動画を作ります。'
        '35〜50秒、冒頭フック→3位→2位→1位→締めの構成です。',
  ),
  WorkflowStep(
    id: 'step_short_2',
    workflowId: 'wf_youtube_short',
    order: 2,
    title: '紹介する3つの島を決める',
    instruction: 'ChatGPTで危険な島を3つ提案させ、紹介する島を確定しましょう。',
    description: '危険度だけでなく、見た目のインパクトがある島を選ぶとショート向きです。',
    promptTemplateId: 'prompt_short_islands',
    aiToolId: 'tool_chatgpt',
  ),
  WorkflowStep(
    id: 'step_short_3',
    workflowId: 'wf_youtube_short',
    order: 3,
    title: '動画の流れを決める',
    instruction: '決めた3つの島で、3位→2位→1位の全体構成を作りましょう。',
    promptTemplateId: 'prompt_short_structure',
    aiToolId: 'tool_chatgpt',
  ),
  WorkflowStep(
    id: 'step_short_4',
    workflowId: 'wf_youtube_short',
    order: 4,
    title: 'ショート動画の台本を作る',
    instruction: '構成メモをもとに、35〜50秒の読み上げ用台本を作りましょう。',
    description: 'ここで動画の土台になる台本を作ります。まずはそのままプロンプトを使ってみましょう。',
    promptTemplateId: 'prompt_short_script_danger',
    aiToolId: 'tool_chatgpt',
  ),
  WorkflowStep(
    id: 'step_short_5',
    workflowId: 'wf_youtube_short',
    order: 5,
    title: '冒頭3秒のフックを強くする',
    instruction: '台本の冒頭1〜2文だけを、視聴者が止まるフックに改善しましょう。',
    promptTemplateId: 'prompt_short_hook',
    aiToolId: 'tool_chatgpt',
  ),
  WorkflowStep(
    id: 'step_short_6',
    workflowId: 'wf_youtube_short',
    order: 6,
    title: 'ナレーション用の原稿に整える',
    instruction: '台本を読み上げツールで使いやすい原稿に整えましょう。',
    description:
        '読み上げツール（ElevenLabs / VOICEVOX など）に貼り付けて使える形にします。',
    promptTemplateId: 'prompt_short_narration_format',
    aiToolId: 'tool_chatgpt',
  ),
  WorkflowStep(
    id: 'step_short_7',
    workflowId: 'wf_youtube_short',
    order: 7,
    title: 'テロップ用の短文を抜き出す',
    instruction: '各シーンで載せる短いテロップ文を一覧にしましょう。',
    promptTemplateId: 'prompt_short_telop',
    aiToolId: 'tool_chatgpt',
  ),
  WorkflowStep(
    id: 'step_short_8',
    workflowId: 'wf_youtube_short',
    order: 8,
    title: '読み上げ音声を作る',
    instruction: 'ナレーション原稿を、使う読み上げツールで音声化しましょう。',
    description:
        'ElevenLabs / VOICEVOX など、使う読み上げツールで音声化しましょう。'
        '声の違いで印象も変わるので、まずは1回試してみましょう。',
    aiToolId: 'tool_elevenlabs',
  ),
  WorkflowStep(
    id: 'step_short_9',
    workflowId: 'wf_youtube_short',
    order: 9,
    title: '動画の尺を確認する',
    instruction: 'できた音声の長さを確認し、完成動画の想定尺を把握しましょう。',
    description: '目安: 35〜50秒。長すぎる場合はStep 4〜6で台本を短く調整します。',
  ),
  WorkflowStep(
    id: 'step_short_10',
    workflowId: 'wf_youtube_short',
    order: 10,
    title: '必要な素材を洗い出す',
    instruction: '各シーンで必要な画像 / 映像素材をリストアップしましょう。',
    description: '素材は自分で集めても、画像生成AIで作ってもOKです。',
    promptTemplateId: 'prompt_short_assets',
    aiToolId: 'tool_chatgpt',
  ),
  WorkflowStep(
    id: 'step_short_11',
    workflowId: 'wf_youtube_short',
    order: 11,
    title: '画像・映像素材を集める',
    instruction: '3島分の素材を実際に揃えましょう。',
    description:
        'フリー素材サイトで探してもOK、画像生成AIで作ってもOK。'
        '最低限、3島分それぞれ1枚以上あれば進められます。',
  ),
  WorkflowStep(
    id: 'step_short_12',
    workflowId: 'wf_youtube_short',
    order: 12,
    title: 'BGM / SE を決める',
    instruction: '動画の雰囲気に合うBGM（効果音があれば尚良し）を1つ決めましょう。',
    description: 'CapCut内蔵音源やYouTubeオーディオライブラリなど、無料素材でOKです。',
  ),
  WorkflowStep(
    id: 'step_short_13',
    workflowId: 'wf_youtube_short',
    order: 13,
    title: 'CapCutに音声を入れて土台を作る',
    instruction: '編集は音声から。まずは映像より先に音声をタイムラインへ入れましょう。',
    description: '9:16（縦型）の新規プロジェクトを作成し、ナレーション音声を配置します。',
    aiToolId: 'tool_capcut',
  ),
  WorkflowStep(
    id: 'step_short_14',
    workflowId: 'wf_youtube_short',
    order: 14,
    title: '素材をシーンごとに配置する',
    instruction: '各セリフに対応する映像 / 画像をタイムラインに配置しましょう。',
    aiToolId: 'tool_capcut',
  ),
  WorkflowStep(
    id: 'step_short_15',
    workflowId: 'wf_youtube_short',
    order: 15,
    title: 'テロップを入れる',
    instruction: 'Step 7で作ったテロップ一覧を参考に、主要なセリフにテロップを入れましょう。',
    aiToolId: 'tool_capcut',
  ),
  WorkflowStep(
    id: 'step_short_16',
    workflowId: 'wf_youtube_short',
    order: 16,
    title: 'BGM・SE・最終調整をして書き出す',
    instruction: 'BGMの音量を調整し、1080×1920の縦型動画として書き出しましょう。',
    description: 'ナレーションよりBGMが大きくならないよう注意してください。',
    aiToolId: 'tool_capcut',
  ),
];

/// Sprint 18.0 · Workflow メタデータ。
Workflow buildYoutubeShortWorkflow() {
  return Workflow(
    id: 'wf_youtube_short',
    title: '世界一危険な島3選',
    description:
        '企画から台本、ナレーション、素材、CapCut編集まで。'
        '35〜50秒の雑学ショート動画を16ステップで完成させます。',
    categoryId: 'cat_video',
    estimatedMinutes: 78,
    tags: const ['YouTube', 'TikTok', '雑学', 'ショート'],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
    steps: mockYoutubeShortSteps,
  );
}
