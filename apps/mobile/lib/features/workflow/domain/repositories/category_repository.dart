import 'package:ai_pilot/features/workflow/domain/entities/category.dart';

/// カテゴリの取得を担当する Repository インターフェース。
///
/// ## 責務
/// - ワークフロー分類用カテゴリ一覧の提供
/// - 表示順（[Category.sortOrder]）に基づく並び替えは実装側で行う
abstract class CategoryRepository {
  /// 全カテゴリを取得する。
  Future<List<Category>> fetchCategories();
}
