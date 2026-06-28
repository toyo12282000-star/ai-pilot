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

## 正式ロゴへの差し替え

1. `assets/app_icon/app_icon.svg` を正式デザインに差し替え
2. `python3 scripts/generate_app_icon.py` を実行（または PNG を直接配置）
3. `dart run flutter_launcher_icons`
4. `dart run flutter_native_splash:create`
