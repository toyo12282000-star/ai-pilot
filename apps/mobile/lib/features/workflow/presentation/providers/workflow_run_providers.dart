import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 実行モードの現在ステップ index（0 始まり）。
///
/// [autoDispose] により画面を離れると自動リセットされる。
final workflowRunStepIndexProvider = NotifierProvider.autoDispose
    .family<WorkflowRunStepIndexNotifier, int, String>(
  WorkflowRunStepIndexNotifier.new,
);

/// ワークフロー実行中のステップ index を管理する。
class WorkflowRunStepIndexNotifier
    extends AutoDisposeFamilyNotifier<int, String> {
  @override
  int build(String workflowId) => 0;

  /// 前のステップへ移動する。
  void previous() {
    if (state > 0) {
      state = state - 1;
    }
  }

  /// 次のステップへ移動する。
  void next(int lastIndex) {
    if (state < lastIndex) {
      state = state + 1;
    }
  }
}
