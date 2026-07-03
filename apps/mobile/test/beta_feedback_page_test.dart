import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/profile/presentation/pages/beta_feedback_page.dart';
import 'package:ai_pilot/shared/config/beta_config.dart';

void main() {
  testWidgets('Beta feedback page shows action cards', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: BetaFeedbackPage()),
    );
    await tester.pumpAndSettle();

    expect(find.text('β版フィードバック'), findsOneWidget);
    expect(find.text('不具合・改善要望を送る'), findsOneWidget);
    expect(find.text('欲しい Workflow をリクエスト'), findsOneWidget);
    expect(find.text('β版の感想を送る'), findsOneWidget);
  });

  test('BetaConfig builds mailto URIs', () {
    expect(BetaConfig.feedbackUri.scheme, 'mailto');
    expect(BetaConfig.feedbackUri.path, BetaConfig.feedbackEmail);
    expect(
      BetaConfig.workflowRequestUri.query,
      contains('AI%20Pilot%20Workflow'),
    );
  });
}
