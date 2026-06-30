import 'package:ai_pilot/features/workflow/data/services/showcase_image_path_registry.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';
import 'package:ai_pilot/features/workflow/domain/services/showcase_image_kind.dart';
import 'package:ai_pilot/features/workflow/domain/services/showcase_image_storage.dart';

/// workflowId / showcaseId → Storage Path → Public URL を解決する。
class ShowcaseImageResolver {
  const ShowcaseImageResolver(this._storage);

  final ShowcaseImageStorage _storage;

  /// カード・Hero 共通のプレビュー画像 URL。
  String? resolvePreviewUrl(WorkflowShowcase showcase) {
    return _resolveShowcase(showcase, ShowcaseImageKind.preview);
  }

  /// 一覧サムネイル URL。
  String? resolveThumbnailUrl(WorkflowShowcase showcase) {
    return _resolveShowcase(showcase, ShowcaseImageKind.thumbnail);
  }

  /// Hero 表示用（プレビューを優先、なければサムネイル）。
  String? resolveHeroUrl(WorkflowShowcase? showcase, {String? workflowId}) {
    if (showcase != null) {
      return resolvePreviewUrl(showcase) ?? resolveThumbnailUrl(showcase);
    }
    if (workflowId == null) {
      return null;
    }
    final path = ShowcaseImagePathRegistry.featuredPreviewPathForWorkflow(
      workflowId,
    );
    return _resolvePath(path);
  }

  /// アセット等の任意 Storage Path / レガシー URL を解決する。
  String? resolveStoredReference(String? storedReference) {
    return _resolvePath(storedReference);
  }

  String? _resolveShowcase(
    WorkflowShowcase showcase,
    ShowcaseImageKind kind,
  ) {
    final registryPath = ShowcaseImagePathRegistry.pathFor(showcase.id, kind);
    final entityPath = switch (kind) {
      ShowcaseImageKind.thumbnail => showcase.thumbnailUrl,
      ShowcaseImageKind.preview => showcase.previewImageUrl,
    };

    return _resolvePath(registryPath ?? entityPath);
  }

  String? _resolvePath(String? pathOrUrl) {
    if (pathOrUrl == null || pathOrUrl.trim().isEmpty) {
      return null;
    }
    final value = pathOrUrl.trim();
    if (_isAbsoluteUrl(value)) {
      return value;
    }
    final normalized = value.startsWith('/')
        ? value.substring(1)
        : value.startsWith('${ShowcaseImagePathRegistry.bucketName}/')
            ? value.substring(ShowcaseImagePathRegistry.bucketName.length + 1)
            : value;
    final publicUrl = _storage.getPublicUrl(normalized);
    return publicUrl.isEmpty ? null : publicUrl;
  }

  static bool _isAbsoluteUrl(String value) {
    return value.startsWith('http://') || value.startsWith('https://');
  }
}
