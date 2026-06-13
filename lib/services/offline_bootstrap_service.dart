import '../database/isar_database_service.dart';
import '../repositories/material_repository.dart';
import '../repositories/theme_repository.dart';
import '../services/legacy_migration_service.dart';
import '../storage/local_storage_service.dart';

class OfflineBootstrapService {
  OfflineBootstrapService({
    required this.database,
    required this.storageService,
    required this.materialRepository,
    required this.themeRepository,
    required this.legacyMigrationService,
  });

  final IsarDatabaseService database;
  final LocalStorageService storageService;
  final MaterialRepository materialRepository;
  final ThemeRepository themeRepository;
  final LegacyMigrationService legacyMigrationService;

  bool _ready = false;

  Future<void> ensureReady() async {
    if (_ready) return;
    await storageService.ensureReady();
    await database.initDatabase();
    await legacyMigrationService.migrateIfNeeded();
    final guestTheme = await themeRepository.loadThemeId('guest');
    if (guestTheme == null) {
      await themeRepository.saveTheme(
        ownerUsername: 'guest',
        themeId: 'default',
        darkMode: false,
      );
    }
    _ready = true;
  }
}
