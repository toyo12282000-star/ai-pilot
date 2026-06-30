import 'package:ai_pilot/features/workflow/data/repositories/showcase_library_catalog.dart';
import 'package:ai_pilot/features/workflow/domain/services/showcase_image_kind.dart';

/// Showcase ID → Storage Path の単一管理レジストリ。
///
/// 画像 Path は [showcaseLibraryCatalog] が唯一のソース。
abstract final class ShowcaseImagePathRegistry {
  static const String bucketName = 'showcases';

  static final Map<String, _ShowcaseImagePaths> _paths = {
    for (final entry in showcaseLibraryCatalog)
      entry.id: _ShowcaseImagePaths(
        thumbnail: entry.thumbnailStoragePath,
        preview: entry.previewStoragePath,
      ),
    for (final entry in showcaseLibraryCatalog)
      entry.supabaseId: _ShowcaseImagePaths(
        thumbnail: entry.thumbnailStoragePath,
        preview: entry.previewStoragePath,
      ),
  };

  /// [showcaseId] に対応する Storage Path。未登録なら null。
  static String? pathFor(String showcaseId, ShowcaseImageKind kind) {
    final paths = _paths[showcaseId];
    if (paths == null) {
      return null;
    }
    return switch (kind) {
      ShowcaseImageKind.thumbnail => paths.thumbnail,
      ShowcaseImageKind.preview => paths.preview,
    };
  }

  /// [workflowId] の featured 完成作品向けプレビューパス（Hero 用フォールバック）。
  static String? featuredPreviewPathForWorkflow(String workflowId) {
    final featured = showcaseLibraryCatalog.where(
      (entry) =>
          entry.isFeatured &&
          (entry.workflowId == workflowId ||
              _workflowUuid(entry.workflowId) == workflowId),
    );
    if (featured.isEmpty) {
      return null;
    }
    return featured.first.previewStoragePath;
  }

  static String? _workflowUuid(String workflowId) => switch (workflowId) {
        'wf_youtube_short' => '40000000-0000-4000-8000-000000000001',
        'wf_blog' => '40000000-0000-4000-8000-000000000002',
        'wf_sns' => '40000000-0000-4000-8000-000000000003',
        _ => null,
      };
}

class _ShowcaseImagePaths {
  const _ShowcaseImagePaths({
    required this.thumbnail,
    required this.preview,
  });

  final String thumbnail;
  final String preview;
}
