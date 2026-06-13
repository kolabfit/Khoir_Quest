import '../models/cloud_auth_profile.dart';
import '../models/app_local_models.dart';
import '../repositories/auth_repository.dart';
import 'supabase_service.dart';

class AuthService {
  AuthService._();

  static final instance = AuthService._();

  final SupabaseService _supabase = SupabaseService.instance;

  late final AuthRepository _repository = AuthRepository(_supabase);

  bool get isConfigured => _supabase.isConfigured;

  bool get hasSession => _repository.currentSession != null;

  bool isValidUsername(String username) =>
      _repository.isValidUsername(username);

  Future<void> ensureReady() => _supabase.ensureInitialized();

  Future<CloudAuthProfile?> currentProfile() async {
    if (!isConfigured) return null;
    await ensureReady();
    final user = _repository.currentUser;
    if (user == null) {
      return null;
    }
    final profile = await _repository.fetchProfileByUserId(user.id);
    if (profile == null) {
      return CloudAuthProfile(
        userId: user.id,
        username:
            user.userMetadata?['username'] as String? ??
            user.email?.split('@').first ??
            '',
        role: 'child',
      );
    }
    final progressMap = Map<String, dynamic>.from(
      profile['progress'] as Map<String, dynamic>? ??
          const {'membaca': 0, 'angka': 0, 'benda': 0, 'iqra': 0},
    );
    return CloudAuthProfile(
      userId: user.id,
      username: profile['username'] as String? ?? '',
      role: profile['role'] as String? ?? 'child',
      avatarUrl: profile['avatar_url'] as String? ?? '',
      childName: profile['child_name'] as String? ?? 'Teman',
      gender: profile['gender'] as String? ?? 'boy',
      themeId: profile['theme_id'] as String? ?? 'default',
      stars: (profile['stars'] as num?)?.toInt() ?? 12,
      iqraStreak: (profile['iqra_streak'] as num?)?.toInt() ?? 0,
      progress: {
        for (final entry in progressMap.entries)
          entry.key: (entry.value as num?)?.toInt() ?? 0,
      },
      iqraMastered: List<String>.from(
        profile['iqra_mastered'] as List? ?? const [],
      ),
      iqraHistory: List<String>.from(
        profile['iqra_history'] as List? ?? const [],
      ),
      hurfMastered: List<String>.from(
        profile['hurf_mastered'] as List? ?? const [],
      ),
      angkaMastered: List<String>.from(
        profile['angka_mastered'] as List? ?? const [],
      ),
      bendaMastered: List<String>.from(
        profile['benda_mastered'] as List? ?? const [],
      ),
      favoriteMaterialIds: List<String>.from(
        profile['favorite_material_ids'] as List? ?? const [],
      ),
    );
  }

  Future<void> resetPasswordByUsername({
    required String username,
    required String newPassword,
  }) async {
    await ensureReady();
    final normalizedUsername = _repository.normalizeUsername(username);
    if (!_repository.isValidUsername(normalizedUsername)) {
      throw 'Username tidak valid.';
    }
    if (newPassword.length < 6) throw 'Password minimal 6 karakter';
    await _repository.resetPasswordByUsername(
      username: normalizedUsername,
      newPassword: newPassword,
    );
  }

  Future<CloudAuthProfile> authenticate({
    required String username,
    required String password,
    required bool register,
    required String preferredRole,
  }) async {
    await ensureReady();
    final normalizedUsername = _repository.normalizeUsername(username);
    final response = register
        ? await _repository.signUp(
            username: normalizedUsername,
            password: password,
          )
        : await _repository.signIn(
            username: normalizedUsername,
            password: password,
          );
    final user = response.user ?? _repository.currentUser;
    if (user == null) {
      throw 'Session Supabase belum aktif. Cek Email Confirmation di project Supabase.';
    }
    final profile = await _ensureProfile(
      userId: user.id,
      username: normalizedUsername,
      preferredRole: preferredRole,
    );
    final progressMap = Map<String, dynamic>.from(
      profile['progress'] as Map<String, dynamic>? ??
          const {'membaca': 0, 'angka': 0, 'benda': 0, 'iqra': 0},
    );
    return CloudAuthProfile(
      userId: user.id,
      username: profile['username'] as String? ?? normalizedUsername,
      role: profile['role'] as String? ?? preferredRole,
      avatarUrl: profile['avatar_url'] as String? ?? '',
      childName: profile['child_name'] as String? ?? 'Teman',
      gender: profile['gender'] as String? ?? 'boy',
      themeId: profile['theme_id'] as String? ?? 'default',
      stars: (profile['stars'] as num?)?.toInt() ?? 12,
      iqraStreak: (profile['iqra_streak'] as num?)?.toInt() ?? 0,
      progress: {
        for (final entry in progressMap.entries)
          entry.key: (entry.value as num?)?.toInt() ?? 0,
      },
      iqraMastered: List<String>.from(
        profile['iqra_mastered'] as List? ?? const [],
      ),
      iqraHistory: List<String>.from(
        profile['iqra_history'] as List? ?? const [],
      ),
      hurfMastered: List<String>.from(
        profile['hurf_mastered'] as List? ?? const [],
      ),
      angkaMastered: List<String>.from(
        profile['angka_mastered'] as List? ?? const [],
      ),
      bendaMastered: List<String>.from(
        profile['benda_mastered'] as List? ?? const [],
      ),
      favoriteMaterialIds: List<String>.from(
        profile['favorite_material_ids'] as List? ?? const [],
      ),
    );
  }

  Future<Map<String, dynamic>> _ensureProfile({
    required String userId,
    required String username,
    required String preferredRole,
  }) async {
    final existing = await _repository.fetchProfileByUserId(userId);
    if (existing == null) {
      return _repository.upsertProfile(
        userId: userId,
        username: username,
        role: preferredRole,
      );
    }

    final currentUsername = (existing['username'] as String? ?? '').trim();
    final currentRole = (existing['role'] as String? ?? '')
        .trim()
        .toLowerCase();
    final nextRole = currentRole == 'teacher' || preferredRole == 'teacher'
        ? 'teacher'
        : (currentRole.isEmpty ? preferredRole : currentRole);
    if (currentUsername == username && currentRole == nextRole) {
      return existing;
    }

    final progress = Map<String, int>.from(
      Map<String, dynamic>.from(
        existing['progress'] as Map<String, dynamic>? ??
            const {'membaca': 0, 'angka': 0, 'benda': 0, 'iqra': 0},
      ).map((key, value) => MapEntry(key, (value as num?)?.toInt() ?? 0)),
    );

    return _repository.upsertProfile(
      userId: userId,
      username: username,
      role: nextRole,
      avatarUrl: existing['avatar_url'] as String? ?? '',
      childName: existing['child_name'] as String? ?? 'Teman',
      gender: existing['gender'] as String? ?? 'boy',
      themeId: existing['theme_id'] as String? ?? 'default',
      stars: (existing['stars'] as num?)?.toInt() ?? 12,
      iqraStreak: (existing['iqra_streak'] as num?)?.toInt() ?? 0,
      progress: progress,
      iqraMastered: List<String>.from(
        existing['iqra_mastered'] as List? ?? const [],
      ),
      iqraHistory: List<String>.from(
        existing['iqra_history'] as List? ?? const [],
      ),
      hurfMastered: List<String>.from(
        existing['hurf_mastered'] as List? ?? const [],
      ),
      angkaMastered: List<String>.from(
        existing['angka_mastered'] as List? ?? const [],
      ),
      bendaMastered: List<String>.from(
        existing['benda_mastered'] as List? ?? const [],
      ),
      favoriteMaterialIds: List<String>.from(
        existing['favorite_material_ids'] as List? ?? const [],
      ),
    );
  }

  Future<Map<String, dynamic>> upsertProfileState({
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
    await ensureReady();
    return _repository.upsertProfile(
      userId: userId,
      username: username,
      role: role,
      avatarUrl: avatarUrl,
      childName: childName,
      gender: gender,
      themeId: themeId,
      stars: stars,
      iqraStreak: iqraStreak,
      progress: progress,
      iqraMastered: iqraMastered,
      iqraHistory: iqraHistory,
      hurfMastered: hurfMastered,
      angkaMastered: angkaMastered,
      bendaMastered: bendaMastered,
      favoriteMaterialIds: favoriteMaterialIds,
    );
  }

  Future<void> addLearningHistory({
    required String userId,
    required LearningHistoryRecord record,
  }) async {
    await ensureReady();
    await _repository.addLearningHistory(userId: userId, record: record);
  }

  Future<void> logout() async {
    if (!isConfigured) return;
    await ensureReady();
    await _repository.signOut();
  }
}
