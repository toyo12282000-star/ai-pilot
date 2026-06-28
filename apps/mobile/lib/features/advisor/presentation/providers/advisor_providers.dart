import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/advisor/domain/services/workflow_advisor_service.dart';

/// Workflow 推薦ロジック（MVP はルールベース）。
final workflowAdvisorServiceProvider = Provider<WorkflowAdvisorService>(
  (ref) => WorkflowAdvisorService(),
);
