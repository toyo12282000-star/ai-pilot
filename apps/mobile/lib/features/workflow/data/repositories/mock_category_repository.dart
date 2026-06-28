import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/category.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/category_repository.dart';

/// [CategoryRepository] の Mock 実装。
///
/// メモリ上の固定カテゴリデータを返す。UI 開発用。
class MockCategoryRepository implements CategoryRepository {
  @override
  Future<List<Category>> fetchCategories() async {
    await Future<void>.delayed(mockNetworkDelay);
    return List<Category>.from(mockCategories)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }
}
