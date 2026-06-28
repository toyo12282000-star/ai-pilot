import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/workflow/data/dto/category_dto.dart';
import 'package:ai_pilot/features/workflow/domain/entities/category.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/category_repository.dart';

/// [CategoryRepository] の Supabase 実装。
class SupabaseCategoryRepository implements CategoryRepository {
  SupabaseCategoryRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<Category>> fetchCategories() async {
    final response = await _client
        .from('categories')
        .select()
        .order('sort_order', ascending: true);

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(CategoryDto.fromJson)
        .map((dto) => dto.toEntity())
        .toList();
  }
}
