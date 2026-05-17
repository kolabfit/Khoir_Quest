import '../core/constants/default_learning_catalog.dart';
import '../database/collections/learning_material_collection.dart';
import '../database/isar_database_service.dart';
import '../models/learning_material_model.dart';
import '../repositories/material_repository.dart' as local_repo;

class CacheService {
  CacheService._();

  static final instance = CacheService._();

  final local_repo.MaterialRepository _materials =
      local_repo.MaterialRepository(IsarDatabaseService.instance);

  Future<void> replaceFromCloud(List<LearningMaterialModel> materials) async {
    final grouped = <String, List<LearningMaterialEntity>>{
      LearningCategories.huruf: [],
      LearningCategories.angka: [],
      LearningCategories.benda: [],
      LearningCategories.iqra: [],
      LearningCategories.lagu: [],
    };
    for (final material in materials) {
      grouped.putIfAbsent(material.category, () => <LearningMaterialEntity>[]);
      grouped[material.category]!.add(material.toEntity());
    }
    for (final entry in grouped.entries) {
      await _materials.replaceCategory(entry.key, entry.value);
    }
  }

  Future<void> upsert(LearningMaterialModel material) {
    return _materials.upsertEntity(material.toEntity());
  }

  Future<void> delete(String materialId) =>
      _materials.deleteMaterialById(materialId);

  Future<LearningMaterialEntity?> findById(String materialId) =>
      _materials.findByMaterialId(materialId);

  Future<List<LearningMaterialEntity>> loadAllSyncable() =>
      _materials.loadAll();
}
