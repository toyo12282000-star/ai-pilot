import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/workflow/data/services/showcase_image_path_registry.dart';
import 'package:ai_pilot/features/workflow/domain/services/showcase_image_storage.dart';

/// 本番 Supabase Storage `showcases` バケット実装。
class SupabaseShowcaseImageStorage implements ShowcaseImageStorage {
  SupabaseShowcaseImageStorage({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  String getPublicUrl(String storagePath) {
    if (storagePath.isEmpty) {
      return '';
    }
    return _client.storage
        .from(ShowcaseImagePathRegistry.bucketName)
        .getPublicUrl(storagePath);
  }
}
