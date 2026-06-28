# AI Pilot セットアップ

Flutter モバイルアプリ（`apps/mobile`）の開発・ビルド手順です。

## 前提

- Flutter SDK（`^3.12.2`）
- Dart SDK
- Android Studio / Xcode（各プラットフォーム向けビルド時）
- Supabase プロジェクト（`.env` 設定）

## 初回セットアップ

```bash
cd apps/mobile
cp .env.example .env
# .env に SUPABASE_URL / SUPABASE_ANON_KEY を設定
flutter pub get
```

## 仮アイコン・スプラッシュの生成

正式ロゴ確定前の **MVP Preview 用** プレースホルダーです。  
ソースは `apps/mobile/assets/app_icon/app_icon.svg` です。

### 1. PNG アセットを生成（必要時）

```bash
python3 scripts/generate_app_icon.py
```

生成先:

- `apps/mobile/assets/app_icon/app_icon.png`
- `apps/mobile/assets/app_icon/app_icon_foreground.png`
- `apps/mobile/assets/app_icon/splash_logo.png`

### 2. ランチャーアイコンを各プラットフォームへ反映

```bash
cd apps/mobile
dart run flutter_launcher_icons
```

### 3. スプラッシュ画面を生成

```bash
cd apps/mobile
dart run flutter_native_splash:create
```

### 設定概要

| 項目 | 値 |
|---|---|
| アプリ表示名 | AI Pilot |
| Primary | `#5B5CEB` |
| スプラッシュ背景 | `#F8FAFC` |
| スプラッシュロゴ | `assets/app_icon/splash_logo.png` |

`pubspec.yaml` の `flutter_launcher_icons` / `flutter_native_splash` セクションを編集した場合は、上記コマンドを再実行してください。

## 開発サーバー

```bash
cd apps/mobile
flutter run -d chrome
flutter run -d ios
flutter run -d android
```

## 品質チェック

```bash
cd apps/mobile
flutter analyze
flutter test
```

## Advisor Edge Function（Sprint 11.5）

Advisor の推薦 API は Supabase Edge Function `advisor` 経由で呼び出せます。  
**現状は Mock レスポンスのみ**（OpenAI 未有効・Secret 不要）。

### 1. Edge Function をデプロイ

リポジトリルートで実行します。

```bash
# Supabase CLI でプロジェクトにリンク済みであること
supabase functions deploy advisor
```

- 必要な env / secret: **なし**（OpenAI API Key はまだ設定しない）
- 詳細: [supabase/functions/advisor/README.md](../supabase/functions/advisor/README.md)

### 2. Flutter の `.env` 切替

```bash
cd apps/mobile
cp .env.example .env
```

| 変数 | デフォルト | 説明 |
|------|-----------|------|
| `USE_ADVISOR_EDGE_FUNCTION` | `false` | `true` で Edge Function 呼び出し |

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
USE_ADVISOR_EDGE_FUNCTION=true
```

- デフォルト（`false`）: ルールベース `MockAdvisorApiRepository`
- `true`: `SupabaseAdvisorApiRepository` → `functions/v1/advisor`
- Edge Function 失敗時は **ルールベース Mock へ自動フォールバック**（`debugPrint` にログ）

### 3. 確認手順

**A. curl（デプロイ直後）**

```bash
curl -i --location --request POST \
  "${SUPABASE_URL}/functions/v1/advisor" \
  --header "Authorization: Bearer ${SUPABASE_ANON_KEY}" \
  --header "Content-Type: application/json" \
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

**B. Flutter アプリ**

1. `.env` に `USE_ADVISOR_EDGE_FUNCTION=true` を設定
2. `flutter run -d chrome` で Advisor 画面を開く
3. 相談を入力して「提案する」→ 結果が表示されれば OK
4. Edge 未デプロイ時もフォールバックで結果表示（コンソールに `[AdvisorService] Edge Function failed` ログ）

## 正式ロゴへの差し替え

1. `assets/app_icon/app_icon.svg` を正式デザインに差し替え
2. `python3 scripts/generate_app_icon.py` を実行（または PNG を直接配置）
3. `dart run flutter_launcher_icons`
4. `dart run flutter_native_splash:create`
