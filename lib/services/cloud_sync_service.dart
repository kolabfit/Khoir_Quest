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
    final local = await _cache.findById(materialId);
    final expectedVersion = local?.cloudVersion ?? 0;
    final deleted = await _materials.softDeleteMaterial(
      materialId,
      expectedVersion: expectedVersion,
    );
    await _cache.upsert(deleted);
  }

  Future<LearningMaterialModel> _pushEntity(
    LearningMaterialEntity entity, {
    required String createdBy,
  }) async {
    final model = LearningMaterialModel.fromEntity(entity);
    final remote = model.version == 0
        ? await _materials.findById(model.id)
        : null;
    final expectedVersion = remote?.version ?? model.version;
    final image = await _resolveCloudAsset(
      path: model.imagePath,
      existingStoragePath: model.imageStoragePath,
      category: model.category,
      type: UploadedAssetType.image,
    );
    final audio = await _resolveCloudAsset(
      path: model.audioPath,
      existingStoragePath: model.audioStoragePath,
      category: model.category,
      type: UploadedAssetType.audio,
    );
    final video = await _resolveCloudAsset(
      path: model.videoPath,
      existingStoragePath: model.videoStoragePath,
      category: model.category,
      type: UploadedAssetType.video,
    );
    final mediaChanged =
        image.storagePath != model.imageStoragePath ||
        audio.storagePath != model.audioStoragePath ||
        video.storagePath != model.videoStoragePath;
    final nextMediaVersion = mediaChanged
        ? (model.mediaVersion <= 0 ? 1 : model.mediaVersion + 1)
        : (model.mediaVersion <= 0 ? 1 : model.mediaVersion);
    final storage = StorageRepository(_supabase);
    final synced = await _materials.upsertMaterial(
      model.copyWith(
        imagePath: image.storagePath.isEmpty
            ? image.publicUrl
            : storage.getVersionedPublicUrl(
                image.storagePath,
                nextMediaVersion,
              ),
        audioPath: audio.storagePath.isEmpty
            ? audio.publicUrl
            : storage.getVersionedPublicUrl(
                audio.storagePath,
                nextMediaVersion,
              ),
        videoPath: video.storagePath.isEmpty
            ? video.publicUrl
            : storage.getVersionedPublicUrl(
                video.storagePath,
                nextMediaVersion,
              ),
        imageStoragePath: image.storagePath,
        audioStoragePath: audio.storagePath,
        videoStoragePath: video.storagePath,
        createdBy: createdBy,
        createdAt: remote?.createdAt ?? model.createdAt,
        mediaVersion: nextMediaVersion,
        updatedAt: DateTime.now().toUtc(),
      ),
      expectedVersion: expectedVersion,
    );
    await _cache.upsert(synced);
    return synced;
  }

  Future<_ResolvedCloudAsset> _resolveCloudAsset({
    required String path,
    required String existingStoragePath,
    required String category,
    required UploadedAssetType type,
  }) async {
    final value = path.trim();
    final storage = StorageRepository(_supabase);
    if (value.isEmpty && existingStoragePath.trim().isEmpty) {
      return const _ResolvedCloudAsset(storagePath: '', publicUrl: '');
    }
    if (value.isEmpty && existingStoragePath.trim().isNotEmpty) {
      final storagePath = existingStoragePath.trim();
      return _ResolvedCloudAsset(
        storagePath: storagePath,
        publicUrl: storage.getPublicUrl(storagePath),
      );
    }
    if (MediaSourceHelper.isRemoteUrl(value)) {
      final storagePath = storage.relativePathFromPublicUrl(value) ?? '';
      return _ResolvedCloudAsset(storagePath: storagePath, publicUrl: value);
    }
    if (MediaSourceHelper.isAssetPath(value)) {
      final fileName = value.split('/').last;
      final bytes = (await rootBundle.load(value)).buffer.asUint8List();
      final asset = await _upload.uploadLearningAssetBytes(
        category: category,
        type: type,
        bytes: bytes,
        fileName: fileName,
      );
      return _ResolvedCloudAsset(
        storagePath: asset.path,
        publicUrl: asset.publicUrl,
      );
    }
    final uploaded = await _upload.uploadLearningAssetFromSource(
      category: category,
      type: type,
      sourcePath: value,
    );
    return _ResolvedCloudAsset(
      storagePath: uploaded.path,
      publicUrl: uploaded.publicUrl,
    );
  }
}

class _ResolvedCloudAsset {
  const _ResolvedCloudAsset({
    required this.storagePath,
    required this.publicUrl,
  });

  final String storagePath;
  final String publicUrl;
}
