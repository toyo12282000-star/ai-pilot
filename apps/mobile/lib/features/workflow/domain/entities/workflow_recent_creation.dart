import 'package:ai_pilot/features/workflow/domain/services/workflow_activity_time_formatter.dart';

/// Workflow 詳細「最近作られた作品」1 件。
class WorkflowRecentCreation {
  const WorkflowRecentCreation({
    required this.userId,
    required this.displayName,
    required this.activityAt,
  });

  final String userId;
  final String displayName;
  final DateTime activityAt;

  String get userLabel {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) {
      return 'ユーザー';
    }
    if (trimmed.endsWith('さん')) {
      return trimmed;
    }
    return '$trimmedさん';
  }

  String get timeLabel => WorkflowActivityTimeFormatter.format(activityAt);

  String get avatarInitial {
    final label = userLabel.replaceAll('さん', '').trim();
    if (label.isEmpty) {
      return '?';
    }
    return label.substring(0, 1);
  }
}
