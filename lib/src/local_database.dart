part of '../main.dart';

class LocalDatabase {
  LocalDatabase({
    UserRepository? userRepository,
    ProgressRepository? progressRepository,
    MaterialRepository? materialRepository,
    ThemeRepository? themeRepository,
    HistoryRepository? historyRepository,
    BadgeRepository? badgeRepository,
    OfflineBootstrapService? bootstrapService,
    LocalStorageService? storageService,
  }) : _userRepository =
           userRepository ?? UserRepository(IsarDatabaseService.instance),
       _progressRepository =
           progressRepository ??
           ProgressRepository(IsarDatabaseService.instance),
       _materialRepository =
           materialRepository ??
           MaterialRepository(IsarDatabaseService.instance),
       _themeRepository =
           themeRepository ?? ThemeRepository(IsarDatabaseService.instance),
       _historyRepository =
           historyRepository ?? HistoryRepository(IsarDatabaseService.instance),
       _badgeRepository =
           badgeRepository ?? BadgeRepository(IsarDatabaseService.instance),
       _bootstrapService =
           bootstrapService ??
           OfflineBootstrapService(
             database: IsarDatabaseService.instance,
             storageService: storageService ?? LocalStorageService.instance,
             materialRepository:
                 materialRepository ??
                 MaterialRepository(IsarDatabaseService.instance),
             themeRepository:
                 themeRepository ??
                 ThemeRepository(IsarDatabaseService.instance),
             legacyMigrationService: LegacyMigrationService(
               userRepository:
                   userRepository ??
                   UserRepository(IsarDatabaseService.instance),
               progressRepository:
                   progressRepository ??
                   ProgressRepository(IsarDatabaseService.instance),
               materialRepository:
                   materialRepository ??
                   MaterialRepository(IsarDatabaseService.instance),
               themeRepository:
                   themeRepository ??
                   ThemeRepository(IsarDatabaseService.instance),
               storageService: storageService ?? LocalStorageService.instance,
             ),
           ),
       _storageService = storageService ?? LocalStorageService.instance;

  LocalDatabase._internal() : this();

  static final instance = LocalDatabase._internal();

  final UserRepository _userRepository;
  final ProgressRepository _progressRepository;
  final MaterialRepository _materialRepository;
  final ThemeRepository _themeRepository;
  final HistoryRepository _historyRepository;
  final BadgeRepository _badgeRepository;
  final OfflineBootstrapService _bootstrapService;
  final LocalStorageService _storageService;
  SharedPreferences? _webPrefs;

  Future<void> ensureReady() async {
    if (!kIsWeb) {
      await _bootstrapService.ensureReady();
      return;
    }
    _webPrefs ??= await SharedPreferences.getInstance();
    final prefs = _webPrefs!;
    if (!prefs.containsKey(_webThemeKey('guest'))) {
      await prefs.setString(_webThemeKey('guest'), 'default');
    }
  }

  Future<UserAccount?> currentAccount() async {
    await ensureReady();
    if (kIsWeb) {
      final prefs = _webPrefs!;
      final username = prefs.getString(_webCurrentUserKey);
      if (username == null || username.isEmpty) return null;
      return _webLoadAccount(username);
    }
    final base = await _userRepository.currentAccount(
      genderParser: _parseGender,
      roleParser: _parseRole,
    );
    if (base == null) return null;
    final progress = await _progressRepository.loadProgress(base.username);
    return _withProgress(base, progress);
  }

  Future<void> clearSession() async {
    await ensureReady();
    if (kIsWeb) {
      await _webPrefs!.remove(_webCurrentUserKey);
      return;
    }
    await _userRepository.clearSession();
  }

  Future<UserAccount> restoreCloudSession({
    required String username,
    required Role role,
    String childName = 'Teman',
    Gender gender = Gender.boy,
    String themeId = 'default',
    String avatarPath = '',
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
    if (kIsWeb) {
      final existing = _webLoadAccount(username);
      final account = existing == null
          ? UserAccount(
              username: username.toLowerCase().trim(),
              childName: childName,
              gender: gender,
              role: role,
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
              avatarPath: avatarPath,
            )
          : UserAccount(
              username: existing.username,
              childName: childName,
              gender: gender,
              role: role,
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
              avatarPath: existing.avatarPath.isEmpty
                  ? avatarPath
                  : existing.avatarPath,
              createdAt: existing.createdAt,
            );
      await _webSaveAccount(account);
      await _webPrefs!.setString(_webCurrentUserKey, account.username);
      return account;
    }
    final existing = await _userRepository.accountByUsername(
      username: username,
      genderParser: _parseGender,
      roleParser: _parseRole,
    );
    if (existing == null) {
      await _userRepository.migrateLegacyAccount(
        username: username,
        childName: childName,
        gender: gender,
        role: role,
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
    } else {
      await _userRepository.saveAccount(
        UserAccount(
          username: existing.username,
          childName: childName,
          gender: gender,
          role: role,
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
          avatarPath: existing.avatarPath.isEmpty
              ? avatarPath
              : existing.avatarPath,
          createdAt: existing.createdAt,
        ),
      );
    }
    await _userRepository.setCurrentUsername(username);
    await _progressRepository.syncProgress(
      username: username,
      progress: progress,
      hurfMastered: hurfMastered,
      angkaMastered: angkaMastered,
      bendaMastered: bendaMastered,
      iqraMastered: iqraMastered,
    );
    await _badgeRepository.ensureSeeded(username);
    final account = await _userRepository.accountByUsername(
      username: username,
      genderParser: _parseGender,
      roleParser: _parseRole,
    );
    final loadedProgress = await _progressRepository.loadProgress(username);
    return _withProgress(account!, loadedProgress);
  }

  Future<UserAccount> authenticate({
    required String username,
    required String password,
    required bool register,
    required bool autoCreate,
    required Role role,
    required String childName,
    required Gender gender,
    required String themeId,
    required Map<String, int> defaultProgress,
    required int defaultStars,
  }) async {
    await ensureReady();
    if (kIsWeb) {
      final prefs = _webPrefs!;
      final normalized = username.toLowerCase().trim();
      final existing = _webLoadAccount(normalized);
      if (existing == null) {
        if (!register && !autoCreate) throw 'Akun belum terdaftar';
        final account = UserAccount(
          username: normalized,
          childName: childName,
          gender: gender,
          role: role,
          themeId: themeId,
          stars: defaultStars,
          iqraStreak: 0,
          progress: Map<String, int>.from(defaultProgress),
          iqraMastered: const [],
          iqraHistory: const [],
          favoriteMaterialIds: const [],
          avatarPath: gender == Gender.girl
              ? DefaultLearningCatalog.avatarGirlAsset
              : DefaultLearningCatalog.avatarBoyAsset,
          createdAt: DateTime.now(),
        );
        await prefs.setString(
          _webPasswordKey(normalized),
          _hashPassword(password),
        );
        await _webSaveAccount(account);
        await prefs.setString(_webCurrentUserKey, normalized);
        return account;
      }
      if (register) throw 'Username sudah terdaftar';
      final savedHash = prefs.getString(_webPasswordKey(normalized));
      final hash = _hashPassword(password);
      if (savedHash != null && savedHash.isNotEmpty && savedHash != hash) {
        throw 'Password salah';
      }
      await prefs.setString(_webPasswordKey(normalized), hash);
      await prefs.setString(_webCurrentUserKey, normalized);
      return existing;
    }
    final account = await _userRepository.authenticate(
      username: username,
      password: password,
      register: register,
      autoCreate: autoCreate,
      role: role,
      childName: childName,
      gender: gender,
      themeId: themeId,
      defaultProgress: defaultProgress,
      defaultStars: defaultStars,
      genderParser: _parseGender,
      roleParser: _parseRole,
    );
    await _progressRepository.ensureDefaults(account.username);
    await _badgeRepository.ensureSeeded(account.username);
    final progress = await _progressRepository.loadProgress(account.username);
    return _withProgress(account, progress);
  }

  Future<void> resetPassword({
    required String username,
    required String newPassword,
  }) async {
    await ensureReady();
    final normalized = username.toLowerCase().trim();
    if (kIsWeb) {
      final existing = _webLoadAccount(normalized);
      if (existing == null) throw 'Akun belum terdaftar';
      await _webPrefs!.setString(
        _webPasswordKey(normalized),
        _hashPassword(newPassword),
      );
      return;
    }
    await _userRepository.resetPassword(
      username: normalized,
      newPassword: newPassword,
    );
  }

  Future<void> saveAccount(UserAccount account) async {
    await ensureReady();
    if (kIsWeb) {
      await _webSaveAccount(account);
      await _webPrefs!.setString(
        _webThemeKey(_themeOwner(account.username)),
        account.themeId,
      );
      return;
    }
    await _userRepository.saveAccount(account);
    await _progressRepository.syncProgress(
      username: account.username,
      progress: account.progress,
      hurfMastered: account.hurfMastered,
      angkaMastered: account.angkaMastered,
      bendaMastered: account.bendaMastered,
      iqraMastered: account.iqraMastered,
    );
    await _themeRepository.saveTheme(
      ownerUsername: _themeOwner(account.username),
      themeId: account.themeId,
      darkMode: account.themeId.toLowerCase().contains('malam'),
    );
    await _materialRepository.setFavoriteState(
      account.favoriteMaterialIds.toSet(),
    );
  }

  Future<void> migrateAccount({
    required String username,
    required String childName,
    required Gender gender,
    required Role role,
    required String themeId,
    required int stars,
    required int iqraStreak,
    required Map<String, int> progress,
    required List<String> iqraMastered,
    required List<String> iqraHistory,
  }) async {
    await ensureReady();
    if (kIsWeb) {
      final account = UserAccount(
        username: username.toLowerCase().trim(),
        childName: childName,
        gender: gender,
        role: role,
        themeId: themeId,
        stars: stars,
        iqraStreak: iqraStreak,
        progress: progress,
        iqraMastered: iqraMastered,
        iqraHistory: iqraHistory,
        avatarPath: gender == Gender.girl
            ? DefaultLearningCatalog.avatarGirlAsset
            : DefaultLearningCatalog.avatarBoyAsset,
        createdAt: DateTime.now(),
      );
      await _webSaveAccount(account);
      await _webPrefs!.setString(_webCurrentUserKey, account.username);
      return;
    }
    await _userRepository.migrateLegacyAccount(
      username: username,
      childName: childName,
      gender: gender,
      role: role,
      themeId: themeId,
      stars: stars,
      iqraStreak: iqraStreak,
      progress: progress,
      iqraMastered: iqraMastered,
      iqraHistory: iqraHistory,
    );
    await _progressRepository.syncProgress(
      username: username,
      progress: progress,
      hurfMastered: const [],
      angkaMastered: const [],
      bendaMastered: const [],
      iqraMastered: iqraMastered,
    );
  }

  Future<String?> loadThemeId({String? ownerUsername}) async {
    await ensureReady();
    if (kIsWeb) {
      return _webPrefs!.getString(_webThemeKey(_themeOwner(ownerUsername)));
    }
    return _themeRepository.loadThemeId(_themeOwner(ownerUsername));
  }

  Future<void> saveThemeId({
    String? ownerUsername,
    required String themeId,
    required bool darkMode,
  }) async {
    await ensureReady();
    if (kIsWeb) {
      await _webPrefs!.setString(
        _webThemeKey(_themeOwner(ownerUsername)),
        themeId,
      );
      return;
    }
    await _themeRepository.saveTheme(
      ownerUsername: _themeOwner(ownerUsername),
      themeId: themeId,
      darkMode: darkMode,
    );
  }

  Future<List<SongItem>> loadSongs() async {
    await ensureReady();
    if (kIsWeb) {
      final raw = _webPrefs!.getString(_webSongsKey);
      if (raw == null || raw.isEmpty) return const [];
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return SongItem(
          map['id'] as String,
          map['title'] as String,
          map['videoUrl'] as String,
          const [],
          fileName: map['fileName'] as String?,
        );
      }).toList();
    }
    final items = await _materialRepository.loadSongs();
    return items
        .map(
          (item) => SongItem(
            item.materialId,
            item.title,
            item.videoPath,
            const [],
            fileName: item.fileName.isEmpty ? null : item.fileName,
          ),
        )
        .toList();
  }

  Future<List<LetterGroup>> loadLetters() async {
    await ensureReady();
    if (kIsWeb) {
      final raw = _webPrefs!.getString(_webLettersKey);
      if (raw == null || raw.isEmpty) return [...defaultLettersData];
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return LetterGroup(map['letter'] as String, [
          LearningObject(
            map['example'] as String? ?? '',
            map['img'] as String? ??
                DefaultLearningCatalog.hurufPlaceholderAsset,
            map['category'] as String? ?? 'contoh',
          ),
        ], map['id'] as String? ?? '');
      }).toList();
    }
    final items = await _materialRepository.loadByCategory(
      LearningCategories.huruf,
    );
    if (items.isEmpty) return [...defaultLettersData];
    return items
        .map(
          (item) => LetterGroup(_normalizeLetterTitle(item.title), [
            LearningObject(
              item.subcategory.isEmpty ? 'Contoh' : item.subcategory,
              item.imagePath.isEmpty
                  ? defaultMediaFallback(LearningCategories.huruf)
                  : item.imagePath,
              'contoh',
            ),
          ], item.materialId),
        )
        .toList();
  }

  Future<List<IqraItem>> loadIqraItems() async {
    await ensureReady();
    if (kIsWeb) {
      final items = [...iqraData];
      items.sort(_compareIqraItems);
      return items;
    }
    final items = await _materialRepository.loadByCategory(
      LearningCategories.iqra,
    );
    if (items.isEmpty) {
      final defaults = [...iqraData];
      defaults.sort(_compareIqraItems);
      return defaults;
    }
    final mapped = items
        .map(
          (item) => IqraItem(
            item.title.isEmpty ? item.subcategory : item.title,
            item.subcategory.isEmpty ? item.title : item.subcategory,
            audioUrl: item.audioPath,
          ),
        )
        .toList();
    mapped.sort(_compareIqraItems);
    return mapped;
  }

  Future<LetterGroup> saveLetter({
    required String letter,
    required String example,
    required String imagePath,
    String? existingId,
  }) async {
    await ensureReady();
    final normalizedLetter = letter.trim().toUpperCase();
    final normalizedExample = example.trim();
    final materialId = existingId?.trim().isNotEmpty == true
        ? existingId!.trim()
        : 'huruf_${normalizedLetter.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}';
    if (kIsWeb) {
      final items = await loadLetters();
      final next = LetterGroup(normalizedLetter, [
        LearningObject(normalizedExample, imagePath, 'contoh'),
      ], materialId);
      items.removeWhere((item) => item.id == materialId);
      items.insert(0, next);
      await _webPrefs!.setString(
        _webLettersKey,
        jsonEncode(
          items.map((item) {
            final sample = item.objects.isEmpty
                ? const LearningObject('', '')
                : item.objects.first;
            return {
              'id': item.id,
              'letter': item.letter,
              'example': sample.name,
              'img': sample.img,
              'category': sample.category,
            };
          }).toList(),
        ),
      );
      return next;
    }
    final entity = await _materialRepository.upsertMaterial(
      materialId: materialId,
      category: LearningCategories.huruf,
      title: normalizedLetter,
      subcategory: normalizedExample,
      imagePath: imagePath,
    );
    return LetterGroup(_normalizeLetterTitle(entity.title), [
      LearningObject(
        entity.subcategory.isEmpty ? 'Contoh' : entity.subcategory,
        entity.imagePath,
        'contoh',
      ),
    ], entity.materialId);
  }

  Future<void> removeLetter(LetterGroup item) async {
    await ensureReady();
    final imagePath = item.objects.isEmpty ? '' : item.objects.first.img;
    if (kIsWeb) {
      final items = await loadLetters();
      items.removeWhere(
        (entry) => entry.id == item.id || entry.letter == item.letter,
      );
      await _webPrefs!.setString(
        _webLettersKey,
        jsonEncode(
          items.map((entry) {
            final sample = entry.objects.isEmpty
                ? const LearningObject('', '')
                : entry.objects.first;
            return {
              'id': entry.id,
              'letter': entry.letter,
              'example': sample.name,
              'img': sample.img,
              'category': sample.category,
            };
          }).toList(),
        ),
      );
      return;
    }
    if (item.id.isNotEmpty) {
      await _materialRepository.deleteMaterialById(item.id);
    }
    if (MediaSourceHelper.isLocalFilePath(imagePath)) {
      await _storageService.deleteFile(imagePath);
    }
  }

  Future<List<NumberItem>> loadNumbers() async {
    await ensureReady();
    if (kIsWeb) {
      final raw = _webPrefs!.getString(_webNumbersKey);
      if (raw == null || raw.isEmpty) return [...defaultNumbersData];
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return NumberItem(
          map['number'] as String,
          map['name'] as String? ?? '',
          map['img'] as String? ?? DefaultLearningCatalog.angkaPlaceholderAsset,
          map['id'] as String? ?? '',
        );
      }).toList();
    }
    final items = await _materialRepository.loadByCategory(
      LearningCategories.angka,
    );
    if (items.isEmpty) return [...defaultNumbersData];
    return items.map((item) {
      final normalizedNumber = _normalizeNumberTitle(item.title);
      return NumberItem(
        normalizedNumber,
        _normalizeNumberSubtitle(
          item.subcategory.isEmpty ? item.title : item.subcategory,
          fallbackNumber: normalizedNumber,
        ),
        item.imagePath.isEmpty
            ? defaultMediaFallback(LearningCategories.angka)
            : item.imagePath,
        item.materialId,
      );
    }).toList();
  }

  Future<NumberItem> saveNumber({
    required String number,
    required String name,
    required String imagePath,
    String? existingId,
  }) async {
    await ensureReady();
    final normalizedNumber = number.trim();
    final normalizedName = name.trim();
    final materialId = existingId?.trim().isNotEmpty == true
        ? existingId!.trim()
        : 'angka_${normalizedNumber}_${DateTime.now().millisecondsSinceEpoch}';
    if (kIsWeb) {
      final items = await loadNumbers();
      final next = NumberItem(
        normalizedNumber,
        normalizedName,
        imagePath,
        materialId,
      );
      items.removeWhere((item) => item.id == materialId);
      items.insert(0, next);
      await _webPrefs!.setString(
        _webNumbersKey,
        jsonEncode(
          items
              .map(
                (item) => {
                  'id': item.id,
                  'number': item.number,
                  'name': item.name,
                  'img': item.img,
                },
              )
              .toList(),
        ),
      );
      return next;
    }
    final entity = await _materialRepository.upsertMaterial(
      materialId: materialId,
      category: LearningCategories.angka,
      title: normalizedNumber,
      subcategory: normalizedName,
      imagePath: imagePath,
    );
    return NumberItem(
      _normalizeNumberTitle(entity.title),
      _normalizeNumberSubtitle(
        entity.subcategory.isEmpty ? entity.title : entity.subcategory,
        fallbackNumber: _normalizeNumberTitle(entity.title),
      ),
      entity.imagePath,
      entity.materialId,
    );
  }

  Future<void> removeNumber(NumberItem item) async {
    await ensureReady();
    if (kIsWeb) {
      final items = await loadNumbers();
      items.removeWhere(
        (entry) => entry.id == item.id || entry.number == item.number,
      );
      await _webPrefs!.setString(
        _webNumbersKey,
        jsonEncode(
          items
              .map(
                (entry) => {
                  'id': entry.id,
                  'number': entry.number,
                  'name': entry.name,
                  'img': entry.img,
                },
              )
              .toList(),
        ),
      );
      return;
    }
    if (item.id.isNotEmpty) {
      await _materialRepository.deleteMaterialById(item.id);
    }
    if (MediaSourceHelper.isLocalFilePath(item.img)) {
      await _storageService.deleteFile(item.img);
    }
  }

  Future<void> saveSongs(List<SongItem> songs) async {
    await ensureReady();
    if (kIsWeb) {
      await _webPrefs!.setString(
        _webSongsKey,
        jsonEncode(
          songs
              .map(
                (song) => {
                  'id': song.id,
                  'title': song.title,
                  'videoUrl': song.videoUrl,
                  'fileName': song.fileName,
                },
              )
              .toList(),
        ),
      );
      return;
    }
    final entities = songs
        .map(
          (song) => LearningMaterialEntity()
            ..materialId = song.id
            ..title = song.title
            ..category = LearningCategories.lagu
            ..videoPath = song.videoUrl
            ..fileName = song.fileName ?? ''
            ..createdAt = DateTime.now()
            ..updatedAt = DateTime.now(),
        )
        .toList();
    await _materialRepository.replaceSongs(entities);
  }

  Future<SongItem> saveSong({
    required String id,
    required String title,
    required String videoPath,
    String? fileName,
  }) async {
    await ensureReady();
    if (kIsWeb) {
      final songs = await loadSongs();
      final song = SongItem(id, title, videoPath, const [], fileName: fileName);
      songs.removeWhere((item) => item.id == id);
      songs.insert(0, song);
      await saveSongs(songs);
      return song;
    }
    await _materialRepository.upsertSong(
      id: id,
      title: title,
      videoPath: videoPath,
      fileName: fileName,
    );
    return SongItem(id, title, videoPath, const [], fileName: fileName);
  }

  Future<void> removeSong(SongItem song) async {
    await ensureReady();
    if (kIsWeb) {
      final songs = await loadSongs();
      songs.removeWhere((item) => item.id == song.id);
      await saveSongs(songs);
      return;
    }
    await _materialRepository.deleteMaterialById(song.id);
  }

  Future<List<LearningObject>> loadObjects() async {
    await ensureReady();
    if (kIsWeb) {
      final raw = _webPrefs!.getString(_webObjectsKey);
      if (raw == null || raw.isEmpty) return [...objectsData];
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return LearningObject(
          map['name'] as String,
          map['img'] as String,
          map['category'] as String? ?? 'benda',
          map['id'] as String? ?? '',
        );
      }).toList();
    }
    final items = await _materialRepository.loadByCategory(
      LearningCategories.benda,
    );
    return items
        .map(
          (item) => LearningObject(
            item.title,
            item.imagePath.isEmpty
                ? defaultMediaFallback(LearningCategories.benda)
                : item.imagePath,
            item.subcategory.isEmpty ? 'benda' : item.subcategory,
            item.materialId,
          ),
        )
        .toList();
  }

  Future<LearningObject> addObject(
    String name,
    String imagePath,
    String category, {
    String? existingId,
    String? previousName,
  }) async {
    await ensureReady();
    if (kIsWeb) {
      final objects = await loadObjects();
      final object = LearningObject(
        name,
        imagePath,
        category,
        existingId?.trim().isNotEmpty == true
            ? existingId!.trim()
            : 'benda_${DateTime.now().millisecondsSinceEpoch}',
      );
      final previous = previousName?.trim();
      objects.removeWhere(
        (item) =>
            item.id == object.id ||
            (previous != null && previous.isNotEmpty && item.name == previous),
      );
      objects.insert(0, object);
      await _webPrefs!.setString(
        _webObjectsKey,
        jsonEncode(
          objects
              .map(
                (item) => {
                  'id': item.id,
                  'name': item.name,
                  'img': item.img,
                  'category': item.category,
                },
              )
              .toList(),
        ),
      );
      return object;
    }
    final materialId = existingId?.trim().isNotEmpty == true
        ? existingId!.trim()
        : 'benda_${name.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}';
    final entity = await _materialRepository.upsertMaterial(
      materialId: materialId,
      category: LearningCategories.benda,
      title: name,
      imagePath: imagePath,
      subcategory: category,
    );
    return LearningObject(
      entity.title,
      entity.imagePath,
      entity.subcategory,
      entity.materialId,
    );
  }

  Future<void> removeObject(LearningObject item) async {
    await ensureReady();
    if (kIsWeb) {
      final objects = await loadObjects();
      objects.removeWhere(
        (object) => object.id == item.id || object.name == item.name,
      );
      await _webPrefs!.setString(
        _webObjectsKey,
        jsonEncode(
          objects
              .map(
                (object) => {
                  'id': object.id,
                  'name': object.name,
                  'img': object.img,
                  'category': object.category,
                },
              )
              .toList(),
        ),
      );
      return;
    }
    if (item.id.isNotEmpty) {
      await _materialRepository.deleteMaterialById(item.id);
      return;
    }
    final objects = await _materialRepository.loadByCategory(
      LearningCategories.benda,
    );
    LearningMaterialEntity? match;
    for (final entity in objects) {
      if (entity.title == item.name) {
        match = entity;
        break;
      }
    }
    if (match != null) {
      await _materialRepository.deleteMaterialById(match.materialId);
    }
  }

  Future<Set<String>> loadFavoriteIds(String username) async {
    await ensureReady();
    if (kIsWeb) {
      return _webLoadAccount(username)?.favoriteMaterialIds.toSet() ??
          <String>{};
    }
    return (await _userRepository.favoriteIds(username)).toSet();
  }

  Future<void> saveFavoriteIds(String username, Set<String> ids) async {
    await ensureReady();
    if (kIsWeb) {
      final account = _webLoadAccount(username);
      if (account == null) return;
      await _webSaveAccount(
        UserAccount(
          username: account.username,
          childName: account.childName,
          gender: account.gender,
          role: account.role,
          themeId: account.themeId,
          stars: account.stars,
          iqraStreak: account.iqraStreak,
          progress: account.progress,
          iqraMastered: account.iqraMastered,
          iqraHistory: account.iqraHistory,
          hurfMastered: account.hurfMastered,
          angkaMastered: account.angkaMastered,
          bendaMastered: account.bendaMastered,
          favoriteMaterialIds: ids.toList(),
          avatarPath: account.avatarPath,
          createdAt: account.createdAt,
        ),
      );
      return;
    }
    await _userRepository.saveFavoriteIds(username, ids);
    await _materialRepository.setFavoriteState(ids);
  }

  Future<int> countAccounts() async {
    await ensureReady();
    if (kIsWeb) {
      return _webPrefs!
          .getKeys()
          .where((key) => key.startsWith('web.account.'))
          .length;
    }
    return _userRepository.countAccounts();
  }

  Future<List<String>> checkNewUnlocks({
    required String username,
    required Map<String, int> progress,
  }) async {
    await ensureReady();
    if (kIsWeb) {
      final already = await savedUnlocks(username);
      final now = <String>[];
      for (final badge in badgeDefinitions) {
        if (_badgeCurrentProgress(badge, progress) >= badge.requiredProgress &&
            !already.contains(badge.id)) {
          now.add(badge.id);
        }
      }
      if (now.isNotEmpty) {
        await _webPrefs!.setStringList(_webBadgesKey(username), [
          ...already,
          ...now,
        ]);
      }
      return now;
    }
    return _badgeRepository.syncUnlocks(username: username, progress: progress);
  }

  Future<Set<String>> savedUnlocks(String username) async {
    await ensureReady();
    if (kIsWeb) {
      return (_webPrefs!.getStringList(_webBadgesKey(username)) ?? const [])
          .toSet();
    }
    return _badgeRepository.savedUnlocks(username);
  }

  Future<void> addHistory({
    required String username,
    required LearningHistoryRecord record,
  }) async {
    await ensureReady();
    if (kIsWeb) {
      final items =
          _webPrefs!.getStringList(_webHistoryKey(username)) ?? <String>[];
      items.insert(
        0,
        jsonEncode({
          'materialId': record.materialId,
          'category': record.category,
          'duration': record.duration,
          'score': record.score,
          'playedAt': record.playedAt.toIso8601String(),
        }),
      );
      await _webPrefs!.setStringList(
        _webHistoryKey(username),
        items.take(100).toList(),
      );
      return;
    }
    await _historyRepository.addRecord(username, record);
  }

  Future<List<LearningHistoryRecord>> loadHistory(
    String username, {
    int limit = 100,
  }) async {
    await ensureReady();
    if (kIsWeb) {
      final items =
          _webPrefs!.getStringList(_webHistoryKey(username)) ?? const [];
      return items.take(limit).map((raw) {
        final map = Map<String, dynamic>.from(jsonDecode(raw) as Map);
        return LearningHistoryRecord(
          materialId: map['materialId'] as String? ?? '',
          category: map['category'] as String? ?? 'huruf',
          duration: (map['duration'] as num?)?.toInt() ?? 0,
          score: (map['score'] as num?)?.toInt() ?? 0,
          playedAt:
              DateTime.tryParse(map['playedAt'] as String? ?? '') ??
              DateTime.now(),
        );
      }).toList();
    }
    return _historyRepository.loadRecords(username, limit: limit);
  }

  Future<String> saveImageBytes({
    required Uint8List bytes,
    required String fileName,
    StorageBucket bucket = StorageBucket.bendaImages,
  }) {
    return _storageService.saveBytes(
      bytes: bytes,
      bucket: bucket,
      fileName: fileName,
    );
  }

  Future<String> saveAudioBytes({
    required Uint8List bytes,
    required String fileName,
    StorageBucket bucket = StorageBucket.iqraAudio,
  }) {
    return _storageService.saveBytes(
      bytes: bytes,
      bucket: bucket,
      fileName: fileName,
    );
  }

  Future<String> saveVideoBytes({
    required Uint8List bytes,
    required String fileName,
  }) {
    return _storageService.saveBytes(
      bytes: bytes,
      bucket: StorageBucket.songVideos,
      fileName: fileName,
    );
  }

  Future<void> deleteFile(String path) => _storageService.deleteFile(path);

  UserAccount? _webLoadAccount(String username) {
    final raw = _webPrefs?.getString(_webAccountKey(username));
    if (raw == null || raw.isEmpty) return null;
    final map = Map<String, dynamic>.from(jsonDecode(raw) as Map);
    return UserAccount(
      username: map['username'] as String,
      childName: map['childName'] as String? ?? 'Teman',
      gender: _parseGender(map['gender'] as String? ?? 'boy'),
      role: _parseRole(map['role'] as String? ?? 'child'),
      themeId: map['themeId'] as String? ?? 'default',
      stars: (map['stars'] as num?)?.toInt() ?? 12,
      iqraStreak: (map['iqraStreak'] as num?)?.toInt() ?? 0,
      progress: {
        for (final entry
            in (map['progress'] as Map<String, dynamic>? ?? const {}).entries)
          entry.key: (entry.value as num).toInt(),
      },
      iqraMastered: List<String>.from(map['iqraMastered'] as List? ?? const []),
      iqraHistory: List<String>.from(map['iqraHistory'] as List? ?? const []),
      hurfMastered: List<String>.from(map['hurfMastered'] as List? ?? const []),
      angkaMastered: List<String>.from(
        map['angkaMastered'] as List? ?? const [],
      ),
      bendaMastered: List<String>.from(
        map['bendaMastered'] as List? ?? const [],
      ),
      favoriteMaterialIds: List<String>.from(
        map['favoriteMaterialIds'] as List? ?? const [],
      ),
      avatarPath: map['avatarPath'] as String? ?? '',
      createdAt: map['createdAt'] == null
          ? null
          : DateTime.tryParse(map['createdAt'] as String),
    );
  }

  Future<void> _webSaveAccount(UserAccount account) {
    return _webPrefs!.setString(
      _webAccountKey(account.username),
      jsonEncode({
        'username': account.username,
        'childName': account.childName,
        'gender': _enumName(account.gender, fallback: 'boy'),
        'role': _enumName(account.role, fallback: 'child'),
        'themeId': account.themeId,
        'stars': account.stars,
        'iqraStreak': account.iqraStreak,
        'progress': account.progress,
        'iqraMastered': account.iqraMastered,
        'iqraHistory': account.iqraHistory,
        'hurfMastered': account.hurfMastered,
        'angkaMastered': account.angkaMastered,
        'bendaMastered': account.bendaMastered,
        'favoriteMaterialIds': account.favoriteMaterialIds,
        'avatarPath': account.avatarPath,
        'createdAt': (account.createdAt ?? DateTime.now()).toIso8601String(),
      }),
    );
  }

  int _badgeCurrentProgress(BadgeData badge, Map<String, int> progress) {
    if (badge.progressKey == '_all_') {
      final vals = [
        'membaca',
        'angka',
        'benda',
        'iqra',
      ].map((key) => progress[key] ?? 0).toList();
      if (vals.isEmpty) return 0;
      return (vals.reduce((a, b) => a + b) / vals.length).round();
    }
    return progress[badge.progressKey] ?? 0;
  }

  UserAccount _withProgress(UserAccount account, Map<String, int> progress) {
    return UserAccount(
      username: account.username,
      childName: account.childName,
      gender: account.gender,
      role: account.role,
      themeId: account.themeId,
      stars: account.stars,
      iqraStreak: account.iqraStreak,
      progress: progress,
      iqraMastered: account.iqraMastered,
      iqraHistory: account.iqraHistory,
      hurfMastered: account.hurfMastered,
      angkaMastered: account.angkaMastered,
      bendaMastered: account.bendaMastered,
      favoriteMaterialIds: account.favoriteMaterialIds,
      avatarPath: account.avatarPath,
      createdAt: account.createdAt,
    );
  }

  String _themeOwner(String? username) {
    final value = username?.trim();
    if (value == null || value.isEmpty) return 'guest';
    return value.toLowerCase();
  }

  Gender _parseGender(String value) =>
      value == 'girl' ? Gender.girl : Gender.boy;

  Role _parseRole(String value) {
    final role = value.trim().toLowerCase();
    return role == 'teacher' || role == 'pengajar' || role == 'guru'
        ? Role.teacher
        : Role.child;
  }

  String _enumName(dynamic value, {required String fallback}) {
    if (value == null) return fallback;
    if (value is Gender) return value == Gender.girl ? 'girl' : 'boy';
    if (value is Role) return value == Role.teacher ? 'teacher' : 'child';
    try {
      final dynamicValue = value as dynamic;
      final name = dynamicValue.name;
      if (name is String && name.isNotEmpty) return name;
    } catch (_) {}
    final text = value.toString();
    if (text.contains('.')) {
      final last = text.split('.').last.trim();
      if (last.isNotEmpty) return last;
    }
    return text.trim().isEmpty ? fallback : text.trim();
  }

  String _hashPassword(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  String _normalizeLetterTitle(String value) {
    final text = value.trim();
    return text.replaceFirst(RegExp(r'^huruf\s+', caseSensitive: false), '');
  }

  String _normalizeNumberTitle(String value) {
    final text = value.trim();
    return text.replaceFirst(RegExp(r'^angka\s+', caseSensitive: false), '');
  }

  String _normalizeNumberSubtitle(
    String value, {
    required String fallbackNumber,
  }) {
    final cleaned = value.trim().replaceFirst(
      RegExp(r'^angka\s+', caseSensitive: false),
      '',
    );
    if (cleaned.isNotEmpty && cleaned != fallbackNumber) {
      return cleaned;
    }
    return switch (fallbackNumber) {
      '1' => 'Satu',
      '2' => 'Dua',
      '3' => 'Tiga',
      '4' => 'Empat',
      '5' => 'Lima',
      '6' => 'Enam',
      '7' => 'Tujuh',
      '8' => 'Delapan',
      '9' => 'Sembilan',
      '10' => 'Sepuluh',
      _ => fallbackNumber,
    };
  }

  int _compareIqraItems(IqraItem a, IqraItem b) {
    final orderBySymbol = {
      for (var i = 0; i < DefaultLearningCatalog.iqraPairs.length; i++)
        DefaultLearningCatalog.iqraPairs[i]['symbol']!: i,
    };
    final orderByLabel = {
      for (var i = 0; i < DefaultLearningCatalog.iqraPairs.length; i++)
        '${DefaultLearningCatalog.iqraPairs[i]['symbol']}:${DefaultLearningCatalog.iqraPairs[i]['label']!.toLowerCase()}':
            i,
    };
    final aIndex =
        orderBySymbol[a.char] ??
        orderByLabel['${a.char}:${a.latin.toLowerCase()}'] ??
        999;
    final bIndex =
        orderBySymbol[b.char] ??
        orderByLabel['${b.char}:${b.latin.toLowerCase()}'] ??
        999;
    if (aIndex != bIndex) return aIndex.compareTo(bIndex);
    return a.latin.toLowerCase().compareTo(b.latin.toLowerCase());
  }

  String _webAccountKey(String username) =>
      'web.account.${username.toLowerCase().trim()}';
  String _webPasswordKey(String username) =>
      'web.password.${username.toLowerCase().trim()}';
  String _webBadgesKey(String username) =>
      'web.badges.${username.toLowerCase().trim()}';
  String _webHistoryKey(String username) =>
      'web.history.${username.toLowerCase().trim()}';
  String _webThemeKey(String ownerUsername) => 'web.theme.$ownerUsername';

  static const _webCurrentUserKey = 'web.current_user';
  static const _webSongsKey = 'web.songs';
  static const _webObjectsKey = 'web.objects';
  static const _webLettersKey = 'web.letters';
  static const _webNumbersKey = 'web.numbers';
}
