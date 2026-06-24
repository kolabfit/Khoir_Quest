class MediaSourceHelper {
  const MediaSourceHelper._();

  static bool isRemoteUrl(String value) {
    final lower = value.toLowerCase();
    return lower.startsWith('http://') || lower.startsWith('https://');
  }

  static bool isYoutubeUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null) return false;
    final host = uri.host.toLowerCase();
    return host == 'youtu.be' ||
        host.endsWith('.youtu.be') ||
        host == 'youtube.com' ||
        host.endsWith('.youtube.com');
  }

  static String? youtubeVideoId(String value) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null) return null;
    final host = uri.host.toLowerCase();
    if (host == 'youtu.be' || host.endsWith('.youtu.be')) {
      return _cleanYoutubeId(
        uri.pathSegments.isEmpty ? '' : uri.pathSegments.first,
      );
    }
    if (host == 'youtube.com' || host.endsWith('.youtube.com')) {
      final queryId = _cleanYoutubeId(uri.queryParameters['v'] ?? '');
      if (queryId != null) return queryId;
      final segments = uri.pathSegments;
      if (segments.length >= 2 &&
          (segments.first == 'embed' ||
              segments.first == 'shorts' ||
              segments.first == 'live')) {
        return _cleanYoutubeId(segments[1]);
      }
    }
    return null;
  }

  static String? _cleanYoutubeId(String value) {
    final id = value.trim();
    if (RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(id)) return id;
    return null;
  }

  static bool isAudioFileName(String value) {
    final lower = value.toLowerCase().trim();
    return lower.endsWith('.mp3') ||
        lower.endsWith('.wav') ||
        lower.endsWith('.ogg') ||
        lower.endsWith('.m4a') ||
        lower.endsWith('.aac') ||
        lower.endsWith('.flac');
  }

  static String inferSongMediaType({
    required String source,
    String? fileName,
    String? explicit,
  }) {
    final value = explicit?.trim().toLowerCase();
    if (value == 'audio' || value == 'video' || value == 'youtube') {
      return value!;
    }
    if (isYoutubeUrl(source)) return 'youtube';
    if (isAudioFileName(fileName ?? source)) return 'audio';
    return 'video';
  }

  static bool isAssetPath(String value) => value.startsWith('assets/');

  static bool isDataUri(String value) => value.startsWith('data:');

  static bool isLocalFilePath(String value) {
    if (value.isEmpty ||
        isAssetPath(value) ||
        isRemoteUrl(value) ||
        isDataUri(value)) {
      return false;
    }
    return value.contains(':\\') ||
        value.startsWith('/') ||
        value.startsWith('\\');
  }

  static String normalizeCategory(String category) {
    final value = category.toLowerCase().trim();
    return switch (value) {
      'membaca' => 'huruf',
      'numbers' => 'angka',
      'songs' => 'lagu',
      _ => value,
    };
  }
}
