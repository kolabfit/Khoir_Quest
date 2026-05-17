import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../core/constants/default_learning_catalog.dart';
import '../core/utils/media_source_helper.dart';
import '../repositories/storage_repository.dart';
import 'supabase_service.dart';

enum UploadedAssetType { image, audio, video }

class UploadedAsset {
  const UploadedAsset({
    required this.path,
    required this.publicUrl,
    required this.fileName,
    required this.contentType,
  });

  final String path;
  final String publicUrl;
  final String fileName;
  final String contentType;
}

class UploadService {
  UploadService._();

  static final instance = UploadService._();

  final SupabaseService _supabase = SupabaseService.instance;
  final _uuid = const Uuid();

  late final StorageRepository _storage = StorageRepository(_supabase);

  Future<void> ensureReady() => _supabase.ensureInitialized();

  Future<String> uploadLearningImage(
    File file, {
    required String category,
  }) async {
    final asset = await uploadLearningAssetFromSource(
      category: category,
      type: UploadedAssetType.image,
      sourcePath: file.path,
    );
    return asset.publicUrl;
  }

  Future<UploadedAsset> uploadLearningAssetFromSource({
    required String category,
    required UploadedAssetType type,
    required String sourcePath,
    String? fileName,
  }) async {
    if (MediaSourceHelper.isRemoteUrl(sourcePath)) {
      final inferred = fileName ?? p.basename(Uri.parse(sourcePath).path);
      return UploadedAsset(
        path: _storage.relativePathFromPublicUrl(sourcePath) ?? inferred,
        publicUrl: sourcePath,
        fileName: inferred,
        contentType: _contentTypeForFileName(inferred, type),
      );
    }
    final resolvedName = fileName ?? _fallbackFileName(sourcePath, type);
    Uint8List bytes;
    if (MediaSourceHelper.isAssetPath(sourcePath)) {
      final data = await rootBundle.load(sourcePath);
      bytes = data.buffer.asUint8List();
    } else if (MediaSourceHelper.isDataUri(sourcePath)) {
      bytes = _decodeDataUri(sourcePath);
    } else if (!kIsWeb) {
      bytes = await File(sourcePath).readAsBytes();
    } else {
      throw 'File web tidak valid untuk upload.';
    }
    return uploadLearningAssetBytes(
      category: category,
      type: type,
      bytes: bytes,
      fileName: resolvedName,
    );
  }

  Future<UploadedAsset> uploadLearningAssetBytes({
    required String category,
    required UploadedAssetType type,
    required Uint8List bytes,
    required String fileName,
  }) async {
    await ensureReady();
    final ext = _normalizedExtension(fileName, type);
    final folder = _folderForCategory(category);
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final storageName = '${_uuid.v4()}_$stamp$ext';
    final path = '$folder/$storageName';
    final contentType = _contentTypeForFileName(storageName, type);
    await _storage.uploadBytes(
      path: path,
      bytes: bytes,
      contentType: contentType,
    );
    return UploadedAsset(
      path: path,
      publicUrl: _storage.getPublicUrl(path),
      fileName: fileName,
      contentType: contentType,
    );
  }

  String _folderForCategory(String category) {
    return switch (MediaSourceHelper.normalizeCategory(category)) {
      LearningCategories.huruf => 'huruf',
      LearningCategories.angka => 'angka',
      LearningCategories.iqra => 'iqra',
      LearningCategories.lagu => 'lagu',
      _ => 'benda',
    };
  }

  String _fallbackFileName(String sourcePath, UploadedAssetType type) {
    final base = sourcePath.trim().isEmpty ? '' : p.basename(sourcePath);
    if (base.isNotEmpty) return base;
    return 'asset_${DateTime.now().millisecondsSinceEpoch}${_defaultExtension(type)}';
  }

  String _normalizedExtension(String fileName, UploadedAssetType type) {
    final ext = p.extension(fileName).toLowerCase();
    if (ext.isNotEmpty) return ext;
    return _defaultExtension(type);
  }

  String _defaultExtension(UploadedAssetType type) {
    return switch (type) {
      UploadedAssetType.image => '.png',
      UploadedAssetType.audio => '.mp3',
      UploadedAssetType.video => '.mp4',
    };
  }

  String _contentTypeForFileName(String fileName, UploadedAssetType type) {
    final ext = p.extension(fileName).toLowerCase();
    if (ext == '.jpg' || ext == '.jpeg') return 'image/jpeg';
    if (ext == '.webp') return 'image/webp';
    if (ext == '.gif') return 'image/gif';
    if (ext == '.mp3') return 'audio/mpeg';
    if (ext == '.wav') return 'audio/wav';
    if (ext == '.ogg') return 'audio/ogg';
    if (ext == '.m4a') return 'audio/mp4';
    if (ext == '.webm') return 'video/webm';
    if (ext == '.mov') return 'video/quicktime';
    if (ext == '.mp4') return 'video/mp4';
    return switch (type) {
      UploadedAssetType.image => 'image/png',
      UploadedAssetType.audio => 'audio/mpeg',
      UploadedAssetType.video => 'video/mp4',
    };
  }

  Uint8List _decodeDataUri(String dataUri) {
    final payload = dataUri.split(',').last;
    return Uint8List.fromList(base64Decode(payload));
  }
}
