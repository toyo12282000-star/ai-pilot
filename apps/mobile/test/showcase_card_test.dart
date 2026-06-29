import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/home/presentation/widgets/showcase_card.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_showcase_seed_data.dart';

void main() {
  testWidgets('ShowcaseCard renders without overflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final showcase = mockWorkflowShowcases.first;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ShowcaseCard(
              showcase: showcase,
              onTap: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('作ってみる'), findsOneWidget);
    expect(find.text(showcase.title), findsOneWidget);
  });

  test('ShowcaseCard listExtent covers image and content', () {
    expect(
      ShowcaseCard.listExtent,
      greaterThan(ShowcaseCard.imageHeight),
    );
  });
}
