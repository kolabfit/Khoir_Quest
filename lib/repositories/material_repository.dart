import 'package:isar/isar.dart';

import '../core/constants/default_learning_catalog.dart';
import '../database/collections/learning_material_collection.dart';
import '../database/isar_database_service.dart';

class MaterialRepository {
  MaterialRepository(this._database);

  final IsarDatabaseService _database;

  Future<void> seedDefaults({required Map<String, String> seededPaths}) async {
    await _database.write((isar) async {
      final hasAny = await isar.learningMaterialEntitys.count() > 0;
      if (hasAny) return;
      final entities = <LearningMaterialEntity>[
        ...DefaultLearningCatalog.hurufSeed.map(
          (letter) => LearningMaterialEntity()
            ..materialId = 'huruf_$letter'
            ..title = letter
            ..subcategory = DefaultLearningCatalog.hurufExamples[letter] ?? ''
            ..category = LearningCategories.huruf
            ..imagePath =
                seededPaths[DefaultStorageFiles.hurufImage] ??
                DefaultLearningCatalog.hurufPlaceholderAsset
            ..createdAt = DateTime.now()
            ..updatedAt = DateTime.now(),
        ),
        ...DefaultLearningCatalog.angkaSeed.map(
          (number) => LearningMaterialEntity()
            ..materialId = 'angka_$number'
            ..title = number
            ..subcategory = DefaultLearningCatalog.angkaLabels[number] ?? number
            ..category = LearningCategories.angka
            ..imagePath =
                seededPaths[DefaultStorageFiles.angkaImage] ??
                DefaultLearningCatalog.angkaPlaceholderAsset
            ..createdAt = DateTime.now()
            ..updatedAt = DateTime.now(),
        ),
        ...DefaultLearningCatalog.bendaSeed.map(
          (item) => LearningMaterialEntity()
            ..materialId = 'benda_${item['title']!.toLowerCase()}'
            ..title = item['title']!
            ..subcategory = item['subcategory']!
            ..category = LearningCategories.benda
            ..imagePath =
                seededPaths[DefaultStorageFiles.bendaImage] ??
                DefaultLearningCatalog.bendaPlaceholderAsset
            ..createdAt = DateTime.now()
            ..updatedAt = DateTime.now(),
        ),
        ...DefaultLearningCatalog.iqraPairs.map(
          (item) => LearningMaterialEntity()
            ..materialId = 'iqra_${item['label']!.toLowerCase()}'
            ..title = item['symbol']!
            ..subcategory = item['label']!
            ..category = LearningCategories.iqra
            ..imagePath =
                seededPaths[DefaultStorageFiles.iqraImage] ??
                DefaultLearningCatalog.iqraPlaceholderAsset
            ..createdAt = DateTime.now()
            ..updatedAt = DateTime.now(),
        ),
      ];
      await isar.learningMaterialEntitys.putAll(entities);
    });
  }

  Future<void> normalizeLearningDefaults() async {
    await _database.write((isar) async {
      final items = (await isar.learningMaterialEntitys.where().findAll())
          .where(
            (item) =>
                item.deletedAt == null &&
                (item.category == LearningCategories.huruf ||
                    item.category == LearningCategories.angka),
          )
          .toList();
      final changed = <LearningMaterialEntity>[];
      for (final item in items) {
        final title = switch (item.category) {
          LearningCategories.huruf => _normalizePrefix(
            item.title,
            'huruf',
          ).toUpperCase(),
          LearningCategories.angka => _normalizePrefix(item.title, 'angka'),
          _ => item.title,
        };
        final subcategory = switch (item.category) {
          LearningCategories.huruf => _normalizeLearningLabel(
            value: item.subcategory,
            prefix: 'huruf',
            symbol: title,
            fallback: DefaultLearningCatalog.hurufExamples[title] ?? '',
          ),
          LearningCategories.angka => _normalizeLearningLabel(
            value: item.subcategory,
            prefix: 'angka',
            symbol: title,
            fallback: DefaultLearningCatalog.angkaLabels[title] ?? title,
          ),
          _ => item.subcategory,
        };
        if (item.title != title || item.subcategory != subcategory) {
          item
            ..title = title
            ..subcategory = subcategory
            ..updatedAt = DateTime.now();
          changed.add(item);
        }
      }
      if (changed.isNotEmpty) {
        await isar.learningMaterialEntitys.putAll(changed);
      }
    });
  }

  Future<List<LearningMaterialEntity>> loadByCategory(String category) {
    return _database.read(
      (isar) => isar.learningMaterialEntitys
          .where()
          .filter()
          .categoryEqualTo(category)
          .deletedAtIsNull()
          .sortByCreatedAtDesc()
          .findAll(),
    );
  }

  Future<List<LearningMaterialEntity>> loadSongs() =>
      loadByCategory(LearningCategories.lagu);

  Future<List<LearningMaterialEntity>> loadAll() {
    return _database.read(
      (isar) => isar.learningMaterialEntitys
          .where()
          .filter()
          .deletedAtIsNull()
          .sortByUpdatedAtDesc()
          .findAll(),
    );
  }

  Future<List<LearningMaterialEntity>> loadAllIncludingDeleted() {
    return _database.read(
      (isar) =>
          isar.learningMaterialEntitys.where().sortByUpdatedAtDesc().findAll(),
    );
  }

  Future<List<LearningMaterialEntity>> loadPendingSync() {
    return _database.read(
      (isar) => isar.learningMaterialEntitys
          .where()
          .filter()
          .syncStateEqualTo('dirty')
          .or()
          .syncStateEqualTo('deletePending')
          .sortByUpdatedAtDesc()
          .findAll(),
    );
  }

  Future<int> countPendingSync() async {
    final items = await loadPendingSync();
    return items.length;
  }

  Future<LearningMaterialEntity?> findByMaterialId(String materialId) {
    return _database.read(
      (isar) => isar.learningMaterialEntitys.getByMaterialId(materialId),
    );
  }

  Future<void> replaceCategory(
    String category,
    List<LearningMaterialEntity> items,
  ) async {
    await _database.write((isar) async {
      final existing = await isar.learningMaterialEntitys
          .where()
          .filter()
          .categoryEqualTo(category)
          .findAll();
      if (existing.isNotEmpty) {
        await isar.learningMaterialEntitys.deleteAll(
          existing.map((item) => item.id).toList(),
        );
      }
      if (items.isNotEmpty) {
        for (final item in items) {
          item
            ..syncState = 'clean'
            ..deletedAt = null;
        }
        await isar.learningMaterialEntitys.putAll(items);
      }
    });
  }

  Future<void> upsertEntity(LearningMaterialEntity entity) {
    return _database.write((isar) => isar.learningMaterialEntitys.put(entity));
  }

  Future<void> mergeFromCloud(List<LearningMaterialEntity> cloudItems) async {
    await _database.write((isar) async {
      for (final cloud in cloudItems) {
        final existing = await isar.learningMaterialEntitys.getByMaterialId(
          cloud.materialId,
        );
        if (existing != null && existing.syncState == 'dirty') {
          continue;
        }
        if (existing != null && existing.syncState == 'deletePending') {
          continue;
        }
        cloud.id = existing?.id ?? Isar.autoIncrement;
        cloud.syncState = cloud.deletedAt == null ? 'clean' : 'deleted';
        await isar.learningMaterialEntitys.put(cloud);
      }
    });
  }

  Future<void> replaceSongs(List<LearningMaterialEntity> items) async {
    await _database.write((isar) async {
      final existing = await isar.learningMaterialEntitys
          .filter()
          .categoryEqualTo(LearningCategories.lagu)
          .findAll();
      if (existing.isNotEmpty) {
        await isar.learningMaterialEntitys.deleteAll(
          existing.map((e) => e.id).toList(),
        );
      }
      await isar.learningMaterialEntitys.putAll(items);
    });
  }

  Future<LearningMaterialEntity> saveObject({
    required String title,
    required String imagePath,
    required String subcategory,
  }) async {
    final entity = LearningMaterialEntity()
      ..materialId =
          'benda_${title.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}'
      ..title = title
      ..subcategory = subcategory
      ..category = LearningCategories.benda
      ..imagePath = imagePath
      ..syncState = 'dirty'
      ..deletedAt = null
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();
    await _database.write((isar) => isar.learningMaterialEntitys.put(entity));
    return entity;
  }

  Future<LearningMaterialEntity> upsertMaterial({
    required String materialId,
    required String category,
    required String title,
    required String imagePath,
    String subcategory = '',
    String audioPath = '',
    String fileName = '',
  }) async {
    final existing = await _database.read(
      (isar) => isar.learningMaterialEntitys.getByMaterialId(materialId),
    );
    final entity = existing ?? LearningMaterialEntity()
      ..materialId = materialId;
    entity
      ..category = category
      ..title = title
      ..subcategory = subcategory
      ..imagePath = imagePath
      ..audioPath = audioPath
      ..fileName = fileName
      ..syncState = 'dirty'
      ..deletedAt = null
      ..mediaVersion = existing?.mediaVersion ?? 1
      ..createdAt = existing?.createdAt ?? DateTime.now()
      ..updatedAt = DateTime.now();
    await _database.write((isar) => isar.learningMaterialEntitys.put(entity));
    return entity;
  }

  Future<void> deleteMaterialById(String materialId) async {
    await _database.write((isar) async {
      final entity = await isar.learningMaterialEntitys
          .filter()
          .materialIdEqualTo(materialId)
          .findFirst();
      if (entity != null) {
        entity
          ..syncState = 'deletePending'
          ..deletedAt = DateTime.now()
          ..updatedAt = DateTime.now();
        await isar.learningMaterialEntitys.put(entity);
      }
    });
  }

  Future<void> upsertSong({
    required String id,
    required String title,
    required String videoPath,
    String? fileName,
  }) async {
    await _database.write((isar) async {
      final existing = await isar.learningMaterialEntitys
          .filter()
          .materialIdEqualTo(id)
          .findFirst();
      final entity = existing ?? LearningMaterialEntity()
        ..materialId = id;
      entity
        ..title = title
        ..category = LearningCategories.lagu
        ..videoPath = videoPath
        ..fileName = fileName ?? ''
        ..thumbnailPath = ''
        ..syncState = 'dirty'
        ..deletedAt = null
        ..createdAt = existing?.createdAt ?? DateTime.now()
        ..updatedAt = DateTime.now();
      await isar.learningMaterialEntitys.put(entity);
    });
  }

  Future<void> setFavoriteState(Set<String> favoriteIds) async {
    await _database.write((isar) async {
      final items = await isar.learningMaterialEntitys.where().findAll();
      for (final item in items) {
        item.favorite = favoriteIds.contains(item.materialId);
      }
      await isar.learningMaterialEntitys.putAll(items);
    });
  }

  String _normalizePrefix(String value, String prefix) {
    return value
        .trim()
        .replaceFirst(RegExp('^$prefix\\s+', caseSensitive: false), '')
        .trim();
  }

  String _normalizeLearningLabel({
    required String value,
    required String prefix,
    required String symbol,
    required String fallback,
  }) {
    final cleaned = _normalizePrefix(value, prefix);
    if (cleaned.isNotEmpty && cleaned.toUpperCase() != symbol.toUpperCase()) {
      return cleaned;
    }
    return fallback;
  }
}
