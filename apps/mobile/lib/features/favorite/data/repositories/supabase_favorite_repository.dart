import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/favorite/data/dto/favorite_dto.dart';
import 'package:ai_pilot/features/favorite/domain/entities/favorite.dart';
import 'package:ai_pilot/features/favorite/domain/repositories/favorite_repository.dart';

/// [FavoriteRepository] の Supabase 実装。
class SupabaseFavoriteRepository implements FavoriteRepository {
  SupabaseFavoriteRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _selectWithWorkflow = '''
id,
user_id,
workflow_id,
created_at,
workflows (
  id
)
''';

  @override
  Future<List<Favorite>> fetchFavorites(String userId) async {
    final response = await _client
        .from('favorites')
        .select(_selectWithWorkflow)
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .where((row) => row['workflows'] != null)
        .map(FavoriteDto.fromJson)
        .map((dto) => dto.toEntity())
        .toList();
  }

  @override
  Future<bool> isFavorite(String userId, String workflowId) async {
    final response = await _client
        .from('favorites')
        .select('id')
        .eq('user_id', userId)
        .eq('workflow_id', workflowId)
        .maybeSingle();

    return response != null;
  }

  @override
  Future<void> addFavorite(String userId, String workflowId) async {
    final alreadyExists = await isFavorite(userId, workflowId);
    if (alreadyExists) {
      return;
    }

    await _client.from('favorites').insert({
      'user_id': userId,
      'workflow_id': workflowId,
    });
  }

  @override
  Future<void> removeFavorite(String userId, String workflowId) async {
    await _client
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('workflow_id', workflowId);
  }
}
