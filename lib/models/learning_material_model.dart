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
    this.createdBy = '',
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
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory LearningMaterialModel.fromMap(Map<String, dynamic> map) {
    return LearningMaterialModel(
      id: (map['id'] as String? ?? '').trim(),
      category: MediaSourceHelper.normalizeCategory(
        map['category'] as String? ?? LearningCategories.benda,
      ),
      symbol: (map['symbol'] as String? ?? '').trim(),
      label: (map['label'] as String? ?? '').trim(),
      imagePath: (map['image_path'] as String? ?? '').trim(),
      audioPath: (map['audio_path'] as String? ?? '').trim(),
      videoPath: (map['video_path'] as String? ?? '').trim(),
      createdBy: (map['created_by'] as String? ?? '').trim(),
      createdAt: _parseDate(map['created_at']) ?? DateTime.now().toUtc(),
      updatedAt: _parseDate(map['updated_at']) ?? DateTime.now().toUtc(),
    );
  }

  factory LearningMaterialModel.fromEntity(LearningMaterialEntity entity) {
    final category = MediaSourceHelper.normalizeCategory(entity.category);
    return LearningMaterialModel(
      id: entity.materialId,
      category: category,
      symbol: switch (category) {
        LearningCategories.benda => entity.subcategory,
        LearningCategories.lagu => '',
        _ => entity.title,
      },
      label: switch (category) {
        LearningCategories.benda => entity.title,
        LearningCategories.lagu => entity.title,
        _ => entity.subcategory,
      },
      imagePath: entity.imagePath,
      audioPath: entity.audioPath,
      videoPath: entity.videoPath,
      createdBy: entity.sourceUrl,
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
    String? createdBy,
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
      createdBy: createdBy ?? this.createdBy,
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
      'created_by': createdBy,
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
      ..sourceUrl = createdBy
      ..fileName = ''
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
}
