import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/learning_material_model.dart';
import '../services/supabase_service.dart';

class LearningMaterialRepository {
  LearningMaterialRepository(this._supabaseService);

  final SupabaseService _supabaseService;

  SupabaseClient get _client => _supabaseService.client;

  Future<List<LearningMaterialModel>> fetchAll() async {
    final data = await _client
        .from('learning_materials')
        .select()
        .order('category')
        .order('updated_at', ascending: false);
    return (data as List<dynamic>)
        .map(
          (item) => LearningMaterialModel.fromMap(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Stream<List<LearningMaterialModel>> watchAll() {
    return _client
        .from('learning_materials')
        .stream(primaryKey: const ['id'])
        .order('updated_at', ascending: false)
        .map(
          (rows) => rows
              .where((item) => item['deleted_at'] == null)
              .map((item) => LearningMaterialModel.fromMap(item))
              .toList(),
        );
  }

  Future<LearningMaterialModel?> findById(String id) async {
    final data = await _client
        .from('learning_materials')
        .select()
        .eq('id', id)
        .isFilter('deleted_at', null)
        .maybeSingle();
    if (data == null) return null;
    return LearningMaterialModel.fromMap(Map<String, dynamic>.from(data));
  }

  Future<LearningMaterialModel> upsertMaterial(
    LearningMaterialModel material, {
    int? expectedVersion,
  }) async {
    final data = expectedVersion == null
        ? await _client
              .from('learning_materials')
              .upsert(material.toMap(), onConflict: 'id')
              .select()
              .single()
        : await _client
              .rpc(
                'upsert_learning_material_if_current',
                params: {
                  'expected_version': expectedVersion,
                  'payload': material.toMap(),
                },
              )
              .single();
    return LearningMaterialModel.fromMap(Map<String, dynamic>.from(data));
  }

  Future<LearningMaterialModel> softDeleteMaterial(
    String id, {
    required int expectedVersion,
  }) async {
    final data = await _client
        .rpc(
          'soft_delete_learning_material_if_current',
          params: {'material_id': id, 'expected_version': expectedVersion},
        )
        .single();
    return LearningMaterialModel.fromMap(Map<String, dynamic>.from(data));
  }
}
