import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';

class StorageRepository {
  StorageRepository(this._supabaseService);

  final SupabaseService _supabaseService;

  static const bucketId = 'learning-assets';

  StorageFileApi get _storage => _supabaseService.client.storage.from(bucketId);

  Future<String> uploadBytes({
    required String path,
    required Uint8List bytes,
    required String contentType,
  }) {
    return _storage.uploadBinary(
      path,
      bytes,
      fileOptions: FileOptions(
        contentType: contentType,
        upsert: true,
        cacheControl: '3600',
      ),
    );
  }

  String getPublicUrl(String path) => _storage.getPublicUrl(path);

  String getVersionedPublicUrl(String path, int version) {
    final url = getPublicUrl(path);
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}v=$version';
  }

  Future<void> deletePath(String path) async {
    if (path.trim().isEmpty) return;
    await _storage.remove([path]);
  }

  Future<void> deletePublicUrl(String publicUrl) async {
    final path = relativePathFromPublicUrl(publicUrl);
    if (path == null || path.isEmpty) return;
    await deletePath(path);
  }

  String? relativePathFromPublicUrl(String publicUrl) {
    final uri = Uri.tryParse(publicUrl);
    if (uri == null) return null;
    final rawPath = uri.path;
    final publicMarker = '/object/public/$bucketId/';
    final renderMarker = '/render/image/public/$bucketId/';
    if (rawPath.contains(publicMarker)) {
      return rawPath.split(publicMarker).last;
    }
    if (rawPath.contains(renderMarker)) {
      return rawPath.split(renderMarker).last;
    }
    return null;
  }
}
