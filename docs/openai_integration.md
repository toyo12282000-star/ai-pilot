# OpenAI Integration Plan (Advisor)

Sprint 11.4 で Advisor を **Supabase Edge Function 経由** で拡張できる土台を整備した。
現時点では Mock レスポンスのみ。本ドキュメントは将来の OpenAI 連携方針をまとめる。

## 概要

| 項目 | 方針 |
|------|------|
| AI モデル | [OpenAI Responses API](https://platform.openai.com/docs/api-reference/responses) |
| 呼び出し元 | Supabase Edge Function `advisor` のみ |
| API Key 保管 | Edge Function Secret（`OPENAI_API_KEY`） |
| Flutter | Key を **一切** 持たない |
| 現状 | Mock `{ recommendationIds, reason }` を返却 |

## Responses API

OpenAI Responses API は、会話・ツール呼び出し・構造化出力を 1 つの API で扱える。
Advisor では次の用途を想定する。

1. ユーザーの自然言語クエリを理解する
2. 公開 Workflow カタログから最適な候補を選ぶ
3. ユーザー向け `reason` 文を生成する

将来の Edge Function 実装イメージ:

```typescript
// supabase/functions/advisor/index.ts（将来）
const response = await openai.responses.create({
  model: "gpt-4.1-mini",
  input: [
    { role: "system", content: "You are AI Pilot Advisor..." },
    { role: "user", content: buildPrompt(query, workflows) },
  ],
  // structured output / JSON schema で recommendationIds + reason を返す
});
```

## Edge Function 構成

```
Flutter (AdvisorService)
    │
    ▼
SupabaseAdvisorApiRepository
    │  POST /functions/v1/advisor
    │  { query, workflows[] }
    ▼
supabase/functions/advisor/index.ts
    │
    ├─ [現在] mockSuggest() ──► { recommendationIds, reason }
    │
    └─ [将来] OpenAI Responses API
              Secret: OPENAI_API_KEY
```

### Request / Response 契約

**Request**

```json
{
  "query": "YouTubeを始めたい",
  "workflows": [
    {
      "id": "uuid",
      "title": "...",
      "description": "...",
      "tags": ["..."],
      "categoryId": "uuid"
    }
  ]
}
```

**Response**

```json
{
  "recommendationIds": ["uuid", "uuid"],
  "reason": "入力内容に合う Workflow として選びました"
}
```

Flutter はこの契約を維持したまま、Edge 内部の AI 実装だけ差し替える。

## セキュリティ

- **API Key は Edge Function の Secret のみ** に設定する
- Flutter アプリ・リポジトリ・`.env` クライアント側には置かない
- Edge Function は JWT 検証を有効化し、authenticated ユーザーのみ呼び出し可にする（本番）
- ローカル開発では `supabase functions serve advisor --no-verify-jwt` で検証可能

```bash
supabase secrets set OPENAI_API_KEY=sk-...
```

## Flutter Repository 構成

| レイヤ | ファイル | 役割 |
|--------|----------|------|
| Domain | `advisor_api_repository.dart` | 抽象 Interface |
| Domain | `advisor_service.dart` | API 結果 → `AdvisorSuggestion` 変換 |
| Data | `mock_advisor_api_repository.dart` | テスト / Edge 未接続時 |
| Data | `supabase_advisor_api_repository.dart` | `functions.invoke('advisor')` |
| Provider | `advisor_providers.dart` | DI / 本番切替 |

### OpenAI 差し替えポイント

1. **`supabase/functions/advisor/index.ts`**  
   `mockSuggest()` を OpenAI Responses API 呼び出しに置換（主な変更箇所）

2. **`SupabaseAdvisorApiRepository`**  
   レスポンス形式が同じなら変更不要。構造化出力を拡張する場合は DTO のみ更新

3. **`AdvisorService`**  
   基本的に変更不要。難易度ラベル等は Flutter 側で Workflow メタデータから算出

4. **`advisorApiRepositoryProvider`**  
   Edge デプロイ後に `SupabaseAdvisorApiRepository()` へ切替

## 将来: Embedding 検索

カタログが増えた場合、全 Workflow をプロンプトに載せるのは非効率になる。
次フェーズで Embedding 検索を追加する予定。

1. Workflow タイトル・説明・タグを Embedding 化（DB または Vector Store）
2. ユーザークエリを Embedding 化
3. 類似度 Top-K を Edge Function で取得
4. Top-K のみ OpenAI Responses API に渡して最終 ranking + reason 生成

これによりトークンコストとレイテンシを抑えつつ、精度を維持できる。

## 関連ファイル

- `supabase/functions/advisor/index.ts`
- `supabase/functions/advisor/README.md`
- `apps/mobile/lib/features/advisor/domain/services/advisor_service.dart`
- `apps/mobile/lib/features/advisor/data/repositories/supabase_advisor_api_repository.dart`
- `apps/mobile/lib/features/advisor/presentation/providers/advisor_providers.dart`

## ローカル確認

Edge Function の起動手順は [supabase/functions/advisor/README.md](../supabase/functions/advisor/README.md) を参照。
