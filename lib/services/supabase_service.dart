import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/supabase_config.dart';

class SupabaseService {
  SupabaseService._();

  static final instance = SupabaseService._();

  bool _initialized = false;

  bool get isConfigured => SupabaseConfig.isConfigured;

  SupabaseClient get client => Supabase.instance.client;

  Future<void> ensureInitialized() async {
    if (_initialized || !isConfigured) return;
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
    _initialized = true;
  }
}
