import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/default_learning_catalog.dart';
import '../core/utils/media_source_helper.dart';
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
    if (kIsWeb) return _webReplaceFromCloud(materials);
    await _materials.mergeFromCloud(
      materials.map((material) => material.toEntity()).toList(),
    );
  }

  Future<void> mergeFromCloud(List<LearningMaterialModel> materials) async {
    if (kIsWeb) return _webMergeFromCloud(materials);
    await _materials.mergeFromCloud(
      materials.map((material) => material.toEntity()).toList(),
    );
  }

  Future<void> upsert(LearningMaterialModel material) {
    if (kIsWeb) return _webUpsert(material);
    return _materials.upsertEntity(material.toEntity());
  }

  Future<void> delete(String materialId) {
    if (kIsWeb) return _webDelete(materialId);
    return _materials.deleteMaterialById(materialId);
  }

  Future<LearningMaterialEntity?> findById(String materialId) {
    if (kIsWeb) return _webFindById(materialId);
    return _materials.findByMaterialId(materialId);
  }

  Future<List<LearningMaterialEntity>> loadAllSyncable() {
    if (kIsWeb) return _webLoadAll();
    return _materials.loadAllIncludingDeleted();
  }

  Future<int> countLocalMaterials() async {
    return (await loadAllSyncable()).length;
  }

  Future<List<LearningMaterialEntity>> loadPendingSync() {
    if (kIsWeb) return Future.value(const <LearningMaterialEntity>[]);
    return _materials.loadPendingSync();
  }

  Future<int> countPendingSync() async {
    if (kIsWeb) return 0;
    return _materials.countPendingSync();
  }

  Future<void> _webReplaceFromCloud(
    List<LearningMaterialModel> materials,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final grouped = <String, List<LearningMaterialModel>>{};
    for (final material in materials.where((item) => item.deletedAt == null)) {
      grouped.putIfAbsent(material.category, () => []).add(material);
    }
    await prefs.setString(
      _webLettersKey,
      jsonEncode(
        (grouped[LearningCategories.huruf] ?? const [])
            .map(
              (item) => {
                'id': item.id,
                'letter': item.symbol,
                'example': item.label,
                'img': item.imagePath,
                'category': 'contoh',
              },
            )
            .toList(),
      ),
    );
    await prefs.setString(
      _webNumbersKey,
      jsonEncode(
        (grouped[LearningCategories.angka] ?? const [])
            .map(
              (item) => {
                'id': item.id,
                'number': item.symbol,
                'name': item.label,
                'img': item.imagePath,
              },
            )
            .toList(),
      ),
    );
    await prefs.setString(
      _webObjectsKey,
      jsonEncode(
        (grouped[LearningCategories.benda] ?? const [])
            .map(
              (item) => {
                'id': item.id,
                'name': item.label,
                'img': item.imagePath,
                'category': item.symbol.isEmpty ? 'benda' : item.symbol,
              },
            )
            .toList(),
      ),
    );
    await prefs.setString(
      _webSongsKey,
      jsonEncode(
        (grouped[LearningCategories.lagu] ?? const [])
            .map(
              (item) => {
                'id': item.id,
                'title': item.label,
                'videoUrl': item.videoPath,
                'fileName': null,
                'mediaType': item.mediaType,
              },
            )
            .toList(),
      ),
    );
  }

  Future<void> _webUpsert(LearningMaterialModel material) async {
    if (material.deletedAt != null) {
      return _webDelete(material.id);
    }
    final prefs = await SharedPreferences.getInstance();
    final items = await _webLoadModels(prefs);
    items.removeWhere((item) => item.id == material.id);
    items.add(material);
    await _webReplaceFromCloud(items);
  }

  Future<void> _webMergeFromCloud(List<LearningMaterialModel> materials) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await _webLoadModels(prefs);
    for (final material in materials) {
      items.removeWhere((item) => item.id == material.id);
      if (material.deletedAt == null) {
        items.add(material);
      }
    }
    await _webReplaceFromCloud(items);
  }

  Future<void> _webDelete(String materialId) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await _webLoadModels(prefs);
    items.removeWhere((item) => item.id == materialId);
    await _webReplaceFromCloud(items);
  }

  Future<LearningMaterialEntity?> _webFindById(String materialId) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await _webLoadModels(prefs);
    for (final item in items) {
      if (item.id == materialId) return item.toEntity();
    }
    return null;
  }

  Future<List<LearningMaterialEntity>> _webLoadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final items = await _webLoadModels(prefs);
    return items.map((item) => item.toEntity()).toList();
  }

  Future<List<LearningMaterialModel>> _webLoadModels(
    SharedPreferences prefs,
  ) async {
    final items = <LearningMaterialModel>[];
    final now = DateTime.now().toUtc();

    for (final map in _decodeList(prefs.getString(_webLettersKey))) {
      final id = map['id'] as String? ?? '';
      final symbol = map['letter'] as String? ?? '';
      if (id.isEmpty || symbol.isEmpty) continue;
      items.add(
        LearningMaterialModel(
          id: id,
          category: LearningCategories.huruf,
          symbol: symbol,
          label: map['example'] as String? ?? '',
          imagePath: map['img'] as String? ?? '',
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    for (final map in _decodeList(prefs.getString(_webNumbersKey))) {
      final id = map['id'] as String? ?? '';
      final symbol = map['number'] as String? ?? '';
      if (id.isEmpty || symbol.isEmpty) continue;
      items.add(
        LearningMaterialModel(
          id: id,
          category: LearningCategories.angka,
          symbol: symbol,
          label: map['name'] as String? ?? '',
          imagePath: map['img'] as String? ?? '',
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    for (final map in _decodeList(prefs.getString(_webObjectsKey))) {
      final id = map['id'] as String? ?? '';
      final label = map['name'] as String? ?? '';
      if (id.isEmpty || label.isEmpty) continue;
      items.add(
        LearningMaterialModel(
          id: id,
          category: LearningCategories.benda,
          symbol: map['category'] as String? ?? 'benda',
          label: label,
          imagePath: map['img'] as String? ?? '',
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    for (final map in _decodeList(prefs.getString(_webSongsKey))) {
      final id = map['id'] as String? ?? '';
      final label = map['title'] as String? ?? '';
      if (id.isEmpty || label.isEmpty) continue;
      items.add(
        LearningMaterialModel(
          id: id,
          category: LearningCategories.lagu,
          symbol: '',
          label: label,
          videoPath: map['videoUrl'] as String? ?? '',
          mediaType: MediaSourceHelper.inferSongMediaType(
            source: map['videoUrl'] as String? ?? '',
            fileName: map['fileName'] as String?,
            explicit: map['mediaType'] as String?,
          ),
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    return items;
  }

  List<Map<String, dynamic>> _decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  static const _webSongsKey = 'web.songs';
  static const _webObjectsKey = 'web.objects';
  static const _webLettersKey = 'web.letters';
  static const _webNumbersKey = 'web.numbers';
}
