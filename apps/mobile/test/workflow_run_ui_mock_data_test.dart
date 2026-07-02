import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/presentation/mock/workflow_run_ui_mock_data.dart';

void main() {
  test('remainingMinutes decreases as steps advance', () {
    final early = WorkflowRunUiMockData.remainingMinutes(
      totalEstimatedMinutes: 45,
      currentStepIndex: 0,
      totalSteps: 4,
    );
    final late = WorkflowRunUiMockData.remainingMinutes(
      totalEstimatedMinutes: 45,
      currentStepIndex: 3,
      totalSteps: 4,
    );

    expect(early, greaterThan(late));
  });

  test('achievement copy reflects completed step', () {
    final copy = WorkflowRunUiMockData.achievementFor(
      completedStepIndex: 0,
      totalSteps: 4,
    );

    expect(copy.title, 'Step1 完了！');
    expect(copy.encouragement, 'いい感じです！');
    expect(copy.remainingMessage, 'あと3Stepです。');
  });

  test('checklist includes ai tool name when provided', () {
    final step = mockWorkflows.first.steps.first;
    final items = WorkflowRunUiMockData.checklistFor(
      step,
      aiToolName: 'ChatGPT',
    );

    expect(items.first, 'ChatGPTを開く');
    expect(items, hasLength(4));
  });
}
