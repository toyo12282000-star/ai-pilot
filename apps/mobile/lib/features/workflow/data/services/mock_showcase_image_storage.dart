import 'package:ai_pilot/features/workflow/data/repositories/showcase_library_catalog.dart';
import 'package:ai_pilot/features/workflow/data/services/showcase_image_path_registry.dart';
import 'package:ai_pilot/features/workflow/domain/services/showcase_image_storage.dart';

/// Mock 環境向け Storage 模倣（バンドル SVG アセットを返す）。
class MockShowcaseImageStorage implements ShowcaseImageStorage {
  MockShowcaseImageStorage({
    this.publicBaseUrl = 'https://mock.supabase.local/storage/v1/object/public',
  });

  final String publicBaseUrl;

  static final Map<String, String> _assetByStoragePath = {
    for (final entry in showcaseLibraryCatalog) ...{
      entry.previewStoragePath: entry.assetPreviewPath,
      entry.thumbnailStoragePath: entry.assetThumbnailPath,
    },
  };

  @override
  String getPublicUrl(String storagePath) {
    if (storagePath.isEmpty) {
      return '';
    }
    final assetPath = _assetByStoragePath[storagePath];
    if (assetPath != null) {
      return 'asset:$assetPath';
    }
    return '$publicBaseUrl/${ShowcaseImagePathRegistry.bucketName}/$storagePath';
  }
}
