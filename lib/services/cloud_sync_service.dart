import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

import '../core/utils/media_source_helper.dart';
import '../database/collections/learning_material_collection.dart';
import '../models/app_local_models.dart';
import '../models/cloud_auth_profile.dart';
import '../models/learning_material_model.dart';
import '../repositories/learning_material_repository.dart';
import '../repositories/storage_repository.dart';
import 'auth_service.dart';
import 'cache_service.dart';
import 'connectivity_service.dart';
import 'supabase_service.dart';
import 'upload_service.dart';

class CloudSyncService {
  CloudSyncService._();

  static final instance = CloudSyncService._();

  final SupabaseService _supabase = SupabaseService.instance;
  final AuthService _auth = AuthService.instance;
  final CacheService _cache = CacheService.instance;
  final ConnectivityService _connectivity = ConnectivityService.instance;
  final UploadService _upload = UploadService.instance;

  late final LearningMaterialRepository _materials = LearningMaterialRepository(
    _supabase,
  );

  bool get isConfigured => _supabase.isConfigured;

  bool get hasSession => _auth.hasSession;

  Stream<List<ConnectivityResult>> get connectivityChanges =>
      _connectivity.onChanged;

  Future<void> ensureReady() => _supabase.ensureInitialized();

  Future<bool> isOnline() => _connectivity.isOnline();

  Future<CloudAuthProfile?> currentProfile() => _auth.currentProfile();

  Future<void> resetPassword({
    required String username,
    required String newPassword,
  }) async {
    if (!isConfigured || !await isOnline()) return;
    await _auth.resetPasswordByUsername(
      username: username,
      newPassword: newPassword,
    );
  }

  Future<CloudAuthProfile> authenticate({
    required String username,
    required String password,
    required bool register,
    required String preferredRole,
  }) {
    return _auth.authenticate(
      username: username,
      password: password,
      register: register,
      preferredRole: preferredRole,
    );
  }

  Future<void> logout() => _auth.logout();

  Future<void> syncUserState(UserAccount account) async {
    if (!isConfigured || !hasSession || !await isOnline()) return;
    final profile = await _auth.currentProfile();
    if (profile == null) return;
    await _auth.upsertProfileState(
      userId: profile.userId,
      username: account.username,
      role: account.role is Enum
          ? (account.role as Enum).name
          : '${account.role}',
      avatarUrl: account.avatarPath,
      childName: account.childName,
      gender: account.gender is Enum
          ? (account.gender as Enum).name
          : '${account.gender}',
      themeId: account.themeId,
      stars: account.stars,
      iqraStreak: account.iqraStreak,
      progress: account.progress,
      iqraMastered: account.iqraMastered,
      iqraHistory: account.iqraHistory,
      hurfMastered: account.hurfMastered,
      angkaMastered: account.angkaMastered,
      bendaMastered: account.bendaMastered,
      favoriteMaterialIds: account.favoriteMaterialIds,
    );
  }

  Future<void> syncLearningHistory(List<LearningHistoryRecord> records) async {
    if (!isConfigured || !hasSession || !await isOnline() || records.isEmpty) {
      return;
    }
    final profile = await _auth.currentProfile();
    if (profile == null) return;
    for (final record in records) {
      await _auth.addLearningHistory(userId: profile.userId, record: record);
    }
  }

  Future<void> syncForRole({required String role}) async {
    if (!isConfigured || !hasSession || !await isOnline()) return;
    final profile = await _auth.currentProfile();
    if (profile == null) return;
    if (role == 'teacher') {
      await pushLocalTeacherCatalog(createdBy: profile.userId);
    }
    await pullCloudToLocal();
  }

  Future<List<LearningMaterialModel>> pullCloudToLocal() async {
    if (!isConfigured || !hasSession) return const [];
    final materials = await _materials.fetchAll();
    await _cache.replaceFromCloud(materials);
    return materials;
  }

  Future<List<LearningMaterialModel>> pushLocalTeacherCatalog({
    required String createdBy,
  }) async {
    final items = await _cache.loadAllSyncable();
    final pushed = <LearningMaterialModel>[];
    for (final item in items) {
      final synced = await syncLocalMaterial(
        item.materialId,
        createdBy: createdBy,
      );
      if (synced != null) {
        pushed.add(synced);
      }
    }
    return pushed;
  }

  Future<LearningMaterialModel?> syncLocalMaterial(
    String materialId, {
    String? createdBy,
  }) async {
    if (!isConfigured || !hasSession || !await isOnline()) return null;
    final entity = await _cache.findById(materialId);
    if (entity == null) return null;
    return _pushEntity(entity, createdBy: createdBy ?? entity.sourceUrl);
  }

  Future<void> deleteMaterial(String materialId) async {
    if (!isConfigured || !hasSession || !await isOnline()) return;
    final remote = await _materials.findById(materialId);
    await _materials.deleteMaterial(materialId);
    if (remote != null) {
      final storage = StorageRepository(_supabase);
      await storage.deletePublicUrl(remote.imagePath);
      await storage.deletePublicUrl(remote.audioPath);
      await storage.deletePublicUrl(remote.videoPath);
    }
    await _cache.delete(materialId);
  }

  Future<LearningMaterialModel> _pushEntity(
    LearningMaterialEntity entity, {
    required String createdBy,
  }) async {
    final model = LearningMaterialModel.fromEntity(entity);
    final imageUrl = await _resolveCloudUrl(
      path: model.imagePath,
      category: model.category,
      type: UploadedAssetType.image,
    );
    final audioUrl = await _resolveCloudUrl(
      path: model.audioPath,
      category: model.category,
      type: UploadedAssetType.audio,
    );
    final videoUrl = await _resolveCloudUrl(
      path: model.videoPath,
      category: model.category,
      type: UploadedAssetType.video,
    );
    final synced = await _materials.upsertMaterial(
      model.copyWith(
        imagePath: imageUrl,
        audioPath: audioUrl,
        videoPath: videoUrl,
        createdBy: createdBy,
        createdAt: model.createdAt,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await _cache.upsert(synced);
    return synced;
  }

  Future<String> _resolveCloudUrl({
    required String path,
    required String category,
    required UploadedAssetType type,
  }) async {
    final value = path.trim();
    if (value.isEmpty) return '';
    if (MediaSourceHelper.isRemoteUrl(value)) return value;
    if (MediaSourceHelper.isAssetPath(value)) {
      final fileName = value.split('/').last;
      final bytes = (await rootBundle.load(value)).buffer.asUint8List();
      final asset = await _upload.uploadLearningAssetBytes(
        category: category,
        type: type,
        bytes: bytes,
        fileName: fileName,
      );
      return asset.publicUrl;
    }
    final uploaded = await _upload.uploadLearningAssetFromSource(
      category: category,
      type: type,
      sourcePath: value,
    );
    return uploaded.publicUrl;
  }
}
