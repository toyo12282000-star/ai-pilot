import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/home/presentation/widgets/showcase_card.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_showcase_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/showcase_library_catalog.dart';
import 'package:ai_pilot/features/workflow/data/services/mock_showcase_image_storage.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/showcase_image_providers.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/showcase_cta_copy.dart';

void main() {
  testWidgets('ShowcaseCard renders without overflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final showcase = mockWorkflowShowcases.firstWhere(
      (s) => s.id == showcaseLibraryCatalog.first.id,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          showcaseImageStorageProvider.overrideWithValue(
            MockShowcaseImageStorage(),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: ShowcaseCard(
                showcase: showcase,
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text(ShowcaseCtaCopy.cardLabel(showcase)), findsOneWidget);
    expect(find.text(showcase.title), findsOneWidget);
  });

  testWidgets('ShowcaseCard listExtent covers image and content', (tester) async {
    late double listExtent;
    late double imageHeight;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            listExtent = ShowcaseCard.listExtent(context);
            imageHeight = ShowcaseCard.imageHeight(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(listExtent, greaterThan(imageHeight));
  });
}
