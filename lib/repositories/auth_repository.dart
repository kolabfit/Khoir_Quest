import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_local_models.dart';
import '../services/supabase_service.dart';

class AuthRepository {
  static const _authEmailDomain = 'example.com';

  AuthRepository(this._supabaseService);

  final SupabaseService _supabaseService;

  SupabaseClient get _client => _supabaseService.client;

  Session? get currentSession => _client.auth.currentSession;

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signIn({
    required String username,
    required String password,
  }) async {
    final primaryEmail = emailForUsername(username);
    try {
      return await _client.auth.signInWithPassword(
        email: primaryEmail,
        password: password,
      );
    } on AuthException {
      return _client.auth.signInWithPassword(
        email: legacyEmailForUsername(username),
        password: password,
      );
    }
  }

  Future<AuthResponse> signUp({
    required String username,
    required String password,
  }) {
    return _client.auth.signUp(
      email: emailForUsername(username),
      password: password,
      data: {'username': normalizeUsername(username)},
    );
  }

  Future<Map<String, dynamic>?> fetchProfileByUserId(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  Future<Map<String, dynamic>> upsertProfile({
    required String userId,
    required String username,
    required String role,
    String avatarUrl = '',
    String childName = 'Teman',
    String gender = 'boy',
    String themeId = 'default',
    int stars = 12,
    int iqraStreak = 0,
    Map<String, int> progress = const {
      'membaca': 0,
      'angka': 0,
      'benda': 0,
      'iqra': 0,
    },
    List<String> iqraMastered = const [],
    List<String> iqraHistory = const [],
    List<String> hurfMastered = const [],
    List<String> angkaMastered = const [],
    List<String> bendaMastered = const [],
    List<String> favoriteMaterialIds = const [],
  }) async {
    final data = await _client
        .from('profiles')
        .upsert({
          'id': userId,
          'username': normalizeUsername(username),
          'role': role,
          'avatar_url': avatarUrl.isEmpty ? null : avatarUrl,
          'child_name': childName,
          'gender': gender,
          'theme_id': themeId,
          'stars': stars,
          'iqra_streak': iqraStreak,
          'progress': progress,
          'iqra_mastered': iqraMastered,
          'iqra_history': iqraHistory,
          'hurf_mastered': hurfMastered,
          'angka_mastered': angkaMastered,
          'benda_mastered': bendaMastered,
          'favorite_material_ids': favoriteMaterialIds,
        }, onConflict: 'id')
        .select()
        .single();
    return Map<String, dynamic>.from(data);
  }

  Future<void> addLearningHistory({
    required String userId,
    required LearningHistoryRecord record,
  }) async {
    await _client.from('learning_histories').upsert({
      'user_id': userId,
      'material_id': record.materialId,
      'category': record.category,
      'duration': record.duration,
      'score': record.score,
      'played_at': record.playedAt.toUtc().toIso8601String(),
    }, onConflict: 'user_id,material_id,category,played_at');
  }

  Future<List<Map<String, dynamic>>> fetchLearningHistories(
    String userId,
  ) async {
    final data = await _client
        .from('learning_histories')
        .select()
        .eq('user_id', userId)
        .order('played_at', ascending: false)
        .limit(100);
    return (data as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  Future<void> signOut() => _client.auth.signOut();

  String normalizeUsername(String username) => username.trim().toLowerCase();

  bool isValidUsername(String username) {
    final normalized = normalizeUsername(username);
    return RegExp(r'^[a-z0-9._-]{3,32}$').hasMatch(normalized);
  }

  String emailForUsername(String username) {
    final normalized = normalizeUsername(username);
    final digest = sha256.convert(utf8.encode(normalized)).toString();
    return 'u.${digest.substring(0, 24)}@$_authEmailDomain';
  }

  String legacyEmailForUsername(String username) {
    final normalized = normalizeUsername(username);
    final slug = normalized
        .replaceAll(RegExp(r'[^a-z0-9]+'), '.')
        .replaceAll(RegExp(r'\.+'), '.')
        .replaceAll(RegExp(r'^\.+|\.+$'), '');
    final safeSlug = slug.isEmpty ? 'khoirquest.user' : slug;
    return '$safeSlug@$_authEmailDomain';
  }
}
