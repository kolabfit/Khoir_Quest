// ignore_for_file: unused_element, unused_field, unused_element_parameter

part of '../main.dart';

enum _TeacherSection {
  dashboard,
  huruf,
  merangkaiAbjad,
  merangkaiKata,
  angka,
  benda,
  lagu,
}

enum _TeacherCategory { huruf, angka, benda, lagu }

const _fixedObjectCategories = <String>[
  'Hewan',
  'Buah',
  'Sayur',
  'Makanan',
  'Minuman',
  'Kendaraan',
  'Alat Tulis',
  'Mainan',
  'Pakaian',
  'Anggota Tubuh',
  'Perabot Rumah',
  'Peralatan Dapur',
  'Alat Musik',
  'Benda Sekolah',
  'Alam',
  'Warna',
];

const _fixedLatinLetters = <String>[
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
];

extension on _TeacherCategory {
  String get label => switch (this) {
    _TeacherCategory.huruf => 'Abjad',
    _TeacherCategory.angka => 'Bilangan',
    _TeacherCategory.benda => 'Benda',
    _TeacherCategory.lagu => 'Lagu Anak',
  };

  String get emptyLabel => switch (this) {
    _TeacherCategory.huruf => 'Belum ada data abjad yang siap ditampilkan.',
    _TeacherCategory.angka => 'Belum ada data bilangan yang siap ditampilkan.',
    _TeacherCategory.benda => 'Belum ada benda yang tersimpan.',
    _TeacherCategory.lagu => 'Belum ada lagu anak yang tersimpan.',
  };

  IconData get icon => switch (this) {
    _TeacherCategory.huruf => Icons.sort_by_alpha_rounded,
    _TeacherCategory.angka => Icons.numbers_rounded,
    _TeacherCategory.benda => Icons.category_rounded,
    _TeacherCategory.lagu => Icons.music_note_rounded,
  };

  Color get color => switch (this) {
    _TeacherCategory.huruf => const Color(0xff8B5CF6),
    _TeacherCategory.angka => const Color(0xff38BDF8),
    _TeacherCategory.benda => const Color(0xff34D399),
    _TeacherCategory.lagu => const Color(0xffFB923C),
  };

  Color get lightColor => switch (this) {
    _TeacherCategory.huruf => const Color(0xffF3EEFF),
    _TeacherCategory.angka => const Color(0xffEAF8FF),
    _TeacherCategory.benda => const Color(0xffEBFFF6),
    _TeacherCategory.lagu => const Color(0xffFFF3E7),
  };

  String get asset => switch (this) {
    _TeacherCategory.huruf => 'assets/images/Belajar_huruf.png',
    _TeacherCategory.angka => 'assets/images/Belajar_Angka.png',
    _TeacherCategory.benda => 'assets/images/Belajar_Benda.png',
    _TeacherCategory.lagu => 'assets/images/Bernyanyi.png',
  };
}

extension on _TeacherSection {
  String get label => switch (this) {
    _TeacherSection.dashboard => 'Dashboard',
    _TeacherSection.huruf => 'Daftar Abjad',
    _TeacherSection.merangkaiAbjad => 'Merangkai Abjad',
    _TeacherSection.merangkaiKata => 'Merangkai Kata',
    _TeacherSection.angka => 'Bilangan',
    _TeacherSection.benda => 'Benda',
    _TeacherSection.lagu => 'Lagu Anak',
  };

  IconData get icon => switch (this) {
    _TeacherSection.dashboard => Icons.grid_view_rounded,
    _TeacherSection.huruf => Icons.sort_by_alpha_rounded,
    _TeacherSection.merangkaiAbjad => Icons.join_inner_rounded,
    _TeacherSection.merangkaiKata => Icons.extension_rounded,
    _TeacherSection.angka => Icons.numbers_rounded,
    _TeacherSection.benda => Icons.category_rounded,
    _TeacherSection.lagu => Icons.music_note_rounded,
  };

  Color get color => switch (this) {
    _TeacherSection.dashboard => const Color(0xff7C3AED),
    _TeacherSection.huruf => _TeacherCategory.huruf.color,
    _TeacherSection.merangkaiAbjad => const Color(0xffF97316),
    _TeacherSection.merangkaiKata => const Color(0xffEC4899),
    _TeacherSection.angka => _TeacherCategory.angka.color,
    _TeacherSection.benda => _TeacherCategory.benda.color,
    _TeacherSection.lagu => _TeacherCategory.lagu.color,
  };

  _TeacherCategory? get category => switch (this) {
    _TeacherSection.huruf => _TeacherCategory.huruf,
    _TeacherSection.merangkaiAbjad => _TeacherCategory.huruf,
    _TeacherSection.merangkaiKata => _TeacherCategory.huruf,
    _TeacherSection.angka => _TeacherCategory.angka,
    _TeacherSection.benda => _TeacherCategory.benda,
    _TeacherSection.lagu => _TeacherCategory.lagu,
    _ => null,
  };
}

class TeacherDashboard extends ConsumerStatefulWidget {
  const TeacherDashboard({super.key});

  @override
  ConsumerState<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends ConsumerState<TeacherDashboard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _TeacherSection _section = _TeacherSection.dashboard;
  _TeacherCategory _category = _TeacherCategory.benda;
  String _selectedFilter = 'Semua';
  String _sortMode = 'Terbaru';
  bool _sidebarCollapsed = false;
  Future<_TeacherStorageData>? _storageFuture;
  final List<_TeacherActivity> _activities = [];
  final List<_LetterBlendItem> _letterBlends = [];
  final List<_WordAssemblyItem> _wordAssemblies = [];
  late final RangkaiItemRepository _rangkaiRepository = RangkaiItemRepository(
    SupabaseService.instance,
  );
  Future<int>? _databaseUserCountFuture;
  final AudioPlayer _songPreviewPlayer = AudioPlayer();
  StreamSubscription<PlayerState>? _songPreviewSub;
  String? _previewSongId;
  bool _previewPlaying = false;
  bool _previewLoading = false;

  @override
  void initState() {
    super.initState();
    _databaseUserCountFuture = _countDatabaseUsers();
    unawaited(_loadAbjadTools());
    _songPreviewSub = _songPreviewPlayer.playerStateStream.listen((state) {
      if (!mounted) return;
      final completed = state.processingState == ProcessingState.completed;
      if (completed) unawaited(_songPreviewPlayer.stop());
      setState(() {
        _previewPlaying = completed ? false : state.playing;
        _previewLoading =
            state.processingState == ProcessingState.loading ||
            state.processingState == ProcessingState.buffering;
        if (completed) _previewSongId = null;
      });
    });
  }

  Future<void> _loadAbjadTools() async {
    final prefs = await SharedPreferences.getInstance();
    final blendsRaw = prefs.getString(_letterBlendsPrefsKey);
    final wordsRaw = prefs.getString(_wordAssembliesPrefsKey);
    final cachedBlends = _decodeLetterBlends(blendsRaw);
    final cachedWords = _decodeWordAssemblies(wordsRaw);
    if (!mounted) return;
    setState(() {
      _letterBlends
        ..clear()
        ..addAll(cachedBlends);
      _wordAssemblies
        ..clear()
        ..addAll(cachedWords);
    });
    if (!SupabaseService.instance.isConfigured) return;
    try {
      await SupabaseService.instance.ensureInitialized();
      final remoteItems = await _rangkaiRepository.fetchAll();
      final remoteBlends = remoteItems
          .where((item) => item.type == 'suku_kata' || item.type == 'abjad')
          .map(_LetterBlendItem.fromModel)
          .where((item) => item.letters.length == 2)
          .toList();
      final remoteWords = remoteItems
          .where((item) => item.type == 'kata')
          .map(_WordAssemblyItem.fromModel)
          .where((item) => item.units.isNotEmpty)
          .toList();
      if (!mounted) return;
      setState(() {
        _letterBlends
          ..clear()
          ..addAll(remoteBlends);
        _wordAssemblies
          ..clear()
          ..addAll(remoteWords);
      });
      if (remoteItems.isEmpty &&
          (cachedBlends.isNotEmpty || cachedWords.isNotEmpty)) {
        for (final item in cachedBlends) {
          await _rangkaiRepository.upsertItem(item.toModel());
        }
        for (final item in cachedWords) {
          await _rangkaiRepository.upsertItem(item.toModel());
        }
      }
      await _saveAbjadTools();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Data merangkai memakai cache lokal. Supabase gagal dimuat.',
          ),
        ),
      );
    }
  }

  Future<void> _saveAbjadTools() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _letterBlendsPrefsKey,
      jsonEncode(_letterBlends.map((item) => item.toJson()).toList()),
    );
    await prefs.setString(
      _wordAssembliesPrefsKey,
      jsonEncode(_wordAssemblies.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> _syncRangkaiItem(RangkaiItemModel item) async {
    await _saveAbjadTools();
    if (!SupabaseService.instance.isConfigured) return;
    await SupabaseService.instance.ensureInitialized();
    await _rangkaiRepository.upsertItem(item);
  }

  Future<void> _deleteRangkaiItem(String id) async {
    await _saveAbjadTools();
    if (!SupabaseService.instance.isConfigured) return;
    await SupabaseService.instance.ensureInitialized();
    await _rangkaiRepository.deleteItem(id);
  }

  void _showRangkaiSyncError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tersimpan lokal, tetapi sinkron Supabase gagal.'),
      ),
    );
  }

  @override
  void dispose() {
    _songPreviewSub?.cancel();
    _songPreviewPlayer.dispose();
    super.dispose();
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .22),
      builder: (_) => const _TeacherLogoutDialog(),
    );
    if (confirmed == true && mounted) {
      await ref.read(appStateProvider).logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 720;
    final tablet = width >= 720 && width < 1180;
    final desktop = width >= 1180;
    final activeCategory = _section.category ?? _category;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xffF7F6FF),
      drawer: mobile
          ? Drawer(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
                  child: _TeacherSidebar(
                    app: app,
                    section: _section,
                    collapsed: false,
                    onToggleCollapse: null,
                    onSelected: (section) {
                      Navigator.of(context).pop();
                      _selectSection(section);
                    },
                    onSync: () {
                      Navigator.of(context).pop();
                      _syncDashboard();
                    },
                    onLogout: () {
                      Navigator.of(context).pop();
                      _confirmLogout();
                    },
                  ),
                ),
              ),
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFCFBFF), Color(0xffF5F4FF), Color(0xffEFF8FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (!mobile)
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 0, 18),
                  child: _TeacherSidebar(
                    app: app,
                    section: _section,
                    collapsed: _sidebarCollapsed,
                    onToggleCollapse: () =>
                        setState(() => _sidebarCollapsed = !_sidebarCollapsed),
                    onSelected: _selectSection,
                    onSync: _syncDashboard,
                    onLogout: _confirmLogout,
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    _TeacherTopbar(
                      app: app,
                      mobile: mobile,
                      activeCategory: activeCategory,
                      onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                      onCollapseTap: mobile
                          ? null
                          : () => setState(
                              () => _sidebarCollapsed = !_sidebarCollapsed,
                            ),
                      onQuickUpload: () => _openUploadDialog(activeCategory),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          mobile ? 16 : 20,
                          6,
                          mobile ? 16 : 24,
                          24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_section == _TeacherSection.dashboard ||
                                _section.category != null)
                              _buildSummarySection(
                                app: app,
                                mobile: mobile,
                                desktop: desktop,
                              ),
                            if (_section == _TeacherSection.dashboard ||
                                _section.category != null) ...[
                              const SizedBox(height: 18),
                              _buildContentSection(
                                app: app,
                                activeCategory: activeCategory,
                                mobile: mobile,
                                tablet: tablet,
                                desktop: desktop,
                              ),
                            ] else
                              ...[],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: mobile && activeCategory != _TeacherCategory.huruf
          ? FloatingActionButton.extended(
              onPressed: () => _openUploadDialog(activeCategory),
              backgroundColor: activeCategory.color,
              foregroundColor: Colors.white,
              elevation: 10,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Upload',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            )
          : null,
    );
  }

  void _selectSection(_TeacherSection section) {
    setState(() {
      _section = section;
      final category = section.category;
      if (category != null) {
        _category = category;
        _selectedFilter = 'Semua';
      }
    });
  }

  Future<void> _toggleSongPreview(SongItem song) async {
    final source = song.videoUrl.trim();
    if (source.isEmpty) return;
    if (song.mediaType == 'youtube' || MediaSourceHelper.isYoutubeUrl(source)) {
      await _songPreviewPlayer.stop();
      if (!mounted) return;
      setState(() {
        _previewSongId = null;
        _previewLoading = false;
        _previewPlaying = false;
      });
      await _showYoutubePreview(song);
      return;
    }
    try {
      if (_previewSongId == song.id) {
        if (_previewPlaying) {
          await _songPreviewPlayer.pause();
        } else {
          await _songPreviewPlayer.play();
        }
        return;
      }
      setState(() {
        _previewSongId = song.id;
        _previewLoading = true;
        _previewPlaying = false;
      });
      await _songPreviewPlayer.stop();
      await _prepareSongSource(
        _songPreviewPlayer,
        source,
        tempFilePrefix: 'teacher_preview_song',
      );
      if (!mounted || _previewSongId != song.id) return;
      await _songPreviewPlayer.play();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _previewSongId = null;
        _previewLoading = false;
        _previewPlaying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preview lagu tidak bisa diputar.')),
      );
    }
  }

  Future<void> _showYoutubePreview(SongItem song) async {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .26),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: _TeacherSurfaceCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _TeacherCategory.lagu.color.withValues(
                          alpha: .12,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.play_circle_fill_rounded,
                        color: _TeacherCategory.lagu.color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff2F2966),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppYoutubeEmbedPlayer(url: song.videoUrl, borderRadius: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<int> _countDatabaseUsers() async {
    try {
      return await AuthService.instance.countDatabaseUsers();
    } catch (_) {}
    return 0;
  }

  Future<void> _syncDashboard({bool silent = false}) async {
    final appState = ref.read(appStateProvider);
    await appState.syncCloudContent(silent: silent);
    if (!mounted) return;
    setState(() {
      _databaseUserCountFuture = _countDatabaseUsers();
      _storageFuture = _loadStorage();
    });
  }

  List<_TeacherContentData> _itemsForCategory(
    AppState app,
    _TeacherCategory category,
  ) {
    return switch (category) {
      _TeacherCategory.huruf =>
        _fixedLatinLetters
            .map(
              (letter) => _TeacherContentData(
                id: 'fixed_letter_$letter',
                title: _letterPair(letter),
                subtitle: '',
                category: 'Abjad',
                statusLabel: 'Bawaan',
                mediaPath: '',
                color: category.color,
                icon: category.icon,
                badgeText: '',
                actionLabel: 'Bawaan aplikasi',
                editable: false,
              ),
            )
            .toList(),
      _TeacherCategory.angka =>
        app.numbers
            .map(
              (item) => _TeacherContentData(
                id: item.id.isEmpty ? item.number : item.id,
                title: item.number,
                subtitle: item.name,
                category: 'Bilangan',
                statusLabel: 'Aktif',
                mediaPath: item.img,
                color: category.color,
                icon: category.icon,
                badgeText: '',
                actionLabel: 'Edit Gambar',
                editable: true,
                number: item,
              ),
            )
            .toList(),
      _TeacherCategory.benda =>
        app.objects
            .map(
              (item) => _TeacherContentData(
                id: item.id.isEmpty ? item.name : item.id,
                title: item.name,
                subtitle: item.category,
                category: 'Benda',
                statusLabel: 'Aktif',
                mediaPath: item.img,
                color: category.color,
                icon: category.icon,
                badgeText: item.category,
                actionLabel: MediaSourceHelper.isLocalFilePath(item.img)
                    ? 'Siap Upload'
                    : 'Cloud',
                editable: true,
                object: item,
              ),
            )
            .toList(),
      _TeacherCategory.lagu => app.songs.map((item) {
        return _TeacherContentData(
          id: item.id,
          title: item.title,
          subtitle: item.fileName ?? 'Video lagu',
          category: 'Lagu Anak',
          statusLabel: 'Aktif',
          mediaPath: DefaultLearningCatalog.laguPlaceholderAsset,
          color: category.color,
          icon: category.icon,
          badgeText: 'Video',
          actionLabel: item.fileName ?? 'Lagu',
          editable: true,
          song: item,
        );
      }).toList(),
    };
  }

  List<_TeacherContentData> _filteredItems(
    AppState app,
    _TeacherCategory category,
  ) {
    final items = _itemsForCategory(app, category).where((item) {
      final matchesFilter =
          _selectedFilter == 'Semua' ||
          item.badgeText.toLowerCase() == _selectedFilter.toLowerCase();
      return matchesFilter;
    }).toList();

    switch (_sortMode) {
      case 'A-Z':
        items.sort((a, b) => a.title.compareTo(b.title));
      case 'Kategori':
        items.sort((a, b) => a.badgeText.compareTo(b.badgeText));
      default:
        break;
    }
    return items;
  }

  List<String> _filterOptionsForCategory(
    AppState app,
    _TeacherCategory category,
  ) {
    final values =
        _itemsForCategory(app, category)
            .map((item) => item.badgeText)
            .where((value) => value.trim().isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return ['Semua', ...values];
  }

  Widget _buildSummarySection({
    required AppState app,
    required bool mobile,
    required bool desktop,
  }) {
    final stats = [
      _TeacherSummaryCardData(
        title: 'Total Konten',
        value:
            '${_fixedLatinLetters.length + _letterBlends.length + _wordAssemblies.length + app.numbers.length + app.objects.length + app.songs.length}',
        subtitle: 'Abjad, rangkaian, kata, bilangan, benda, lagu',
        icon: Icons.dashboard_customize_rounded,
        color: const Color(0xff8B5CF6),
        background: const [Color(0xffF3ECFF), Color(0xffFFF7FF)],
      ),
      _TeacherSummaryCardData(
        title: 'Abjad Aktif',
        value: '${_fixedLatinLetters.length}',
        subtitle:
            '${_letterBlends.length} rangkaian, ${_wordAssemblies.length} kata',
        icon: Icons.sort_by_alpha_rounded,
        color: const Color(0xffA855F7),
        background: const [Color(0xffF4ECFF), Color(0xffF8F4FF)],
      ),
      _TeacherSummaryCardData(
        title: 'Bilangan Aktif',
        value: '${app.numbers.length}',
        subtitle: 'Materi berhitung dasar',
        icon: Icons.numbers_rounded,
        color: const Color(0xff38BDF8),
        background: const [Color(0xffEAF9FF), Color(0xffF5FCFF)],
      ),
      _TeacherSummaryCardData(
        title: 'Benda Aktif',
        value: '${app.objects.length}',
        subtitle: 'Materi mengenal benda',
        icon: Icons.category_rounded,
        color: const Color(0xff34D399),
        background: const [Color(0xffECFFF6), Color(0xffF6FFFB)],
      ),
      _TeacherSummaryCardData(
        title: 'Lagu Anak',
        value: '${app.songs.length}',
        subtitle: 'Materi lagu anak',
        icon: Icons.music_video_rounded,
        color: const Color(0xffFB923C),
        background: const [Color(0xffFFF1E8), Color(0xffFFF8F1)],
      ),
      _TeacherSummaryCardData(
        title: 'Total User',
        valueFuture: _databaseUserCountFuture,
        subtitle: 'Akun terdaftar',
        icon: Icons.groups_rounded,
        color: const Color(0xffFBBF24),
        background: const [Color(0xffFFF9E7), Color(0xffFFFDF3)],
      ),
    ];

    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TeacherSectionTitle(
            title: 'Ringkasan Dashboard',
            subtitle: 'Pantau status konten utama secara cepat.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 164,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: stats.length,
              separatorBuilder: (_, index) => const SizedBox(width: 12),
              itemBuilder: (_, i) => SizedBox(
                width: 230,
                child: _TeacherSummaryCard(data: stats[i]),
              ),
            ),
          ),
        ],
      );
    }

    final columns = desktop ? 3 : 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TeacherSectionTitle(
          title: 'Ringkasan Dashboard',
          subtitle: 'Pantau status konten utama secara cepat.',
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: desktop ? 2.25 : 1.62,
          ),
          itemCount: stats.length,
          itemBuilder: (_, i) => _TeacherSummaryCard(data: stats[i]),
        ),
      ],
    );
  }

  Widget _buildContentSection({
    required AppState app,
    required _TeacherCategory activeCategory,
    required bool mobile,
    required bool tablet,
    required bool desktop,
  }) {
    if (_section == _TeacherSection.merangkaiAbjad) {
      return _buildLetterBlendSection(mobile: mobile, desktop: desktop);
    }
    if (_section == _TeacherSection.merangkaiKata) {
      return _buildWordAssemblySection(mobile: mobile, desktop: desktop);
    }
    final screenWidth = MediaQuery.sizeOf(context).width;
    final filters = _filterOptionsForCategory(app, activeCategory);
    if (!filters.contains(_selectedFilter)) {
      _selectedFilter = 'Semua';
    }
    final items = _filteredItems(app, activeCategory);
    final columns = desktop
        ? 5
        : tablet
        ? 2
        : screenWidth < 430
        ? 1
        : 2;

    return _TeacherSurfaceCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _TeacherSectionTitle(
                  title: 'Kelola Konten Pembelajaran',
                  subtitle:
                      'Fokus pada materi inti yang sudah aktif di Khoir Quest.',
                ),
              ),
              if (!mobile && activeCategory != _TeacherCategory.huruf)
                FilledButton.icon(
                  onPressed: () => _openUploadDialog(activeCategory),
                  style: FilledButton.styleFrom(
                    backgroundColor: activeCategory.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Tambah Konten'),
                ),
            ],
          ),
          const SizedBox(height: 18),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _TeacherCategory.values.map((category) {
                final selected = category == activeCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _TeacherCategoryChip(
                    category: category,
                    selected: selected,
                    onTap: () {
                      setState(() {
                        _category = category;
                        if (_section != _TeacherSection.dashboard) {
                          _section = switch (category) {
                            _TeacherCategory.huruf => _TeacherSection.huruf,
                            _TeacherCategory.angka => _TeacherSection.angka,
                            _TeacherCategory.benda => _TeacherSection.benda,
                            _TeacherCategory.lagu => _TeacherSection.lagu,
                          };
                        }
                        _selectedFilter = 'Semua';
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _TeacherDropdownField(
                label: _selectedFilter,
                icon: Icons.tune_rounded,
                items: filters,
                onSelected: (value) => setState(() => _selectedFilter = value),
              ),
              _TeacherDropdownField(
                label: _sortMode,
                icon: Icons.swap_vert_rounded,
                items: const ['Terbaru', 'A-Z', 'Kategori'],
                onSelected: (value) => setState(() => _sortMode = value),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (items.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: const Color(0xffFCFBFF),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xffE8E2FF)),
              ),
              child: Column(
                children: [
                  Icon(
                    activeCategory.icon,
                    size: 48,
                    color: activeCategory.color,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    activeCategory.emptyLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Color(0xff322A64),
                    ),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                mainAxisExtent: desktop
                    ? 490
                    : tablet
                    ? 470
                    : columns == 1
                    ? 520
                    : 450,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) =>
                  _TeacherContentCard(
                    item: items[i],
                    onUpload: items[i].editable
                        ? () => _openUploadDialog(
                            activeCategory,
                            existing: items[i],
                          )
                        : null,
                    onDelete: items[i].editable
                        ? () => _deleteContent(items[i])
                        : null,
                    onReadOnlyTap: () => _showReadOnlyMessage(activeCategory),
                    previewActive: _previewSongId == items[i].song?.id,
                    previewPlaying:
                        _previewSongId == items[i].song?.id && _previewPlaying,
                    previewLoading:
                        _previewSongId == items[i].song?.id && _previewLoading,
                    onPreview: items[i].song == null
                        ? null
                        : () => _toggleSongPreview(items[i].song!),
                  ).animate().fadeIn(
                    duration: 260.ms,
                    delay: Duration(milliseconds: i * 35),
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildLetterBlendSection({
    required bool mobile,
    required bool desktop,
  }) {
    final columns = desktop
        ? 4
        : mobile
        ? 1
        : 2;
    return _TeacherSurfaceCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TeacherToolHeader(
            title: 'Merangkai Abjad',
            subtitle: 'Gabungkan dua abjad dasar menjadi rangkaian seperti AN.',
            icon: Icons.join_inner_rounded,
            color: _TeacherSection.merangkaiAbjad.color,
            actionLabel: 'Tambah Rangkaian',
            onAction: _openLetterBlendDialog,
          ),
          const SizedBox(height: 18),
          if (_letterBlends.isEmpty)
            _TeacherEmptyTool(
              icon: Icons.join_inner_rounded,
              color: _TeacherSection.merangkaiAbjad.color,
              text:
                  'Belum ada rangkaian abjad. Pilih dua kartu abjad untuk membuat rangkaian pertama.',
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                mainAxisExtent: 270,
              ),
              itemCount: _letterBlends.length,
              itemBuilder: (_, i) {
                final item = _letterBlends[i];
                final usedBy = _wordsUsingBlend(item.label);
                return _TeacherBlendCard(
                  item: item,
                  usedCount: usedBy.length,
                  onEdit: () => _openLetterBlendDialog(existing: item),
                  onPreview: () => _showBlendPreview(item),
                  onDelete: () => _deleteLetterBlend(item),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildWordAssemblySection({
    required bool mobile,
    required bool desktop,
  }) {
    final columns = desktop
        ? 3
        : mobile
        ? 1
        : 2;
    return _TeacherSurfaceCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TeacherToolHeader(
            title: 'Merangkai Kata',
            subtitle:
                'Susun abjad dasar dan rangkaian abjad menjadi satu kata.',
            icon: Icons.extension_rounded,
            color: _TeacherSection.merangkaiKata.color,
            actionLabel: 'Tambah Kata',
            onAction: _openWordAssemblyDialog,
          ),
          const SizedBox(height: 18),
          if (_wordAssemblies.isEmpty)
            _TeacherEmptyTool(
              icon: Icons.extension_rounded,
              color: _TeacherSection.merangkaiKata.color,
              text:
                  'Belum ada latihan kata. Buat dari abjad dasar dan rangkaian abjad yang sudah tersimpan.',
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                mainAxisExtent: 300,
              ),
              itemCount: _wordAssemblies.length,
              itemBuilder: (_, i) {
                final item = _wordAssemblies[i];
                return _TeacherWordCard(
                  item: item,
                  onEdit: () => _openWordAssemblyDialog(existing: item),
                  onPreview: () => _showWordPreview(item),
                  onDelete: () => _deleteWordAssembly(item),
                );
              },
            ),
        ],
      ),
    );
  }

  Future<void> _openLetterBlendDialog({_LetterBlendItem? existing}) async {
    final result = await showDialog<_LetterBlendItem>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .18),
      builder: (_) => _LetterBlendDialog(
        letters: _fixedLatinLetters,
        existing: existing,
        existingLabels: _letterBlends
            .where((item) => item.id != existing?.id)
            .map((item) => item.label)
            .toSet(),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _letterBlends.removeWhere((item) => item.id == result.id);
      _letterBlends.insert(0, result);
    });
    try {
      await _syncRangkaiItem(result.toModel());
      _pushActivity(
        title: existing == null
            ? 'Menambahkan rangkaian abjad: ${result.label}'
            : 'Memperbarui rangkaian abjad: ${result.label}',
        subtitle: result.letters.join(' + '),
        icon: Icons.join_inner_rounded,
        color: _TeacherSection.merangkaiAbjad.color,
      );
    } catch (_) {
      _showRangkaiSyncError();
    }
  }

  Future<void> _openWordAssemblyDialog({_WordAssemblyItem? existing}) async {
    final result = await showDialog<_WordAssemblyItem>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .18),
      builder: (_) => _WordAssemblyDialog(
        letters: _fixedLatinLetters,
        blends: _letterBlends,
        existing: existing,
        existingTargets: _wordAssemblies
            .where((item) => item.id != existing?.id)
            .map((item) => item.target)
            .toSet(),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _wordAssemblies.removeWhere((item) => item.id == result.id);
      _wordAssemblies.insert(0, result);
    });
    try {
      await _syncRangkaiItem(result.toModel());
      _pushActivity(
        title: existing == null
            ? 'Menambahkan latihan kata: ${result.target}'
            : 'Memperbarui latihan kata: ${result.target}',
        subtitle: result.name,
        icon: Icons.extension_rounded,
        color: _TeacherSection.merangkaiKata.color,
      );
    } catch (_) {
      _showRangkaiSyncError();
    }
  }

  Future<void> _deleteLetterBlend(_LetterBlendItem item) async {
    final usedBy = _wordsUsingBlend(item.label);
    if (usedBy.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _TeacherSection.merangkaiAbjad.color,
          content: Text(
            '${item.label} dipakai di kata ${usedBy.map((e) => e.target).join(', ')}.',
          ),
        ),
      );
      return;
    }
    final confirmed = await _confirmDeleteLabel('Hapus Rangkaian?', item.label);
    if (!confirmed || !mounted) return;
    setState(() => _letterBlends.removeWhere((entry) => entry.id == item.id));
    try {
      await _deleteRangkaiItem(item.id);
    } catch (_) {
      _showRangkaiSyncError();
    }
  }

  Future<void> _deleteWordAssembly(_WordAssemblyItem item) async {
    final confirmed = await _confirmDeleteLabel(
      'Hapus Latihan Kata?',
      item.target,
    );
    if (!confirmed || !mounted) return;
    setState(() => _wordAssemblies.removeWhere((entry) => entry.id == item.id));
    try {
      await _deleteRangkaiItem(item.id);
    } catch (_) {
      _showRangkaiSyncError();
    }
  }

  Future<bool> _confirmDeleteLabel(String title, String value) async {
    return await showDialog<bool>(
          context: context,
          barrierColor: Colors.black.withValues(alpha: .20),
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            content: Text(
              '"$value" akan dihapus dari dashboard pengajar.',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xffF43F5E),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;
  }

  List<_WordAssemblyItem> _wordsUsingBlend(String label) {
    return _wordAssemblies
        .where(
          (word) => word.units.any(
            (unit) => unit.type == _WordUnitType.blend && unit.value == label,
          ),
        )
        .toList();
  }

  void _showBlendPreview(_LetterBlendItem item) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .18),
      builder: (_) => _TeacherPreviewDialog(
        title: 'Preview ${item.label}',
        child: _BlendPreview(item: item),
      ),
    );
  }

  void _showWordPreview(_WordAssemblyItem item) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .18),
      builder: (_) => _TeacherPreviewDialog(
        title: 'Preview ${item.target}',
        child: _WordTapPreview(item: item),
      ),
    );
  }

  Future<void> _openUploadDialog(
    _TeacherCategory category, {
    _TeacherContentData? existing,
  }) async {
    if (category == _TeacherCategory.huruf && existing == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: category.color,
          content: Text(
            '${category.label} bawaan hanya bisa diganti gambarnya, bukan tambah simbol baru.',
          ),
        ),
      );
      return;
    }

    final result = await showDialog<_TeacherDraftResult>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .18),
      builder: (_) =>
          _TeacherUploadDialog(category: category, existing: existing),
    );
    if (result == null || !mounted) return;

    final appState = ref.read(appStateProvider);
    if (category == _TeacherCategory.huruf) {
      final previousPath = existing?.letter?.objects.isNotEmpty == true
          ? existing!.letter!.objects.first.img
          : null;
      await appState.saveLetter(
        letter: existing?.letter?.letter ?? result.title,
        example: result.subtitle,
        imagePath: result.mediaPath,
        existingId: existing?.letter?.id,
      );
      if (previousPath != null &&
          previousPath != result.mediaPath &&
          MediaSourceHelper.isLocalFilePath(previousPath)) {
        await LocalDatabase.instance.deleteFile(previousPath);
      }
      _pushActivity(
        title: existing == null
            ? 'Menambahkan huruf baru: ${result.title}'
            : 'Memperbarui huruf: ${result.title}',
        subtitle: result.subtitle,
        icon: Icons.sort_by_alpha_rounded,
        color: _TeacherCategory.huruf.color,
      );
    } else if (category == _TeacherCategory.angka) {
      final previousPath = existing?.number?.img;
      await appState.saveNumber(
        number: existing?.number?.number ?? result.title,
        name: result.subtitle,
        imagePath: result.mediaPath,
        existingId: existing?.number?.id,
      );
      if (previousPath != null &&
          previousPath != result.mediaPath &&
          MediaSourceHelper.isLocalFilePath(previousPath)) {
        await LocalDatabase.instance.deleteFile(previousPath);
      }
      _pushActivity(
        title: existing == null
            ? 'Menambahkan angka baru: ${result.title}'
            : 'Memperbarui angka: ${result.title}',
        subtitle: result.subtitle,
        icon: Icons.numbers_rounded,
        color: _TeacherCategory.angka.color,
      );
    } else if (category == _TeacherCategory.benda) {
      final previousPath = existing?.object?.img;
      await appState.addObject(
        result.title,
        result.mediaPath,
        result.subtitle.isEmpty ? 'umum' : result.subtitle,
        existingId: existing?.object?.id,
        previousName: existing?.object?.name,
      );
      if (previousPath != null &&
          previousPath != result.mediaPath &&
          MediaSourceHelper.isLocalFilePath(previousPath)) {
        await LocalDatabase.instance.deleteFile(previousPath);
      }
      _pushActivity(
        title: existing == null
            ? 'Menambahkan benda baru: ${result.title}'
            : 'Memperbarui benda: ${result.title}',
        subtitle: result.subtitle.isEmpty ? 'Kategori umum' : result.subtitle,
        icon: Icons.category_rounded,
        color: _TeacherCategory.benda.color,
      );
    } else {
      final previousPath = existing?.song?.videoUrl;
      await appState.addSong(
        result.title,
        result.mediaPath,
        fileName: result.fileName,
        mediaType: result.mediaType,
        existingId: existing?.song?.id,
      );
      if (previousPath != null &&
          previousPath != result.mediaPath &&
          MediaSourceHelper.isLocalFilePath(previousPath)) {
        await LocalDatabase.instance.deleteFile(previousPath);
      }
      _pushActivity(
        title: existing == null
            ? 'Mengunggah lagu baru: ${result.title}'
            : 'Memperbarui lagu: ${result.title}',
        subtitle: result.fileName ?? 'Video online',
        icon: Icons.music_note_rounded,
        color: _TeacherCategory.lagu.color,
      );
    }
    _refreshStorage();
  }

  Future<void> _deleteContent(_TeacherContentData item) async {
    final confirmed = await _confirmDeleteContent(item);
    if (!confirmed || !mounted) return;
    final appState = ref.read(appStateProvider);
    if (item.letter != null) {
      await appState.removeLetter(item.letter!);
      _pushActivity(
        title: 'Menghapus huruf: ${item.title}',
        subtitle: item.subtitle,
        icon: Icons.delete_outline_rounded,
        color: const Color(0xffF43F5E),
      );
    } else if (item.number != null) {
      await appState.removeNumber(item.number!);
      _pushActivity(
        title: 'Menghapus angka: ${item.title}',
        subtitle: item.subtitle,
        icon: Icons.delete_outline_rounded,
        color: const Color(0xffF43F5E),
      );
    } else if (item.object != null) {
      await appState.removeObject(item.object!);
      _pushActivity(
        title: 'Menghapus benda: ${item.title}',
        subtitle: item.subtitle,
        icon: Icons.delete_outline_rounded,
        color: const Color(0xffF43F5E),
      );
    } else if (item.song != null) {
      await appState.removeSong(item.song!);
      _pushActivity(
        title: 'Menghapus lagu: ${item.title}',
        subtitle: item.subtitle,
        icon: Icons.delete_outline_rounded,
        color: const Color(0xffF43F5E),
      );
    }
    _refreshStorage();
  }

  Future<bool> _confirmDeleteContent(_TeacherContentData item) async {
    return await showDialog<bool>(
          context: context,
          barrierColor: Colors.black.withValues(alpha: .20),
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            title: const Text(
              'Hapus Materi?',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            content: Text(
              'Materi "${item.title}" akan dihapus permanen dari dashboard dan cloud.',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xffF43F5E),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showReadOnlyMessage(_TeacherCategory category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: category.color,
        content: Text('${category.label} siap diubah dari dashboard pengajar.'),
      ),
    );
  }

  void _pushActivity({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    setState(() {
      _activities.insert(
        0,
        _TeacherActivity(
          title: title,
          subtitle: subtitle,
          timestamp: DateTime.now(),
          icon: icon,
          color: color,
        ),
      );
    });
  }

  List<_TeacherActivity> _activityFeed(AppState app) {
    if (_activities.isNotEmpty) return _activities;
    return [
      _TeacherActivity(
        title: 'Konten benda siap digunakan',
        subtitle: '${app.objects.length} item online tersedia untuk belajar.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        icon: Icons.inventory_2_rounded,
        color: _TeacherCategory.benda.color,
      ),
      _TeacherActivity(
        title: 'Lagu anak siap diputar',
        subtitle: '${app.songs.length} media online tersimpan.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        icon: Icons.music_video_rounded,
        color: _TeacherCategory.lagu.color,
      ),
      _TeacherActivity(
        title: 'Dashboard online aktif',
        subtitle: 'Konten tersinkron dan siap diakses lewat web.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        icon: Icons.cloud_done_rounded,
        color: const Color(0xff0EA5E9),
      ),
    ];
  }

  void _refreshStorage() {
    setState(() {
      _storageFuture = _loadStorage();
    });
  }

  Future<_TeacherStorageData> _loadStorage() async {
    final app = ref.read(appStateProvider);
    const capacity = 5 * 1024 * 1024 * 1024;
    final seen = <String>{};
    int imageBytes = 0;
    int videoBytes = 0;
    int audioBytes = 0;

    for (final item in app.objects) {
      imageBytes += await _measureMedia(item.img, seen);
    }
    for (final song in app.songs) {
      videoBytes += await _measureMedia(song.videoUrl, seen);
    }
    audioBytes += await _measureMedia(
      DefaultLearningCatalog.hurufPlaceholderAsset,
      seen,
    );

    final total = imageBytes + audioBytes + videoBytes;
    return _TeacherStorageData(
      totalBytes: total,
      capacityBytes: capacity,
      segments: [
        _TeacherStorageSegment(
          label: 'Gambar',
          bytes: imageBytes,
          color: const Color(0xff8B5CF6),
          icon: Icons.image_rounded,
        ),
        _TeacherStorageSegment(
          label: 'Audio',
          bytes: audioBytes,
          color: const Color(0xff22C55E),
          icon: Icons.audiotrack_rounded,
        ),
        _TeacherStorageSegment(
          label: 'Video',
          bytes: videoBytes,
          color: const Color(0xff38BDF8),
          icon: Icons.video_library_rounded,
        ),
      ],
    );
  }

  Future<int> _measureMedia(String path, Set<String> seen) async {
    if (path.trim().isEmpty || MediaSourceHelper.isAssetPath(path)) return 0;
    if (!seen.add(path)) return 0;
    if (MediaSourceHelper.isDataUri(path)) {
      final payload = path.split(',').last;
      return (payload.length * 0.75).round();
    }
    if (MediaSourceHelper.isLocalFilePath(path) && !kIsWeb) {
      return fileLength(path);
    }
    return 0;
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    double value = bytes.toDouble();
    var unitIndex = 0;
    while (value >= 1024 && unitIndex < units.length - 1) {
      value /= 1024;
      unitIndex++;
    }
    final digits = value >= 100
        ? 0
        : value >= 10
        ? 1
        : 2;
    return '${value.toStringAsFixed(digits)} ${units[unitIndex]}';
  }
}

class _TeacherSidebar extends StatelessWidget {
  const _TeacherSidebar({
    required this.app,
    required this.section,
    required this.collapsed,
    required this.onToggleCollapse,
    required this.onSelected,
    required this.onSync,
    required this.onLogout,
  });

  final AppState app;
  final _TeacherSection section;
  final bool collapsed;
  final VoidCallback? onToggleCollapse;
  final ValueChanged<_TeacherSection> onSelected;
  final VoidCallback onSync;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final items = [
      _TeacherSection.dashboard,
      _TeacherSection.angka,
      _TeacherSection.benda,
      _TeacherSection.lagu,
    ];
    final abjadItems = [
      _TeacherSection.huruf,
      _TeacherSection.merangkaiAbjad,
      _TeacherSection.merangkaiKata,
    ];

    return AnimatedContainer(
      duration: 260.ms,
      width: collapsed ? 96 : 276,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          colors: [Color(0xffFFFFFF), Color(0xffF6F2FF), Color(0xffEFF9FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white, width: 1.6),
        boxShadow: [
          BoxShadow(
            blurRadius: 34,
            offset: const Offset(0, 16),
            color: const Color(0xff8262FF).withValues(alpha: .14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: collapsed ? 8 : 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff8B5CF6), Color(0xffA78BFA)],
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 24,
                        color: const Color(0xff8B5CF6).withValues(alpha: .25),
                      ),
                    ],
                  ),
                  child: collapsed
                      ? Center(
                          child: Image.asset(
                            'assets/images/Logo_Aplikasi.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Row(
                          children: [
                            Image.asset(
                              'assets/images/Logo_Aplikasi.png',
                              width: 56,
                              height: 56,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Khoir Quest',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      _TeacherSidebarTile(
                        item: _TeacherSection.dashboard,
                        selected: section == _TeacherSection.dashboard,
                        collapsed: collapsed,
                        onTap: () => onSelected(_TeacherSection.dashboard),
                      ),
                      const SizedBox(height: 8),
                      _TeacherSidebarGroup(
                        title: 'Abjad',
                        icon: Icons.sort_by_alpha_rounded,
                        color: _TeacherCategory.huruf.color,
                        collapsed: collapsed,
                        selected: abjadItems.contains(section),
                        children: abjadItems
                            .map(
                              (item) => _TeacherSidebarSubTile(
                                item: item,
                                selected: item == section,
                                collapsed: collapsed,
                                onTap: () => onSelected(item),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      ...items
                          .skip(1)
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _TeacherSidebarTile(
                                item: item,
                                selected: item == section,
                                collapsed: collapsed,
                                onTap: () => onSelected(item),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _TeacherSyncSidebarButton(
                  app: app,
                  collapsed: collapsed,
                  onTap: onSync,
                ),
                const SizedBox(height: 10),
                _TeacherLogoutSidebarButton(
                  collapsed: collapsed,
                  onTap: onLogout,
                ),
                if (onToggleCollapse != null) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: collapsed
                        ? Alignment.center
                        : Alignment.centerRight,
                    child: IconButton(
                      onPressed: onToggleCollapse,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xffF3EEFF),
                        foregroundColor: const Color(0xff7C3AED),
                      ),
                      icon: Icon(
                        collapsed
                            ? Icons.chevron_right_rounded
                            : Icons.chevron_left_rounded,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TeacherLogoutSidebarButton extends StatelessWidget {
  const _TeacherLogoutSidebarButton({
    required this.collapsed,
    required this.onTap,
  });

  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: collapsed ? 0 : 14,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffFFF1F2),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xffFECDD3)),
        ),
        child: collapsed
            ? const Center(
                child: Icon(Icons.logout_rounded, color: Color(0xffE11D48)),
              )
            : const Row(
                children: [
                  Icon(Icons.logout_rounded, color: Color(0xffE11D48)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Color(0xffE11D48),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ObjectCategoryDropdown extends StatelessWidget {
  const _ObjectCategoryDropdown({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = _fixedObjectCategories.contains(value)
        ? value
        : _fixedObjectCategories.first;
    return DropdownButtonFormField<String>(
      initialValue: selected,
      items: _fixedObjectCategories
          .map(
            (category) => DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
      decoration: InputDecoration(
        labelText: 'Kategori',
        prefixIcon: const Icon(Icons.category_rounded),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xffE6E0FF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xffE6E0FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xff8B5CF6), width: 1.8),
        ),
      ),
      style: const TextStyle(
        color: Color(0xff2F2966),
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _TeacherSidebarGroup extends StatelessWidget {
  const _TeacherSidebarGroup({
    required this.title,
    required this.icon,
    required this.color,
    required this.collapsed,
    required this.selected,
    required this.children,
  });

  final String title;
  final IconData icon;
  final Color color;
  final bool collapsed;
  final bool selected;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (collapsed) {
      return Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: selected
                  ? color.withValues(alpha: .16)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 6),
          ...children,
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: selected ? .08 : .04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: .12)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xff2D275B),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          ...children,
        ],
      ),
    );
  }
}

class _TeacherSidebarSubTile extends StatelessWidget {
  const _TeacherSidebarSubTile({
    required this.item,
    required this.selected,
    required this.collapsed,
    required this.onTap,
  });

  final _TeacherSection item;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: collapsed ? 0 : 18, top: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: 220.ms,
          padding: EdgeInsets.symmetric(
            horizontal: collapsed ? 0 : 12,
            vertical: collapsed ? 10 : 11,
          ),
          decoration: BoxDecoration(
            color: selected
                ? item.color.withValues(alpha: .14)
                : Colors.white.withValues(alpha: .45),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? item.color.withValues(alpha: .35)
                  : Colors.white.withValues(alpha: .55),
            ),
          ),
          child: collapsed
              ? Icon(item.icon, color: item.color, size: 19)
              : Row(
                  children: [
                    Icon(item.icon, color: item.color, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: selected
                              ? item.color
                              : const Color(0xff4A4278),
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _TeacherSidebarTile extends StatelessWidget {
  const _TeacherSidebarTile({
    required this.item,
    required this.selected,
    required this.collapsed,
    required this.onTap,
  });

  final _TeacherSection item;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: 220.ms,
        padding: EdgeInsets.symmetric(
          horizontal: collapsed ? 10 : 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [item.color, item.color.withValues(alpha: .78)],
                )
              : null,
          color: selected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          boxShadow: selected
              ? [
                  BoxShadow(
                    blurRadius: 20,
                    color: item.color.withValues(alpha: .25),
                  ),
                ]
              : null,
        ),
        child: collapsed
            ? Center(
                child: Icon(
                  item.icon,
                  color: selected ? Colors.white : item.color,
                  size: 24,
                ),
              )
            : Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white.withValues(alpha: .20)
                          : item.color.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      item.icon,
                      color: selected ? Colors.white : item.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : const Color(0xff2D275B),
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (selected)
                    Container(
                      width: 8,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .85),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _TeacherSyncSidebarButton extends StatelessWidget {
  const _TeacherSyncSidebarButton({
    required this.app,
    required this.collapsed,
    required this.onTap,
  });

  final AppState app;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final online = app.online;
    final pending = app.hasPendingMaterialSync;
    final color = !online
        ? const Color(0xffEA580C)
        : pending
        ? const Color(0xffB45309)
        : const Color(0xff059669);
    final bg = !online
        ? const Color(0xffFFF7ED)
        : pending
        ? const Color(0xffFEF3C7)
        : const Color(0xffECFDF5);
    final border = !online
        ? const Color(0xffFED7AA)
        : pending
        ? const Color(0xffF59E0B)
        : const Color(0xffBBF7D0);
    final icon = app.syncInProgress
        ? null
        : !online
        ? Icons.cloud_off_rounded
        : pending
        ? Icons.priority_high_rounded
        : Icons.cloud_done_rounded;
    final label = app.syncInProgress
        ? 'Menyinkron...'
        : pending
        ? 'Tekan saya - belum sinkron'
        : 'Sudah sinkron';
    final tooltip = pending
        ? '${app.syncStatus} (${app.pendingMaterialSyncCount} perubahan belum sinkron)'
        : app.syncStatus;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: app.syncInProgress ? null : onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: collapsed ? 0 : 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border),
          ),
          child: collapsed
              ? Center(
                  child: app.syncInProgress
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: color,
                          ),
                        )
                      : Icon(icon, color: color),
                )
              : Row(
                  children: [
                    app.syncInProgress
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: color,
                            ),
                          )
                        : Icon(icon, color: color),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _TeacherTopbar extends StatelessWidget {
  const _TeacherTopbar({
    required this.app,
    required this.mobile,
    required this.activeCategory,
    required this.onMenuTap,
    required this.onCollapseTap,
    required this.onQuickUpload,
  });

  final AppState app;
  final bool mobile;
  final _TeacherCategory activeCategory;
  final VoidCallback onMenuTap;
  final VoidCallback? onCollapseTap;
  final VoidCallback onQuickUpload;

  @override
  Widget build(BuildContext context) {
    const teacherName = 'Pengajar';
    return Padding(
      padding: EdgeInsets.fromLTRB(mobile ? 16 : 20, 18, mobile ? 16 : 24, 12),
      child: _TeacherSurfaceCard(
        padding: EdgeInsets.symmetric(
          horizontal: mobile ? 14 : 18,
          vertical: 14,
        ),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (mobile)
                  IconButton(
                    onPressed: onMenuTap,
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xffF2EEFF),
                      foregroundColor: const Color(0xff7C3AED),
                    ),
                    icon: const Icon(Icons.menu_rounded),
                  )
                else if (onCollapseTap != null)
                  IconButton(
                    onPressed: onCollapseTap,
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xffF2EEFF),
                      foregroundColor: const Color(0xff7C3AED),
                    ),
                    icon: const Icon(Icons.space_dashboard_rounded),
                  ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: activeCategory.lightColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        activeCategory.asset,
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                      if (!mobile) ...[
                        const SizedBox(width: 8),
                        Text(
                          'Panel Pengajar',
                          style: TextStyle(
                            color: activeCategory.color,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!mobile && activeCategory != _TeacherCategory.huruf)
                  FilledButton.icon(
                    onPressed: onQuickUpload,
                    style: FilledButton.styleFrom(
                      backgroundColor: activeCategory.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    icon: const Icon(Icons.file_upload_rounded),
                    label: const Text('Quick Upload'),
                  ),
                const SizedBox(width: 12),
                _TeacherProfilePill(
                  name: teacherName,
                  compact: mobile,
                  gender: app.gender,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TeacherSummaryCard extends StatelessWidget {
  const _TeacherSummaryCard({required this.data});

  final _TeacherSummaryCardData data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;
        final padding = compact ? 14.0 : 18.0;
        final iconSize = compact ? 52.0 : 60.0;
        final valueSize = compact ? 24.0 : 28.0;
        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: data.background,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white, width: 1.8),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 12),
                color: data.color.withValues(alpha: .12),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.white, data.color.withValues(alpha: .20)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 16,
                      color: data.color.withValues(alpha: .18),
                    ),
                  ],
                ),
                child: Icon(
                  data.icon,
                  color: data.color,
                  size: compact ? 26 : 30,
                ),
              ),
              SizedBox(width: compact ? 10 : 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    data.value != null
                        ? Text(
                            data.value!,
                            style: TextStyle(
                              fontSize: valueSize,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff2F2966),
                            ),
                          )
                        : FutureBuilder<int>(
                            future: data.valueFuture,
                            builder: (_, snapshot) => Text(
                              '${snapshot.data ?? 0}',
                              style: TextStyle(
                                fontSize: valueSize,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff2F2966),
                              ),
                            ),
                          ),
                    const SizedBox(height: 4),
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xff342D6B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: compact ? 11 : 12,
                        color: const Color(0xff6D6A95),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TeacherCategoryChip extends StatelessWidget {
  const _TeacherCategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final _TeacherCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: 220.ms,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [
                    category.color,
                    category.color.withValues(alpha: .78),
                  ],
                )
              : null,
          color: selected ? null : category.lightColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? category.color
                : category.color.withValues(alpha: .18),
            width: selected ? 1.8 : 1.2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    blurRadius: 16,
                    color: category.color.withValues(alpha: .20),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 18,
              color: selected ? Colors.white : category.color,
            ),
            const SizedBox(width: 8),
            Text(
              category.label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xff2F2966),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeacherContentCard extends StatelessWidget {
  const _TeacherContentCard({
    required this.item,
    required this.onUpload,
    required this.onDelete,
    required this.onReadOnlyTap,
    required this.previewActive,
    required this.previewPlaying,
    required this.previewLoading,
    this.onPreview,
  });

  final _TeacherContentData item;
  final VoidCallback? onUpload;
  final VoidCallback? onDelete;
  final VoidCallback onReadOnlyTap;
  final bool previewActive;
  final bool previewPlaying;
  final bool previewLoading;
  final VoidCallback? onPreview;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 220;
        if (item.category == 'Abjad') {
          return Container(
            padding: EdgeInsets.all(compact ? 12 : 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .90),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white, width: 1.5),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                  color: item.color.withValues(alpha: .10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      item.color.withValues(alpha: .12),
                      item.color.withValues(alpha: .03),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: compact ? 76 : 104,
                        fontWeight: FontWeight.w900,
                        color: item.color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Container(
          padding: EdgeInsets.all(compact ? 12 : 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .90),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 10),
                color: item.color.withValues(alpha: .10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: compact ? 190 : 240,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          item.color.withValues(alpha: .08),
                          item.color.withValues(alpha: .02),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: item.mediaPath.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(compact ? 10 : 12),
                            child: Image.asset(
                              item.category == 'Abjad'
                                  ? _TeacherCategory.huruf.asset
                                  : item.category == 'Bilangan'
                                  ? _TeacherCategory.angka.asset
                                  : item.category == 'Benda'
                                  ? _TeacherCategory.benda.asset
                                  : _TeacherCategory.lagu.asset,
                              fit: BoxFit.contain,
                            ),
                          )
                        : AppImage(url: item.mediaPath, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: compact ? 10 : 14),
              SizedBox(
                height: compact ? 42 : 46,
                child: Text(
                  item.title,
                  maxLines: item.song == null ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: compact ? 16 : 18,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff2F2966),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xff6D6A95),
                  fontWeight: FontWeight.w800,
                  fontSize: compact ? 12 : 13,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _TeacherStatusPill(
                    label: item.statusLabel,
                    background: const Color(0xffEAFBF2),
                    foreground: const Color(0xff1F9D57),
                  ),
                  if (item.badgeText.trim().isNotEmpty)
                    _TeacherStatusPill(
                      label: item.badgeText,
                      background: item.color.withValues(alpha: .10),
                      foreground: item.color,
                    ),
                ],
              ),
              const Spacer(),
              const SizedBox(height: 12),
              item.editable
                  ? Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (item.song != null)
                          _TeacherActionButton(
                            icon: previewLoading
                                ? Icons.hourglass_top_rounded
                                : previewPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: previewActive
                                ? const Color(0xff22C55E)
                                : const Color(0xffFB923C),
                            onTap: onPreview!,
                          ),
                        _TeacherActionButton(
                          icon: item.song == null
                              ? Icons.photo_size_select_large_rounded
                              : Icons.video_file_rounded,
                          color: const Color(0xff38BDF8),
                          onTap: onUpload!,
                        ),
                        if (item.letter == null)
                          _TeacherActionButton(
                            icon: Icons.delete_outline_rounded,
                            color: const Color(0xffFB7185),
                            onTap: onDelete!,
                          ),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onReadOnlyTap,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: item.color,
                          side: BorderSide(
                            color: item.color.withValues(alpha: .22),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 18,
                        ),
                        label: Text(item.actionLabel),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}

class _TeacherUploadDialog extends StatefulWidget {
  const _TeacherUploadDialog({required this.category, this.existing});

  final _TeacherCategory category;
  final _TeacherContentData? existing;

  @override
  State<_TeacherUploadDialog> createState() => _TeacherUploadDialogState();
}

class _TeacherUploadDialogState extends State<_TeacherUploadDialog> {
  late final TextEditingController _title;
  late final TextEditingController _subtitle;
  late final TextEditingController _youtubeUrl;
  String? _fileName;
  String? _mediaPath;
  String _pickedSongMediaType = 'video';
  bool _pickedNewSongFile = false;
  Uint8List? _pickedMediaBytes;
  bool _saving = false;

  bool get _isSong => widget.category == _TeacherCategory.lagu;
  bool get _isHuruf => widget.category == _TeacherCategory.huruf;
  bool get _isAngka => widget.category == _TeacherCategory.angka;
  bool get _isBenda => widget.category == _TeacherCategory.benda;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(
      text:
          widget.existing?.letter?.letter ??
          widget.existing?.number?.number ??
          widget.existing?.title ??
          '',
    );
    _subtitle = TextEditingController(
      text: widget.existing?.letter?.objects.isNotEmpty == true
          ? widget.existing!.letter!.objects.first.name
          : widget.existing?.number?.name ??
                widget.existing?.object?.category ??
                '',
    );
    if (_isBenda && !_fixedObjectCategories.contains(_subtitle.text)) {
      _subtitle.text = _fixedObjectCategories.first;
    }
    final existingSongUrl = widget.existing?.song?.videoUrl ?? '';
    final existingSongMediaType = widget.existing?.song?.mediaType ?? '';
    _youtubeUrl = TextEditingController(
      text:
          _isSong &&
              MediaSourceHelper.inferSongMediaType(
                    source: existingSongUrl,
                    fileName: widget.existing?.song?.fileName,
                    explicit: existingSongMediaType,
                  ) ==
                  'youtube'
          ? existingSongUrl
          : '',
    );
    _fileName = widget.existing?.song?.fileName;
    _pickedSongMediaType = MediaSourceHelper.inferSongMediaType(
      source: existingSongUrl,
      fileName: _fileName,
      explicit: existingSongMediaType,
    );
    _mediaPath = widget.existing?.letter?.objects.isNotEmpty == true
        ? widget.existing!.letter!.objects.first.img
        : widget.existing?.number?.img ??
              widget.existing?.object?.img ??
              widget.existing?.song?.videoUrl;
  }

  @override
  void dispose() {
    _title.dispose();
    _subtitle.dispose();
    _youtubeUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isSong) return _buildSongDialog(context);

    final accent = widget.category.color;
    final mediaWidth = MediaQuery.sizeOf(context).width;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.fromLTRB(
        18,
        18,
        18,
        max(18, MediaQuery.viewInsetsOf(context).bottom + 18),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: MediaQuery.sizeOf(context).height * .88,
        ),
        child: _TeacherSurfaceCard(
          padding: const EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(widget.category.icon, color: accent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.existing == null
                                ? 'Tambah ${widget.category.label}'
                                : 'Edit ${widget.category.label}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff2F2966),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isSong
                                ? 'Upload file MP3/video atau tempel link YouTube.'
                                : _isHuruf
                                ? 'Atur abjad, contoh benda, dan gambar preview secara terpisah.'
                                : _isAngka
                                ? 'Atur bilangan, nama bilangan, dan gambar preview.'
                                : 'Simpan benda baru beserta gambar untuk cloud.',
                            style: const TextStyle(
                              color: Color(0xff6D6A95),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                AppField(
                  controller: _title,
                  label: _isSong
                      ? 'Judul Lagu'
                      : _isHuruf
                      ? 'Abjad'
                      : _isAngka
                      ? 'Bilangan'
                      : 'Nama Benda',
                  icon: _isSong
                      ? Icons.music_note_rounded
                      : _isAngka
                      ? Icons.numbers_rounded
                      : Icons.edit_rounded,
                  readOnly: _isHuruf || (_isAngka && widget.existing != null),
                ),
                if (!_isSong)
                  _isBenda
                      ? _ObjectCategoryDropdown(
                          value: _subtitle.text,
                          onChanged: (value) => setState(() {
                            _subtitle.text = value;
                          }),
                        )
                      : AppField(
                          controller: _subtitle,
                          label: _isHuruf ? 'Contoh Benda' : 'Nama Bilangan',
                          icon: _isHuruf
                              ? Icons.lightbulb_outline_rounded
                              : Icons.record_voice_over_rounded,
                          hint: _isHuruf
                              ? 'contoh: Apel, Bola, Cicak'
                              : 'contoh: Satu, Dua, Tiga',
                        ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: _pickMedia,
                  child: AnimatedContainer(
                    duration: 220.ms,
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: .06),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: accent.withValues(alpha: .35),
                        width: 1.4,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: !_isSong && _mediaPath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: AppImage(
                                    url: _mediaPath!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  _isSong
                                      ? _TeacherCategory.lagu.asset
                                      : _isHuruf
                                      ? _TeacherCategory.huruf.asset
                                      : _isAngka
                                      ? _TeacherCategory.angka.asset
                                      : _TeacherCategory.benda.asset,
                                  fit: BoxFit.contain,
                                ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _isSong
                              ? 'Tap untuk pilih file MP3/video'
                              : _isHuruf
                              ? 'Tap untuk pilih gambar huruf'
                              : _isAngka
                              ? 'Tap untuk pilih gambar angka'
                              : 'Tap untuk pilih gambar benda',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xff2F2966),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _fileName ??
                              (_mediaPath == null
                                  ? 'Belum ada file dipilih'
                                  : _mediaPath!),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xff6D6A95),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isSong) ...[
                  const SizedBox(height: 14),
                  AppField(
                    controller: _youtubeUrl,
                    label: 'Link YouTube',
                    icon: Icons.link_rounded,
                    hint: 'https://youtu.be/...',
                  ),
                ],
                if (_mediaPath != null && !_isSong) ...[
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: mediaWidth < 420 ? 320 : 420,
                      width: double.infinity,
                      child: AppImage(url: _mediaPath!, fit: BoxFit.cover),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: mediaWidth < 420 ? double.infinity : 220,
                      child: OutlinedButton(
                        onPressed: _saving
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('Batal'),
                      ),
                    ),
                    SizedBox(
                      width: mediaWidth < 420 ? double.infinity : 220,
                      child: FilledButton.icon(
                        onPressed: _saving ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.white,
                        ),
                        icon: _saving
                            ? const SizedBox.square(
                                dimension: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save_rounded),
                        label: Text(
                          widget.existing == null
                              ? 'Simpan Konten'
                              : 'Update Konten',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSongDialog(BuildContext context) {
    final accent = widget.category.color;
    final mediaWidth = MediaQuery.sizeOf(context).width;
    final compact = mediaWidth < 430;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.fromLTRB(
        18,
        18,
        18,
        max(18, MediaQuery.viewInsetsOf(context).bottom + 18),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: MediaQuery.sizeOf(context).height * .9,
        ),
        child: _TeacherSurfaceCard(
          padding: EdgeInsets.all(compact ? 18 : 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xffffefe8),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                            color: accent.withValues(alpha: .18),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.music_note_rounded,
                        color: accent,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.existing == null
                                  ? 'Tambah Lagu Anak'
                                  : 'Edit Lagu Anak',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff2F2966),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Unggah file MP3/video atau tempel link YouTube untuk konten pembelajaran.',
                              style: TextStyle(
                                color: Color(0xff6D6A95),
                                fontWeight: FontWeight.w800,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: _saving ? null : () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xffF3EEFF),
                        foregroundColor: const Color(0xff5B3CB8),
                      ),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _SongTitleField(controller: _title),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: _pickMedia,
                  child: AnimatedContainer(
                    duration: 220.ms,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 16 : 24,
                      vertical: compact ? 24 : 30,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xfffff7f0),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: accent.withValues(alpha: .65),
                        width: 1.4,
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/Menambahkan_lagu_pengajar.png',
                          width: compact ? 150 : 180,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Klik untuk memilih',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff2F2966),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _fileName ?? 'Format: MP3, MP4, MOV - Maks. 50 MB',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xff6D6A95),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _SongDivider(label: 'atau'),
                const SizedBox(height: 14),
                _SongYoutubeField(controller: _youtubeUrl),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _saving
                              ? null
                              : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xff7C3AED),
                            side: const BorderSide(
                              color: Color(0xff8B5CF6),
                              width: 1.4,
                            ),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                    ),
                    SizedBox(width: compact ? 10 : 18),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: FilledButton.icon(
                          onPressed: _saving ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: Colors.white,
                          ),
                          icon: _saving
                              ? const SizedBox.square(
                                  dimension: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_rounded),
                          label: Text(
                            widget.existing == null
                                ? 'Simpan Konten'
                                : 'Update Konten',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickMedia() async {
    Uint8List? bytes;
    String? pickedName;
    if (!_isSong &&
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked == null) return;
      bytes = await picked.readAsBytes();
      pickedName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    } else {
      final result = await FilePicker.pickFiles(
        type: _isSong ? FileType.custom : FileType.image,
        allowedExtensions: _isSong
            ? const ['mp3', 'wav', 'm4a', 'ogg', 'mp4', 'webm', 'mov']
            : null,
        withData: true,
      );
      final file = result?.files.single;
      bytes = file?.bytes;
      pickedName = file?.name;
    }
    if (bytes == null || (pickedName ?? '').trim().isEmpty) return;

    final savedPath = _isSong
        ? kIsWeb
              ? 'pending-web-song:${DateTime.now().microsecondsSinceEpoch}'
              : await LocalDatabase.instance.saveVideoBytes(
                  bytes: bytes,
                  fileName: pickedName!,
                )
        : await LocalDatabase.instance.saveImageBytes(
            bytes: bytes,
            fileName: pickedName!,
            bucket: _isHuruf || _isAngka
                ? StorageBucket.hurufImages
                : StorageBucket.bendaImages,
          );
    if (!mounted) return;
    setState(() {
      _fileName = pickedName;
      _pickedSongMediaType = MediaSourceHelper.inferSongMediaType(
        source: savedPath,
        fileName: pickedName,
      );
      _pickedMediaBytes = _isSong && kIsWeb ? bytes : null;
      _mediaPath = savedPath;
      if (_isSong) _pickedNewSongFile = true;
      if (_isSong) _youtubeUrl.clear();
    });
  }

  Future<void> _submit() async {
    if (_title.text.trim().isEmpty) return;
    if (!_isSong && _subtitle.text.trim().isEmpty) return;
    final youtubeUrl = _youtubeUrl.text.trim();
    if (_isSong) {
      final hasYoutube = youtubeUrl.isNotEmpty;
      final hasFile =
          (_mediaPath ?? '').trim().isNotEmpty &&
          (!hasYoutube || _pickedNewSongFile);
      if (hasFile == hasYoutube) {
        _showUploadError(
          'Pilih file MP3/video atau isi link YouTube, salah satu saja.',
        );
        return;
      }
      if (hasYoutube && !MediaSourceHelper.isYoutubeUrl(youtubeUrl)) {
        _showUploadError('Link YouTube tidak valid.');
        return;
      }
    } else if ((_mediaPath ?? '').trim().isEmpty) {
      return;
    }
    setState(() => _saving = true);
    try {
      var mediaPath = _isSong && youtubeUrl.isNotEmpty
          ? youtubeUrl
          : _mediaPath!.trim();
      var mediaType = _isSong && youtubeUrl.isNotEmpty
          ? 'youtube'
          : _pickedSongMediaType;
      final pickedBytes = _pickedMediaBytes;
      if (_isSong && kIsWeb && pickedBytes != null) {
        final baseName = (_fileName ?? 'lagu.mp4').trim();
        final uniqueName = '${DateTime.now().microsecondsSinceEpoch}_$baseName';
        mediaPath = (await UploadService.instance.uploadLearningAssetBytes(
          category: LearningCategories.lagu,
          type: mediaType == 'audio'
              ? UploadedAssetType.audio
              : UploadedAssetType.video,
          bytes: pickedBytes,
          fileName: uniqueName,
        )).publicUrl;
      }
      if (!mounted) return;
      Navigator.of(context).pop(
        _TeacherDraftResult(
          title: _title.text.trim(),
          subtitle: _subtitle.text.trim(),
          mediaPath: mediaPath,
          fileName: _fileName,
          mediaType: mediaType,
        ),
      );
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showUploadError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SongTitleField extends StatelessWidget {
  const _SongTitleField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Masukkan judul lagu',
        prefixIcon: Container(
          width: 48,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xffF3EEFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.article_rounded, color: Color(0xff7C3AED)),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: .86),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xffDDD6FE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xffDDD6FE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xff8B5CF6), width: 1.6),
        ),
      ),
    );
  }
}

class _SongYoutubeField extends StatelessWidget {
  const _SongYoutubeField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'https://youtube.com/...',
        prefixIcon: Container(
          width: 48,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xffF3EEFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.link_rounded, color: Color(0xff5B3CB8)),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: .86),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xffDDD6FE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xffDDD6FE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xff8B5CF6), width: 1.6),
        ),
      ),
    );
  }
}

class _SongDivider extends StatelessWidget {
  const _SongDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xffDDD6FE), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xff6D6A95),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xffDDD6FE), thickness: 1)),
      ],
    );
  }
}

class _TeacherProfilePill extends StatelessWidget {
  const _TeacherProfilePill({
    required this.name,
    required this.gender,
    this.compact = false,
  });

  final String name;
  final Gender gender;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .86),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffECE7FF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xff8B5CF6), Color(0xff60A5FA)],
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                gender == Gender.girl
                    ? 'assets/images/profil_perempuan.png'
                    : 'assets/images/profil_lakilaki.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (!compact) ...[
            const SizedBox(width: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 124),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff2F2966),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const _TeacherRolePill(compact: true),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TeacherRolePill extends StatelessWidget {
  const _TeacherRolePill({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffEFE8FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'Pengajar',
        style: TextStyle(
          color: const Color(0xff7C3AED),
          fontWeight: FontWeight.w900,
          fontSize: compact ? 11 : 12,
        ),
      ),
    );
  }
}

class _TeacherSectionTitle extends StatelessWidget {
  const _TeacherSectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xff2F2966),
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xff6D6A95),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _TeacherDropdownField extends StatelessWidget {
  const _TeacherDropdownField({
    required this.label,
    required this.icon,
    required this.items,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final List<String> items;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      itemBuilder: (_) => items
          .map((item) => PopupMenuItem<String>(value: item, child: Text(item)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .80),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xffE9E4FF)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: const Color(0xff8B5CF6)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xff2F2966),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.expand_more_rounded, color: Color(0xff7C3AED)),
          ],
        ),
      ),
    );
  }
}

class _TeacherStatusPill extends StatelessWidget {
  const _TeacherStatusPill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _TeacherActionButton extends StatelessWidget {
  const _TeacherActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _TeacherActivityTile extends StatelessWidget {
  const _TeacherActivityTile({required this.activity});

  final _TeacherActivity activity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: activity.color.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(activity.icon, color: activity.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xff2F2966),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.subtitle,
                  style: const TextStyle(
                    color: Color(0xff6D6A95),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _relativeTime(activity.timestamp),
            style: const TextStyle(
              color: Color(0xff8B87AC),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  String _relativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }
}

class _TeacherStorageRow extends StatelessWidget {
  const _TeacherStorageRow({required this.segment, required this.maxBytes});

  final _TeacherStorageSegment segment;
  final int maxBytes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: segment.color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(segment.icon, color: segment.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  segment.label,
                  style: const TextStyle(
                    color: Color(0xff2F2966),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: maxBytes <= 0
                        ? 0
                        : (segment.bytes / maxBytes).clamp(0, 1).toDouble(),
                    minHeight: 8,
                    backgroundColor: segment.color.withValues(alpha: .12),
                    color: segment.color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _formatBytes(segment.bytes),
            style: const TextStyle(
              color: Color(0xff6D6A95),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB'];
    double value = bytes.toDouble();
    var index = 0;
    while (value >= 1024 && index < units.length - 1) {
      value /= 1024;
      index++;
    }
    return '${value.toStringAsFixed(value >= 10 ? 1 : 2)} ${units[index]}';
  }
}

class _TeacherStorageChip extends StatelessWidget {
  const _TeacherStorageChip({required this.segment});

  final _TeacherStorageSegment segment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: segment.color.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(segment.icon, color: segment.color),
          const SizedBox(height: 10),
          Text(
            segment.label,
            style: const TextStyle(
              color: Color(0xff2F2966),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatBytes(segment.bytes),
            style: TextStyle(
              color: segment.color,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB'];
    double value = bytes.toDouble();
    var index = 0;
    while (value >= 1024 && index < units.length - 1) {
      value /= 1024;
      index++;
    }
    return '${value.toStringAsFixed(value >= 10 ? 1 : 2)} ${units[index]}';
  }
}

class _TeacherLogoutDialog extends StatelessWidget {
  const _TeacherLogoutDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: _TeacherSurfaceCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xffFF8A9B), Color(0xffFF5D73)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                          color: const Color(0xffFF5D73).withValues(alpha: .22),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keluar dari dashboard?',
                          style: TextStyle(
                            color: Color(0xff2F2966),
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sesi pengajar akan ditutup.',
                          style: TextStyle(
                            color: Color(0xff6D6A95),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffFFF1F4),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xffFFD5DE)),
                ),
                child: const Text(
                  'Konten yang sudah disimpan tetap aman. Kamu bisa masuk lagi untuk lanjut mengelola materi kapan saja.',
                  style: TextStyle(
                    color: Color(0xff6B5570),
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        side: const BorderSide(color: Color(0xffE6E0FF)),
                        foregroundColor: const Color(0xff6D6A95),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Tetap di sini',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        backgroundColor: const Color(0xffFF5D73),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Ya, keluar',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeacherToolHeader extends StatelessWidget {
  const _TeacherToolHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 620;
        final titleBlock = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 52,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: color),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TeacherSectionTitle(title: title, subtitle: subtitle),
            ),
          ],
        );
        final button = FilledButton.icon(
          onPressed: onAction,
          style: FilledButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: narrow ? 12 : 18,
              vertical: narrow ? 14 : 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(narrow ? 18 : 22),
            ),
          ),
          icon: const Icon(Icons.add_rounded),
          label: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              actionLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: narrow ? 13 : 14),
            ),
          ),
        );
        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleBlock,
              const SizedBox(height: 14),
              SizedBox(width: double.infinity, child: button),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: titleBlock),
            const SizedBox(width: 12),
            button,
          ],
        );
      },
    );
  }
}

class _TeacherEmptyTool extends StatelessWidget {
  const _TeacherEmptyTool({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: const Color(0xffFCFBFF),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withValues(alpha: .16)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Color(0xff322A64),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeacherBlendCard extends StatelessWidget {
  const _TeacherBlendCard({
    required this.item,
    required this.usedCount,
    required this.onEdit,
    required this.onPreview,
    required this.onDelete,
  });

  final _LetterBlendItem item;
  final int usedCount;
  final VoidCallback onEdit;
  final VoidCallback onPreview;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xffF97316);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .90),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: color.withValues(alpha: .10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...item.letters.map(
                (letter) => _MiniLetterTile(label: _letterPair(letter)),
              ),
              const Icon(Icons.arrow_forward_rounded, color: Color(0xff8B87AC)),
              _BlendPill(label: item.label, large: true),
            ],
          ),
          const SizedBox(height: 10),
          _TeacherStatusPill(
            label: usedCount == 0 ? 'Belum dipakai' : 'Dipakai $usedCount kata',
            background: color.withValues(alpha: .10),
            foreground: color,
          ),
          const Spacer(),
          Wrap(
            spacing: 8,
            children: [
              _TeacherActionButton(
                icon: Icons.visibility_rounded,
                color: color,
                onTap: onPreview,
              ),
              _TeacherActionButton(
                icon: Icons.edit_rounded,
                color: const Color(0xff38BDF8),
                onTap: onEdit,
              ),
              _TeacherActionButton(
                icon: Icons.delete_outline_rounded,
                color: const Color(0xffFB7185),
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeacherWordCard extends StatelessWidget {
  const _TeacherWordCard({
    required this.item,
    required this.onEdit,
    required this.onPreview,
    required this.onDelete,
  });

  final _WordAssemblyItem item;
  final VoidCallback onEdit;
  final VoidCallback onPreview;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xffEC4899);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .90),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: color.withValues(alpha: .10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.target,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xff2F2966),
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xff6D6A95),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._compactUnits(
                item.units,
                maxVisible: 3,
              ).map((unit) => _UnitChip(unit: unit, showTypeLabel: true)),
              if (item.units.length > 3)
                _OverflowUnitChip(extraCount: item.units.length - 3),
            ],
          ),
          const Spacer(),
          Wrap(
            spacing: 8,
            children: [
              _TeacherActionButton(
                icon: Icons.play_arrow_rounded,
                color: color,
                onTap: onPreview,
              ),
              _TeacherActionButton(
                icon: Icons.edit_rounded,
                color: const Color(0xff38BDF8),
                onTap: onEdit,
              ),
              _TeacherActionButton(
                icon: Icons.delete_outline_rounded,
                color: const Color(0xffFB7185),
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniLetterTile extends StatelessWidget {
  const _MiniLetterTile({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xff8B5CF6);
    return Container(
      width: 46,
      height: 46,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: selected ? .18 : .10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: selected ? .45 : .18),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
      ),
    );
  }
}

class _UnitChip extends StatelessWidget {
  const _UnitChip({required this.unit, this.showTypeLabel = false});

  final _WordUnitData unit;
  final bool showTypeLabel;

  @override
  Widget build(BuildContext context) {
    final color = unit.type == _WordUnitType.blend
        ? const Color(0xffF97316)
        : const Color(0xff8B5CF6);
    final radius = unit.type == _WordUnitType.blend ? 999.0 : 16.0;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: unit.type == _WordUnitType.blend ? 16 : 12,
        vertical: showTypeLabel ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: color.withValues(alpha: .24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            unit.display,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: unit.type == _WordUnitType.blend ? 17 : 16,
            ),
          ),
          if (showTypeLabel) ...[
            const SizedBox(height: 2),
            Text(
              unit.type == _WordUnitType.blend ? 'Rangkaian' : 'Abjad',
              style: TextStyle(
                color: color.withValues(alpha: .82),
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

List<_WordUnitData> _compactUnits(
  List<_WordUnitData> units, {
  required int maxVisible,
}) {
  if (units.length <= maxVisible) return units;
  return units.take(maxVisible).toList();
}

class _OverflowUnitChip extends StatelessWidget {
  const _OverflowUnitChip({required this.extraCount});

  final int extraCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffEC4899).withValues(alpha: .10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xffEC4899).withValues(alpha: .24),
        ),
      ),
      child: Text(
        '+$extraCount',
        style: const TextStyle(
          color: Color(0xffEC4899),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _BlendPill extends StatelessWidget {
  const _BlendPill({required this.label, this.large = false});

  final String label;
  final bool large;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xffF97316);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 18 : 14,
        vertical: large ? 10 : 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .28)),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: large ? 30 : 20,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _TeacherPreviewDialog extends StatelessWidget {
  const _TeacherPreviewDialog({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: _TeacherSurfaceCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xff2F2966),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _BlendPreview extends StatelessWidget {
  const _BlendPreview({required this.item});

  final _LetterBlendItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xffFFF7ED),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...item.letters.map(
            (letter) => _MiniLetterTile(label: _letterPair(letter)),
          ),
          const Icon(Icons.arrow_forward_rounded, color: Color(0xffF97316)),
          _BlendPill(label: item.label, large: true),
        ],
      ),
    );
  }
}

class _WordTapPreview extends StatefulWidget {
  const _WordTapPreview({required this.item});

  final _WordAssemblyItem item;

  @override
  State<_WordTapPreview> createState() => _WordTapPreviewState();
}

class _WordTapPreviewState extends State<_WordTapPreview> {
  late List<_WordUnitData> _choices;
  final List<_WordUnitData> _filled = [];

  @override
  void initState() {
    super.initState();
    _choices = [...widget.item.units]..shuffle(Random(widget.item.id.hashCode));
  }

  @override
  Widget build(BuildContext context) {
    final complete = _filled.length == widget.item.units.length;
    final correct =
        complete &&
        List.generate(
          widget.item.units.length,
          (i) =>
              widget.item.units[i].value == _filled[i].value &&
              widget.item.units[i].type == _filled[i].type,
        ).every((ok) => ok);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xffFFF4FA),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.item.target,
            style: const TextStyle(
              color: Color(0xff2F2966),
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: List.generate(widget.item.units.length, (index) {
              final filled = index < _filled.length ? _filled[index] : null;
              return Container(
                width: 82,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xffF9A8D4)),
                ),
                child: filled == null
                    ? null
                    : FittedBox(child: _UnitChip(unit: filled)),
              );
            }),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _choices.map((unit) {
              final used = _filled.contains(unit);
              return Opacity(
                opacity: used ? .35 : 1,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: used || complete
                      ? null
                      : () => setState(() => _filled.add(unit)),
                  child: _UnitChip(unit: unit),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: _filled.isEmpty
                    ? null
                    : () => setState(() => _filled.removeLast()),
                icon: const Icon(Icons.undo_rounded),
                label: const Text('Undo'),
              ),
              FilledButton.icon(
                onPressed: () => setState(() => _filled.clear()),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xffEC4899),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reset'),
              ),
            ],
          ),
          if (complete) ...[
            const SizedBox(height: 12),
            Text(
              correct ? 'Urutan benar' : 'Urutan belum tepat',
              style: TextStyle(
                color: correct
                    ? const Color(0xff16A34A)
                    : const Color(0xffF43F5E),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LetterBlendDialog extends StatefulWidget {
  const _LetterBlendDialog({
    required this.letters,
    required this.existingLabels,
    this.existing,
  });

  final List<String> letters;
  final Set<String> existingLabels;
  final _LetterBlendItem? existing;

  @override
  State<_LetterBlendDialog> createState() => _LetterBlendDialogState();
}

class _LetterBlendDialogState extends State<_LetterBlendDialog> {
  late final List<String> _selected;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selected = [...?widget.existing?.letters];
  }

  @override
  Widget build(BuildContext context) {
    final result = _selected.join();
    void save() {
      if (_selected.length != 2) {
        setState(() => _error = 'Pilih tepat 2 abjad.');
        return;
      }
      if (widget.existingLabels.contains(result)) {
        setState(() => _error = '$result sudah ada.');
        return;
      }
      Navigator.of(context).pop(
        _LetterBlendItem(
          id: widget.existing?.id ?? _newLocalId('blend'),
          letters: [..._selected],
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 760,
          maxHeight: MediaQuery.sizeOf(context).height * .88,
        ),
        child: _TeacherSurfaceCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dialogTitle(
                        context,
                        widget.existing == null
                            ? 'Tambah Rangkaian Abjad'
                            : 'Edit Rangkaian Abjad',
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: widget.letters.map((item) {
                          final letter = _normalizeLabel(item);
                          final selected = _selected.contains(letter);
                          return InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              setState(() {
                                _error = null;
                                if (selected) {
                                  _selected.remove(letter);
                                } else if (_selected.length < 2) {
                                  _selected.add(letter);
                                }
                              });
                            },
                            child: _MiniLetterTile(
                              label: _letterPair(letter),
                              selected: selected,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFF7ED),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              'Hasil: ',
                              style: TextStyle(
                                color: Color(0xff6D6A95),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            if (_selected.isEmpty)
                              const Text(
                                '-',
                                style: TextStyle(
                                  color: Color(0xff2F2966),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            else ...[
                              ..._selected.map(
                                (letter) => _MiniLetterTile(
                                  label: _letterPair(letter),
                                  selected: false,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Color(0xffF97316),
                              ),
                              _BlendPill(
                                label: result.isEmpty ? '-' : result,
                                large: false,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (_error != null) _DialogError(text: _error!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _dialogActions(context, onSave: save),
            ],
          ),
        ),
      ),
    );
  }
}

class _WordAssemblyDialog extends StatefulWidget {
  const _WordAssemblyDialog({
    required this.letters,
    required this.blends,
    required this.existingTargets,
    this.existing,
  });

  final List<String> letters;
  final List<_LetterBlendItem> blends;
  final Set<String> existingTargets;
  final _WordAssemblyItem? existing;

  @override
  State<_WordAssemblyDialog> createState() => _WordAssemblyDialogState();
}

class _WordAssemblyDialogState extends State<_WordAssemblyDialog> {
  late final TextEditingController _name;
  late final List<_WordUnitData> _units;
  int _tab = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.name ?? '');
    _units = [...?widget.existing?.units];
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final target = _units.map((unit) => unit.value).join();
    final source = _tab == 0
        ? widget.letters
              .map((letter) => _WordUnitData(_WordUnitType.letter, letter))
              .toList()
        : widget.blends
              .map((blend) => _WordUnitData(_WordUnitType.blend, blend.label))
              .toList();
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: _TeacherSurfaceCard(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dialogTitle(
                  context,
                  widget.existing == null
                      ? 'Tambah Merangkai Kata'
                      : 'Edit Merangkai Kata',
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _name,
                  decoration: InputDecoration(
                    labelText: 'Nama aktivitas (opsional)',
                    hintText: target.isEmpty ? 'Otomatis dari kata' : target,
                    prefixIcon: const Icon(
                      Icons.drive_file_rename_outline_rounded,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('Abjad Dasar')),
                    ButtonSegment(value: 1, label: Text('Rangkaian Abjad')),
                  ],
                  selected: {_tab},
                  onSelectionChanged: (value) =>
                      setState(() => _tab = value.first),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: source.map((unit) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => setState(() {
                        _error = null;
                        _units.add(unit);
                      }),
                      child: _UnitChip(unit: unit, showTypeLabel: true),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                _DialogPreviewLine(
                  label: 'Target kata',
                  value: target.isEmpty ? '-' : target,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._units.asMap().entries.map((entry) {
                      final unit = entry.value;
                      final color = unit.type == _WordUnitType.blend
                          ? const Color(0xffF97316)
                          : const Color(0xff8B5CF6);
                      return InputChip(
                        backgroundColor: color.withValues(alpha: .10),
                        side: BorderSide(color: color.withValues(alpha: .24)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            unit.type == _WordUnitType.blend ? 999 : 16,
                          ),
                        ),
                        label: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              unit.display,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              unit.type == _WordUnitType.blend
                                  ? 'Rangkaian'
                                  : 'Abjad',
                              style: TextStyle(
                                color: color.withValues(alpha: .82),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        onDeleted: () =>
                            setState(() => _units.removeAt(entry.key)),
                      );
                    }),
                    if (_units.isNotEmpty)
                      ActionChip(
                        avatar: const Icon(Icons.undo_rounded, size: 18),
                        label: const Text('Undo'),
                        onPressed: () => setState(() => _units.removeLast()),
                      ),
                  ],
                ),
                if (_error != null) _DialogError(text: _error!),
                const SizedBox(height: 18),
                _dialogActions(
                  context,
                  onSave: () {
                    if (_units.isEmpty) {
                      setState(() => _error = 'Pilih minimal satu unit.');
                      return;
                    }
                    if (widget.existingTargets.contains(target)) {
                      setState(() => _error = '$target sudah ada.');
                      return;
                    }
                    final name = _name.text.trim().isEmpty
                        ? target
                        : _name.text.trim();
                    Navigator.of(context).pop(
                      _WordAssemblyItem(
                        id: widget.existing?.id ?? _newLocalId('word'),
                        name: name,
                        units: [..._units],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _dialogTitle(BuildContext context, String title) {
  return Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xff2F2966),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.close_rounded),
      ),
    ],
  );
}

Widget _dialogActions(BuildContext context, {required VoidCallback onSave}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final narrow = constraints.maxWidth < 320;
      final cancel = OutlinedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: narrow ? 10 : 14,
            vertical: 13,
          ),
        ),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Batal', maxLines: 1),
        ),
      );
      final save = FilledButton.icon(
        onPressed: onSave,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xff8B5CF6),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: narrow ? 10 : 14,
            vertical: 13,
          ),
        ),
        icon: const Icon(Icons.save_rounded, size: 18),
        label: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Simpan', maxLines: 1),
        ),
      );
      if (narrow) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: double.infinity, child: cancel),
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, child: save),
          ],
        );
      }
      return Row(
        children: [
          Expanded(child: cancel),
          const SizedBox(width: 12),
          Expanded(child: save),
        ],
      );
    },
  );
}

class _DialogPreviewLine extends StatelessWidget {
  const _DialogPreviewLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffF7F3FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Color(0xff6D6A95),
              fontWeight: FontWeight.w900,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xff2F2966),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogError extends StatelessWidget {
  const _DialogError({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xffE11D48),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _TeacherSurfaceCard extends StatelessWidget {
  const _TeacherSurfaceCard({
    required this.child,
    required this.padding,
    this.inner = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool inner;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(inner ? 26 : 32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: inner ? .86 : .78),
            borderRadius: BorderRadius.circular(inner ? 26 : 32),
            border: Border.all(color: Colors.white, width: 1.4),
            boxShadow: [
              BoxShadow(
                blurRadius: inner ? 16 : 24,
                offset: const Offset(0, 12),
                color: const Color(0xff8B5CF6).withValues(alpha: .08),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

const _letterBlendsPrefsKey = 'teacher.letter_blends.v1';
const _wordAssembliesPrefsKey = 'teacher.word_assemblies.v1';

String _newLocalId(String prefix) =>
    '${prefix}_${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(9999)}';

String _normalizeLabel(String value) => value.trim().toUpperCase();

String _letterPair(String value) {
  final normalized = _normalizeLabel(value);
  if (normalized.isEmpty) return '';
  return '$normalized${normalized.toLowerCase()}';
}

List<_LetterBlendItem> _decodeLetterBlends(String? raw) {
  if (raw == null || raw.trim().isEmpty) return const [];
  try {
    final data = jsonDecode(raw);
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map(
          (item) => _LetterBlendItem.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.letters.length == 2)
        .toList();
  } catch (_) {
    return const [];
  }
}

List<_WordAssemblyItem> _decodeWordAssemblies(String? raw) {
  if (raw == null || raw.trim().isEmpty) return const [];
  try {
    final data = jsonDecode(raw);
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map(
          (item) => _WordAssemblyItem.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.units.isNotEmpty)
        .toList();
  } catch (_) {
    return const [];
  }
}

class _LetterBlendItem {
  const _LetterBlendItem({required this.id, required this.letters});

  final String id;
  final List<String> letters;

  factory _LetterBlendItem.fromModel(RangkaiItemModel model) {
    return _LetterBlendItem(
      id: model.id,
      letters: model.pieces.map(_normalizeLabel).toList(),
    );
  }

  String get label => letters.map(_normalizeLabel).join();

  Map<String, dynamic> toJson() => {
    'id': id,
    'letters': letters.map(_normalizeLabel).toList(),
  };

  RangkaiItemModel toModel() {
    return RangkaiItemModel(
      id: id,
      type: 'suku_kata',
      title: label,
      target: label,
      pieces: letters.map(_normalizeLabel).toList(),
      units: const [],
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }

  factory _LetterBlendItem.fromJson(Map<String, dynamic> json) {
    final letters = (json['letters'] as List? ?? const [])
        .map((item) => _normalizeLabel('$item'))
        .where((item) => item.isNotEmpty)
        .toList();
    return _LetterBlendItem(
      id: '${json['id'] ?? _newLocalId('blend')}',
      letters: letters,
    );
  }
}

enum _WordUnitType { letter, blend }

class _WordUnitData {
  const _WordUnitData(this.type, this.value);

  final _WordUnitType type;
  final String value;

  String get display =>
      type == _WordUnitType.letter ? _letterPair(value) : value;

  Map<String, dynamic> toJson() => {'type': type.name, 'value': value};

  factory _WordUnitData.fromJson(Map<String, dynamic> json) {
    final type = json['type'] == 'blend'
        ? _WordUnitType.blend
        : _WordUnitType.letter;
    return _WordUnitData(type, _normalizeLabel('${json['value'] ?? ''}'));
  }
}

class _WordAssemblyItem {
  const _WordAssemblyItem({
    required this.id,
    required this.name,
    required this.units,
  });

  final String id;
  final String name;
  final List<_WordUnitData> units;

  factory _WordAssemblyItem.fromModel(RangkaiItemModel model) {
    final units = model.units
        .map(_WordUnitData.fromJson)
        .where((item) => item.value.isNotEmpty)
        .toList();
    if (units.isEmpty) {
      final pieces = model.pieces
          .map((piece) => _WordUnitData(_WordUnitType.letter, piece))
          .toList();
      return _WordAssemblyItem(
        id: model.id,
        name: model.title.isEmpty ? model.target : model.title,
        units: pieces,
      );
    }
    return _WordAssemblyItem(
      id: model.id,
      name: model.title.isEmpty ? model.target : model.title,
      units: units,
    );
  }

  String get target => units.map((unit) => unit.value).join();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'units': units.map((unit) => unit.toJson()).toList(),
  };

  RangkaiItemModel toModel() {
    return RangkaiItemModel(
      id: id,
      type: 'kata',
      title: name,
      target: target,
      pieces: units.map((unit) => unit.value).toList(),
      units: units.map((unit) => unit.toJson()).toList(),
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }

  factory _WordAssemblyItem.fromJson(Map<String, dynamic> json) {
    final units = (json['units'] as List? ?? const [])
        .whereType<Map>()
        .map((item) => _WordUnitData.fromJson(Map<String, dynamic>.from(item)))
        .where((item) => item.value.isNotEmpty)
        .toList();
    final target = units.map((unit) => unit.value).join();
    final name = '${json['name'] ?? ''}'.trim();
    return _WordAssemblyItem(
      id: '${json['id'] ?? _newLocalId('word')}',
      name: name.isEmpty ? target : name,
      units: units,
    );
  }
}

class _TeacherSummaryCardData {
  const _TeacherSummaryCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.background,
    this.value,
    this.valueFuture,
  });

  final String title;
  final String? value;
  final Future<int>? valueFuture;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<Color> background;
}

class _TeacherContentData {
  const _TeacherContentData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.statusLabel,
    required this.mediaPath,
    required this.color,
    required this.icon,
    required this.badgeText,
    required this.actionLabel,
    required this.editable,
    this.object,
    this.song,
    this.letter,
    this.number,
  });

  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String statusLabel;
  final String mediaPath;
  final Color color;
  final IconData icon;
  final String badgeText;
  final String actionLabel;
  final bool editable;
  final LearningObject? object;
  final SongItem? song;
  final LetterGroup? letter;
  final NumberItem? number;
}

class _TeacherDraftResult {
  const _TeacherDraftResult({
    required this.title,
    required this.subtitle,
    required this.mediaPath,
    required this.mediaType,
    this.fileName,
  });

  final String title;
  final String subtitle;
  final String mediaPath;
  final String mediaType;
  final String? fileName;
}

class _TeacherActivity {
  const _TeacherActivity({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final DateTime timestamp;
  final IconData icon;
  final Color color;
}

class _TeacherStorageData {
  const _TeacherStorageData({
    required this.totalBytes,
    required this.capacityBytes,
    required this.segments,
  });

  const _TeacherStorageData.loading()
    : totalBytes = 0,
      capacityBytes = 5 * 1024 * 1024 * 1024,
      segments = const [
        _TeacherStorageSegment(
          label: 'Gambar',
          bytes: 0,
          color: Color(0xff8B5CF6),
          icon: Icons.image_rounded,
        ),
        _TeacherStorageSegment(
          label: 'Audio',
          bytes: 0,
          color: Color(0xff22C55E),
          icon: Icons.audiotrack_rounded,
        ),
        _TeacherStorageSegment(
          label: 'Video',
          bytes: 0,
          color: Color(0xff38BDF8),
          icon: Icons.video_library_rounded,
        ),
      ];

  final int totalBytes;
  final int capacityBytes;
  final List<_TeacherStorageSegment> segments;

  double get usage => (totalBytes / capacityBytes).clamp(0, 1).toDouble();
}

class _TeacherStorageSegment {
  const _TeacherStorageSegment({
    required this.label,
    required this.bytes,
    required this.color,
    required this.icon,
  });

  final String label;
  final int bytes;
  final Color color;
  final IconData icon;
}
