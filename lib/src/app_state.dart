part of '../main.dart';

final appStateProvider = ChangeNotifierProvider<AppState>(
  (ref) => AppState(LocalDatabase.instance),
);

enum Role { child, teacher }

enum Gender { boy, girl }

enum TabItem { main, belajar, lagu, akun }

enum LearnMode { menu, huruf, sukuKata, rangkaiKata, angka, benda, iqra }

class AppState extends ChangeNotifier with WidgetsBindingObserver {
  AppState(this._db) {
    WidgetsBinding.instance.addObserver(this);
    load();
  }

  SharedPreferences? _prefs;
  final LocalDatabase _db;
  final CloudSyncService _cloudSync = CloudSyncService.instance;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<List<LearningMaterialModel>>? _materialSubscription;
  Timer? _autoSyncTimer;
  DateTime? _lastAutoSyncAt;
  String? email;
  String childName = 'Teman';
  Gender gender = Gender.boy;
  Role? role;
  String themeId = 'default';
  String languageCode = 'id';
  bool onboardingSeen = false;
  TabItem tab = TabItem.main;
  LearnMode learnMode = LearnMode.menu;
  bool ready = false;
  bool online = true;

  final Map<String, int> progress = {
    'membaca': 0,
    'angka': 0,
    'benda': 0,
    'iqra': 0,
  };

  final List<LetterGroup> letters = [...defaultLettersData];
  final List<NumberItem> numbers = [...defaultNumbersData];
  final List<LearningObject> objects = [...objectsData];
  final List<IqraItem> iqraItems = [...iqraData];
  final List<SongItem> songs = [...songsData];
  final Set<String> favorites = {};
  final Set<String> iqraMastered = {};
  final Set<String> hurfMastered = {};
  final Set<String> sukuKataMastered = {};
  final Set<String> rangkaiKataMastered = {};
  final Set<String> angkaMastered = {};
  final Set<String> bendaMastered = {};
  int _sukuKataTotal = 0;
  int _rangkaiKataTotal = 0;
  final List<String> iqraHistory = [];
  int stars = 12;
  int iqraStreak = 0;
  bool syncInProgress = false;
  String syncStatus = 'Siap sinkron ke cloud';
  DateTime? lastSyncedAt;
  int pendingMaterialSyncCount = 0;
  static final Set<String> _pendingMaterialSyncIds = {};
  static final Set<String> _pendingMaterialDeleteIds = {};

  bool get hasPendingMaterialSync => pendingMaterialSyncCount > 0;

  AppThemeData get theme =>
      appThemes.firstWhere((t) => t.id == themeId, orElse: () => appThemes[0]);

  Future<void> load() async {
    await _db.ensureReady();
    await _cloudSync.ensureReady();
    _prefs = await SharedPreferences.getInstance();
    onboardingSeen = _prefs?.getBool('onboardingSeen') ?? false;
    languageCode = _prefs?.getString('languageCode') ?? 'id';
    online = await _cloudSync.isOnline();
    UserAccount? account;
    final profile = _cloudSync.isConfigured
        ? await _cloudSync.currentProfile()
        : null;
    if (profile != null) {
      final profileRole = _resolveRole(profile.username) == Role.teacher
          ? Role.teacher
          : _roleFromString(profile.role);
      account = await _db.restoreCloudSession(
        username: profile.username,
        role: profileRole,
        childName: profile.childName,
        gender: profile.gender == 'girl' ? Gender.girl : Gender.boy,
        themeId: profile.themeId,
        avatarPath: profile.avatarUrl,
        stars: profile.stars,
        iqraStreak: profile.iqraStreak,
        progress: profile.progress,
        iqraMastered: profile.iqraMastered,
        iqraHistory: profile.iqraHistory,
        hurfMastered: profile.hurfMastered,
        angkaMastered: profile.angkaMastered,
        bendaMastered: profile.bendaMastered,
        favoriteMaterialIds: profile.favoriteMaterialIds,
      );
    }
    if (account == null) {
      final savedTheme =
          await _db.loadThemeId() ?? _prefs?.getString('themeId') ?? 'default';
      themeId = appThemes.any((t) => t.id == savedTheme)
          ? savedTheme
          : 'default';
      favorites.clear();
    } else {
      _applyAccount(account);
    }
    await _loadRangkaiLearningProgress();
    await _reloadLearningCatalog();
    await _refreshPendingMaterialSyncCount();
    await _startConnectivityWatch();
    _startMaterialRealtime();
    _startAutoSync();
    if (email != null && role != null) {
      unawaited(_safeSyncCloudContent(silent: true));
    }
    ready = true;
    notifyListeners();
  }

  Future<void> login({
    required String nextEmail,
    required String password,
    bool teacherMode = false,
    bool register = false,
    bool autoCreate = false,
    String? name,
    Gender? nextGender,
  }) async {
    if (nextEmail.trim().length < 3) throw 'Username minimal 3 karakter ya';
    if (password.length < 6) throw 'Password minimal 6 karakter ya';
    if (!AuthService.instance.isValidUsername(nextEmail)) {
      throw 'Username hanya boleh huruf kecil, angka, titik, underscore, atau strip.';
    }
    try {
      final usernameIsTeacher =
          teacherMode || _resolveRole(nextEmail) == Role.teacher;
      var nextRole = usernameIsTeacher ? Role.teacher : Role.child;
      if (!_cloudSync.isConfigured) throw 'Supabase belum dikonfigurasi.';
      final cloudProfile = await _cloudSync.authenticate(
        username: nextEmail,
        password: password,
        register: register,
        preferredRole: nextRole.name,
        childName: name ?? nextEmail,
        gender: (nextGender ?? Gender.boy).name,
      );
      nextRole = usernameIsTeacher
          ? Role.teacher
          : _roleFromString(cloudProfile.role);
      final account = await _db.restoreCloudSession(
        username: cloudProfile.username.isEmpty
            ? nextEmail
            : cloudProfile.username,
        role: nextRole,
        childName: cloudProfile.childName,
        gender: cloudProfile.gender == 'girl' ? Gender.girl : Gender.boy,
        themeId: cloudProfile.themeId,
        avatarPath: cloudProfile.avatarUrl,
        stars: cloudProfile.stars,
        iqraStreak: cloudProfile.iqraStreak,
        progress: cloudProfile.progress,
        iqraMastered: cloudProfile.iqraMastered,
        iqraHistory: cloudProfile.iqraHistory,
        hurfMastered: cloudProfile.hurfMastered,
        angkaMastered: cloudProfile.angkaMastered,
        bendaMastered: cloudProfile.bendaMastered,
        favoriteMaterialIds: cloudProfile.favoriteMaterialIds,
      );
      _applyAccount(account);
      tab = role == Role.teacher ? TabItem.akun : TabItem.main;
      _startMaterialRealtime();
      _startAutoSync();
      notifyListeners();
      unawaited(_safeSyncCloudContent(silent: true));
    } catch (error) {
      throw ApiErrorMapper.toMessage(error);
    }
  }

  Future<void> resetPassword({
    required String username,
    required String newPassword,
  }) async {
    if (username.trim().length < 3) throw 'Username minimal 3 karakter';
    if (newPassword.length < 6) throw 'Password minimal 6 karakter';
    if (!AuthService.instance.isValidUsername(username)) {
      throw 'Username hanya boleh huruf kecil, angka, titik, underscore, atau strip.';
    }
    try {
      if (_cloudSync.isConfigured) {
        await _cloudSync.resetPassword(
          username: username,
          newPassword: newPassword,
        );
      }
      await _db.resetPassword(username: username, newPassword: newPassword);
    } catch (error) {
      throw ApiErrorMapper.toMessage(error);
    }
  }

  Role _resolveRole(String identity) {
    final id = identity.toLowerCase().trim();
    if (id == adminEmail ||
        id == 'pengajar' ||
        id == 'guru' ||
        id.startsWith('pengajar') ||
        id.startsWith('guru_') ||
        id.startsWith('guru') ||
        id.contains('@guru')) {
      return Role.teacher;
    }
    return Role.child;
  }

  Future<void> completeOnboarding() async {
    onboardingSeen = true;
    await _prefs?.setBool('onboardingSeen', true);
    notifyListeners();
  }

  Future<void> logout() async {
    email = null;
    role = null;
    favorites.clear();
    sukuKataMastered.clear();
    rangkaiKataMastered.clear();
    _autoSyncTimer?.cancel();
    _autoSyncTimer = null;
    await _materialSubscription?.cancel();
    _materialSubscription = null;
    if (_cloudSync.isConfigured) {
      await _cloudSync.logout();
    }
    await _db.clearSession();
    notifyListeners();
  }

  Future<void> setTheme(String id) async {
    themeId = id;
    await _prefs?.setString('themeId', id);
    await _db.saveThemeId(
      ownerUsername: email,
      themeId: id,
      darkMode: appThemes
          .firstWhere((t) => t.id == id, orElse: () => appThemes[0])
          .night,
    );
    await _saveAccount();
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    languageCode = code;
    await _prefs?.setString('languageCode', code);
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required Gender gender,
  }) async {
    childName = name.trim().isEmpty ? 'Teman' : name.trim();
    this.gender = gender;
    await _saveAccount();
    notifyListeners();
  }

  void go(TabItem item) {
    tab = item;
    notifyListeners();
  }

  void openLearn(LearnMode mode) {
    learnMode = mode;
    tab = TabItem.belajar;
    if (mode != LearnMode.menu) {
      unawaited(_persistLearningOpen(mode));
    }
    notifyListeners();
  }

  Future<void> markIqraViewed(IqraItem item) async {
    stars += 1;
    _registerIqraViewed(item);
    await _saveAccount();
    notifyListeners();
  }

  Future<void> markIqraSuccess(IqraItem item) async {
    _registerIqraViewed(item);
    iqraHistory.insert(
      0,
      '${DateTime.now().toIso8601String()}|${item.char}|${item.latin}',
    );
    if (iqraHistory.length > 20) {
      iqraHistory.removeRange(20, iqraHistory.length);
    }
    iqraStreak += 1;
    stars += 2;
    await _recordHistory(
      materialId: item.latin,
      category: 'iqra',
      duration: 1,
      score: 100,
    );
    await _saveAccount();
    notifyListeners();
  }

  Future<void> markHurfViewed(String letter) async {
    stars += 1;
    _registerHurfViewed(letter);
    await _saveAccount();
    notifyListeners();
  }

  Future<void> markSukuKataViewed(String id, {required int total}) async {
    _sukuKataTotal = total;
    stars += 1;
    sukuKataMastered.add(progressMasteryKey(id));
    _refreshHurfProgress();
    await _saveRangkaiLearningProgress();
    await _saveAccount();
    notifyListeners();
  }

  Future<void> markRangkaiKataViewed(String id, {required int total}) async {
    _rangkaiKataTotal = total;
    stars += 1;
    rangkaiKataMastered.add(progressMasteryKey(id));
    _refreshHurfProgress();
    await _saveRangkaiLearningProgress();
    await _saveAccount();
    notifyListeners();
  }

  Future<void> awardRangkaiKataPoint(String id, {required int total}) async {
    _rangkaiKataTotal = total;
    stars += 5;
    rangkaiKataMastered.add(progressMasteryKey(id));
    _refreshHurfProgress();
    await _saveRangkaiLearningProgress();
    await _recordHistory(
      materialId: id,
      category: 'rangkai_kata',
      duration: 1,
      score: 100,
    );
    await _saveAccount();
    notifyListeners();
  }

  void setRangkaiLearningTotals({int? sukuKata, int? rangkaiKata}) {
    final nextSukuKata = sukuKata ?? _sukuKataTotal;
    final nextRangkaiKata = rangkaiKata ?? _rangkaiKataTotal;
    if (_sukuKataTotal == nextSukuKata &&
        _rangkaiKataTotal == nextRangkaiKata) {
      return;
    }
    _sukuKataTotal = nextSukuKata;
    _rangkaiKataTotal = nextRangkaiKata;
    _refreshHurfProgress();
    notifyListeners();
  }

  Future<void> markHurfSuccess(String letter) async {
    _registerHurfViewed(letter);
    stars += 2;
    await _recordHistory(
      materialId: letter,
      category: 'huruf',
      duration: 1,
      score: 100,
    );
    await _saveAccount();
    notifyListeners();
  }

  Future<void> markAngkaViewed(String number) async {
    stars += 1;
    _registerAngkaViewed(number);
    await _saveAccount();
    notifyListeners();
  }

  Future<void> markAngkaSuccess(String number) async {
    _registerAngkaViewed(number);
    stars += 2;
    await _recordHistory(
      materialId: number,
      category: 'angka',
      duration: 1,
      score: 100,
    );
    await _saveAccount();
    notifyListeners();
  }

  Future<void> markBendaViewed(String name) async {
    stars += 1;
    _registerBendaViewed(name);
    await _saveAccount();
    notifyListeners();
  }

  Future<void> markBendaSuccess(String name) async {
    _registerBendaViewed(name);
    stars += 2;
    await _recordHistory(
      materialId: name,
      category: 'benda',
      duration: 1,
      score: 100,
    );
    await _saveAccount();
    notifyListeners();
  }

  Future<void> addObject(
    String name,
    String img,
    String category, {
    String? existingId,
    String? previousName,
  }) async {
    final object = await _db.addObject(
      name,
      img,
      category,
      existingId: existingId,
      previousName: previousName,
    );
    final previous = previousName?.trim();
    objects.removeWhere(
      (item) =>
          item.id == object.id ||
          (previous != null && previous.isNotEmpty && item.name == previous),
    );
    objects.insert(0, object);
    _markMaterialPending(object.id);
    await _refreshPendingMaterialSyncCount();
    await _syncSingleMaterial(object.id);
    notifyListeners();
  }

  Future<void> saveLetter({
    required String letter,
    required String example,
    required String imagePath,
    String? existingId,
  }) async {
    final item = await _db.saveLetter(
      letter: letter,
      example: example,
      imagePath: imagePath,
      existingId: existingId,
    );
    letters.removeWhere((entry) => entry.id == item.id);
    letters.insert(0, item);
    _sortLetters();
    _markMaterialPending(item.id);
    await _refreshPendingMaterialSyncCount();
    await _syncSingleMaterial(item.id);
    notifyListeners();
  }

  Future<void> removeLetter(LetterGroup item) async {
    letters.removeWhere(
      (entry) => entry.id == item.id || entry.letter == item.letter,
    );
    if (hurfMastered.remove(progressMasteryKey(item.letter))) {
      _refreshHurfProgress();
      await _saveAccount();
    }
    await _db.removeLetter(item);
    _markMaterialDeletePending(item.id);
    await _refreshPendingMaterialSyncCount();
    await _deleteCloudMaterial(item.id);
    notifyListeners();
  }

  Future<void> saveNumber({
    required String number,
    required String name,
    required String imagePath,
    String? existingId,
  }) async {
    final item = await _db.saveNumber(
      number: number,
      name: name,
      imagePath: imagePath,
      existingId: existingId,
    );
    numbers.removeWhere((entry) => entry.id == item.id);
    numbers.insert(0, item);
    _sortNumbers();
    _markMaterialPending(item.id);
    await _refreshPendingMaterialSyncCount();
    await _syncSingleMaterial(item.id);
    notifyListeners();
  }

  void _sortLetters() {
    letters.sort(
      (a, b) => a.letter.toUpperCase().compareTo(b.letter.toUpperCase()),
    );
  }

  void _sortNumbers() {
    numbers.sort((a, b) {
      final aNum = int.tryParse(a.number) ?? 9999;
      final bNum = int.tryParse(b.number) ?? 9999;
      final byValue = aNum.compareTo(bNum);
      if (byValue != 0) return byValue;
      return a.number.compareTo(b.number);
    });
  }

  Future<void> removeNumber(NumberItem item) async {
    numbers.removeWhere(
      (entry) => entry.id == item.id || entry.number == item.number,
    );
    if (angkaMastered.remove(progressMasteryKey(item.number))) {
      _refreshAngkaProgress();
      await _saveAccount();
    }
    await _db.removeNumber(item);
    _markMaterialDeletePending(item.id);
    await _refreshPendingMaterialSyncCount();
    await _deleteCloudMaterial(item.id);
    notifyListeners();
  }

  Future<void> removeObject(
    LearningObject item, {
    bool deleteMedia = true,
  }) async {
    objects.remove(item);
    if (deleteMedia && MediaSourceHelper.isLocalFilePath(item.img)) {
      await _db.deleteFile(item.img);
    }
    await _db.removeObject(item);
    _markMaterialDeletePending(item.id);
    await _refreshPendingMaterialSyncCount();
    await _deleteCloudMaterial(item.id);
    notifyListeners();
  }

  Future<void> addSong(
    String title,
    String url, {
    String? fileName,
    String mediaType = 'video',
    String? existingId,
  }) async {
    final id = existingId?.trim().isNotEmpty == true
        ? existingId!.trim()
        : DateTime.now().millisecondsSinceEpoch.toString();
    final song = await _db.saveSong(
      id: id,
      title: title,
      videoPath: url,
      fileName: fileName,
      mediaType: mediaType,
    );
    songs.removeWhere((item) => item.id == id);
    songs.insert(0, song);
    _markMaterialPending(song.id);
    await _refreshPendingMaterialSyncCount();
    await _syncSingleMaterial(song.id);
    notifyListeners();
  }

  Future<void> removeSong(SongItem song, {bool deleteMedia = true}) async {
    songs.remove(song);
    favorites.remove(song.id);
    if (deleteMedia && MediaSourceHelper.isLocalFilePath(song.videoUrl)) {
      await _db.deleteFile(song.videoUrl);
    }
    await _db.removeSong(song);
    if (email != null) {
      await _db.saveFavoriteIds(email!, favorites);
    }
    _markMaterialDeletePending(song.id);
    await _refreshPendingMaterialSyncCount();
    await _deleteCloudMaterial(song.id);
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    if (email != null) {
      await _db.saveFavoriteIds(email!, favorites);
    }
    notifyListeners();
  }

  Future<void> syncCloudContent({bool silent = false}) async {
    final username = email;
    final currentRole = role;
    if (username == null || currentRole == null) return;
    online = await _cloudSync.isOnline();
    if (!online) {
      syncStatus = 'Butuh koneksi internet';
      if (!silent && ready) notifyListeners();
      return;
    }
    if (!_cloudSync.isConfigured) {
      syncStatus = 'Supabase belum aktif';
      if (!silent) notifyListeners();
      return;
    }
    if (syncInProgress) return;
    syncInProgress = true;
    syncStatus = 'Sinkronisasi cloud...';
    if (!silent && ready) notifyListeners();
    try {
      await _pushCloudAccountState();
      if (currentRole == Role.teacher) {
        await _pushPendingMaterialDeletes();
      }
      await _pushCloudLearningHistory();
      await _cloudSync.syncForRole(
        role: currentRole.name,
        forceFullCatalogRefresh: !silent,
      );
      await _reloadLearningCatalog();
      await _refreshPendingMaterialSyncCount();
      if (pendingMaterialSyncCount == _pendingMaterialSyncIds.length) {
        _pendingMaterialSyncIds.clear();
        await _refreshPendingMaterialSyncCount();
      }
      lastSyncedAt = DateTime.now();
      syncStatus = hasPendingMaterialSync
          ? 'Belum sinkron: $pendingMaterialSyncCount perubahan'
          : 'Sudah sinkron ${_formatSyncTime(lastSyncedAt!)}';
    } catch (error) {
      syncStatus = ApiErrorMapper.toMessage(
        error,
        fallback: 'Sinkron gagal. Cek koneksi internet.',
      );
    } finally {
      syncInProgress = false;
      await _refreshPendingMaterialSyncCount();
      if (ready) notifyListeners();
    }
  }

  Future<void> _safeSyncCloudContent({bool silent = false}) async {
    try {
      await syncCloudContent(silent: silent);
    } catch (_) {
      syncStatus = 'Sinkronisasi ditunda';
      if (!silent && ready) notifyListeners();
    }
  }

  Future<void> _syncSingleMaterial(String materialId) async {
    if (materialId.trim().isEmpty) return;
    if (role != Role.teacher || email == null || !_cloudSync.isConfigured) {
      return;
    }
    online = await _cloudSync.isOnline();
    if (!online) {
      syncStatus = 'Butuh koneksi internet';
      await _refreshPendingMaterialSyncCount();
      if (ready) notifyListeners();
      return;
    }
    try {
      syncInProgress = true;
      syncStatus = 'Upload materi ke cloud...';
      if (ready) notifyListeners();
      final profile = await _cloudSync.currentProfile();
      final synced = await _cloudSync.syncLocalMaterial(
        materialId,
        createdBy: profile?.userId ?? email!,
      );
      if (synced == null) throw 'Sinkron materi ditunda.';
      _pendingMaterialSyncIds.remove(materialId);
      await _reloadLearningCatalog();
      await _refreshPendingMaterialSyncCount();
      lastSyncedAt = DateTime.now();
      syncStatus = 'Materi tersinkron ${_formatSyncTime(lastSyncedAt!)}';
    } catch (error) {
      await _refreshPendingMaterialSyncCount();
      syncStatus = ApiErrorMapper.toMessage(
        error,
        fallback: 'Ada konflik. Perubahan lokal aman.',
      );
    } finally {
      syncInProgress = false;
      await _refreshPendingMaterialSyncCount();
      if (ready) notifyListeners();
    }
  }

  Future<void> _deleteCloudMaterial(String materialId) async {
    if (materialId.trim().isEmpty) return;
    if (role != Role.teacher || !_cloudSync.isConfigured) return;
    online = await _cloudSync.isOnline();
    if (!online) {
      syncStatus = 'Butuh koneksi internet';
      await _refreshPendingMaterialSyncCount();
      if (ready) notifyListeners();
      return;
    }
    try {
      syncInProgress = true;
      syncStatus = 'Menghapus materi cloud...';
      if (ready) notifyListeners();
      await _cloudSync.deleteMaterial(materialId);
      _pendingMaterialSyncIds.remove(materialId);
      _pendingMaterialDeleteIds.remove(materialId);
      await _refreshPendingMaterialSyncCount();
      lastSyncedAt = DateTime.now();
      syncStatus = 'Perubahan tersinkron ${_formatSyncTime(lastSyncedAt!)}';
    } catch (error) {
      await _refreshPendingMaterialSyncCount();
      syncStatus = ApiErrorMapper.toMessage(
        error,
        fallback: 'Ada konflik. Perubahan lokal aman.',
      );
    } finally {
      syncInProgress = false;
      await _refreshPendingMaterialSyncCount();
      if (ready) notifyListeners();
    }
  }

  Future<void> _reloadLearningCatalog() async {
    objects
      ..clear()
      ..addAll(await _db.loadObjects());
    letters
      ..clear()
      ..addAll(await _db.loadLetters());
    _sortLetters();
    numbers
      ..clear()
      ..addAll(await _db.loadNumbers());
    _sortNumbers();
    iqraItems
      ..clear()
      ..addAll(await _db.loadIqraItems());
    songs
      ..clear()
      ..addAll(await _db.loadSongs());
    _refreshDerivedProgress();
  }

  Future<void> _refreshPendingMaterialSyncCount() async {
    if (role != Role.teacher || !_cloudSync.isConfigured) {
      pendingMaterialSyncCount = 0;
      _pendingMaterialSyncIds.clear();
      _pendingMaterialDeleteIds.clear();
      return;
    }
    final storedCount = await _cloudSync.pendingMaterialSyncCount();
    pendingMaterialSyncCount = max(storedCount, _pendingMaterialSyncIds.length);
  }

  void _markMaterialPending(String materialId) {
    final id = materialId.trim();
    if (id.isNotEmpty) _pendingMaterialSyncIds.add(id);
  }

  void _markMaterialDeletePending(String materialId) {
    final id = materialId.trim();
    if (id.isEmpty) return;
    _pendingMaterialSyncIds.add(id);
    _pendingMaterialDeleteIds.add(id);
  }

  Future<void> _pushPendingMaterialDeletes() async {
    if (_pendingMaterialDeleteIds.isEmpty) return;
    for (final id in _pendingMaterialDeleteIds.toList()) {
      await _cloudSync.deleteMaterial(id);
      _pendingMaterialDeleteIds.remove(id);
      _pendingMaterialSyncIds.remove(id);
    }
  }

  Future<void> _startConnectivityWatch() async {
    if (_connectivitySubscription != null || !_cloudSync.isConfigured) return;
    _connectivitySubscription = _cloudSync.connectivityChanges.listen((
      states,
    ) async {
      online = !states.contains(ConnectivityResult.none);
      if (states.contains(ConnectivityResult.none)) {
        syncStatus = 'Butuh koneksi internet';
        if (ready) notifyListeners();
        return;
      }
      if (email == null || role == null || syncInProgress) return;
      if (role == Role.teacher) {
        syncStatus = 'Koneksi pulih. Sinkron manual tersedia.';
        if (ready) notifyListeners();
        return;
      }
      syncStatus = 'Koneksi pulih. Refresh materi...';
      if (ready) notifyListeners();
      await syncCloudContent();
    });
  }

  void _startAutoSync() {
    _autoSyncTimer?.cancel();
    if (!_cloudSync.isConfigured) return;
    if (role == Role.teacher) return;
    _autoSyncTimer = Timer.periodic(const Duration(minutes: 5), (_) async {
      await _syncIfNeeded(reason: 'timer');
    });
  }

  void _startMaterialRealtime() {
    _materialSubscription?.cancel();
    _materialSubscription = null;
    if (!_cloudSync.isConfigured || role != Role.child || email == null) return;
    _materialSubscription = _cloudSync.watchCloudMaterials().listen(
      (materials) async {
        if (role != Role.child) return;
        await _cloudSync.mergeCloudMaterials(materials);
        await _reloadLearningCatalog();
        lastSyncedAt = DateTime.now();
        syncStatus = 'Materi realtime ${_formatSyncTime(lastSyncedAt!)}';
        if (ready) notifyListeners();
      },
      onError: (_) {
        syncStatus = 'Realtime materi ditunda';
        if (ready) notifyListeners();
      },
    );
  }

  Future<void> _syncIfNeeded({
    required String reason,
    bool force = false,
  }) async {
    if (email == null || role == null) return;
    if (!_cloudSync.isConfigured) return;
    if (syncInProgress) return;
    if (!force) {
      final last = _lastAutoSyncAt;
      if (last != null &&
          DateTime.now().difference(last) < const Duration(minutes: 5)) {
        return;
      }
    }
    _lastAutoSyncAt = DateTime.now();
    await syncCloudContent(silent: reason != 'resume');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (role == Role.teacher) return;
      unawaited(_syncIfNeeded(reason: 'resume', force: true));
    }
  }

  Role _roleFromString(String value) {
    final role = value.trim().toLowerCase();
    return role == 'teacher' || role == 'pengajar' || role == 'guru'
        ? Role.teacher
        : Role.child;
  }

  String _formatSyncTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription?.cancel();
    _materialSubscription?.cancel();
    _autoSyncTimer?.cancel();
    super.dispose();
  }

  void _applyAccount(UserAccount account) {
    email = account.username;
    childName = account.childName;
    gender = account.gender;
    role = account.role;
    themeId = appThemes.any((t) => t.id == account.themeId)
        ? account.themeId
        : 'default';
    favorites
      ..clear()
      ..addAll(account.favoriteMaterialIds);
    for (final entry in account.progress.entries) {
      progress[entry.key] = entry.value;
    }
    stars = account.stars;
    iqraStreak = account.iqraStreak;
    iqraMastered
      ..clear()
      ..addAll(account.iqraMastered);
    iqraHistory
      ..clear()
      ..addAll(account.iqraHistory);
    hurfMastered
      ..clear()
      ..addAll(account.hurfMastered);
    angkaMastered
      ..clear()
      ..addAll(account.angkaMastered);
    bendaMastered
      ..clear()
      ..addAll(account.bendaMastered);
  }

  Future<void> _saveAccount() async {
    final username = email;
    final currentRole = role;
    if (username == null || currentRole == null) return;
    final account = _currentAccountSnapshot();
    await _db.saveAccount(account);
    unawaited(_cloudSync.syncUserState(account));
  }

  Future<void> _recordHistory({
    required String materialId,
    required String category,
    required int duration,
    required int score,
  }) async {
    final username = email;
    if (username == null) return;
    await _db.addHistory(
      username: username,
      record: LearningHistoryRecord(
        materialId: materialId,
        category: category,
        duration: duration,
        score: score,
        playedAt: DateTime.now(),
      ),
    );
    unawaited(_pushCloudLearningHistory());
  }

  UserAccount _currentAccountSnapshot() {
    final username = email ?? '';
    final currentRole = role ?? Role.child;
    return UserAccount(
      username: username,
      childName: childName,
      gender: gender,
      role: currentRole,
      themeId: themeId,
      stars: stars,
      iqraStreak: iqraStreak,
      progress: Map<String, int>.from(progress),
      iqraMastered: iqraMastered.toList(),
      iqraHistory: iqraHistory.toList(),
      hurfMastered: hurfMastered.toList(),
      angkaMastered: angkaMastered.toList(),
      bendaMastered: bendaMastered.toList(),
      favoriteMaterialIds: favorites.toList(),
    );
  }

  Future<void> _pushCloudAccountState() async {
    final username = email;
    final currentRole = role;
    if (username == null || currentRole == null) return;
    await _cloudSync.syncUserState(_currentAccountSnapshot());
  }

  Future<void> _pushCloudLearningHistory() async {
    final username = email;
    if (username == null) return;
    final records = await _db.loadHistory(username, limit: 100);
    try {
      await _cloudSync.syncLearningHistory(records);
    } catch (_) {
      syncStatus = 'Riwayat belajar belum tersinkron';
    }
  }

  String? _progressKeyForMode(LearnMode mode) => switch (mode) {
    LearnMode.huruf => 'membaca',
    LearnMode.sukuKata => 'membaca',
    LearnMode.rangkaiKata => 'membaca',
    LearnMode.angka => 'angka',
    LearnMode.benda => 'benda',
    LearnMode.iqra => 'iqra',
    LearnMode.menu => null,
  };

  String? _historyCategoryForMode(LearnMode mode) => switch (mode) {
    LearnMode.huruf => 'huruf',
    LearnMode.sukuKata => 'suku_kata',
    LearnMode.rangkaiKata => 'rangkai_kata',
    LearnMode.angka => 'angka',
    LearnMode.benda => 'benda',
    LearnMode.iqra => 'iqra',
    LearnMode.menu => null,
  };

  bool _registerIqraViewed(IqraItem item) {
    final added = iqraMastered.add(iqraMasteryKey(item));
    if (!added) return false;
    _refreshIqraProgress();
    return true;
  }

  bool _registerHurfViewed(String letter) {
    final added = hurfMastered.add(progressMasteryKey(letter));
    if (!added) return false;
    _refreshHurfProgress();
    return true;
  }

  bool _registerAngkaViewed(String number) {
    final added = angkaMastered.add(progressMasteryKey(number));
    if (!added) return false;
    _refreshAngkaProgress();
    return true;
  }

  bool _registerBendaViewed(String name) {
    final added = bendaMastered.add(progressMasteryKey(name));
    if (!added) return false;
    _refreshBendaProgress();
    return true;
  }

  void _refreshDerivedProgress() {
    _refreshHurfProgress();
    _refreshAngkaProgress();
    _refreshBendaProgress();
    _refreshIqraProgress();
  }

  void _refreshHurfProgress() {
    final valid = _validProgressKeys(letters.map((item) => item.letter));
    _normalizeMastered(hurfMastered, valid, upperCase: true);
    final masteredCount =
        hurfMastered.where(valid.contains).length +
        sukuKataMastered.length +
        rangkaiKataMastered.length;
    final total = valid.length + _sukuKataTotal + _rangkaiKataTotal;
    progress['membaca'] = total == 0
        ? 0
        : min(100, (masteredCount / total * 100).round());
  }

  void _refreshAngkaProgress() {
    final valid = _validProgressKeys(numbers.map((item) => item.number));
    _normalizeMastered(angkaMastered, valid);
    progress['angka'] = _progressPercent(angkaMastered, valid);
  }

  void _refreshBendaProgress() {
    final valid = _validProgressKeys(objects.map((item) => item.name));
    _normalizeMastered(bendaMastered, valid);
    progress['benda'] = _progressPercent(bendaMastered, valid);
  }

  void _refreshIqraProgress() {
    progress['iqra'] = min(
      100,
      (iqraMasteredCount(iqraMastered, iqraItems) /
              max(1, iqraItems.length) *
              100)
          .round(),
    );
  }

  Set<String> _validProgressKeys(Iterable<String> values) =>
      values.map(progressMasteryKey).where((value) => value.isNotEmpty).toSet();

  void _normalizeMastered(
    Set<String> mastered,
    Set<String> valid, {
    bool upperCase = false,
  }) {
    final normalized = mastered
        .map((value) {
          final key = progressMasteryKey(value);
          return upperCase ? key.toUpperCase() : key;
        })
        .where((value) => value.isNotEmpty && valid.contains(value))
        .toSet();
    mastered
      ..clear()
      ..addAll(normalized);
  }

  int _progressPercent(Set<String> mastered, Set<String> valid) {
    if (valid.isEmpty) return 0;
    final count = mastered.where(valid.contains).length;
    return min(100, (count / valid.length * 100).round());
  }

  Future<void> _persistLearningOpen(LearnMode mode) async {
    final category = _historyCategoryForMode(mode);
    final progressKey = _progressKeyForMode(mode);
    if (category != null) {
      await _recordHistory(
        materialId: 'screen_${mode.name}',
        category: category,
        duration: 1,
        score: progressKey == null ? 0 : (progress[progressKey] ?? 0),
      );
    }
    await _saveAccount();
  }

  String _rangkaiProgressKey(String suffix) =>
      'child_rangkai_progress_${email ?? 'guest'}_$suffix';

  Future<void> _loadRangkaiLearningProgress() async {
    final prefs = _prefs;
    if (prefs == null) return;
    sukuKataMastered
      ..clear()
      ..addAll(prefs.getStringList(_rangkaiProgressKey('suku')) ?? const [])
      ..addAll(prefs.getStringList(_rangkaiProgressKey('saku')) ?? const []);
    rangkaiKataMastered
      ..clear()
      ..addAll(prefs.getStringList(_rangkaiProgressKey('kata')) ?? const []);
  }

  Future<void> _saveRangkaiLearningProgress() async {
    final prefs = _prefs;
    if (prefs == null) return;
    await prefs.setStringList(
      _rangkaiProgressKey('suku'),
      sukuKataMastered.toList(),
    );
    await prefs.setStringList(
      _rangkaiProgressKey('kata'),
      rangkaiKataMastered.toList(),
    );
  }
}
