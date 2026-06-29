-- AI Pilot showcase foundation (Sprint 12.4)
-- Completed-work sample library for 3 workflows.
-- Requires: 002_seed_initial_data.sql

-- Fixed UUID scheme (Sprint 12.4):
--   workflow_showcases  90000000-0000-4000-8000-00000000000x
--   showcase_tags       91000000-0000-4000-8000-00000000000x
--   showcase_assets     92000000-0000-4000-8000-00000000000x

-- ---------------------------------------------------------------------------
-- workflow_showcases
-- ---------------------------------------------------------------------------

CREATE TABLE public.workflow_showcases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workflow_id uuid NOT NULL REFERENCES public.workflows (id) ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  thumbnail_url text,
  preview_image_url text,
  preview_video_url text,
  completed_output text,
  category text,
  difficulty text CHECK (difficulty IN ('easy', 'normal', 'hard')),
  estimated_time int,
  is_featured boolean NOT NULL DEFAULT false,
  sort_order int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX workflow_showcases_workflow_id_idx
  ON public.workflow_showcases (workflow_id);

CREATE INDEX workflow_showcases_is_featured_idx
  ON public.workflow_showcases (is_featured)
  WHERE is_featured = true;

CREATE INDEX workflow_showcases_category_idx
  ON public.workflow_showcases (category);

CREATE TRIGGER workflow_showcases_set_updated_at
  BEFORE UPDATE ON public.workflow_showcases
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- ---------------------------------------------------------------------------
-- showcase_tags
-- ---------------------------------------------------------------------------

CREATE TABLE public.showcase_tags (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  showcase_id uuid NOT NULL REFERENCES public.workflow_showcases (id) ON DELETE CASCADE,
  tag text NOT NULL,
  UNIQUE (showcase_id, tag)
);

CREATE INDEX showcase_tags_showcase_id_idx
  ON public.showcase_tags (showcase_id);

-- ---------------------------------------------------------------------------
-- showcase_assets
-- ---------------------------------------------------------------------------

CREATE TABLE public.showcase_assets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  showcase_id uuid NOT NULL REFERENCES public.workflow_showcases (id) ON DELETE CASCADE,
  asset_type text NOT NULL CHECK (
    asset_type IN ('image', 'video', 'article', 'slide', 'prompt')
  ),
  url text,
  title text,
  sort_order int NOT NULL DEFAULT 0
);

CREATE INDEX showcase_assets_showcase_id_idx
  ON public.showcase_assets (showcase_id);

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------

ALTER TABLE public.workflow_showcases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.showcase_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.showcase_assets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read access"
  ON public.workflow_showcases
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Public read access"
  ON public.showcase_tags
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Public read access"
  ON public.showcase_assets
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Admins can manage workflow_showcases"
  ON public.workflow_showcases
  FOR ALL
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));

CREATE POLICY "Admins can manage showcase_tags"
  ON public.showcase_tags
  FOR ALL
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));

CREATE POLICY "Admins can manage showcase_assets"
  ON public.showcase_assets
  FOR ALL
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));

-- ---------------------------------------------------------------------------
-- Seed: YouTubeショート (3)
-- ---------------------------------------------------------------------------

INSERT INTO public.workflow_showcases (
  id, workflow_id, title, description,
  thumbnail_url, preview_image_url, preview_video_url, completed_output,
  category, difficulty, estimated_time, is_featured, sort_order,
  created_at, updated_at
) VALUES
  (
    '90000000-0000-4000-8000-000000000001',
    '40000000-0000-4000-8000-000000000001',
    '世界一危険な島3選',
    '60秒で「行ってはいけない島」を3つ紹介するYouTubeショート。冒頭フック→島ごとの恐怖ポイント→保存CTAの定番構成。',
    'https://placehold.co/400x711/1a1a2e/eaeaea/png?text=%E5%8D%B1%E9%99%A9%E3%81%AA%E5%B3%B6',
    'https://placehold.co/1080x1920/1a1a2e/eaeaea/png?text=%E5%B1%B1%E5%B3%B6%E3%83%97%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC',
    'https://example.com/showcase/youtube/dangerous-islands.mp4',
    '9:16縦型・58秒・テロップ付き・BGM付きの完成ショート動画',
    'エンタメ',
    'easy',
    40,
    true,
    0,
    '2026-01-15T00:00:00+00',
    '2026-01-15T00:00:00+00'
  ),
  (
    '90000000-0000-4000-8000-000000000002',
    '40000000-0000-4000-8000-000000000001',
    'ドラッグストア化粧水3選',
    'プチプラコスメの比較ショート。価格・成分・使い心地を3本で紹介し、保存・コメントを促す構成。',
    'https://placehold.co/400x711/2d1b4e/f5e6ff/png?text=%E5%8C%96%E7%B2%A7%E6%B0%B4',
    'https://placehold.co/1080x1920/2d1b4e/f5e6ff/png?text=%E3%82%B3%E3%82%B9%E3%83%A1%E3%83%97%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC',
    'https://example.com/showcase/youtube/drugstore-toner.mp4',
    '9:16縦型・55秒・商品名テロップ・価格表示入りの完成ショート',
    'ライフハック',
    'normal',
    45,
    false,
    1,
    '2026-01-15T00:00:00+00',
    '2026-01-15T00:00:00+00'
  ),
  (
    '90000000-0000-4000-8000-000000000003',
    '40000000-0000-4000-8000-000000000001',
    '世界の変な法律3選',
    '「知らないとヤバい」系の雑学ショート。国名→法律→理由の3段構成で視聴維持率を意識。',
    'https://placehold.co/400x711/0f3460/e94560/png?text=%E5%A4%89%E3%81%AA%E6%B3%95%E5%BE%8B',
    'https://placehold.co/1080x1920/0f3460/e94560/png?text=%E9%9B%91%E5%AD%A6%E3%83%97%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC',
    'https://example.com/showcase/youtube/weird-laws.mp4',
    '9:16縦型・60秒・国旗素材＋テロップの完成ショート',
    '雑学',
    'easy',
    35,
    false,
    2,
    '2026-01-15T00:00:00+00',
    '2026-01-15T00:00:00+00'
  )
ON CONFLICT (id) DO UPDATE SET
  workflow_id = EXCLUDED.workflow_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  thumbnail_url = EXCLUDED.thumbnail_url,
  preview_image_url = EXCLUDED.preview_image_url,
  preview_video_url = EXCLUDED.preview_video_url,
  completed_output = EXCLUDED.completed_output,
  category = EXCLUDED.category,
  difficulty = EXCLUDED.difficulty,
  estimated_time = EXCLUDED.estimated_time,
  is_featured = EXCLUDED.is_featured,
  sort_order = EXCLUDED.sort_order,
  updated_at = now();

-- ---------------------------------------------------------------------------
-- Seed: ブログ記事 (3)
-- ---------------------------------------------------------------------------

INSERT INTO public.workflow_showcases (
  id, workflow_id, title, description,
  thumbnail_url, preview_image_url, preview_video_url, completed_output,
  category, difficulty, estimated_time, is_featured, sort_order,
  created_at, updated_at
) VALUES
  (
    '90000000-0000-4000-8000-000000000004',
    '40000000-0000-4000-8000-000000000002',
    'ChatGPTで副業を始める完全ガイド',
    'SEOを意識した3,500字の入門記事。H2構成・具体的手順・注意点まで網羅した公開可能なブログ記事。',
    'https://placehold.co/800x450/1e5128/dcfce7/png?text=ChatGPT%E5%89%AF%E6%A5%AD',
    'https://placehold.co/1200x630/1e5128/dcfce7/png?text=OGP%E3%83%97%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC',
    NULL,
    'WordPressにそのまま貼れるMarkdown/HTML形式の完成記事（約3,500字）',
    '副業',
    'normal',
    60,
    true,
    0,
    '2026-01-15T00:00:00+00',
    '2026-01-15T00:00:00+00'
  ),
  (
    '90000000-0000-4000-8000-000000000005',
    '40000000-0000-4000-8000-000000000002',
    '在宅ワークの始め方【2026年版】',
    '検索意図「在宅ワーク 始め方」に対応した比較記事。おすすめサービス5選と選び方を解説。',
    'https://placehold.co/800x450/134e4a/ccfbf1/png?text=%E5%9C%A8%E5%AE%85%E3%83%AF%E3%83%BC%E3%82%AF',
    'https://placehold.co/1200x630/134e4a/ccfbf1/png?text=OGP%E3%83%97%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC',
    NULL,
    'SEO最適化済み・内部リンク案付きの完成記事（約4,200字）',
    'キャリア',
    'normal',
    75,
    false,
    1,
    '2026-01-15T00:00:00+00',
    '2026-01-15T00:00:00+00'
  ),
  (
    '90000000-0000-4000-8000-000000000006',
    '40000000-0000-4000-8000-000000000002',
    'Notionでタスク管理を始める手順',
    '初心者向けHow-to記事。テンプレート選びから日次運用までステップ形式で解説。',
    'https://placehold.co/800x450/312e81/e0e7ff/png?text=Notion%E7%AE%A1%E7%90%86',
    'https://placehold.co/1200x630/312e81/e0e7ff/png?text=OGP%E3%83%97%E3%83%AC%E3%83%93%E3%83%A5%E3%83%BC',
    NULL,
    'スクリーンショット挿入位置指示付きの完成記事（約2,800字）',
    '生産性',
    'easy',
    50,
    false,
    2,
    '2026-01-15T00:00:00+00',
    '2026-01-15T00:00:00+00'
  )
ON CONFLICT (id) DO UPDATE SET
  workflow_id = EXCLUDED.workflow_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  thumbnail_url = EXCLUDED.thumbnail_url,
  preview_image_url = EXCLUDED.preview_image_url,
  preview_video_url = EXCLUDED.preview_video_url,
  completed_output = EXCLUDED.completed_output,
  category = EXCLUDED.category,
  difficulty = EXCLUDED.difficulty,
  estimated_time = EXCLUDED.estimated_time,
  is_featured = EXCLUDED.is_featured,
  sort_order = EXCLUDED.sort_order,
  updated_at = now();

-- ---------------------------------------------------------------------------
-- Seed: Instagram投稿 (3)
-- ---------------------------------------------------------------------------

INSERT INTO public.workflow_showcases (
  id, workflow_id, title, description,
  thumbnail_url, preview_image_url, preview_video_url, completed_output,
  category, difficulty, estimated_time, is_featured, sort_order,
  created_at, updated_at
) VALUES
  (
    '90000000-0000-4000-8000-000000000007',
    '40000000-0000-4000-8000-000000000003',
    '【保存版】朝のルーティン5ステップ',
    'カルーセル5枚＋キャプション＋ハッシュタグ15個のInstagram投稿セット。',
    'https://placehold.co/400x400/fbbf24/78350f/png?text=%E6%9C%9D%E3%83%AB%E3%83%BC%E3%83%81%E3%83%B3',
    'https://placehold.co/1080x1080/fbbf24/78350f/png?text=%E3%82%AB%E3%83%AB%E3%83%BC%E3%82%BB%E3%83%AB1',
    NULL,
    '1080×1080画像5枚＋2200字以内キャプションの完成投稿セット',
    'ライフスタイル',
    'easy',
    25,
    true,
    0,
    '2026-01-15T00:00:00+00',
    '2026-01-15T00:00:00+00'
  ),
  (
    '90000000-0000-4000-8000-000000000008',
    '40000000-0000-4000-8000-000000000003',
    'AIツール比較カルーセル',
    'ChatGPT vs Claude vs Geminiを1スライド1ポイントで比較する保存版投稿。',
    'https://placehold.co/400x400/6366f1/e0e7ff/png?text=AI%E6%AF%94%E8%BC%83',
    'https://placehold.co/1080x1080/6366f1/e0e7ff/png?text=%E3%82%AB%E3%83%AB%E3%83%BC%E3%82%BB%E3%83%AB1',
    NULL,
    '1080×1080画像6枚＋CTA付きキャプションの完成投稿セット',
    'テック',
    'normal',
    30,
    false,
    1,
    '2026-01-15T00:00:00+00',
    '2026-01-15T00:00:00+00'
  ),
  (
    '90000000-0000-4000-8000-000000000009',
    '40000000-0000-4000-8000-000000000003',
    '副業で月3万円の3つの方法',
    '数字フック＋共感ポイント＋保存誘導のバズ狙い投稿。単一画像＋長文キャプション。',
    'https://placehold.co/400x400/be123c/ffe4e6/png?text=%E5%89%AF%E6%A5%AD3%E4%B8%87',
    'https://placehold.co/1080x1350/be123c/ffe4e6/png?text=%E3%83%95%E3%82%A3%E3%83%BC%E3%83%89%E7%94%BB%E5%83%8F',
    NULL,
    '1080×1350画像1枚＋ハッシュタグ戦略付きキャプションの完成投稿',
    '副業',
    'easy',
    20,
    false,
    2,
    '2026-01-15T00:00:00+00',
    '2026-01-15T00:00:00+00'
  )
ON CONFLICT (id) DO UPDATE SET
  workflow_id = EXCLUDED.workflow_id,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  thumbnail_url = EXCLUDED.thumbnail_url,
  preview_image_url = EXCLUDED.preview_image_url,
  preview_video_url = EXCLUDED.preview_video_url,
  completed_output = EXCLUDED.completed_output,
  category = EXCLUDED.category,
  difficulty = EXCLUDED.difficulty,
  estimated_time = EXCLUDED.estimated_time,
  is_featured = EXCLUDED.is_featured,
  sort_order = EXCLUDED.sort_order,
  updated_at = now();

-- ---------------------------------------------------------------------------
-- Seed: showcase_tags (27 = 3 per showcase)
-- ---------------------------------------------------------------------------

INSERT INTO public.showcase_tags (id, showcase_id, tag) VALUES
  ('91000000-0000-4000-8000-000000000001', '90000000-0000-4000-8000-000000000001', '雑学'),
  ('91000000-0000-4000-8000-000000000002', '90000000-0000-4000-8000-000000000001', 'ショート動画'),
  ('91000000-0000-4000-8000-000000000003', '90000000-0000-4000-8000-000000000001', '保存版'),
  ('91000000-0000-4000-8000-000000000004', '90000000-0000-4000-8000-000000000002', 'コスメ'),
  ('91000000-0000-4000-8000-000000000005', '90000000-0000-4000-8000-000000000002', 'プチプラ'),
  ('91000000-0000-4000-8000-000000000006', '90000000-0000-4000-8000-000000000002', '比較'),
  ('91000000-0000-4000-8000-000000000007', '90000000-0000-4000-8000-000000000003', '法律'),
  ('91000000-0000-4000-8000-000000000008', '90000000-0000-4000-8000-000000000003', '海外'),
  ('91000000-0000-4000-8000-000000000009', '90000000-0000-4000-8000-000000000003', 'トリビア'),
  ('91000000-0000-4000-8000-000000000010', '90000000-0000-4000-8000-000000000004', 'ChatGPT'),
  ('91000000-0000-4000-8000-000000000011', '90000000-0000-4000-8000-000000000004', '副業'),
  ('91000000-0000-4000-8000-000000000012', '90000000-0000-4000-8000-000000000004', 'SEO'),
  ('91000000-0000-4000-8000-000000000013', '90000000-0000-4000-8000-000000000005', '在宅ワーク'),
  ('91000000-0000-4000-8000-000000000014', '90000000-0000-4000-8000-000000000005', '比較記事'),
  ('91000000-0000-4000-8000-000000000015', '90000000-0000-4000-8000-000000000005', '2026年版'),
  ('91000000-0000-4000-8000-000000000016', '90000000-0000-4000-8000-000000000006', 'Notion'),
  ('91000000-0000-4000-8000-000000000017', '90000000-0000-4000-8000-000000000006', 'タスク管理'),
  ('91000000-0000-4000-8000-000000000018', '90000000-0000-4000-8000-000000000006', 'How-to'),
  ('91000000-0000-4000-8000-000000000019', '90000000-0000-4000-8000-000000000007', 'ルーティン'),
  ('91000000-0000-4000-8000-000000000020', '90000000-0000-4000-8000-000000000007', 'カルーセル'),
  ('91000000-0000-4000-8000-000000000021', '90000000-0000-4000-8000-000000000007', 'ライフスタイル'),
  ('91000000-0000-4000-8000-000000000022', '90000000-0000-4000-8000-000000000008', 'AI'),
  ('91000000-0000-4000-8000-000000000023', '90000000-0000-4000-8000-000000000008', '比較'),
  ('91000000-0000-4000-8000-000000000024', '90000000-0000-4000-8000-000000000008', 'テック'),
  ('91000000-0000-4000-8000-000000000025', '90000000-0000-4000-8000-000000000009', '副業'),
  ('91000000-0000-4000-8000-000000000026', '90000000-0000-4000-8000-000000000009', 'バズ'),
  ('91000000-0000-4000-8000-000000000027', '90000000-0000-4000-8000-000000000009', '保存版')
ON CONFLICT (id) DO UPDATE SET
  showcase_id = EXCLUDED.showcase_id,
  tag = EXCLUDED.tag;

-- ---------------------------------------------------------------------------
-- Seed: showcase_assets (18 = 2 per showcase)
-- ---------------------------------------------------------------------------

INSERT INTO public.showcase_assets (id, showcase_id, asset_type, url, title, sort_order) VALUES
  ('92000000-0000-4000-8000-000000000001', '90000000-0000-4000-8000-000000000001', 'video', 'https://example.com/showcase/youtube/dangerous-islands.mp4', '完成ショート動画', 0),
  ('92000000-0000-4000-8000-000000000002', '90000000-0000-4000-8000-000000000001', 'prompt', 'https://example.com/showcase/prompts/dangerous-islands.txt', '企画・台本プロンプト', 1),
  ('92000000-0000-4000-8000-000000000003', '90000000-0000-4000-8000-000000000002', 'video', 'https://example.com/showcase/youtube/drugstore-toner.mp4', '完成ショート動画', 0),
  ('92000000-0000-4000-8000-000000000004', '90000000-0000-4000-8000-000000000002', 'image', 'https://placehold.co/1080x1920/2d1b4e/f5e6ff/png?text=Thumbnail', 'サムネイル画像', 1),
  ('92000000-0000-4000-8000-000000000005', '90000000-0000-4000-8000-000000000003', 'video', 'https://example.com/showcase/youtube/weird-laws.mp4', '完成ショート動画', 0),
  ('92000000-0000-4000-8000-000000000006', '90000000-0000-4000-8000-000000000003', 'prompt', 'https://example.com/showcase/prompts/weird-laws.txt', '台本プロンプト', 1),
  ('92000000-0000-4000-8000-000000000007', '90000000-0000-4000-8000-000000000004', 'article', 'https://example.com/showcase/blog/chatgpt-side-hustle.html', '完成記事HTML', 0),
  ('92000000-0000-4000-8000-000000000008', '90000000-0000-4000-8000-000000000004', 'prompt', 'https://example.com/showcase/prompts/chatgpt-side-hustle.txt', '構成・執筆プロンプト', 1),
  ('92000000-0000-4000-8000-000000000009', '90000000-0000-4000-8000-000000000005', 'article', 'https://example.com/showcase/blog/remote-work-2026.html', '完成記事HTML', 0),
  ('92000000-0000-4000-8000-000000000010', '90000000-0000-4000-8000-000000000005', 'image', 'https://placehold.co/1200x630/134e4a/ccfbf1/png?text=OGP', 'OGP画像', 1),
  ('92000000-0000-4000-8000-000000000011', '90000000-0000-4000-8000-000000000006', 'article', 'https://example.com/showcase/blog/notion-tasks.html', '完成記事HTML', 0),
  ('92000000-0000-4000-8000-000000000012', '90000000-0000-4000-8000-000000000006', 'slide', 'https://example.com/showcase/blog/notion-tasks-slides.pdf', '構成スライド', 1),
  ('92000000-0000-4000-8000-000000000013', '90000000-0000-4000-8000-000000000007', 'image', 'https://placehold.co/1080x1080/fbbf24/78350f/png?text=Slide1', 'カルーセル画像セット', 0),
  ('92000000-0000-4000-8000-000000000014', '90000000-0000-4000-8000-000000000007', 'prompt', 'https://example.com/showcase/prompts/morning-routine.txt', 'キャプション生成プロンプト', 1),
  ('92000000-0000-4000-8000-000000000015', '90000000-0000-4000-8000-000000000008', 'image', 'https://placehold.co/1080x1080/6366f1/e0e7ff/png?text=Slide1', 'カルーセル画像セット', 0),
  ('92000000-0000-4000-8000-000000000016', '90000000-0000-4000-8000-000000000008', 'prompt', 'https://example.com/showcase/prompts/ai-compare.txt', '投稿文プロンプト', 1),
  ('92000000-0000-4000-8000-000000000017', '90000000-0000-4000-8000-000000000009', 'image', 'https://placehold.co/1080x1350/be123c/ffe4e6/png?text=Feed', 'フィード画像', 0),
  ('92000000-0000-4000-8000-000000000018', '90000000-0000-4000-8000-000000000009', 'prompt', 'https://example.com/showcase/prompts/side-income.txt', 'バズ狙いキャプション', 1)
ON CONFLICT (id) DO UPDATE SET
  showcase_id = EXCLUDED.showcase_id,
  asset_type = EXCLUDED.asset_type,
  url = EXCLUDED.url,
  title = EXCLUDED.title,
  sort_order = EXCLUDED.sort_order;
