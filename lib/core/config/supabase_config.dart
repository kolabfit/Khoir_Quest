class SupabaseConfig {
  const SupabaseConfig._();

  static const _defaultUrl = 'https://jsftomhyuavuuynmxxxp.supabase.co';
  static const _defaultAnonKey =
      'sb_publishable_rHA_PJnZgdCfNrhG5nu8bA_-4kVtvxf';

  static const _url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: _defaultUrl,
  );

  static const _anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: _defaultAnonKey,
  );

  static String get url => _url.trim().isEmpty ? _defaultUrl : _url.trim();

  static String get anonKey =>
      _anonKey.trim().isEmpty ? _defaultAnonKey : _anonKey.trim();

  static bool get isConfigured =>
      url.trim().isNotEmpty && anonKey.trim().isNotEmpty;
}
