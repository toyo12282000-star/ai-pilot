import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_showcase_gallery.dart';

void main() {
  test('mobile width uses 2 column gallery grid', () {
    expect(
      WorkflowShowcaseGallery.crossAxisCountForWidth(390),
      2,
    );
    expect(
      WorkflowShowcaseGallery.crossAxisCountForWidth(800),
      2,
    );
  });

  test('desktop width uses 3 column gallery grid', () {
    expect(
      WorkflowShowcaseGallery.crossAxisCountForWidth(1200),
      3,
    );
  });

  test('mobile tile aspect ratio targets compact card height', () {
    final ratio = WorkflowShowcaseGallery.childAspectRatio(
      tileWidth: 173,
      compactScreen: true,
    );

    final totalHeight = 173 / ratio;
    expect(totalHeight, greaterThan(170));
    expect(totalHeight, lessThan(230));
  });
}
