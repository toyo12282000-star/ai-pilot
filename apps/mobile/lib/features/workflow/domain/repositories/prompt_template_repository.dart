import 'package:ai_pilot/features/workflow/domain/entities/prompt_template.dart';

/// プロンプトテンプレートの取得を担当する Repository インターフェース。
abstract class PromptTemplateRepository {
  /// 全プロンプトテンプレートを取得する。
  Future<List<PromptTemplate>> fetchPromptTemplates();

  /// ID を指定してプロンプトテンプレートを 1 件取得する。
  ///
  /// 該当がない場合は `null` を返す。
  Future<PromptTemplate?> fetchPromptTemplateById(String id);
}
