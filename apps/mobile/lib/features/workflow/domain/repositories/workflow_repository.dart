import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

/// ワークフローの取得・検索を担当する Repository インターフェース。
///
/// ## 責務
/// - ワークフロー一覧・詳細の取得
/// - カテゴリ別・キーワード検索による絞り込み
/// - [Workflow] 集約（steps 含む）を Domain Entity として返す
///
/// 永続化の詳細（Supabase 等）は Data 層の実装に委ねる。
abstract class WorkflowRepository {
  /// 全ワークフローを取得する。
  ///
  /// 各 [Workflow] には [Workflow.steps] が含まれる。
  Future<List<Workflow>> fetchWorkflows();

  /// 指定カテゴリに属するワークフローを取得する。
  ///
  /// [categoryId] に一致する [Workflow.categoryId] を持つものを返す。
  Future<List<Workflow>> fetchWorkflowsByCategory(String categoryId);

  /// ID を指定してワークフローを 1 件取得する。
  ///
  /// 該当がない場合は `null` を返す。
  Future<Workflow?> fetchWorkflowById(String id);

  /// キーワードでワークフローを検索する。
  ///
  /// [query] はタイトル・説明・タグ等を対象とする（具体ロジックは実装側）。
  Future<List<Workflow>> searchWorkflows(String query);
}
