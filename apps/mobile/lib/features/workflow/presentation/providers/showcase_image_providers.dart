import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/workflow/data/services/mock_showcase_image_storage.dart';
import 'package:ai_pilot/features/workflow/data/services/supabase_showcase_image_storage.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_showcase_repository.dart';
import 'package:ai_pilot/features/workflow/domain/services/showcase_image_resolver.dart';
import 'package:ai_pilot/features/workflow/domain/services/showcase_image_storage.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_providers.dart';

/// Showcase 画像 Storage 実装（Mock Repository 時は Mock Storage）。
final showcaseImageStorageProvider = Provider<ShowcaseImageStorage>((ref) {
  final repository = ref.watch(workflowShowcaseRepositoryProvider);
  if (repository is MockWorkflowShowcaseRepository) {
    return MockShowcaseImageStorage();
  }
  return SupabaseShowcaseImageStorage();
});

/// Showcase 画像 URL 解決。
final showcaseImageResolverProvider = Provider<ShowcaseImageResolver>((ref) {
  return ShowcaseImageResolver(ref.watch(showcaseImageStorageProvider));
});
