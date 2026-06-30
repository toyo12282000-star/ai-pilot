import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/workflow/data/repositories/mock_showcase_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/showcase_library_catalog.dart';
import 'package:ai_pilot/features/workflow/data/services/mock_showcase_image_storage.dart';
import 'package:ai_pilot/features/workflow/data/services/showcase_image_path_registry.dart';
import 'package:ai_pilot/features/workflow/domain/services/showcase_image_kind.dart';
import 'package:ai_pilot/features/workflow/domain/services/showcase_image_resolver.dart';

void main() {
  group('ShowcaseImagePathRegistry', () {
    test('maps showcase id to storage path', () {
      expect(
        ShowcaseImagePathRegistry.pathFor(
          'showcase_yt_1',
          ShowcaseImageKind.preview,
        ),
        'youtube/wf_youtube_short/showcase_yt_1/preview.webp',
      );
    });

    test('catalog has 30 entries', () {
      expect(showcaseLibraryCatalog, hasLength(30));
    });
  });

  group('ShowcaseImageResolver', () {
    late ShowcaseImageResolver resolver;

    setUp(() {
      resolver = ShowcaseImageResolver(MockShowcaseImageStorage());
    });

    test('resolves preview url to bundled asset scheme', () {
      final showcase = mockWorkflowShowcases.first;
      final url = resolver.resolvePreviewUrl(showcase);

      expect(url, startsWith('asset:assets/showcases/'));
      expect(url, contains('preview.svg'));
    });

    test('hero and card preview use the same url for a showcase', () {
      final showcase = mockWorkflowShowcases.first;
      final preview = resolver.resolvePreviewUrl(showcase);
      final hero = resolver.resolveHeroUrl(
        showcase,
        workflowId: showcase.workflowId,
      );

      expect(preview, hero);
    });

    test('passes through absolute legacy urls', () {
      final url = resolver.resolveStoredReference(
        'https://example.com/legacy.png',
      );

      expect(url, 'https://example.com/legacy.png');
    });

    test('resolveHeroUrl falls back to workflow featured path', () {
      final url = resolver.resolveHeroUrl(
        null,
        workflowId: 'wf_youtube_short',
      );

      expect(url, startsWith('asset:'));
      expect(
        url,
        contains('youtube/wf_youtube_short/showcase_yt_1/preview.svg'),
      );
    });
  });
}
