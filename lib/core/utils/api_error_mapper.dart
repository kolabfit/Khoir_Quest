import 'package:supabase_flutter/supabase_flutter.dart';

class ApiErrorMapper {
  const ApiErrorMapper._();

  static String toMessage(
    Object error, {
    String fallback = 'Terjadi kesalahan. Coba lagi ya.',
  }) {
    if (error is String) {
      return _fromText(error, fallback: fallback);
    }

    if (error is AuthException) {
      return _fromText(
        '${error.message} ${error.statusCode ?? ''}',
        fallback: fallback,
      );
    }

    if (error is PostgrestException) {
      return _fromText(
        '${error.message} ${error.code ?? ''} ${error.details ?? ''}',
        fallback: fallback,
      );
    }

    if (error is StorageException) {
      return _fromText(error.message, fallback: fallback);
    }

    if (_looksLikeSocketException(error)) {
      return 'Koneksi internet bermasalah. Periksa jaringan lalu coba lagi.';
    }

    return _fromText(error.toString(), fallback: fallback);
  }

  static String _fromText(String raw, {required String fallback}) {
    final text = raw.trim();
    final normalized = text.toLowerCase();

    if (normalized.isEmpty) return fallback;
    if (_containsAny(normalized, const [
      'akun belum terdaftar',
      'user not found',
      'user does not exist',
      'no user found',
    ])) {
      return 'User tidak ditemukan. Silakan daftar dulu.';
    }
    if (_containsAny(normalized, const [
      'invalid login credentials',
      'email not confirmed',
      'invalid credentials',
      'password salah',
    ])) {
      return 'Username atau password salah.';
    }
    if (_containsAny(normalized, const [
      'user already registered',
      'already been registered',
      'username sudah terdaftar',
      'duplicate key',
      'already exists',
    ])) {
      return 'Username sudah terdaftar. Coba login atau pakai username lain.';
    }
    if (_containsAny(normalized, const [
      'invalid email',
      'email address is invalid',
      'unable to validate email address',
    ])) {
      return 'Username tidak valid. Gunakan huruf/angka sederhana lalu coba lagi.';
    }
    if (_containsAny(normalized, const [
      'password should be at least',
      'password minimal',
      'weak password',
    ])) {
      return 'Password minimal 6 karakter.';
    }
    if (_containsAny(normalized, const [
      'email rate limit exceeded',
      'rate limit',
      'too many requests',
    ])) {
      return 'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.';
    }
    if (_containsAny(normalized, const [
      'fetch failed',
      'network',
      'socketexception',
      'connection',
      'timeout',
    ])) {
      return 'Koneksi ke server gagal. Cek internet lalu coba lagi.';
    }
    if (_containsAny(normalized, const [
      'jwt',
      'session',
      'token',
      'unauthorized',
      '401',
    ])) {
      return 'Sesi login bermasalah. Silakan login ulang.';
    }
    if (_containsAny(normalized, const [
      '403',
      'permission',
      'row-level security',
      'violates row-level security policy',
    ])) {
      return 'Akses ditolak. Akun ini tidak punya izin untuk aksi tersebut.';
    }
    if (_containsAny(normalized, const ['404', 'not found'])) {
      return 'Data tidak ditemukan.';
    }
    if (_containsAny(normalized, const ['400', 'bad request'])) {
      return 'Permintaan tidak valid. Periksa data yang diisi lalu coba lagi.';
    }
    if (_containsAny(normalized, const [
      '500',
      '502',
      '503',
      '504',
      'internal server error',
    ])) {
      return 'Server sedang bermasalah. Coba lagi beberapa saat lagi.';
    }

    if (text.startsWith('Exception: ')) {
      return _fromText(
        text.substring('Exception: '.length),
        fallback: fallback,
      );
    }

    return text;
  }

  static bool _containsAny(String text, List<String> patterns) {
    for (final pattern in patterns) {
      if (text.contains(pattern)) return true;
    }
    return false;
  }

  static bool _looksLikeSocketException(Object error) {
    return error.runtimeType.toString().toLowerCase().contains(
      'socketexception',
    );
  }
}
