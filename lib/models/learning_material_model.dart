import '../core/constants/default_learning_catalog.dart';
import '../core/utils/media_source_helper.dart';
import '../database/collections/learning_material_collection.dart';

class LearningMaterialModel {
  const LearningMaterialModel({
    required this.id,
    required this.category,
    required this.symbol,
    required this.label,
    this.imagePath = '',
    this.audioPath = '',
    this.videoPath = '',
    this.imageStoragePath = '',
    this.audioStoragePath = '',
    this.videoStoragePath = '',
    this.createdBy = '',
    this.version = 0,
    this.mediaVersion = 1,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String category;
  final String symbol;
  final String label;
  final String imagePath;
  final String audioPath;
  final String videoPath;
  final String imageStoragePath;
  final String audioStoragePath;
  final String videoStoragePath;
  final String createdBy;
  final int version;
  final int mediaVersion;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory LearningMaterialModel.fromMap(Map<String, dynamic> map) {
    final category = MediaSourceHelper.normalizeCategory(
      map['category'] as String? ?? LearningCategories.benda,
    );
    final symbol = _normalizeSymbol(map['symbol'] as String? ?? '', category);
    return LearningMaterialModel(
      id: (map['id'] as String? ?? '').trim(),
      category: category,
      symbol: symbol,
      label: _normalizeLabel(
        map['label'] as String? ?? '',
        category,
        fallbackSymbol: symbol,
      ),
      imagePath: (map['image_path'] as String? ?? '').trim(),
      audioPath: (map['audio_path'] as String? ?? '').trim(),
      videoPath: (map['video_path'] as String? ?? '').trim(),
      imageStoragePath: (map['image_storage_path'] as String? ?? '').trim(),
      audioStoragePath: (map['audio_storage_path'] as String? ?? '').trim(),
      videoStoragePath: (map['video_storage_path'] as String? ?? '').trim(),
      createdBy: (map['created_by'] as String? ?? '').trim(),
      version: (map['version'] as num?)?.toInt() ?? 0,
      mediaVersion: (map['media_version'] as num?)?.toInt() ?? 1,
      deletedAt: _parseDate(map['deleted_at']),
      createdAt: _parseDate(map['created_at']) ?? DateTime.now().toUtc(),
      updatedAt: _parseDate(map['updated_at']) ?? DateTime.now().toUtc(),
    );
  }

  factory LearningMaterialModel.fromEntity(LearningMaterialEntity entity) {
    final category = MediaSourceHelper.normalizeCategory(entity.category);
    final normalizedTitle = _normalizeSymbol(entity.title, category);
    final normalizedLabel = _normalizeLabel(
      entity.subcategory,
      category,
      fallbackSymbol: normalizedTitle,
    );
    return LearningMaterialModel(
      id: entity.materialId,
      category: category,
      symbol: switch (category) {
        LearningCategories.benda => entity.subcategory,
        LearningCategories.lagu => '',
        _ => normalizedTitle,
      },
      label: switch (category) {
        LearningCategories.benda => entity.title,
        LearningCategories.lagu => entity.title,
        _ => normalizedLabel,
      },
      imagePath: entity.imagePath,
      audioPath: entity.audioPath,
      videoPath: entity.videoPath,
      imageStoragePath: entity.imageStoragePath,
      audioStoragePath: entity.audioStoragePath,
      videoStoragePath: entity.videoStoragePath,
      createdBy: entity.sourceUrl,
      version: entity.cloudVersion,
      mediaVersion: entity.mediaVersion,
      deletedAt: entity.deletedAt?.toUtc(),
      createdAt: entity.createdAt.toUtc(),
      updatedAt: entity.updatedAt.toUtc(),
    );
  }

  LearningMaterialModel copyWith({
    String? id,
    String? category,
    String? symbol,
    String? label,
    String? imagePath,
    String? audioPath,
    String? videoPath,
    String? imageStoragePath,
    String? audioStoragePath,
    String? videoStoragePath,
    String? createdBy,
    int? version,
    int? mediaVersion,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LearningMaterialModel(
      id: id ?? this.id,
      category: category ?? this.category,
      symbol: symbol ?? this.symbol,
      label: label ?? this.label,
      imagePath: imagePath ?? this.imagePath,
      audioPath: audioPath ?? this.audioPath,
      videoPath: videoPath ?? this.videoPath,
      imageStoragePath: imageStoragePath ?? this.imageStoragePath,
      audioStoragePath: audioStoragePath ?? this.audioStoragePath,
      videoStoragePath: videoStoragePath ?? this.videoStoragePath,
      createdBy: createdBy ?? this.createdBy,
      version: version ?? this.version,
      mediaVersion: mediaVersion ?? this.mediaVersion,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'symbol': symbol,
      'label': label,
      'image_path': imagePath.isEmpty ? null : imagePath,
      'audio_path': audioPath.isEmpty ? null : audioPath,
      'video_path': videoPath.isEmpty ? null : videoPath,
      'image_storage_path': imageStoragePath.isEmpty ? null : imageStoragePath,
      'audio_storage_path': audioStoragePath.isEmpty ? null : audioStoragePath,
      'video_storage_path': videoStoragePath.isEmpty ? null : videoStoragePath,
      'created_by': createdBy,
      'version': version,
      'media_version': mediaVersion,
      'deleted_at': deletedAt?.toUtc().toIso8601String(),
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  LearningMaterialEntity toEntity() {
    final entity = LearningMaterialEntity()..materialId = id;
    entity
      ..category = category
      ..title = switch (category) {
        LearningCategories.benda => label,
        LearningCategories.lagu => label,
        _ => symbol,
      }
      ..subcategory = switch (category) {
        LearningCategories.benda => symbol,
        LearningCategories.lagu => '',
        _ => label,
      }
      ..imagePath = imagePath
      ..audioPath = audioPath
      ..videoPath = videoPath
      ..imageStoragePath = imageStoragePath
      ..audioStoragePath = audioStoragePath
      ..videoStoragePath = videoStoragePath
      ..sourceUrl = createdBy
      ..fileName = ''
      ..cloudVersion = version
      ..cloudUpdatedAt = updatedAt.toLocal()
      ..syncState = deletedAt == null ? 'clean' : 'deleted'
      ..deletedAt = deletedAt?.toLocal()
      ..mediaVersion = mediaVersion
      ..createdAt = createdAt.toLocal()
      ..updatedAt = updatedAt.toLocal();
    return entity;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is DateTime) return value.toUtc();
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value)?.toUtc();
    }
    return null;
  }

  static String _normalizeSymbol(String value, String category) {
    final text = value.trim();
    return switch (category) {
      LearningCategories.huruf =>
        text
            .replaceFirst(RegExp(r'^huruf\s+', caseSensitive: false), '')
            .trim()
            .toUpperCase(),
      LearningCategories.angka =>
        text
            .replaceFirst(RegExp(r'^angka\s+', caseSensitive: false), '')
            .trim(),
      _ => text,
    };
  }

  static String _normalizeLabel(
    String value,
    String category, {
    required String fallbackSymbol,
  }) {
    final text = value.trim();
    if (category == LearningCategories.angka) {
      final cleaned = text
          .replaceFirst(RegExp(r'^angka\s+', caseSensitive: false), '')
          .trim();
      if (cleaned.isNotEmpty && cleaned != fallbackSymbol) return cleaned;
      return DefaultLearningCatalog.angkaLabels[fallbackSymbol] ??
          fallbackSymbol;
    }
    if (category == LearningCategories.huruf) {
      final cleaned = text
          .replaceFirst(RegExp(r'^huruf\s+', caseSensitive: false), '')
          .trim();
      if (cleaned.isNotEmpty && cleaned.toUpperCase() != fallbackSymbol) {
        return cleaned;
      }
      return DefaultLearningCatalog.hurufExamples[fallbackSymbol] ?? cleaned;
    }
    return text;
  }
}
