/// Supabase Storage `showcases` バケットへの抽象アクセス。
abstract class ShowcaseImageStorage {
  /// [storagePath]（例: `youtube/wf_youtube_short/showcase_yt_1/preview.webp`）の公開 URL を返す。
  String getPublicUrl(String storagePath);
}
