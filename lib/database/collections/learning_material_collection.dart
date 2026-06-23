import 'package:isar/isar.dart';

part 'learning_material_collection.g.dart';

@collection
class LearningMaterialEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String materialId;

  @Index()
  late String category;

  @Index()
  bool favorite = false;

  String title = '';
  String subcategory = '';
  String imagePath = '';
  String audioPath = '';
  String videoPath = '';
  String imageStoragePath = '';
  String audioStoragePath = '';
  String videoStoragePath = '';
  String thumbnailPath = '';
  String fileName = '';
  String sourceUrl = '';
  int cloudVersion = 0;
  DateTime? cloudUpdatedAt;
  String syncState = 'clean';
  DateTime? deletedAt;
  int mediaVersion = 1;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}
