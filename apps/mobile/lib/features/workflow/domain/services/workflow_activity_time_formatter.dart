/// 最近の作成履歴向け相対日時ラベル。
abstract final class WorkflowActivityTimeFormatter {
  static String format(DateTime activityAt, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final localActivity = activityAt.toLocal();
    final localReference = reference.toLocal();

    final activityDay = DateTime(
      localActivity.year,
      localActivity.month,
      localActivity.day,
    );
    final referenceDay = DateTime(
      localReference.year,
      localReference.month,
      localReference.day,
    );
    final dayDiff = referenceDay.difference(activityDay).inDays;

    if (dayDiff <= 0) {
      return '今日作成';
    }
    if (dayDiff == 1) {
      return '昨日';
    }
    if (dayDiff < 7) {
      return '$dayDiff日前';
    }
    if (dayDiff < 30) {
      return '${dayDiff ~/ 7}週間前';
    }
    return '${localActivity.month}/${localActivity.day}';
  }
}
