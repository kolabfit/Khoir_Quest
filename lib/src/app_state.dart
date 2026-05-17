part of '../main.dart';

final appStateProvider = ChangeNotifierProvider<AppState>(
  (ref) => AppState(LocalDatabase.instance),
);

enum Role { child, teacher }

enum Gender { boy, girl }

enum TabItem { main, belajar, lagu, akun }

enum LearnMode { menu, huruf, angka, benda, iqra }

class AppState extends ChangeNotifier with WidgetsBindingObserver {
  AppState(this._db) {
    WidgetsBinding.instance.addObserver(this);
    load();
  }

  SharedPreferences? _prefs;
  final LocalDatabase _db;
  final CloudSyncService _cloudSync = CloudSyncService.instance;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _autoSyncTimer;
  DateTime? _lastAutoSyncAt;
  String? email;
  String childName = 'Teman';
  Gender gender = Gender.boy;
  Role? role;
  String themeId = 'default';
  bool onboardingSeen = false;
  TabItem tab = TabItem.main;
  LearnMode learnMode = LearnMode.menu;
  bool ready = false;

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
  final Set<String> angkaMastered = {};
  final Set<String> bendaMastered = {};
  final List<String> iqraHistory = [];
  int stars = 12;
  int iqraStreak = 0;
  bool syncInProgress = false;
  String syncStatus = 'Cache lokal aktif';
  DateTime? lastSyncedAt;

  AppThemeData get theme =>
      appThemes.firstWhere((t) => t.id == themeId, orElse: () => appThemes[0]);

  Future<void> load() async {
    await _db.ensureReady();
    await _cloudSync.ensureReady();
    _prefs = await SharedPreferences.getInstance();
    onboardingSeen = _prefs?.getBool('onboardingSeen') ?? false;
    await _migrateSharedPreferencesAccount();
    var account = await _db.currentAccount();
    if (_cloudSync.isConfigured) {
      final profile = await _cloudSync.currentProfile();
      if (profile != null) {
        account = await _db.restoreCloudSession(
          username: profile.username,
          role: _roleFromString(profile.role),
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
    await _reloadLearningCatalog();
    await _startConnectivityWatch();
    _startAutoSync();
    if (email != null && role != null) {
      await syncCloudContent(silent: true);
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
      var nextRole = teacherMode || _resolveRole(nextEmail) == Role.teacher
          ? Role.teacher
          : Role.child;
      CloudAuthProfile? cloudProfile;
      Object? cloudError;
      if (_cloudSync.isConfigured) {
        try {
          cloudProfile = await _cloudSync.authenticate(
            username: nextEmail,
            password: password,
            register: register,
            preferredRole: nextRole.name,
          );
          nextRole = _roleFromString(cloudProfile.role);
        } catch (error) {
          if (register) rethrow;
          cloudError = error;
        }
      }
      var account = await _db.authenticate(
        username: nextEmail,
        password: password,
        register: register,
        autoCreate: autoCreate || (!register && cloudProfile != null),
        role: nextRole,
        childName: name?.trim().isNotEmpty == true ? name!.trim() : 'Teman',
        gender: nextGender ?? gender,
        themeId: themeId,
        defaultProgress: progress,
        defaultStars: stars,
      );
      if (cloudProfile != null) {
        account = await _db.restoreCloudSession(
          username: cloudProfile.username.isEmpty
              ? nextEmail
              : cloudProfile.username,
          role: _roleFromString(cloudProfile.role),
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
      } else if (cloudError != null) {
        // Lanjut pakai akun lokal bila login cloud gagal tetapi data lokal ada.
      }
      _applyAccount(account);
      tab = role == Role.teacher ? TabItem.akun : TabItem.main;
      _startAutoSync();
      await syncCloudContent(silent: true);
      notifyListeners();
    } catch (error) {
      throw ApiErrorMapper.toMessage(error);
    }
  }

  Role _resolveRole(String identity) {
    final id = identity.toLowerCase().trim();
    if (id == adminEmail ||
        id == 'pengajar' ||
        id == 'guru' ||
        id.startsWith('guru_') ||
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
    _autoSyncTimer?.cancel();
    _autoSyncTimer = null;
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

  Future<void> addObject(String name, String img, String category) async {
    final object = await _db.addObject(name, img, category);
    objects.insert(0, object);
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
    await _syncSingleMaterial(item.id);
    notifyListeners();
  }

  Future<void> removeLetter(LetterGroup item) async {
    letters.removeWhere(
      (entry) => entry.id == item.id || entry.letter == item.letter,
    );
    if (hurfMastered.remove(item.letter)) {
      progress['membaca'] = min(
        100,
        (hurfMastered.length / max(1, letters.length) * 100).round(),
      );
      await _saveAccount();
    }
    await _db.removeLetter(item);
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
    if (angkaMastered.remove(item.number)) {
      progress['angka'] = min(
        100,
        (angkaMastered.length / max(1, numbers.length) * 100).round(),
      );
      await _saveAccount();
    }
    await _db.removeNumber(item);
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
    await _deleteCloudMaterial(item.id);
    notifyListeners();
  }

  Future<void> addSong(String title, String url, {String? fileName}) async {
    final song = SongItem(
      DateTime.now().millisecondsSinceEpoch.toString(),
      title,
      url,
      const [],
      fileName: fileName,
    );
    songs.insert(0, song);
    await _db.saveSongs(songs);
    await _syncSingleMaterial(song.id);
    notifyListeners();
  }

  Future<void> removeSong(SongItem song, {bool deleteMedia = true}) async {
    songs.remove(song);
    favorites.remove(song.id);
    if (deleteMedia && MediaSourceHelper.isLocalFilePath(song.videoUrl)) {
      await _db.deleteFile(song.videoUrl);
    }
    await _db.saveSongs(songs);
    if (email != null) {
      await _db.saveFavoriteIds(email!, favorites);
    }
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

  Future<void> _migrateSharedPreferencesAccount() async {
    final savedEmail = _prefs?.getString('email');
    if (savedEmail == null) return;
    final savedTheme = _prefs?.getString('themeId') ?? 'default';
    final savedProgress = Map<String, int>.from(progress);
    for (final key in savedProgress.keys) {
      savedProgress[key] =
          _prefs?.getInt('progress_$key') ?? savedProgress[key]!;
    }
    final roleName = _prefs?.getString('role');
    await _db.migrateAccount(
      username: savedEmail,
      childName: _prefs?.getString('childName') ?? 'Teman',
      gender: _prefs?.getString('gender') == 'girl' ? Gender.girl : Gender.boy,
      role: roleName == 'teacher' ? Role.teacher : Role.child,
      themeId: appThemes.any((t) => t.id == savedTheme)
          ? savedTheme
          : 'default',
      stars: _prefs?.getInt('stars') ?? stars,
      iqraStreak: _prefs?.getInt('iqra_streak') ?? 0,
      progress: savedProgress,
      iqraMastered: _prefs?.getStringList('iqra_mastered') ?? const [],
      iqraHistory: _prefs?.getStringList('iqra_history') ?? const [],
    );
  }

  Future<void> syncCloudContent({bool silent = false}) async {
    final username = email;
    final currentRole = role;
    if (username == null || currentRole == null) return;
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
      await _pushCloudLearningHistory();
      await _cloudSync.syncForRole(role: currentRole.name);
      await _reloadLearningCatalog();
      lastSyncedAt = DateTime.now();
      syncStatus = 'Tersinkron ${_formatSyncTime(lastSyncedAt!)}';
    } catch (_) {
      syncStatus = 'Mode offline. Cache lokal dipakai.';
    } finally {
      syncInProgress = false;
      if (ready) notifyListeners();
    }
  }

  Future<void> _syncSingleMaterial(String materialId) async {
    if (materialId.trim().isEmpty) return;
    if (role != Role.teacher || email == null || !_cloudSync.isConfigured) {
      return;
    }
    try {
      syncInProgress = true;
      syncStatus = 'Upload materi ke cloud...';
      if (ready) notifyListeners();
      final profile = await _cloudSync.currentProfile();
      await _cloudSync.syncLocalMaterial(
        materialId,
        createdBy: profile?.userId ?? email!,
      );
      await _reloadLearningCatalog();
      lastSyncedAt = DateTime.now();
      syncStatus = 'Materi tersinkron ${_formatSyncTime(lastSyncedAt!)}';
    } catch (_) {
      syncStatus = 'Tersimpan lokal. Sinkron tertunda.';
    } finally {
      syncInProgress = false;
      if (ready) notifyListeners();
    }
  }

  Future<void> _deleteCloudMaterial(String materialId) async {
    if (materialId.trim().isEmpty) return;
    if (role != Role.teacher || !_cloudSync.isConfigured) return;
    try {
      syncInProgress = true;
      syncStatus = 'Menghapus materi cloud...';
      if (ready) notifyListeners();
      await _cloudSync.deleteMaterial(materialId);
      lastSyncedAt = DateTime.now();
      syncStatus = 'Perubahan tersinkron ${_formatSyncTime(lastSyncedAt!)}';
    } catch (_) {
      syncStatus = 'Hapus lokal selesai. Sinkron cloud tertunda.';
    } finally {
      syncInProgress = false;
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

  Future<void> _startConnectivityWatch() async {
    if (_connectivitySubscription != null || !_cloudSync.isConfigured) return;
    _connectivitySubscription = _cloudSync.connectivityChanges.listen((
      states,
    ) async {
      if (states.contains(ConnectivityResult.none)) {
        syncStatus = 'Offline cache aktif';
        if (ready) notifyListeners();
        return;
      }
      if (email == null || role == null || syncInProgress) return;
      syncStatus = 'Koneksi pulih. Refresh materi...';
      if (ready) notifyListeners();
      await syncCloudContent();
    });
  }

  void _startAutoSync() {
    _autoSyncTimer?.cancel();
    if (!_cloudSync.isConfigured) return;
    _autoSyncTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await _syncIfNeeded(reason: 'timer');
    });
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
          DateTime.now().difference(last) < const Duration(seconds: 20)) {
        return;
      }
    }
    _lastAutoSyncAt = DateTime.now();
    await syncCloudContent(silent: reason != 'resume');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_syncIfNeeded(reason: 'resume', force: true));
    }
  }

  Role _roleFromString(String value) =>
      value.trim().toLowerCase() == 'teacher' ? Role.teacher : Role.child;

  String _formatSyncTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription?.cancel();
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
    await _cloudSync.syncLearningHistory(records);
  }

  String? _progressKeyForMode(LearnMode mode) => switch (mode) {
    LearnMode.huruf => 'membaca',
    LearnMode.angka => 'angka',
    LearnMode.benda => 'benda',
    LearnMode.iqra => 'iqra',
    LearnMode.menu => null,
  };

  String? _historyCategoryForMode(LearnMode mode) => switch (mode) {
    LearnMode.huruf => 'huruf',
    LearnMode.angka => 'angka',
    LearnMode.benda => 'benda',
    LearnMode.iqra => 'iqra',
    LearnMode.menu => null,
  };

  bool _registerIqraViewed(IqraItem item) {
    final added = iqraMastered.add(item.latin);
    if (!added) return false;
    progress['iqra'] = min(
      100,
      (iqraMastered.length / max(1, iqraItems.length) * 100).round(),
    );
    return true;
  }

  bool _registerHurfViewed(String letter) {
    final added = hurfMastered.add(letter);
    if (!added) return false;
    progress['membaca'] = min(
      100,
      (hurfMastered.length / max(1, letters.length) * 100).round(),
    );
    return true;
  }

  bool _registerAngkaViewed(String number) {
    final added = angkaMastered.add(number);
    if (!added) return false;
    progress['angka'] = min(
      100,
      (angkaMastered.length / max(1, numbers.length) * 100).round(),
    );
    return true;
  }

  bool _registerBendaViewed(String name) {
    final added = bendaMastered.add(name);
    if (!added) return false;
    progress['benda'] = min(
      100,
      (bendaMastered.length / max(1, objects.length) * 100).round(),
    );
    return true;
  }

  void _refreshDerivedProgress() {
    progress['membaca'] = min(
      100,
      (hurfMastered.length / max(1, letters.length) * 100).round(),
    );
    progress['angka'] = min(
      100,
      (angkaMastered.length / max(1, numbers.length) * 100).round(),
    );
    progress['benda'] = min(
      100,
      (bendaMastered.length / max(1, objects.length) * 100).round(),
    );
    progress['iqra'] = min(
      100,
      (iqraMastered.length / max(1, iqraItems.length) * 100).round(),
    );
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
}
