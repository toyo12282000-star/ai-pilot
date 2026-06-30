import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_completion_progress.dart';
import 'package:ai_pilot/features/workflow/presentation/widgets/workflow_product_cta.dart';

void main() {
  testWidgets('WorkflowCompletionProgress renders steps and rate', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WorkflowCompletionProgress(
            steps: ['Step1', 'Step2', 'Step3', 'Step4'],
            currentStepIndex: 1,
          ),
        ),
      ),
    );

    expect(find.text('Step1'), findsOneWidget);
    expect(find.text('Step4'), findsOneWidget);
    expect(find.text('50% 完了'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('WorkflowProductCta label is unified', () {
    expect(WorkflowProductCta.label, '無料でこの作品を作る');
  });
}
