import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/rangkai_item_model.dart';
import '../services/supabase_service.dart';

class RangkaiItemRepository {
  RangkaiItemRepository(this._supabaseService);

  final SupabaseService _supabaseService;

  SupabaseClient get _client => _supabaseService.client;

  Future<List<RangkaiItemModel>> fetchAll() async {
    final data = await _client
        .from('rangkai_items')
        .select()
        .order('type')
        .order('updated_at', ascending: false);
    return (data as List<dynamic>)
        .map(
          (item) =>
              RangkaiItemModel.fromMap(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<RangkaiItemModel> upsertItem(RangkaiItemModel item) async {
    final payload = item.toMap();
    final userId = _client.auth.currentUser?.id;
    if (userId != null) {
      payload['created_by'] = userId;
    }
    final data = await _client
        .from('rangkai_items')
        .upsert(payload, onConflict: 'id')
        .select()
        .single();
    return RangkaiItemModel.fromMap(Map<String, dynamic>.from(data));
  }

  Future<void> deleteItem(String id) async {
    await _client.from('rangkai_items').delete().eq('id', id);
  }
}
