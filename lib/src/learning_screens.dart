part of '../main.dart';

class BelajarScreen extends ConsumerStatefulWidget {
  const BelajarScreen({super.key});

  @override
  ConsumerState<BelajarScreen> createState() => _BelajarScreenState();
}

class _BelajarScreenState extends ConsumerState<BelajarScreen> {
  bool readingHelp = false;

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final body = modeBody(app);
    return switch (app.learnMode) {
      LearnMode.menu ||
      LearnMode.huruf ||
      LearnMode.sukuKata ||
      LearnMode.rangkaiKata ||
      LearnMode.angka ||
      LearnMode.benda ||
      LearnMode.iqra => body,
    };
  }

  Widget modeBody(AppState app) {
    return switch (app.learnMode) {
      LearnMode.huruf => const HurufScreen(),
      LearnMode.sukuKata => const SukuKataScreen(),
      LearnMode.rangkaiKata => const RangkaiKataScreen(),
      LearnMode.angka => const AngkaScreen(),
      LearnMode.benda => const BendaScreen(),
      LearnMode.iqra => IqraLesson(
        readingHelp: readingHelp,
        onToggle: () => setState(() => readingHelp = !readingHelp),
      ),
      LearnMode.menu => const LearnMenu(),
    };
  }
}

class LearnMenu extends ConsumerWidget {
  const LearnMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    final t = app.theme;
    final size = MediaQuery.sizeOf(context);
    final tablet = size.width >= 700;
    final mascot = app.gender == Gender.girl
        ? 'assets/images/Anak_Perempuan_Menu.png'
        : 'assets/images/Anak_LakiLaki_Menu.png';
    final cards = [
      _AdventureData(
        'MEMBACA',
        'A sampai Z',
        'assets/images/Logo_membaca.png',
        const Color(0xffFFE2ED),
        const Color(0xffF65391),
        LearnMode.huruf,
      ),
      _AdventureData(
        'SUKU KATA',
        'Gabungan abjad',
        'assets/images/logo_Suku_kata.png',
        const Color(0xffFFF0D9),
        const Color(0xffF97316),
        LearnMode.sukuKata,
      ),
      _AdventureData(
        'MERANGKAI KATA',
        'Latihan merangkai kata',
        'assets/images/log_merangkai_kata.png',
        const Color(0xffFFE2F0),
        const Color(0xffEC4899),
        LearnMode.rangkaiKata,
      ),
      _AdventureData(
        'ANGKA',
        '1 sampai 10',
        'assets/images/Logo_123.png',
        const Color(0xffDDF4FF),
        const Color(0xff279AF3),
        LearnMode.angka,
      ),
      _AdventureData(
        'BENDA',
        'Mengenal berbagai benda di sekitar kita',
        'assets/images/Logo_Benda.png',
        const Color(0xffE3F8D8),
        const Color(0xff32C653),
        LearnMode.benda,
      ),
      _AdventureData(
        'IQRA',
        'Hijaiyah dasar',
        'assets/images/Logo_iqra.png',
        const Color(0xffEBDDFF),
        const Color(0xff9656F4),
        LearnMode.iqra,
      ),
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          t.night
              ? 'assets/images/Background_Image_Malam.png'
              : 'assets/images/Background_image.png',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: t.night
                  ? [
                      NightPalette.midnight.withValues(alpha: .12),
                      NightPalette.purple.withValues(alpha: .50),
                      NightPalette.midnight.withValues(alpha: .82),
                    ]
                  : [
                      Colors.white.withValues(alpha: .02),
                      const Color(0xffEAF8FF).withValues(alpha: .58),
                      Colors.white.withValues(alpha: .82),
                    ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        ...List.generate(t.night ? 26 : 18, (i) {
          final left = (i * 67 % max(1, size.width.toInt())).toDouble();
          final top = 42.0 + (i * 53 % 520);
          return Positioned(
            left: left,
            top: top,
            child:
                Icon(
                      i.isEven
                          ? Icons.star_rounded
                          : Icons.auto_awesome_rounded,
                      color:
                          (t.night
                                  ? [
                                      NightPalette.cyan,
                                      NightPalette.gold,
                                      NightPalette.lavender,
                                    ][i % 3]
                                  : Colors.white)
                              .withValues(alpha: t.night ? .52 : .86),
                      size: i.isEven ? 18 : 13,
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(.72, .72),
                      end: const Offset(1.12, 1.12),
                      duration: (900 + i * 70).ms,
                    ),
          );
        }),
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: tablet ? 980 : 560),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  tablet ? 28 : 18,
                  18,
                  tablet ? 28 : 18,
                  126,
                ),
                children: [
                  _AdventureTopBar(
                    stars: app.stars,
                    onBack: () => ref.read(appStateProvider).go(TabItem.main),
                  ),
                  SizedBox(height: tablet ? 10 : 18),
                  _AdventureHero(mascot: mascot, tablet: tablet),
                  SizedBox(height: tablet ? 24 : 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: tablet ? 4 : 2,
                      mainAxisSpacing: tablet ? 18 : 14,
                      crossAxisSpacing: tablet ? 18 : 14,
                      childAspectRatio: tablet ? .84 : .77,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (context, i) => _AdventureCard(
                      data: cards[i],
                      delay: i * 90,
                      onTap: () =>
                          ref.read(appStateProvider).openLearn(cards[i].mode),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _AdventureMotivation(mascot: mascot),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdventureTopBar extends StatelessWidget {
  const _AdventureTopBar({required this.stars, required this.onBack});
  final int stars;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Row(
      children: [
        _AdventureGlassButton(icon: Icons.chevron_left_rounded, onTap: onBack),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: t.night
                ? NightPalette.surface.withValues(alpha: .70)
                : Colors.white.withValues(alpha: .93),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: t.night
                  ? NightPalette.gold.withValues(alpha: .30)
                  : Colors.white,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 9),
                color: (t.night ? NightPalette.gold : const Color(0xff4EA7DB))
                    .withValues(alpha: .18),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xffFFC928),
                size: 30,
              ),
              const SizedBox(width: 7),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$stars',
                    style: TextStyle(
                      color: t.night
                          ? NightPalette.text
                          : const Color(0xff3B3D86),
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Poin Kamu',
                    style: TextStyle(
                      color: t.night
                          ? NightPalette.muted
                          : const Color(0xff5A6090),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdventureHero extends StatelessWidget {
  const _AdventureHero({required this.mascot, required this.tablet});
  final String mascot;
  final bool tablet;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tablet ? 170 : 278,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            left: tablet ? 170 : 14,
            right: tablet ? 170 : 14,
            child:
                Image.asset(
                      'assets/images/Pusat_petualangan.png',
                      height: tablet ? 128 : 110,
                      fit: BoxFit.contain,
                    )
                    .animate()
                    .fadeIn(duration: 380.ms)
                    .scale(begin: const Offset(.92, .92)),
          ),
          Positioned(
            right: tablet ? 58 : 8,
            bottom: -6,
            child:
                Image.asset(
                      mascot,
                      height: tablet ? 170 : 134,
                      fit: BoxFit.contain,
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: -5, end: 5, duration: 1700.ms),
          ),
        ],
      ),
    );
  }
}

class _AdventureCard extends StatelessWidget {
  const _AdventureCard({
    required this.data,
    required this.delay,
    required this.onTap,
  });
  final _AdventureData data;
  final int delay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(34),
        child: Ink(
          decoration: BoxDecoration(
            color: t.night
                ? Color.lerp(data.bg, NightPalette.surface, .55)
                : data.bg,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: t.night ? data.color.withValues(alpha: .46) : Colors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: const Offset(0, 12),
                color: data.color.withValues(alpha: t.night ? .34 : .20),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(31),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: .25),
                              data.bg.withValues(alpha: .15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 10,
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white.withValues(alpha: .84),
                        size: 18,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 2, 6, 0),
                        child: Transform.scale(
                          scale: 1.16,
                          child: Image.asset(data.asset, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
                decoration: BoxDecoration(
                  color: t.night
                      ? NightPalette.purple.withValues(alpha: .70)
                      : Colors.white.withValues(alpha: .78),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(31),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: data.color,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            data.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: t.night
                                  ? NightPalette.muted
                                  : const Color(0xff4D5179),
                              fontSize: 12,
                              height: 1.2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: data.color,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                                color: data.color.withValues(alpha: .32),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(
                          begin: const Offset(.95, .95),
                          end: const Offset(1.07, 1.07),
                          duration: 1200.ms,
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: .07);
  }
}

class _AdventureMotivation extends StatelessWidget {
  const _AdventureMotivation({required this.mascot});
  final String mascot;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
      decoration: BoxDecoration(
        color: t.night
            ? NightPalette.surface.withValues(alpha: .70)
            : Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: t.night
              ? NightPalette.gold.withValues(alpha: .28)
              : Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: (t.night ? NightPalette.gold : const Color(0xff6AAFE6))
                .withValues(alpha: .18),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(mascot, width: 72, fit: BoxFit.contain),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: t.night
                    ? NightPalette.purple.withValues(alpha: .62)
                    : const Color(0xffF1EAFF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                'Terus belajar ya! Setiap langkah kecil membawamu jadi hebat!',
                style: TextStyle(
                  color: t.night ? NightPalette.text : const Color(0xff4A3B8F),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  height: 1.25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdventureGlassButton extends StatelessWidget {
  const _AdventureGlassButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: t.night
              ? NightPalette.surface.withValues(alpha: .72)
              : Colors.white.withValues(alpha: .88),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 58,
              height: 58,
              child: Icon(
                icon,
                color: t.night ? NightPalette.cyan : const Color(0xff8B55F6),
                size: 34,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdventureData {
  const _AdventureData(
    this.title,
    this.subtitle,
    this.asset,
    this.bg,
    this.color,
    this.mode,
  );
  final String title;
  final String subtitle;
  final String asset;
  final Color bg;
  final Color color;
  final LearnMode mode;
}

class HurufScreen extends ConsumerStatefulWidget {
  const HurufScreen({super.key});

  @override
  ConsumerState<HurufScreen> createState() => _HurufScreenState();
}

class _HurufScreenState extends ConsumerState<HurufScreen> {
  final search = TextEditingController();
  final _tts = FlutterTts();
  int pageIndex = 0;
  String category = 'Semua';

  @override
  void initState() {
    super.initState();
    unawaited(_setupTts());
  }

  @override
  void dispose() {
    search.dispose();
    unawaited(_tts.stop());
    super.dispose();
  }

  Future<void> _setupTts() async {
    try {
      await _configureTts(_tts, 'id-ID');
    } catch (_) {}
  }

  Future<void> _speakLetter(String letter) async {
    try {
      await _speakTts(_tts, letter.toLowerCase(), language: 'id-ID');
    } catch (_) {}
    await ref.read(appStateProvider).markHurfViewed(letter);
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final query = search.text.toLowerCase().trim();
    final filtered = _fixedLatinLetters.where((letter) {
      final isVowel = 'AIUEO'.contains(letter);
      final categoryOk =
          category == 'Semua' ||
          (category == 'Vokal' && isVowel) ||
          (category == 'Konsonan' && !isVowel);
      final queryOk = query.isEmpty || letter.toLowerCase().contains(query);
      return categoryOk && queryOk;
    }).toList();
    return _PremiumLearningScaffold(
      titleAsset: 'assets/images/Belajar_huruf.png',
      mascotAsset: 'assets/images/Anak_Belajar_Huruf.png',
      fallbackTitle: 'Belajar',
      subtitle: tr(context, 'Ayo mengenal abjad besar dan kecil!'),
      accent: const Color(0xffFF8F1F),
      stars: app.stars,
      onBack: () => ref.read(appStateProvider).openLearn(LearnMode.menu),
      chips: const ['Semua', 'Vokal', 'Konsonan'],
      selectedChip: category,
      onChip: (value) => setState(() {
        category = value;
        pageIndex = 0;
      }),
      search: search,
      searchHint: tr(context, 'Cari...'),
      onSearch: () => setState(() => pageIndex = 0),
      itemCount: filtered.length,
      pageIndex: pageIndex,
      onPage: (next) => setState(() => pageIndex = next),
      itemBuilder: (context, itemIndex, color) {
        final letter = filtered[itemIndex];
        final mastered = app.hurfMastered.contains(progressMasteryKey(letter));
        return _PremiumLearningCard(
          color: color,
          title: letter,
          subtitle: letter.toLowerCase(),
          caption: '',
          imageUrl: '',
          badge: '',
          kind: _PremiumCardKind.letter,
          mastered: mastered,
          onTap: () => unawaited(_speakLetter(letter)),
        );
      },
    );
  }
}

class SukuKataScreen extends ConsumerStatefulWidget {
  const SukuKataScreen({super.key});

  @override
  ConsumerState<SukuKataScreen> createState() => _SukuKataScreenState();
}

class _SukuKataScreenState extends ConsumerState<SukuKataScreen> {
  final search = TextEditingController();
  final _tts = FlutterTts();
  List<_LetterBlendItem> items = const [];
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_setupTts());
    unawaited(_loadItems());
  }

  @override
  void dispose() {
    search.dispose();
    unawaited(_tts.stop());
    super.dispose();
  }

  Future<void> _setupTts() async {
    try {
      await _configureTts(_tts, 'id-ID');
    } catch (_) {}
  }

  Future<void> _loadItems() async {
    final loaded = await _loadRangkaiItems();
    final blends = loaded
        .where((item) => item.type == 'suku_kata' || item.type == 'abjad')
        .map(_LetterBlendItem.fromModel)
        .where((item) => item.letters.length == 2)
        .toList();
    if (!mounted) return;
    setState(() => items = blends);
    ref
        .read(appStateProvider)
        .setRangkaiLearningTotals(sukuKata: blends.length);
  }

  Future<void> _speak(_LetterBlendItem item) async {
    try {
      await _speakTts(_tts, item.label.toLowerCase(), language: 'id-ID');
    } catch (_) {}
    await ref
        .read(appStateProvider)
        .markSukuKataViewed(item.id, total: items.length);
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final query = search.text.toLowerCase().trim();
    final filtered = items
        .where(
          (item) => query.isEmpty || item.label.toLowerCase().contains(query),
        )
        .toList();
    return _PremiumLearningScaffold(
      titleAsset: 'assets/images/Belajar_huruf.png',
      mascotAsset: 'assets/images/Anak_Belajar_Huruf.png',
      fallbackTitle: 'Suku Kata',
      subtitle: 'Dengarkan gabungan abjad dari pengajar!',
      accent: const Color(0xffF97316),
      stars: app.stars,
      onBack: () => ref.read(appStateProvider).openLearn(LearnMode.menu),
      chips: const ['Semua'],
      selectedChip: 'Semua',
      onChip: (_) => setState(() => pageIndex = 0),
      search: search,
      searchHint: 'Cari suku kata...',
      onSearch: () => setState(() => pageIndex = 0),
      emptyText: 'Belum ada materi dari pengajar.',
      itemCount: filtered.length,
      pageIndex: pageIndex,
      onPage: (next) => setState(() => pageIndex = next),
      itemBuilder: (context, itemIndex, color) {
        final item = filtered[itemIndex];
        return _RangkaiLearningCard(
          color: color,
          title: item.label,
          subtitle: item.letters.map(_letterPair).join(' + '),
          badge: 'Suku Kata',
          icon: Icons.volume_up_rounded,
          mastered: app.sukuKataMastered.contains(progressMasteryKey(item.id)),
          onTap: () => unawaited(_speak(item)),
        );
      },
    );
  }
}

class RangkaiKataScreen extends ConsumerStatefulWidget {
  const RangkaiKataScreen({super.key});

  @override
  ConsumerState<RangkaiKataScreen> createState() => _RangkaiKataScreenState();
}

class _RangkaiKataScreenState extends ConsumerState<RangkaiKataScreen> {
  final search = TextEditingController();
  List<_WordAssemblyItem> items = const [];
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_loadItems());
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    final loaded = await _loadRangkaiItems();
    final words = loaded
        .where((item) => item.type == 'kata')
        .map(_WordAssemblyItem.fromModel)
        .where((item) => item.units.isNotEmpty)
        .toList();
    if (!mounted) return;
    setState(() => items = words);
    ref
        .read(appStateProvider)
        .setRangkaiLearningTotals(rangkaiKata: words.length);
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final query = search.text.toLowerCase().trim();
    final filtered = items.where((item) {
      return query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.target.toLowerCase().contains(query);
    }).toList();
    return _PremiumLearningScaffold(
      titleAsset: 'assets/images/belajar_merangkai_kata.png',
      mascotAsset: 'assets/images/Anak_Belajar_Huruf.png',
      fallbackTitle: 'Merangkai Kata',
      subtitle: 'Tekan kata, susun potongan, lalu kumpulkan poin!',
      accent: const Color(0xffEC4899),
      stars: app.stars,
      onBack: () => ref.read(appStateProvider).openLearn(LearnMode.menu),
      chips: const ['Semua'],
      selectedChip: 'Semua',
      onChip: (_) => setState(() => pageIndex = 0),
      search: search,
      searchHint: 'Cari kata...',
      onSearch: () => setState(() => pageIndex = 0),
      emptyText: 'Belum ada materi dari pengajar.',
      itemCount: filtered.length,
      pageIndex: pageIndex,
      onPage: (next) => setState(() => pageIndex = next),
      itemBuilder: (context, itemIndex, color) {
        final item = filtered[itemIndex];
        return _RangkaiLearningCard(
          color: color,
          title: item.target,
          subtitle: item.name,
          badge: item.units.map((unit) => unit.display).join(' + '),
          icon: Icons.record_voice_over_rounded,
          mastered: app.rangkaiKataMastered.contains(
            progressMasteryKey(item.id),
          ),
          onTap: () => showDialog<void>(
            context: context,
            builder: (_) => RangkaiKataGameDialog(initialId: item.id),
          ),
        );
      },
    );
  }
}

class RangkaiKataGameDialog extends ConsumerStatefulWidget {
  const RangkaiKataGameDialog({super.key, this.initialId});

  final String? initialId;

  @override
  ConsumerState<RangkaiKataGameDialog> createState() =>
      _RangkaiKataGameDialogState();
}

class _RangkaiKataGameDialogState extends ConsumerState<RangkaiKataGameDialog> {
  List<_WordAssemblyItem> items = const [];
  final Set<String> done = {};
  _WordAssemblyItem? selected;
  List<_WordUnitData> choices = const [];
  final List<_WordUnitData> answer = [];
  bool loading = true;
  bool awarded = false;
  String feedback = '';
  int attempts = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final loaded = await _loadRangkaiItems();
    final words = loaded
        .where((item) => item.type == 'kata')
        .map(_WordAssemblyItem.fromModel)
        .where((item) => item.units.isNotEmpty)
        .toList();
    if (!mounted) return;
    setState(() {
      items = words;
      loading = false;
    });
    final initialId = widget.initialId;
    if (initialId != null) {
      for (final item in words) {
        if (item.id == initialId) {
          _select(item);
          break;
        }
      }
    }
    ref
        .read(appStateProvider)
        .setRangkaiLearningTotals(rangkaiKata: words.length);
  }

  void _select(_WordAssemblyItem item) {
    final shuffled = [...item.units]..shuffle(Random());
    setState(() {
      selected = item;
      choices = shuffled;
      answer.clear();
      awarded = false;
      feedback = '';
      attempts = 0;
    });
  }

  void _pick(_WordUnitData unit) {
    if (selected == null || answer.length == selected!.units.length) return;
    setState(() {
      choices = [...choices]..remove(unit);
      answer.add(unit);
      feedback = '';
    });
    if (answer.length == selected!.units.length) unawaited(_check());
  }

  void _undo() {
    if (answer.isEmpty || selected == null) return;
    setState(() {
      final unit = answer.removeLast();
      choices = [...choices, unit];
      feedback = '';
    });
  }

  void _reset() {
    final item = selected;
    if (item == null) return;
    setState(() {
      choices = [...item.units]..shuffle(Random());
      answer.clear();
      feedback = '';
    });
  }

  Future<void> _check() async {
    final item = selected;
    if (item == null) return;
    attempts += 1;
    final correct = answer.map((unit) => unit.value).join() == item.target;
    if (!correct) {
      setState(() => feedback = 'Hampir benar. Coba susun lagi, ya!');
      return;
    }
    if (!awarded) {
      awarded = true;
      done.add(item.id);
      await ref
          .read(appStateProvider)
          .awardRangkaiKataPoint(item.id, total: items.length);
    }
    if (!mounted) return;
    setState(() => feedback = 'Hebat! Kata ${item.target} berhasil dirangkai.');
  }

  @override
  Widget build(BuildContext context) {
    final item = selected;
    return Dialog(
      insetPadding: const EdgeInsets.all(18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: item == null ? _buildList(context) : _buildGame(context, item),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _dialogHeader('Merangkai Kata', onBack: Navigator.of(context).pop),
        const SizedBox(height: 14),
        if (loading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (items.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                'Belum ada kata untuk dirangkai.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, separatorIndex) =>
                  const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                return FilledButton.icon(
                  onPressed: () => _select(item),
                  icon: Icon(
                    done.contains(item.id)
                        ? Icons.check_circle_rounded
                        : Icons.extension_rounded,
                  ),
                  label: Text(item.target),
                  style: FilledButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                    backgroundColor: const Color(0xffEC4899),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildGame(BuildContext context, _WordAssemblyItem item) {
    final complete = feedback.startsWith('Hebat!');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _dialogHeader(
          item.target,
          onBack: widget.initialId == null
              ? () => setState(() => selected = null)
              : Navigator.of(context).pop,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            for (final unit in answer)
              Chip(
                label: Text(unit.display),
                labelStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Expanded(
          child: Center(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                for (final unit in choices)
                  FilledButton(
                    onPressed: complete ? null : () => _pick(unit),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xffFFB927),
                      foregroundColor: const Color(0xff293464),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      unit.display,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (feedback.isNotEmpty)
          Text(
            feedback,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: complete
                  ? const Color(0xff20B447)
                  : const Color(0xffF97316),
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: complete ? null : _undo,
                icon: const Icon(Icons.backspace_rounded),
                label: const Text('Hapus terakhir'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: complete ? null : _reset,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reset'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: complete
              ? widget.initialId == null
                    ? () => setState(() => selected = null)
                    : Navigator.of(context).pop
              : null,
          icon: const Icon(Icons.done_rounded),
          label: Text(complete ? 'Selesai (+5 poin)' : 'Susun sampai lengkap'),
        ),
        if (complete)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Percobaan: $attempts',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
      ],
    );
  }

  Widget _dialogHeader(String title, {required VoidCallback onBack}) {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}

Future<List<RangkaiItemModel>> _loadRangkaiItems() async {
  if (SupabaseService.instance.isConfigured) {
    try {
      await SupabaseService.instance.ensureInitialized();
      return await RangkaiItemRepository(SupabaseService.instance).fetchAll();
    } catch (_) {}
  }
  final prefs = await SharedPreferences.getInstance();
  final blends = _decodeLetterBlends(
    prefs.getString(_letterBlendsPrefsKey),
  ).map((item) => item.toModel());
  final words = _decodeWordAssemblies(
    prefs.getString(_wordAssembliesPrefsKey),
  ).map((item) => item.toModel());
  return [...blends, ...words];
}

class _RangkaiLearningCard extends StatelessWidget {
  const _RangkaiLearningCard({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
    required this.mastered,
    required this.onTap,
  });

  final Color color;
  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final bool mastered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    final textColor = t.night ? NightPalette.text : const Color(0xff293464);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: t.night
                ? Color.lerp(color, NightPalette.surface, .54)
                : color,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: t.night ? color.withValues(alpha: .46) : Colors.white,
              width: 2.2,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 22,
                offset: const Offset(0, 12),
                color: color.withValues(alpha: t.night ? .30 : .45),
              ),
            ],
          ),
          child: Stack(
            children: [
              if (mastered)
                const Positioned(
                  left: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.check_rounded,
                      color: Color(0xff38C985),
                      size: 20,
                    ),
                  ),
                ),
              Positioned(
                right: 6,
                top: 6,
                child: Icon(icon, color: const Color(0xffFFB927), size: 25),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 22),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontSize: title.length <= 4 ? 74 : 54,
                            height: .95,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: t.night ? .16 : .70,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xff59617E),
                        fontSize: 10,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: .05);
  }
}

class AngkaScreen extends ConsumerStatefulWidget {
  const AngkaScreen({super.key});

  @override
  ConsumerState<AngkaScreen> createState() => _AngkaScreenState();
}

class _AngkaScreenState extends ConsumerState<AngkaScreen> {
  final search = TextEditingController();
  final _tts = FlutterTts();
  int pageIndex = 0;
  String category = 'Semua';

  @override
  void initState() {
    super.initState();
    unawaited(_setupTts());
  }

  @override
  void dispose() {
    search.dispose();
    unawaited(_tts.stop());
    super.dispose();
  }

  Future<void> _setupTts() async {
    try {
      await _configureTts(_tts, 'id-ID');
    } catch (_) {}
  }

  Future<void> _speak(NumberItem item) async {
    final text = _numberTtsText(item);
    if (text.isEmpty) return;
    try {
      await _speakTts(_tts, text, language: 'id-ID');
    } catch (_) {}
    await ref.read(appStateProvider).markAngkaViewed(item.number);
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final query = search.text.toLowerCase().trim();
    final numberItems = app.numbers;
    final filtered = numberItems.where((item) {
      final n = int.tryParse(item.number) ?? 0;
      final categoryOk =
          category == 'Semua' ||
          (category == 'Ganjil' && n.isOdd) ||
          (category == 'Genap' && n.isEven);
      final queryOk =
          query.isEmpty ||
          item.number.contains(query) ||
          item.name.toLowerCase().contains(query);
      return categoryOk && queryOk;
    }).toList();
    return _PremiumLearningScaffold(
      titleAsset: 'assets/images/Belajar_Angka.png',
      mascotAsset: 'assets/images/Anak_Belajar_Angka.png',
      fallbackTitle: 'Belajar',
      subtitle: tr(
        context,
        'Yuk belajar bilangan dengan gambar pilihan pengajar!',
      ),
      accent: const Color(0xff4E8BFF),
      stars: app.stars,
      onBack: () => ref.read(appStateProvider).openLearn(LearnMode.menu),
      chips: const ['Semua', 'Ganjil', 'Genap'],
      selectedChip: category,
      onChip: (value) => setState(() {
        category = value;
        pageIndex = 0;
      }),
      search: search,
      searchHint: tr(context, 'Cari...'),
      onSearch: () => setState(() => pageIndex = 0),
      itemCount: filtered.length,
      pageIndex: pageIndex,
      onPage: (next) => setState(() => pageIndex = next),
      itemBuilder: (context, itemIndex, color) {
        final item = filtered[itemIndex];
        final mastered = app.angkaMastered.contains(
          progressMasteryKey(item.number),
        );
        return _PremiumLearningCard(
          color: color,
          title: item.number,
          subtitle: item.name,
          caption: item.number,
          imageUrl: item.img,
          badge: _numberBadge(item.number),
          kind: _PremiumCardKind.number,
          mastered: mastered,
          onTap: () => unawaited(_speak(item)),
        );
      },
    );
  }
}

class BendaScreen extends ConsumerStatefulWidget {
  const BendaScreen({super.key});

  @override
  ConsumerState<BendaScreen> createState() => _BendaScreenState();
}

class _BendaScreenState extends ConsumerState<BendaScreen> {
  final search = TextEditingController();
  final _tts = FlutterTts();
  int pageIndex = 0;
  String category = 'Semua';

  @override
  void initState() {
    super.initState();
    unawaited(_setupTts());
  }

  @override
  void dispose() {
    search.dispose();
    unawaited(_tts.stop());
    super.dispose();
  }

  Future<void> _setupTts() async {
    try {
      await _configureTts(_tts, 'id-ID');
    } catch (_) {}
  }

  Future<void> _speak(LearningObject item) async {
    try {
      await _speakTts(_tts, item.name.toLowerCase(), language: 'id-ID');
    } catch (_) {}
    await ref.read(appStateProvider).markBendaViewed(item.name);
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final objects = app.objects;
    final query = search.text.toLowerCase().trim();
    final filtered = objects.where((item) {
      final family = _objectFamily(item);
      final categoryOk = category == 'Semua' || category == family;
      final queryOk =
          query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);
      return categoryOk && queryOk;
    }).toList();
    return _PremiumLearningScaffold(
      titleAsset: 'assets/images/Belajar_Benda.png',
      mascotAsset: 'assets/images/Anak_Belajar_Benda.png',
      fallbackTitle: 'Belajar Benda',
      subtitle: tr(context, 'Mengenal benda di sekitar kita'),
      accent: const Color(0xff32C653),
      stars: app.stars,
      onBack: () => ref.read(appStateProvider).openLearn(LearnMode.menu),
      chips: const ['Semua', ..._fixedObjectCategories],
      selectedChip: category,
      onChip: (value) => setState(() {
        category = value;
        pageIndex = 0;
      }),
      search: search,
      searchHint: tr(context, 'Cari benda...'),
      onSearch: () => setState(() => pageIndex = 0),
      itemCount: filtered.length,
      pageIndex: pageIndex,
      onPage: (next) => setState(() => pageIndex = next),
      itemBuilder: (context, itemIndex, color) {
        final item = filtered[itemIndex];
        final mastered = app.bendaMastered.contains(
          progressMasteryKey(item.name),
        );
        return _PremiumLearningCard(
          color: color,
          title: item.name,
          subtitle: item.name,
          caption: item.category,
          imageUrl: item.img,
          badge: _objectFamily(item),
          kind: _PremiumCardKind.object,
          mastered: mastered,
          onTap: () => unawaited(_speak(item)),
        );
      },
    );
  }
}

typedef _PremiumItemBuilder =
    Widget Function(BuildContext context, int itemIndex, Color color);

enum _PremiumCardKind { letter, number, object }

class _PremiumLearningScaffold extends StatelessWidget {
  const _PremiumLearningScaffold({
    required this.titleAsset,
    required this.mascotAsset,
    required this.fallbackTitle,
    required this.subtitle,
    required this.accent,
    required this.stars,
    required this.onBack,
    required this.chips,
    required this.selectedChip,
    required this.onChip,
    required this.search,
    required this.searchHint,
    required this.onSearch,
    required this.itemCount,
    required this.pageIndex,
    required this.onPage,
    required this.itemBuilder,
    this.emptyText,
  });

  final String titleAsset;
  final String mascotAsset;
  final String fallbackTitle;
  final String subtitle;
  final Color accent;
  final int stars;
  final VoidCallback onBack;
  final List<String> chips;
  final String selectedChip;
  final ValueChanged<String> onChip;
  final TextEditingController search;
  final String searchHint;
  final VoidCallback onSearch;
  final int itemCount;
  final int pageIndex;
  final ValueChanged<int> onPage;
  final _PremiumItemBuilder itemBuilder;
  final String? emptyText;

  static const colors = [
    Color(0xffffe4ef),
    Color(0xffe4f3ff),
    Color(0xfffff2cc),
    Color(0xffe4f9df),
    Color(0xffefe5ff),
    Color(0xffffead9),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final tablet = width >= 760;
    final columns = tablet ? (width >= 1020 ? 4 : 3) : 2;
    final perPage = columns * (tablet ? 2 : 3);
    final pages = max(1, (itemCount / perPage).ceil());
    final page = pageIndex.clamp(0, pages - 1);
    final start = page * perPage;
    final end = min(itemCount, start + perPage);
    final visible = itemCount == 0
        ? <int>[]
        : List.generate(end - start, (i) => start + i);

    return Stack(
      children: [
        const Positioned.fill(child: _KidsDreamBackground()),
        ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 118),
          children: [
            _PremiumLearningHero(
              titleAsset: titleAsset,
              mascotAsset: mascotAsset,
              fallbackTitle: fallbackTitle,
              subtitle: subtitle,
              accent: accent,
              stars: stars,
              onBack: onBack,
            ),
            const SizedBox(height: 14),
            _PremiumSearchAndChips(
              search: search,
              hint: searchHint,
              chips: chips,
              selected: selectedChip,
              accent: accent,
              onChanged: onSearch,
              onChip: onChip,
            ),
            const SizedBox(height: 14),
            if (visible.isEmpty)
              _PremiumEmptyState(
                accent: accent,
                text: emptyText ?? 'Belum ada hasil yang cocok.',
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visible.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: tablet ? .78 : .68,
                ),
                itemBuilder: (context, i) {
                  final item = visible[i];
                  return itemBuilder(
                    context,
                    item,
                    colors[item % colors.length],
                  );
                },
              ),
            const SizedBox(height: 16),
            _PremiumPagination(
              page: page,
              pages: pages,
              accent: accent,
              onPrev: () => onPage(max(0, page - 1)),
              onNext: () => onPage(min(pages - 1, page + 1)),
            ),
          ],
        ),
      ],
    );
  }
}

class _KidsDreamBackground extends StatelessWidget {
  const _KidsDreamBackground();

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          t.night
              ? 'assets/images/Background_Image_Malam.png'
              : 'assets/images/Background_image.png',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: t.night
                  ? [
                      NightPalette.midnight.withValues(alpha: .12),
                      NightPalette.purple.withValues(alpha: .52),
                      NightPalette.midnight.withValues(alpha: .86),
                    ]
                  : [
                      Colors.white.withValues(alpha: .03),
                      Colors.white.withValues(alpha: .18),
                      Colors.white.withValues(alpha: .88),
                    ],
              stops: const [0, .44, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        if (t.night)
          const NightSparkles(count: 28)
        else
          ...List.generate(16, (i) {
            return Positioned(
              left: (i * 61 % 320).toDouble() + (i.isEven ? 12 : 80),
              top: 48.0 + (i * 43 % 440),
              child:
                  Icon(
                        i.isEven
                            ? Icons.star_rounded
                            : Icons.auto_awesome_rounded,
                        color: Colors.white.withValues(alpha: .75),
                        size: 12 + (i % 4) * 3,
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(begin: -5, end: 6, duration: (1300 + i * 80).ms),
            );
          }),
      ],
    );
  }
}

class _PremiumLearningHero extends StatelessWidget {
  const _PremiumLearningHero({
    required this.titleAsset,
    required this.mascotAsset,
    required this.fallbackTitle,
    required this.subtitle,
    required this.accent,
    required this.stars,
    required this.onBack,
  });

  final String titleAsset;
  final String mascotAsset;
  final String fallbackTitle;
  final String subtitle;
  final Color accent;
  final int stars;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    final tablet = MediaQuery.sizeOf(context).width >= 760;
    return SizedBox(
      height: tablet ? 286 : 252,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 12,
            right: 12,
            top: 12,
            child: Row(
              children: [
                _PremiumRoundButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: onBack,
                  color: accent,
                ),
                const Spacer(),
                _PremiumPoints(stars: stars),
              ],
            ),
          ),
          Positioned(
            left: tablet ? 24 : 14,
            top: tablet ? 58 : 62,
            width: tablet ? 470 : 270,
            child: Image.asset(
              titleAsset,
              height: tablet ? 168 : 126,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) => Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      fallbackTitle,
                      style: TextStyle(
                        fontSize: tablet ? 42 : 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: tablet ? 32 : 8,
            bottom: tablet ? 18 : 18,
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: t.night ? 1 : 0,
                duration: 420.ms,
                child: Container(
                  width: tablet ? 210 : 156,
                  height: tablet ? 178 : 138,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 48,
                        spreadRadius: 8,
                        color: NightPalette.gold.withValues(alpha: .20),
                      ),
                      BoxShadow(
                        blurRadius: 60,
                        color: accent.withValues(alpha: .18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: tablet ? 18 : -18,
            bottom: -4,
            child:
                Image.asset(
                      mascotAsset,
                      height: tablet ? 238 : 184,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/Anak_hebat.png',
                        height: tablet ? 210 : 158,
                        fit: BoxFit.contain,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: -5, end: 6, duration: 1700.ms),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: .04);
  }
}

class _PremiumSearchAndChips extends StatelessWidget {
  const _PremiumSearchAndChips({
    required this.search,
    required this.hint,
    required this.chips,
    required this.selected,
    required this.accent,
    required this.onChanged,
    required this.onChip,
  });

  final TextEditingController search;
  final String hint;
  final List<String> chips;
  final String selected;
  final Color accent;
  final VoidCallback onChanged;
  final ValueChanged<String> onChip;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: t.night
          ? nightGlassDecoration(borderColor: accent, radius: 28)
          : BoxDecoration(
              color: Colors.white.withValues(alpha: .88),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  color: const Color(0xff6DAEDB).withValues(alpha: .13),
                ),
              ],
            ),
      child: Column(
        children: [
          TextField(
            controller: search,
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(Icons.search_rounded, color: accent),
              filled: true,
              fillColor: t.night
                  ? NightPalette.midnight2.withValues(alpha: .60)
                  : const Color(0xffF9FBFF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: chips.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final chip = chips[i];
                final active = chip == selected;
                return GestureDetector(
                  onTap: () => onChip(chip),
                  child: AnimatedContainer(
                    duration: 220.ms,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? accent
                          : (t.night
                                ? NightPalette.surface.withValues(alpha: .62)
                                : Colors.white),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: active
                            ? accent
                            : (t.night
                                  ? NightPalette.cyan.withValues(alpha: .18)
                                  : const Color(0xffE7ECFF)),
                      ),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                blurRadius: 16,
                                color: accent.withValues(alpha: .24),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      tr(context, chip),
                      style: TextStyle(
                        color: active
                            ? Colors.white
                            : (t.night
                                  ? NightPalette.muted
                                  : const Color(0xff4C5875)),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumLearningCard extends StatelessWidget {
  const _PremiumLearningCard({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.caption,
    required this.imageUrl,
    required this.badge,
    required this.kind,
    required this.onTap,
    this.mastered = false,
  });

  final Color color;
  final String title;
  final String subtitle;
  final String caption;
  final String imageUrl;
  final String badge;
  final _PremiumCardKind kind;
  final VoidCallback onTap;
  final bool mastered;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    final compact = MediaQuery.sizeOf(context).width < 430;
    final isLetterCard = kind == _PremiumCardKind.letter;
    final isNumberCard = kind == _PremiumCardKind.number;
    final cardColor = color;
    final bg = t.night
        ? Color.lerp(cardColor, NightPalette.surface, .54)!
        : cardColor;
    final textColor = t.night ? NightPalette.text : const Color(0xff293464);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: t.night ? cardColor.withValues(alpha: .46) : Colors.white,
              width: 2.2,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 22,
                offset: const Offset(0, 12),
                color: cardColor.withValues(alpha: t.night ? .34 : .55),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 7,
                top: 7,
                child: mastered
                    ? Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Color(0xff38C985),
                          size: 20,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Positioned(
                right: 7,
                top: 7,
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xffFFB927),
                  size: 22,
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 12),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        isNumberCard ? 8 : 6,
                        isNumberCard
                            ? (mastered
                                  ? (compact ? 26 : 30)
                                  : (compact ? 16 : 20))
                            : 6,
                        isNumberCard ? 8 : 6,
                        isNumberCard ? (compact ? 12 : 16) : 6,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isLetterCard)
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      color: t.night
                                          ? color
                                          : const Color(0xff293464),
                                      fontSize: compact ? 92 : 112,
                                      height: .9,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Text(
                                    subtitle,
                                    style: TextStyle(
                                      color:
                                          (t.night
                                                  ? NightPalette.muted
                                                  : const Color(0xff293464))
                                              .withValues(alpha: .78),
                                      fontSize: compact ? 68 : 84,
                                      height: .95,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (isNumberCard)
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: compact ? 6 : 10,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.white.withValues(
                                      alpha: t.night ? .22 : .34,
                                    ),
                                    fontSize: compact ? 128 : 156,
                                    height: 1,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          if (!isLetterCard)
                            Transform.scale(
                              scale: isNumberCard ? (compact ? 1.18 : 1.04) : 1,
                              child: AppImage(
                                url: imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLetterCard) ...[
                    SizedBox(height: isNumberCard ? 10 : 0),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (!isNumberCard) ...[
                      const SizedBox(height: 2),
                      Text(
                        caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              (t.night
                                      ? NightPalette.muted
                                      : const Color(0xff293464))
                                  .withValues(alpha: .82),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: t.night ? .16 : .70,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xff59617E),
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: .05);
  }
}

class _PremiumPagination extends StatelessWidget {
  const _PremiumPagination({
    required this.page,
    required this.pages,
    required this.accent,
    required this.onPrev,
    required this.onNext,
  });

  final int page;
  final int pages;
  final Color accent;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _PremiumRoundButton(
        icon: Icons.chevron_left_rounded,
        onTap: onPrev,
        color: accent,
      ),
      const SizedBox(width: 12),
      ...List.generate(
        pages,
        (i) => AnimatedContainer(
          duration: 220.ms,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: i == page ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == page ? accent : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: accent.withValues(alpha: .30)),
          ),
        ),
      ),
      const SizedBox(width: 12),
      _PremiumRoundButton(
        icon: Icons.chevron_right_rounded,
        onTap: onNext,
        color: accent,
      ),
    ],
  );
}

class _PremiumRoundButton extends StatelessWidget {
  const _PremiumRoundButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Material(
      color: t.night
          ? NightPalette.surface.withValues(alpha: .72)
          : Colors.white.withValues(alpha: .92),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon, color: color, size: 31)],
          ),
        ),
      ),
    );
  }
}

class _PremiumPoints extends StatelessWidget {
  const _PremiumPoints({required this.stars});
  final int stars;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: t.night
            ? NightPalette.surface.withValues(alpha: .72)
            : Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xffFFC928), size: 25),
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$stars',
                style: TextStyle(
                  color: t.night ? NightPalette.text : const Color(0xff293464),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Poin',
                style: TextStyle(
                  color: t.night ? NightPalette.muted : const Color(0xff6F7692),
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PremiumEmptyState extends StatelessWidget {
  const _PremiumEmptyState({required this.accent, required this.text});
  final Color accent;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: t.night
            ? NightPalette.surface.withValues(alpha: .72)
            : Colors.white.withValues(alpha: .88),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Text(
        tr(context, text),
        textAlign: TextAlign.center,
        style: TextStyle(color: accent, fontWeight: FontWeight.w900),
      ),
    );
  }
}

String _objectFamily(LearningObject item) =>
    _standardObjectCategory(item.category);

String _standardObjectCategory(String rawCategory) {
  final category = rawCategory.toLowerCase().trim();
  if (category.isEmpty || category == 'benda') return 'Perabot Rumah';
  if (category.contains('hewan')) return 'Hewan';
  if (category.contains('buah')) return 'Buah';
  if (category.contains('sayur')) return 'Sayur';
  if (category.contains('makanan')) return 'Makanan';
  if (category.contains('minuman')) return 'Minuman';
  if (category.contains('kendaraan') || category.contains('transportasi')) {
    return 'Kendaraan';
  }
  if (category.contains('tulis')) return 'Alat Tulis';
  if (category.contains('mainan')) return 'Mainan';
  if (category.contains('pakaian')) return 'Pakaian';
  if (category.contains('tubuh')) return 'Anggota Tubuh';
  if (category.contains('perabot') || category.contains('rumah')) {
    return 'Perabot Rumah';
  }
  if (category.contains('dapur')) return 'Peralatan Dapur';
  if (category.contains('musik')) return 'Alat Musik';
  if (category.contains('sekolah')) return 'Benda Sekolah';
  if (category.contains('alam')) return 'Alam';
  if (category.contains('warna')) return 'Warna';

  for (final fixed in _fixedObjectCategories) {
    if (fixed.toLowerCase() == category) return fixed;
  }
  return 'Perabot Rumah';
}

Future<void> _configureTts(
  FlutterTts tts,
  String language, {
  double speechRate = .42,
  double pitch = 1.08,
}) async {
  if (kIsWeb) return;
  await tts.setLanguage(language);
  await tts.setSpeechRate(speechRate);
  await tts.setPitch(pitch);
  try {
    final voices = await tts.getVoices;
    if (voices is! List) return;
    final prefix = language.toLowerCase();
    for (final voice in voices) {
      if (voice is! Map) continue;
      final locale = (voice['locale'] ?? voice['lang'] ?? '').toString();
      final name = (voice['name'] ?? '').toString();
      if (name.isEmpty || !locale.toLowerCase().startsWith(prefix)) continue;
      await tts.setVoice({'name': name, 'locale': locale});
      return;
    }
  } catch (_) {}
}

Future<bool> _speakTts(
  FlutterTts tts,
  String text, {
  required String language,
  double speechRate = .42,
  double pitch = 1.08,
}) async {
  if (await speakWithWebTts(
    text,
    language: language,
    speechRate: speechRate,
    pitch: pitch,
  )) {
    return true;
  }
  if (kIsWeb) {
    return false;
  }
  unawaited(tts.stop());
  await tts.speak(text);
  return true;
}

String _numberBadge(String number) {
  final n = int.tryParse(number) ?? 0;
  return n.isEven ? 'genap' : 'ganjil';
}

String _numberTtsText(NumberItem item) {
  final label = item.name.trim();
  final n = int.tryParse(item.number.trim());
  if (label.isNotEmpty && int.tryParse(label) == null) {
    return label.toLowerCase();
  }
  if (n == null || n < 0 || n > 999) return label.toLowerCase();
  return _numberToIndonesian(n);
}

String _numberToIndonesian(int value) {
  const units = [
    'nol',
    'satu',
    'dua',
    'tiga',
    'empat',
    'lima',
    'enam',
    'tujuh',
    'delapan',
    'sembilan',
    'sepuluh',
    'sebelas',
  ];
  if (value < 12) return units[value];
  if (value < 20) return '${units[value - 10]} belas';
  if (value < 100) {
    final tens = value ~/ 10;
    final rest = value % 10;
    return rest == 0
        ? '${units[tens]} puluh'
        : '${units[tens]} puluh ${units[rest]}';
  }
  if (value == 100) return 'seratus';
  final hundreds = value ~/ 100;
  final rest = value % 100;
  final prefix = hundreds == 1 ? 'seratus' : '${units[hundreds]} ratus';
  return rest == 0 ? prefix : '$prefix ${_numberToIndonesian(rest)}';
}

class IqraLesson extends ConsumerStatefulWidget {
  const IqraLesson({
    required this.readingHelp,
    required this.onToggle,
    super.key,
  });
  final bool readingHelp;
  final VoidCallback onToggle;

  @override
  ConsumerState<IqraLesson> createState() => _IqraLessonState();
}

class _IqraLessonState extends ConsumerState<IqraLesson> {
  late final ConfettiController confetti;
  final _tts = FlutterTts();
  int index = 0;

  @override
  void initState() {
    super.initState();
    confetti = ConfettiController(duration: const Duration(seconds: 2));
    unawaited(_setupTts());
  }

  @override
  void dispose() {
    confetti.dispose();
    unawaited(_tts.stop());
    super.dispose();
  }

  Future<void> _setupTts() async {
    try {
      if (kIsWeb) return;
      await _tts.setLanguage('ar-SA');
      await _tts.setSpeechRate(.38);
      await _tts.setPitch(1.0);
    } catch (_) {}
  }

  Future<void> _selectIqra(int i, List<IqraItem> items) async {
    setState(() => index = i);
    final item = items[i];
    try {
      final spoken = await _speakTts(
        _tts,
        _iqraArabicTtsText(item),
        language: 'ar-SA',
        speechRate: .38,
        pitch: 1.0,
      );
      if (!spoken) {
        await _speakTts(_tts, item.latin.toLowerCase(), language: 'id-ID');
      }
    } catch (_) {}
    await ref.read(appStateProvider).markIqraViewed(item);
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final iqraItems = app.iqraItems;
    final progress = app.progress['iqra'] ?? 0;
    return Stack(
      children: [
        const Positioned.fill(child: _IqraDreamScene()),
        Positioned.fill(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 118),
            children: [
              _IqraHeroSection(
                app: app,
                latinEnabled: widget.readingHelp,
                slow: false,
                onBack: () =>
                    ref.read(appStateProvider).openLearn(LearnMode.menu),
                onSettings: widget.onToggle,
              ),
              const SizedBox(height: 14),
              _IqraProgressCard(
                progress: progress,
                mastered: iqraMasteredCount(app.iqraMastered, iqraItems),
                total: iqraItems.length,
                streak: app.iqraStreak,
              ),
              const SizedBox(height: 18),
              _IqraCatalogSection(
                items: iqraItems,
                selectedIndex: index,
                latinEnabled: widget.readingHelp,
                mastered: app.iqraMastered,
                feedback: '',
                onSelect: (i) => unawaited(_selectIqra(i, iqraItems)),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: confetti,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
          ),
        ),
      ],
    );
  }
}

String _iqraArabicTtsText(IqraItem item) {
  return switch (item.latin.toLowerCase()) {
    'alif' => 'أَلِف',
    'ba' => 'بَاء',
    'ta' => 'تَاء',
    'tsa' => 'ثَاء',
    'jim' => 'جِيم',
    'ha' => item.char == '\u062D' ? 'حَاء' : 'هَاء',
    'kho' => 'خَاء',
    'dal' => 'دَال',
    'dzal' => 'ذَال',
    'ra' => 'رَاء',
    'zai' => 'زَاي',
    'sin' => 'سِين',
    'syin' => 'شِين',
    'shod' => 'صَاد',
    'dhod' => 'ضَاد',
    'tho' => 'طَاء',
    'zho' => 'ظَاء',
    'ain' => 'عَيْن',
    'ghoin' => 'غَيْن',
    'fa' => 'فَاء',
    'qof' => 'قَاف',
    'kaf' => 'كَاف',
    'lam' => 'لَام',
    'mim' => 'مِيم',
    'nun' => 'نُون',
    'wau' => 'وَاو',
    'hamzah' => 'هَمْزَة',
    'ya' => 'يَاء',
    _ => item.char,
  };
}

class _IqraParticles extends StatelessWidget {
  const _IqraParticles();
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Stack(
      children: List.generate(14, (i) {
        final left = (i * 37 % 100) / 100;
        final top = (i * 23 % 100) / 100;
        return Positioned(
          left: MediaQuery.sizeOf(context).width * left,
          top: MediaQuery.sizeOf(context).height * .45 * top,
          child:
              Icon(
                    i.isEven ? Icons.star_rounded : Icons.auto_awesome_rounded,
                    size: 14 + (i % 4) * 4,
                    color: Colors.amber.withValues(alpha: .34),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(begin: -8, end: 8, duration: (1300 + i * 90).ms),
        );
      }),
    ),
  );
}

class _IqraDreamScene extends StatelessWidget {
  const _IqraDreamScene();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/Backgroudn_Image_Iqra.png',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: .05),
                const Color(0xffF2EAFF).withValues(alpha: .20),
                Colors.white.withValues(alpha: .82),
              ],
              stops: const [0, .42, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        const Positioned.fill(child: _IqraParticles()),
        Positioned(
          left: 34,
          top: 76,
          child:
              Icon(
                    Icons.nightlight_round,
                    size: 46,
                    color: const Color(0xffFFC857).withValues(alpha: .82),
                    shadows: [
                      Shadow(
                        blurRadius: 24,
                        color: const Color(0xffFFD978).withValues(alpha: .82),
                      ),
                    ],
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(.96, .96),
                    end: const Offset(1.08, 1.08),
                    duration: 1800.ms,
                  ),
        ),
        Positioned(
          right: 34,
          top: 96,
          child:
              Icon(
                    Icons.tips_and_updates_rounded,
                    size: 38,
                    color: const Color(0xffFFD36A).withValues(alpha: .70),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(begin: -5, end: 6, duration: 1500.ms),
        ),
      ],
    );
  }
}

class _IqraHeroSection extends StatelessWidget {
  const _IqraHeroSection({
    required this.app,
    required this.latinEnabled,
    required this.slow,
    required this.onBack,
    required this.onSettings,
  });

  final AppState app;
  final bool latinEnabled;
  final bool slow;
  final VoidCallback onBack;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final tablet = width >= 720;
    final mascot = app.gender == Gender.girl
        ? 'assets/images/Anak_perempuan_Mengaji.png'
        : 'assets/images/Anak_lakilaki_Mengaji.png';
    return SizedBox(
      height: tablet ? 266 : 278,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.all(tablet ? 22 : 16),

              child: Column(
                children: [
                  Row(
                    children: [
                      _IqraCircleButton(
                        icon: Icons.chevron_left_rounded,
                        onTap: onBack,
                      ),
                      const Spacer(),
                      _IqraPointsPill(stars: app.stars),
                      const SizedBox(width: 8),
                      _IqraCircleButton(
                        icon: slow
                            ? Icons.slow_motion_video_rounded
                            : Icons.settings_rounded,
                        active: slow,
                        label: 'Pelan',
                        onTap: onSettings,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: tablet ? 460 : 270,
                      height: tablet ? 150 : 126,
                      child: Image.asset(
                        'assets/images/Belajar_Iqra.png',
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
          Positioned(
            right: tablet ? 26 : 0,
            bottom: -2,
            child:
                Image.asset(
                      mascot,
                      height: tablet ? 210 : 166,
                      fit: BoxFit.contain,
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: -5, end: 6, duration: 1700.ms),
          ),
          Positioned(
            right: tablet ? 198 : 128,
            bottom: tablet ? 34 : 46,
            child:
                Image.asset(
                      'assets/images/Logo_iqra.png',
                      width: tablet ? 84 : 64,
                      height: tablet ? 84 : 64,
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .rotate(begin: -.015, end: .015, duration: 1500.ms),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 340.ms).slideY(begin: .04);
  }
}

class _IqraCircleButton extends StatelessWidget {
  const _IqraCircleButton({
    required this.icon,
    required this.onTap,
    this.active = false,
    this.label,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  final String? label;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(22),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
      child: Material(
        color: active
            ? const Color(0xff1498BD).withValues(alpha: .92)
            : Colors.white.withValues(alpha: .86),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: label == null ? 48 : 56,
            height: 48,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: active ? Colors.white : const Color(0xff1498BD),
                  size: label == null ? 31 : 22,
                ),
                if (label != null)
                  Text(
                    label!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: active ? Colors.white : const Color(0xff335D73),
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _IqraPointsPill extends StatelessWidget {
  const _IqraPointsPill({required this.stars});
  final int stars;

  @override
  Widget build(BuildContext context) => Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .90),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: Colors.white),
      boxShadow: [
        BoxShadow(
          blurRadius: 18,
          offset: const Offset(0, 8),
          color: const Color(0xff1498BD).withValues(alpha: .13),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, color: Color(0xffFFC928), size: 25),
        const SizedBox(width: 5),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$stars',
              style: const TextStyle(
                color: Color(0xff393073),
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'Poin',
              style: TextStyle(
                color: Color(0xff70699A),
                fontSize: 8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _IqraProgressCard extends StatelessWidget {
  const _IqraProgressCard({
    required this.progress,
    required this.mastered,
    required this.total,
    required this.streak,
  });

  final int progress;
  final int mastered;
  final int total;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final value = progress.clamp(0, 100) / 100;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .90),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 14),
            color: const Color(0xff1498BD).withValues(alpha: .14),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 480;
          final content = [
            SizedBox(
              width: 96,
              height: 96,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 86,
                    height: 86,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 11,
                      strokeCap: StrokeCap.round,
                      backgroundColor: const Color(
                        0xffEADFFF,
                      ).withValues(alpha: .85),
                      color: const Color(0xff1498BD),
                    ),
                  ),
                  Text(
                    '$progress%',
                    style: const TextStyle(
                      color: Color(0xff1498BD),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16, height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress Kamu',
                    style: TextStyle(
                      color: Color(0xff30265F),
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$mastered / $total Huruf',
                    style: const TextStyle(
                      color: Color(0xff5C587E),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: value,
                      backgroundColor: const Color(0xffD7F7EA),
                      color: const Color(0xff42D59D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16, height: 16),
          ];
          return compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: content.take(3).toList()),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: content.last),
                        const SizedBox(width: 10),
                        _IqraMiniStat(
                          icon: Icons.local_fire_department_rounded,
                          text: '$streak streak',
                        ),
                      ],
                    ),
                  ],
                )
              : Row(children: content);
        },
      ),
    ).animate().fadeIn(duration: 320.ms, delay: 60.ms).slideY(begin: .04);
  }
}

class _IqraMiniStat extends StatelessWidget {
  const _IqraMiniStat({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xffFFF4CD),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xffFF9F1C), size: 18),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xff704E18),
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  );
}

class _IqraCatalogSection extends StatelessWidget {
  const _IqraCatalogSection({
    required this.items,
    required this.selectedIndex,
    required this.latinEnabled,
    required this.mastered,
    required this.feedback,
    required this.onSelect,
  });

  final List<IqraItem> items;
  final int selectedIndex;
  final bool latinEnabled;
  final Set<String> mastered;
  final String feedback;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) => _IqraSectionCard(
    title: 'Katalog Huruf Hijaiyah Dasar',
    subtitle: 'Klik huruf untuk belajar membaca dan mendengarkan',
    icon: Icons.auto_stories_rounded,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 760;
            final crossAxisCount = wide ? 4 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: wide ? .72 : .68,
              ),
              itemBuilder: (context, i) {
                final item = items[i];
                return _IqraLetterCard(
                  number: i + 1,
                  item: item,
                  selected: selectedIndex == i,
                  latinEnabled: latinEnabled,
                  mastered: isIqraMastered(mastered, item),
                  onTap: () => onSelect(i),
                );
              },
            );
          },
        ),
        if (feedback.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xffE9FFF5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              feedback,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xff167653),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

class _IqraLetterCard extends StatelessWidget {
  const _IqraLetterCard({
    required this.number,
    required this.item,
    required this.selected,
    required this.latinEnabled,
    required this.mastered,
    required this.onTap,
  });

  final int number;
  final IqraItem item;
  final bool selected;
  final bool latinEnabled;
  final bool mastered;
  final VoidCallback onTap;

  Color get statusColor {
    if (mastered) return const Color(0xff38C985);
    if (selected) return const Color(0xff1498BD);
    return const Color(0xff9EA5BC);
  }

  IconData get statusIcon {
    if (mastered) return Icons.check_circle_rounded;
    if (selected) return Icons.play_circle_fill_rounded;
    return Icons.radio_button_unchecked_rounded;
  }

  @override
  Widget build(BuildContext context) {
    const scale = 1.0;
    return AnimatedScale(
      scale: scale,
      duration: 220.ms,
      curve: Curves.easeOutBack,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(26),
          child: Ink(
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .94),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: statusColor.withValues(alpha: selected ? .70 : .28),
                width: selected ? 2.2 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: selected ? 26 : 16,
                  offset: const Offset(0, 10),
                  color: statusColor.withValues(alpha: selected ? .24 : .12),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor.withValues(alpha: .14),
                      ),
                      child: Text(
                        '$number',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(statusIcon, size: 18, color: statusColor),
                  ],
                ),
                const Spacer(flex: 2),
                SizedBox(
                  height: 74,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      item.char,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 66,
                        height: 1.08,
                        color: Color(0xff22264D),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.latin,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (latinEnabled)
                  Text(
                    item.latin.toLowerCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff757C9D),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 260.ms).slideY(begin: .05);
  }
}

class _IqraSectionCard extends StatelessWidget {
  const _IqraSectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .78),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: [
        BoxShadow(
          blurRadius: 24,
          offset: const Offset(0, 13),
          color: const Color(0xff7AAED3).withValues(alpha: .13),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffF0E7FF),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    color: const Color(0xff1498BD).withValues(alpha: .18),
                  ),
                ],
              ),
              child: Icon(icon, color: const Color(0xff1498BD), size: 24),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff30265F),
                      fontSize: 18,
                      height: 1.08,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff777293),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    ),
  ).animate().fadeIn(duration: 320.ms).slideY(begin: .04);
}
