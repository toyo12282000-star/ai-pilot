import 'package:ai_pilot/features/workflow/data/repositories/showcase_library_catalog.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/showcase_asset.dart';
import 'package:ai_pilot/features/workflow/domain/entities/showcase_tag.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';

/// Mock 完成作品タグ（カタログから生成）。
final List<ShowcaseTag> mockShowcaseTags = [
  for (final entry in showcaseLibraryCatalog)
    for (var index = 0; index < entry.tags.length; index++)
      ShowcaseTag(
        id: 'tag_${entry.id}_${index + 1}',
        showcaseId: entry.id,
        tag: entry.tags[index],
      ),
];

WorkflowShowcase _showcaseFromEntry(ShowcaseLibraryEntry entry) {
  return WorkflowShowcase(
    id: entry.id,
    workflowId: entry.workflowId,
    title: entry.title,
    description: entry.description,
    previewVideoUrl: entry.previewVideoUrl,
    completedOutput: entry.description,
    category: entry.category,
    difficulty: entry.difficulty,
    estimatedTime: entry.estimatedTime,
    isFeatured: entry.isFeatured,
    sortOrder: entry.sortOrder,
    tags: mockShowcaseTags
        .where((tag) => tag.showcaseId == entry.id)
        .toList(),
    assets: const [],
    createdAt: mockBaseDate,
    updatedAt: mockBaseDate,
  );
}

/// Mock 完成作品サンプル一覧（Sprint 13.3 · 30 件）。
final List<WorkflowShowcase> mockWorkflowShowcases = [
  for (final entry in showcaseLibraryCatalog) _showcaseFromEntry(entry),
]..sort((a, b) {
    final workflowCompare = a.workflowId.compareTo(b.workflowId);
    if (workflowCompare != 0) {
      return workflowCompare;
    }
    return a.sortOrder.compareTo(b.sortOrder);
  });

/// 旧 seed 互換（アセット参照用）。
final List<ShowcaseAsset> mockShowcaseAssets = const [];
