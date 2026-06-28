import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/features/advisor/data/repositories/supabase_advisor_history_repository.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_history.dart';
import 'package:ai_pilot/features/advisor/domain/repositories/advisor_history_repository.dart';

/// [AdvisorHistoryRepository] を提供する（Supabase 実装）。
final advisorHistoryRepositoryProvider = Provider<AdvisorHistoryRepository>(
  (ref) => SupabaseAdvisorHistoryRepository(),
);

/// 指定ユーザーの Advisor 相談履歴（新しい順、最大 10 件）。
final advisorHistoriesProvider =
    FutureProvider.family<List<AdvisorHistory>, String>((ref, userId) {
  return ref.watch(advisorHistoryRepositoryProvider).fetchRecentHistories(
        userId,
      );
});

/// 相談履歴 Provider を再取得する。
void invalidateAdvisorHistories(WidgetRef ref, String userId) {
  ref.invalidate(advisorHistoriesProvider(userId));
}
