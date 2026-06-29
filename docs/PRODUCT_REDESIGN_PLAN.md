# AI Pilot プロダクト再設計計画（Sprint 12.1）

> **ステータス:** 設計ドキュメント（実装前）  
> **目的:** 「AIツール紹介アプリ」から「AIで成果物を作るためのナビゲーションアプリ」への方向転換を定義する。

---

## 1. 現状の問題整理

実機検証（Sprint 11 時点）で確認された課題を、観点別に整理する。

### UI/UX

| 問題 | 詳細 |
|------|------|
| デザインが古い | Material デフォルト感が強く、2020年代の AI プロダクト（Linear / Perplexity 等）と比較して魅力が弱い |
| 情報密度が不適切 | カードに詰め込みすぎ／逆に重要情報が埋もれる箇所があり、視線誘導が弱い |
| PC 最適化不足 | モバイル前提の縦積みが Web でもそのまま。横幅・CTA サイズが統一されていない |
| 成果物が見えない | 一覧・詳細とも「手順」は見えるが「完成品」が想像しにくい |

### コンテンツ量

| 問題 | 詳細 |
|------|------|
| AI ツール数が少い | シードは 8 ツール程度。ユーザーが「この用途ならこの AI」と選べない |
| プロンプト例が少い | Step あたり 1 テンプレートが中心。状況別の選択肢がない |
| Workflow 数が限定的 | MVP 5 本。ホームの「作りたいこと」カバレッジが狭い |

### Workflow 構成

| 問題 | 詳細 |
|------|------|
| 開発者目線の命名 | 「調査レポートを作る」より「営業資料が完成する」の方が価値が伝わる |
| 成果物（Outcome）の欠如 | `title` / `description` / `steps` 中心で、**何が完成するか**が構造化されていない |
| Step のゴールが曖昧 | 「この Step で何を作るか」「完了条件」がユーザー言語で書かれていない |

### AI ツール情報

| 問題 | 詳細 |
|------|------|
| 選定理由がない | なぜこの Step でこの AI なのかが UI に出ない |
| 比較情報がない | 料金・難易度・得意分野・代替ツールが未整備 |
| ツール単体の価値が弱い | ツール詳細画面がカタログ程度で、Workflow との接続が薄い |

### Prompt 情報

| 問題 | 詳細 |
|------|------|
| バリエーション不足 | 初心者 / 高品質 / 時短など用途別プロンプトがない |
| 出力イメージがない | `exampleOutput`・`expectedOutput` がなく、コピー後の期待が不明 |
| 変数の説明不足 | `{{theme}}` 等の埋め方が開発者向けのまま |

### ユーザー価値

| 問題 | 詳細 |
|------|------|
| 価値提案のズレ | 「AI を探す」体験に見えるが、ユーザーが欲しいのは「成果物を作る」体験 |
| 最初の一歩が重い | Workflow 一覧から選ぶ構造は、目的がはっきりしていないユーザーにはハードルが高い |
| 「作れそう」感が弱い | 完成イメージ・時間・難易度・必要ツールが揃っていないため、着手判断ができない |

---

## 2. 新しいプロダクトコンセプト

### 一言定義

**「作りたい成果物から始める AI 活用ナビ」**

AI Pilot は AI ツールのディレクトリではない。  
ユーザーが **完成イメージ** を選び、**必要な AI・プロンプト・手順** まで一気通貫で案内し、**成果物の完成** まで伴走するアプリである。

### コアメッセージ

| 従来 | 再設計後 |
|------|----------|
| AI ツールを探す | **作りたいもの** を選ぶ |
| Workflow を実行する | **完成イメージ → 必要 AI → プロンプト → 実行** |
| AI を学ぶ | **AI を学ばず、成果物を作る** |

### 提供価値（ユーザーに約束すること）

1. **「これ、作れそう」** — 完成プレビュー・時間・難易度で着手可否が判断できる  
2. **「何をすればいいか分かる」** — Step ごとにゴール・プロンプト・完了条件が明示される  
3. **「なぜこの AI か分かる」** — ツール選定理由と代替案が見える  
4. **「コピーしてすぐ試せる」** — 用途別プロンプトをワンタップで外部 AI に持っていける  

---

## 3. 新しいユーザーフロー

### 現在（As-Is）

```
Workflow 一覧
    ↓
Workflow 詳細（タイトル・説明・Step 一覧）
    ↓
Step 詳細
    ↓
Prompt コピー → 外部 AI で実行
```

**問題:** 入口が「Workflow」という開発者語。完成品が見える前に手順に入る。

### 変更後（To-Be）

```
完成イメージを見る（Home / Advisor）
    ↓
「これを作りたい」
    ↓
Workflow 詳細
  ├─ これが作れます（Outcome プレビュー）
  ├─ 必要な AI ツール一覧
  ├─ 作成ステップ概要
  └─ おすすめプロンプト例
    ↓
「始める」
    ↓
Step 実行（1 Step ずつ）
  ├─ この Step で作るもの
  ├─ プロンプト候補（用途別）
  ├─ 出力例
  ├─ コピー / AI ツールを開く
  └─ 完了条件を満たしたら次へ
    ↓
成果物完成（Workflow 完了）
```

### Advisor の位置づけ

- 「作りたいこと」を自然言語で入力 → **Outcome ベースの Workflow 提案**
- 例文チップ・完成物カードと連動し、**同じ UX 言語** で統一する

---

## 4. 新しい情報設計

### Workflow に追加すべき情報

| フィールド | 型（案） | 説明 |
|-----------|---------|------|
| `outcomeTitle` | text | ユーザー向け成果物名（例: 「60秒の YouTube ショート動画」） |
| `outcomeDescription` | text | 完成後に得られるものの説明 |
| `outcomeType` | enum | `video` / `article` / `image` / `slide` / `sns_post` / `app` |
| `outcomePreviewUrl` | text? | 完成物プレビュー（動画 URL 等） |
| `outcomePreviewImageUrl` | text? | サムネイル・静止画プレビュー |
| `difficulty` | enum | `easy` / `medium` / `hard` |
| `requiredTime` | int | 想定所要時間（分）— 既存 `estimated_minutes` と統合検討 |
| `requiredTools` | uuid[] | 必要 AI ツール ID 一覧（非正規化 or 導出） |
| `useCases` | text[] | 利用シーン（例: 「副業の第一歩」） |
| `targetUsers` | text[] | 想定ユーザー（例: 「動画未経験者」） |
| `expectedResult` | text | 完成後の状態を一文で |

> 既存: `title`, `description`, `tags`, `estimated_minutes`, `category_id` は維持。  
> `outcomeTitle` はユーザー向け、`title` は内部管理名として使い分けも可。

### WorkflowStep に追加すべき情報

| フィールド | 型（案） | 説明 |
|-----------|---------|------|
| `goal` | text | この Step で達成すること（ユーザー語） |
| `outputExample` | text | 出力サンプル（テキスト・画像 URL 等） |
| `toolOptions` | relation | 使える AI 候補（複数）— 下記 `workflow_step_tool_options` |
| `recommendedToolId` | uuid | おすすめ AI（既存 `ai_tool_id` と統合検討） |
| `promptVariants` | relation | 用途別プロンプト — 下記 `prompt_variants` |
| `tips` | text[] | うまくいくコツ |
| `commonMistakes` | text[] | よくある失敗 |
| `completionCriteria` | text | Step 完了の判断基準 |

### AITool に追加すべき情報

| フィールド | 型（案） | 説明 |
|-----------|---------|------|
| `pricingType` | enum | `free` / `freemium` / `paid` / `subscription` |
| `difficulty` | enum | `easy` / `medium` / `hard` |
| `strengths` | text[] | 得意なこと |
| `weaknesses` | text[] | 苦手・注意点 |
| `bestFor` | text[] | 向いている用途 |
| `alternativeToolIds` | relation | 代替ツール — 下記 `ai_tool_alternatives` |
| `officialUrl` | text | 公式 URL（既存 `url` と統合検討） |
| `tutorialUrl` | text? | チュートリアル・公式ガイド |

### PromptTemplate に追加すべき情報

| フィールド | 型（案） | 説明 |
|-----------|---------|------|
| `variantType` | enum | `beginner` / `high_quality` / `short_time` / `viral` / `professional` 等 |
| `expectedOutput` | text | このプロンプトで得られる出力の説明 |
| `usageTips` | text[] | 使い方のヒント |
| `variables` | jsonb | 変数定義（名前・説明・例） |
| `exampleOutput` | text | 出力例全文 |

---

## 5. 新しい画面案

### Home

**ヘッダー:** 「何を作りたいですか？」

**メインコンテンツ:**

| セクション | 内容 |
|-----------|------|
| 完成物カード（Outcome Grid） | YouTube ショート / Instagram 投稿 / ブログ記事 / 営業資料 / AI 画像 / アプリ画面 等 |
| 各カード | プレビュー画像・難易度・所要時間・必要 AI アイコン |
| CTA | 「AIに相談する」→ Advisor |
| 補助 | カテゴリ browse / お気に入り（既存機能は維持） |

**変更の要点:** `recommendations` カードを **Outcome ファースト** のビジュアルに刷新。  
「YouTubeを始めたい」→ 完成動画イメージが見えるカード。

### Workflow 詳細

| 順序 | ブロック |
|------|----------|
| 1 | **完成イメージ**（大きなプレビュー + outcomeTitle） |
| 2 | 「これが作れます」（expectedResult / useCases） |
| 3 | 必要な AI ツール（アイコン + 一言説明） |
| 4 | 作成ステップ（タイムライン概要） |
| 5 | おすすめプロンプト例（代表 1〜2 件） |
| 6 | **開始する** CTA（固定フッター） |

### Step 詳細 / 実行

| ブロック | 内容 |
|----------|------|
| Step ゴール | 「この Step で作るもの」 |
| 入力ガイド | ユーザーが用意・入力する内容 |
| 使う AI | おすすめ + 代替（タップで AI 詳細 / 外部 URL） |
| プロンプト候補 | variantType タブ（初心者 / 高品質 / 時短 …） |
| 出力例 | exampleOutput |
| アクション | コピー / AI ツールを開く |
| 完了条件 | completionCriteria + 「次の Step へ」 |

### AI ツール詳細

| ブロック | 内容 |
|----------|------|
| 概要 | 名前・タイプ・アイコン |
| 何が得意か | strengths / bestFor |
| 料金・難易度 | pricingType / difficulty |
| 注意点 | weaknesses |
| 代替ツール | alternativeToolIds → 横スクロール |
| 関連 Workflow | このツールを使う Workflow 一覧 |

---

## 6. デザイン方向性

### 参照プロダクト

Linear / Perplexity / Cursor / Notion AI / Apple — **静かで信頼感のある AI プロダクト** の UI 言語を参考にする。

### デザイン原則

| 原則 | 具体 |
|------|------|
| Material 感を減らす | 標準 ElevatedButton / Card の多用を避け、フラット +  subtle border |
| 白背景だけに頼らない | セクション背景に `#F8FAFC` / `#F1F5F9`、Hero に淡いグラデーション |
| 余白を広く | セクション間 32〜48px、カード内 padding 20〜24px |
| 情報密度を整理 | 1 カード 1 メッセージ。副情報は折りたたみ or 詳細へ |
| 横幅を揃える | max-width 720〜960px（PC）。Home / Detail / Step で統一 |
| PC レイアウト最適化 | 2 カラム（プレビュー + 情報）、サイドバー固定 CTA |
| CTA・検索のサイズ統一 | Primary ボタン高さ 48px、検索欄と同幅 |
| 成果物プレビューを大きく | Workflow 詳細 Hero は 16:9 or 4:3、min-height 200px+ |
| AI 感のグラデーション | Primary `#5B5CEB` → `#6DD5FA` の淡い linear（10〜15% opacity） |
| タイポグラフィ階層 | Display（成果物名）/ Title（セクション）/ Body / Caption を明確化 |

### カラーシステム（既存 Primary 維持 + 拡張）

- Primary: `#5B5CEB`
- Accent: `#6DD5FA`
- Background: `#F8FAFC`
- Surface: `#FFFFFF`
- Text Primary: `#0F172A`
- Text Secondary: `#64748B`
- Outcome Type バッジ: type ごとに淡い色（video=赤系、article=緑系 …）

---

## 7. コンテンツ拡充方針

### まず追加する AI ツール（20）

| カテゴリ | ツール |
|---------|--------|
| チャット / 調査 | ChatGPT, Claude, Gemini, Perplexity |
| デザイン / 資料 | Canva, Figma, Gamma |
| 動画 | CapCut, Vrew, Runway, Pika, Kling |
| 音声 | ElevenLabs, VOICEVOX |
| 画像 | Midjourney, Ideogram |
| 開発 / UI | Cursor, v0, Lovable |
| 生産性 | Notion AI |

各ツールに **strengths / pricingType / bestFor / officialUrl** を最低限記載する。

### まず強化する Workflow（8）

| Workflow | Outcome 例 | 優先理由 |
|----------|-----------|----------|
| YouTube ショートを作る | 60秒ショート動画 | 既存ユーザー訴求が強い |
| Instagram 投稿を作る | フィード投稿セット | SNS 需要 |
| ブログ記事を書く | SEO 記事 1 本 | 副業・情報発信 |
| 営業資料を作る | 調査ベースの提案資料 | B2B・実務需要 |
| AI 画像を作る | サムネ / イラスト | ビジュアル訴求 |
| LP を作る | 1 ページ LP 構成 + 文案 | 起業・副業 |
| アプリ UI を作る | 画面モック / 実装方針 | 開発者層 |
| 副業アイデアを作る | アイデア + 実行プラン | 入口として汎用 |

各 Workflow に **Outcome プレビュー・3 Step 以上・ツール選定理由** を必須とする。

---

## 8. プロンプト拡充方針

### 最低ライン（各 Step）

| variantType | 目的 |
|-------------|------|
| `beginner` | 初めてでも迷わない、短い指示 |
| `high_quality` | 出力品質を最大化 |
| `short_time` | 最小入力・最速完成 |

### 追加（Workflow タイプに応じて）

| variantType | 向く Workflow |
|-------------|--------------|
| `viral` | YouTube ショート / SNS |
| `professional` | 営業資料 / LP |
| SEO 重視 | ブログ記事 |
| ビジネス向け | 営業資料 / 副業アイデア |

### 品質基準

- 各プロンプトに `variables` 定義 + `exampleOutput` を付ける  
- Step 画面では **タブ or チップ** で切替、デフォルトは `beginner`  
- 管理画面（将来）では variant ごとにプレビュー編集可能に  

---

## 9. DB 変更案

### 案 A: 既存テーブル拡張のみ

`workflows`, `workflow_steps`, `ai_tools`, `prompt_templates` にカラム追加。

| メリット | デメリット |
|---------|-----------|
| マイグレーションが単純 | 1:N 関係（toolOptions, promptVariants, alternatives）を JSONB で無理やり入れるとクエリ・整合性が悪化 |
| JOIN が少ない | 正規化不足で Admin 編集・バリデーションが難しい |
| Flutter Entity 変更が局所的 | 将来の拡張で JSONB が肥大化 |

### 案 B: 新規テーブル追加 + 既存拡張（推奨）

**新規テーブル:**

| テーブル | 用途 |
|---------|------|
| `workflow_outcomes` | Workflow 1:1。Outcome 専用フィールドを集約 |
| `workflow_step_tool_options` | Step × AI Tool（sort_order, is_recommended） |
| `prompt_variants` | Step × Prompt（variant_type, content, example_output …） |
| `ai_tool_alternatives` | Tool × Tool（双方向 or 有向） |

**既存テーブル拡張（最小）:**

| テーブル | 追加カラム例 |
|---------|-------------|
| `workflows` | `use_cases text[]`, `target_users text[]`, `expected_result text` |
| `workflow_steps` | `goal`, `output_example`, `tips text[]`, `common_mistakes text[]`, `completion_criteria` |
| `ai_tools` | `pricing_type`, `difficulty`, `strengths text[]`, `weaknesses text[]`, `best_for text[]`, `tutorial_url` |
| `prompt_templates` | 基本テンプレートとして残し、**実行時は `prompt_variants` を優先** |

| メリット | デメリット |
|---------|-----------|
| 正規化され Admin CRUD がしやすい | マイグレーション・Repository 層の変更量が増える |
| variant / alternative を独立クエリ可能 | JOIN が増え Flutter DTO が複雑化 |
| Sprint 12.2 以降の Seed 拡充と相性が良い | 初期実装コストは案 A より高い |

### 推奨: **案 B**

理由:

1. **プロンプト variant** と **ツール代替** は本質的に 1:N — JSONB より専用テーブルが適切  
2. **Outcome** は Workflow の顔 — 独立テーブルにすると Home / Detail のクエリを最適化しやすい  
3. Admin Console（将来）で CRUD 単位が明確  
4. 既存 `prompt_template_id` / `ai_tool_id` は **後方互換** として残し、段階的移行可能  

### 移行方針

1. Sprint 12.2: 案 B のスキーマ追加（既存カラムは deprecated マークのみ、削除しない）  
2. Sprint 12.3: Seed を新テーブルへ投入。Flutter は新 Entity を読む  
3. 旧 `prompt_templates` 単体参照は 12.6 完了までフォールバック  

---

## 10. 実装ロードマップ

| Sprint | 内容 | 主な成果物 |
|--------|------|-----------|
| **12.2** | DB 設計変更 | マイグレーション 005、schema ドキュメント更新 |
| **12.3** | Seed データ拡充 | AI 20 ツール、Workflow 8 強化、prompt_variants 各 Step 3 種 |
| **12.4** | Workflow 詳細 UI 刷新 | Outcome Hero、必要 AI、Step タイムライン |
| **12.5** | Home 刷新 | Outcome カード Grid、「何を作りたいですか？」 |
| **12.6** | Step 詳細 / 実行画面刷新 | プロンプト variant タブ、完了条件、外部 AI 起動 |
| **12.7** | AI ツール詳細刷新 | strengths / 料金 / 代替 / 関連 Workflow |
| **12.8** | 実機 QA | 8 Workflow 通し実行、6 例文 Advisor、PC/モバイル |

### 依存関係

```
12.2 DB → 12.3 Seed → 12.4 Detail UI ─┐
                    → 12.5 Home UI ─────┼→ 12.6 Step UI → 12.7 Tool UI → 12.8 QA
                    → Advisor Outcome 連携 ┘
```

---

## 11. 今回やらないこと（Sprint 12.x スコープ外）

| 項目 | 理由 |
|------|------|
| OpenAI 本番連携 | Outcome / コンテンツ構造の確定が先。Advisor は Mock Edge のまま |
| 課金 | プロダクト価値検証前 |
| ユーザー投稿 Workflow | モデレーション・品質管理が未整備 |
| 本格管理画面 | Admin 基盤（Sprint 10.2）はあるが、variant / outcome 編集 UI は後回し |
| App Store 公開 | 再設計完了 + QA 後 |

---

## 12. 推奨方針（まとめ）

### 最優先

> **「ユーザーが“これ作れそう”と思える体験」を最優先にする。**

1. **完成イメージとプロンプト例を増やす** — UI より先にコンテンツ構造（Outcome / variant）を改善する  
2. **UI 刷新は構造に追随させる** — 空の綺麗な画面より、中身のある画面を先に  
3. **開発者語をユーザー語に置換する** — Workflow → 「これが作れます」、Step → 「この Step で作るもの」  

### 判断基準（今後の PR / Sprint で）

- この変更は **完成イメージがより見えるか？**  
- この変更は **プロンプトをコピーして試すまでのステップが減るか？**  
- この変更は **なぜこの AI か** が説明されているか？  

### 次に着手すべき Sprint

**Sprint 12.2: DB 設計変更**

- 本ドキュメントの **案 B** に基づき `005_outcome_foundation.sql`（仮）を作成  
- `docs/database_schema.md` を更新  
- Flutter Domain Entity の interface 草案（実装は 12.3〜）  

---

## 関連ドキュメント

- [database_schema.md](./database_schema.md) — 現行スキーマ  
- [openai_integration.md](./openai_integration.md) — Advisor / OpenAI（12.x では未有効）  
- [ADMIN_CONSOLE_SPEC.md](./ADMIN_CONSOLE_SPEC.md) — 将来のコンテンツ管理  
- [QA_CHECKLIST.md](./QA_CHECKLIST.md) — Sprint 12.8 で更新予定  
