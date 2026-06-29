import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/workflow/data/dto/showcase_asset_dto.dart';
import 'package:ai_pilot/features/workflow/data/dto/showcase_tag_dto.dart';
import 'package:ai_pilot/features/workflow/data/dto/workflow_showcase_dto.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_showcase_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_showcase_repository.dart';
import 'package:ai_pilot/features/workflow/domain/entities/showcase_asset.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_showcase.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_providers.dart';

void main() {
  group('WorkflowShowcase entity', () {
    test('holds showcase metadata with nested tags and assets', () {
      final showcase = mockWorkflowShowcases.first;

      expect(showcase.title, contains('危険な島'));
      expect(showcase.tags, isNotEmpty);
      expect(showcase.assets, isNotEmpty);
      expect(showcase.isFeatured, isTrue);
    });
  });

  group('DTO parsing', () {
    test('WorkflowShowcaseDto parses nested relations', () {
      final dto = WorkflowShowcaseDto.fromJson({
        'id': 'showcase-1',
        'workflow_id': 'wf-1',
        'title': '世界一危険な島3選',
        'description': '説明',
        'thumbnail_url': 'https://example.com/thumb.png',
        'preview_image_url': 'https://example.com/preview.png',
        'preview_video_url': 'https://example.com/video.mp4',
        'completed_output': '完成ショート',
        'category': 'エンタメ',
        'difficulty': 'easy',
        'estimated_time': 40,
        'is_featured': true,
        'sort_order': 0,
        'created_at': '2026-01-15T00:00:00Z',
        'updated_at': '2026-01-15T00:00:00Z',
        'showcase_tags': [
          {'id': 'tag-1', 'showcase_id': 'showcase-1', 'tag': '雑学'},
        ],
        'showcase_assets': [
          {
            'id': 'asset-1',
            'showcase_id': 'showcase-1',
            'asset_type': 'video',
            'url': 'https://example.com/video.mp4',
            'title': '完成動画',
            'sort_order': 0,
          },
        ],
      });

      final entity = dto.toEntity();
      expect(entity.difficulty, ShowcaseDifficulty.easy);
      expect(entity.tags, hasLength(1));
      expect(entity.assets.first.assetType, ShowcaseAssetType.video);
    });

    test('ShowcaseTagDto parses tag row', () {
      final dto = ShowcaseTagDto.fromJson({
        'id': 'tag-1',
        'showcase_id': 'showcase-1',
        'tag': '保存版',
      });

      expect(dto.toEntity().tag, '保存版');
    });

    test('ShowcaseAssetDto parses prompt asset type', () {
      final dto = ShowcaseAssetDto.fromJson({
        'id': 'asset-1',
        'showcase_id': 'showcase-1',
        'asset_type': 'prompt',
        'url': 'https://example.com/prompt.txt',
        'title': 'プロンプト',
        'sort_order': 1,
      });

      expect(dto.toEntity().assetType, ShowcaseAssetType.prompt);
    });
  });

  group('Mock repository', () {
    test('Sprint 12.4 seed counts', () {
      expect(mockWorkflowShowcases, hasLength(9));
      expect(mockShowcaseTags, hasLength(27));
      expect(mockShowcaseAssets, hasLength(18));
    });

    test('fetchShowcases returns all showcases sorted', () async {
      final repository = MockWorkflowShowcaseRepository();
      final showcases = await repository.fetchShowcases();

      expect(showcases, hasLength(9));
      expect(showcases.first.sortOrder, lessThanOrEqualTo(showcases.last.sortOrder));
    });

    test('fetchFeaturedShowcases returns one per workflow', () async {
      final repository = MockWorkflowShowcaseRepository();
      final featured = await repository.fetchFeaturedShowcases();

      expect(featured, hasLength(3));
      expect(featured.every((showcase) => showcase.isFeatured), isTrue);
    });

    test('fetchByWorkflow returns youtube showcases only', () async {
      final repository = MockWorkflowShowcaseRepository();
      final showcases =
          await repository.fetchByWorkflow('wf_youtube_short');

      expect(showcases, hasLength(3));
      expect(showcases.every((s) => s.workflowId == 'wf_youtube_short'), isTrue);
    });
  });

  group('Showcase providers smoke', () {
    test('featuredShowcasesProvider resolves mock data', () async {
      final container = ProviderContainer(
        overrides: [
          workflowShowcaseRepositoryProvider.overrideWithValue(
            MockWorkflowShowcaseRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final showcases = await container.read(featuredShowcasesProvider.future);

      expect(showcases, hasLength(3));
      expect(showcases.first.title, mockWorkflowShowcases.first.title);
    });

    test('workflowShowcasesProvider resolves mock data', () async {
      final container = ProviderContainer(
        overrides: [
          workflowShowcaseRepositoryProvider.overrideWithValue(
            MockWorkflowShowcaseRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final showcases = await container.read(
        workflowShowcasesProvider('wf_blog').future,
      );

      expect(showcases, hasLength(3));
      expect(showcases.first.workflowId, 'wf_blog');
    });
  });
}
