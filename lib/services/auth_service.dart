import '../models/cloud_auth_profile.dart';
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
    return CloudAuthProfile(
      userId: user.id,
      username: profile['username'] as String? ?? '',
      role: profile['role'] as String? ?? 'child',
      avatarUrl: profile['avatar_url'] as String? ?? '',
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
    final profile =
        await _repository.fetchProfileByUserId(user.id) ??
        await _repository.upsertProfile(
          userId: user.id,
          username: normalizedUsername,
          role: preferredRole,
        );
    return CloudAuthProfile(
      userId: user.id,
      username: profile['username'] as String? ?? normalizedUsername,
      role: profile['role'] as String? ?? preferredRole,
      avatarUrl: profile['avatar_url'] as String? ?? '',
    );
  }

  Future<void> logout() async {
    if (!isConfigured) return;
    await ensureReady();
    await _repository.signOut();
  }
}
