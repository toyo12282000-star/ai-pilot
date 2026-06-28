# Advisor Edge Function

AI Pilot の Advisor 相談 API（Sprint 11.4）。

現状は **Mock レスポンス** を返します。将来 [OpenAI Responses API](https://platform.openai.com/docs/api-reference/responses) に差し替える前提の土台です。

## エンドポイント

`POST /functions/v1/advisor`

### Request

```json
{
  "query": "YouTubeを始めたい",
  "workflows": [
    {
      "id": "wf_youtube_short",
      "title": "YouTubeショートを作る",
      "description": "...",
      "tags": ["YouTube", "ショート"],
      "categoryId": "cat_content"
    }
  ]
}
```

### Response (Mock)

```json
{
  "recommendationIds": ["wf_youtube_short"],
  "reason": "入力内容に近いWorkflowとして選びました"
}
```

## ローカル実行

### 前提

- [Supabase CLI](https://supabase.com/docs/guides/cli) がインストール済み
- リポジトリルートで `supabase/` を参照できること

### 1. Supabase を起動

```bash
cd /path/to/ai-pilot
supabase start
```

### 2. Edge Function をローカル serve

```bash
supabase functions serve advisor --no-verify-jwt
```

デフォルト URL:

```
http://127.0.0.1:54321/functions/v1/advisor
```

### 3. curl で確認

```bash
curl -i --location --request POST \
  'http://127.0.0.1:54321/functions/v1/advisor' \
  --header 'Authorization: Bearer <SUPABASE_ANON_KEY>' \
  --header 'Content-Type: application/json' \
  --data '{
    "query": "YouTubeを始めたい",
    "workflows": [
      {
        "id": "wf_youtube_short",
        "title": "YouTubeショートを作る",
        "description": "企画から投稿まで",
        "tags": ["YouTube", "ショート"]
      }
    ]
  }'
```

`<SUPABASE_ANON_KEY>` は `supabase status` の `anon key` を使用してください。

### 4. デプロイ（本番 / ステージング）

```bash
supabase functions deploy advisor
```

OpenAI 連携時は Edge Function の Secret に API Key を設定します（Flutter には置かない）。

```bash
supabase secrets set OPENAI_API_KEY=sk-...
```

## 関連ドキュメント

- [docs/openai_integration.md](../../../docs/openai_integration.md)
