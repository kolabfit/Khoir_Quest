part of '../main.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

enum _AccountPage { home, profile, security, parent, language, faq, theme }

class _AccountScreenState extends ConsumerState<AccountScreen> {
  _AccountPage page = _AccountPage.home;

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .24),
      builder: (_) => const _AccountLogoutDialog(),
    );
    if (confirmed == true && mounted) {
      await ref.read(appStateProvider).logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    if (page == _AccountPage.theme) {
      return _ThemeSettingsPage(
        app: app,
        onBack: () => setState(() => page = _AccountPage.home),
      );
    }
    if (page == _AccountPage.profile) {
      return _ProfileSettingsPage(
        app: app,
        onBack: () => setState(() => page = _AccountPage.home),
      );
    }
    if (page == _AccountPage.security) {
      return _SecuritySettingsPage(
        app: app,
        onBack: () => setState(() => page = _AccountPage.home),
      );
    }
    if (page == _AccountPage.parent) {
      return _ParentSettingsPage(
        app: app,
        onBack: () => setState(() => page = _AccountPage.home),
      );
    }
    if (page == _AccountPage.language) {
      return _LanguageSettingsPage(
        app: app,
        onBack: () => setState(() => page = _AccountPage.home),
      );
    }
    if (page == _AccountPage.faq) {
      return _FaqSettingsPage(
        onBack: () => setState(() => page = _AccountPage.home),
      );
    }
    final tablet = MediaQuery.sizeOf(context).width >= 700;
    final totalProgress = _accountTotalProgress(app.progress);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: tablet ? 980 : 520),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            tablet ? 28 : 18,
            14,
            tablet ? 28 : 18,
            126,
          ),
          children: [
            const _AccountHero(),
            const SizedBox(height: 16),
            _PremiumProfileCard(app: app),
            const SizedBox(height: 16),
            _LearningStats(app: app),
            const SizedBox(height: 24),
            if (app.role == Role.teacher) ...[
              _TeacherDashboardCard(
                onTap: () => ref.read(appStateProvider).go(TabItem.akun),
              ),
              const SizedBox(height: 16),
            ],
            _SettingsSection(
              app: app,
              onProfileTap: () => setState(() => page = _AccountPage.profile),
              onSecurityTap: () => setState(() => page = _AccountPage.security),
              onParentTap: () => setState(() => page = _AccountPage.parent),
              onLanguageTap: () => setState(() => page = _AccountPage.language),
              onThemeTap: () => setState(() => page = _AccountPage.theme),
              onFaqTap: () => setState(() => page = _AccountPage.faq),
            ),
            const SizedBox(height: 16),
            if (tablet)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: _OverallProgressCard(
                      progress: totalProgress,
                      app: app,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(flex: 5, child: _BadgeShowcase()),
                ],
              )
            else ...[
              _OverallProgressCard(progress: totalProgress, app: app),
              const SizedBox(height: 16),
              const _BadgeShowcase(),
            ],
            const SizedBox(height: 16),
            _LogoutCard(onTap: _confirmLogout),
          ],
        ),
      ),
    );
  }
}

int _accountTotalProgress(Map<String, int> progress) {
  final values = [
    'membaca',
    'angka',
    'benda',
    'iqra',
  ].map((e) => progress[e] ?? 0).toList();
  if (values.isEmpty) return 0;
  return (values.reduce((a, b) => a + b) / values.length).round();
}

int _studiedMaterialCount(AppState app) {
  const keys = ['membaca', 'angka', 'benda', 'iqra'];
  return keys.where((key) => (app.progress[key] ?? 0) > 0).length;
}

int _accountLevel(int stars) => (stars ~/ 100 + 1).clamp(1, 5);

String _levelTitle(int level) => switch (level) {
  1 => 'Penjelajah Pemula',
  2 => 'Penjelajah Ceria',
  3 => 'Penjelajah Pintar',
  4 => 'Penjelajah Hebat',
  _ => 'Penjelajah Juara',
};

class _AccountHero extends StatelessWidget {
  const _AccountHero();

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return SizedBox(
      height: 138,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Stack(fit: StackFit.expand),
            ),
          ),
          Positioned(
            left: 20,
            top: 22,
            right: 112,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Akun',
                  style: TextStyle(
                    fontSize: 34,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    color: t.night ? Colors.white : const Color(0xff38258A),
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: t.night
                            ? Colors.black.withValues(alpha: .5)
                            : Colors.white,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kelola profil dan pengaturan akunmu ✨',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: t.night
                        ? const Color(0xffB8C0D8)
                        : const Color(0xff58607E),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: t.night
                            ? Colors.black.withValues(alpha: .3)
                            : Colors.white,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 18,
            top: 18,
            child: Row(
              children: [
                _AccountRoundButton(icon: Icons.settings_rounded),
                SizedBox(width: 10),
                _AccountNotifyButton(),
              ],
            ),
          ),
          ...List.generate(10, (i) {
            final left = 34.0 + (i * 41 % 300);
            final top = 24.0 + (i * 23 % 84);
            return Positioned(
              left: left,
              top: top,
              child:
                  Icon(
                        i.isEven
                            ? Icons.star_rounded
                            : Icons.auto_awesome_rounded,
                        size: i.isEven ? 13 : 10,
                        color: const Color(0xffFFD34D).withValues(alpha: .75),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        begin: const Offset(.75, .75),
                        end: const Offset(1.1, 1.1),
                        duration: (900 + i * 80).ms,
                      ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(duration: 320.ms).slideY(begin: .04);
  }
}

class _PremiumProfileCard extends StatelessWidget {
  const _PremiumProfileCard({required this.app});
  final AppState app;

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).width >= 700;
    final name = app.email?.trim().isNotEmpty == true
        ? app.email!.trim()
        : 'Pengguna';
    final level = _accountLevel(app.stars);
    final need = level >= 5 ? 500 : level * 100;
    final current = app.stars.clamp(0, need);
    final avatar = app.gender == Gender.girl
        ? 'assets/images/profil_perempuan.png'
        : 'assets/images/profil_lakilaki.png';
    return Container(
      padding: EdgeInsets.all(tablet ? 24 : 18),
      decoration: _accountCardDecoration(
        context,
        shadow: const Color(0xff855CFF),
        radius: 34,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -8,
            top: -14,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: const Color(0xffFFD24D).withValues(alpha: .70),
              size: 24,
            ),
          ),
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: tablet ? 118 : 94,
                    height: tablet ? 118 : 94,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xff6AD7FF), Color(0xff9D6BFF)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                          color: const Color(0xff6D8CFF).withValues(alpha: .25),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(avatar, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 4,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xff8D55F6), Color(0xffFF7CBD)],
                        ),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 12,
                            color: const Color(
                              0xff8D55F6,
                            ).withValues(alpha: .30),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: tablet ? 28 : 23,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xff2F2D72),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _AccountPill(
                          icon: Icons.star_rounded,
                          label: 'Level $level',
                          color: const Color(0xff8B55F6),
                        ),
                        _AccountPill(
                          icon: Icons.workspace_premium_rounded,
                          label: _levelTitle(level),
                          color: const Color(0xffFFB020),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: 0,
                          end: need == 0 ? 0 : current / need,
                        ),
                        duration: 700.ms,
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          minHeight: 10,
                          backgroundColor: const Color(0xffEBE7FF),
                          color: const Color(0xff8B55F6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$current / $need XP',
                      style: const TextStyle(
                        color: Color(0xff65698B),
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (tablet) ...[
                const SizedBox(width: 14),
                _RewardTrophy(stars: app.stars),
              ] else
                _RewardTrophy(stars: app.stars, compact: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _LearningStats extends ConsumerWidget {
  const _LearningStats({required this.app});
  final AppState app;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablet = MediaQuery.sizeOf(context).width >= 700;
    final badgeCount = BadgeService.instance.unlockedCount(app.progress);
    final studiedCount = _studiedMaterialCount(app);
    final stats = [
      _StatData(
        Icons.menu_book_rounded,
        'Materi Dipelajari',
        studiedCount,
        'Topik',
        const Color(0xff33C66A),
      ),
      _StatData(
        Icons.event_available_rounded,
        'Streak Belajar',
        app.iqraStreak,
        'Hari',
        const Color(0xff16B9E8),
      ),
      _StatData(
        Icons.workspace_premium_rounded,
        'Badge',
        badgeCount,
        'Diperoleh',
        const Color(0xffFFB020),
      ),
      _StatData(
        Icons.star_rounded,
        'Total Poin',
        app.stars,
        'Bintang',
        const Color(0xff8B55F6),
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: tablet ? 4 : 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: tablet ? 2.45 : 2.05,
      ),
      itemCount: stats.length,
      itemBuilder: (_, i) => _StatCard(data: stats[i], delay: i * 70),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.app,
    required this.onProfileTap,
    required this.onSecurityTap,
    required this.onParentTap,
    required this.onLanguageTap,
    required this.onThemeTap,
    required this.onFaqTap,
  });
  final AppState app;
  final VoidCallback onProfileTap;
  final VoidCallback onSecurityTap;
  final VoidCallback onParentTap;
  final VoidCallback onLanguageTap;
  final VoidCallback onThemeTap;
  final VoidCallback onFaqTap;

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).width >= 700;
    final settings = [
      _SettingData(
        Icons.person_rounded,
        'Profil Saya',
        'Lihat dan edit profil',
        const Color(0xff30C46A),
      ),
      _SettingData(
        Icons.security_rounded,
        'Keamanan',
        'Ubah password & keamanan',
        const Color(0xff20C997),
      ),
      _SettingData(
        Icons.child_care_rounded,
        'Pengaturan Anak',
        'Atur preferensi belajar',
        const Color(0xff36A3FF),
      ),
      _SettingData(
        Icons.family_restroom_rounded,
        'Orang Tua',
        'Kontrol dan pantau anak',
        const Color(0xffFF6DA8),
      ),
      _SettingData(
        Icons.language_rounded,
        'Bahasa',
        app.languageCode == 'en' ? 'English' : 'Bahasa Indonesia',
        const Color(0xff8B55F6),
      ),
      _SettingData(
        Icons.notifications_rounded,
        'Notifikasi',
        'Dinonaktifkan sementara',
        const Color(0xffFF8A00),
      ),
      _SettingData(
        Icons.color_lens_rounded,
        'Tema',
        'Tema ${app.theme.name}',
        const Color(0xffFF6BCB),
      ),
      _SettingData(
        Icons.help_rounded,
        'Bantuan & FAQ',
        'Pusat bantuan aplikasi',
        const Color(0xff2BA8FF),
      ),
    ];
    return _AccountSectionCard(
      title: 'Pengaturan Akun',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: tablet ? 2 : 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 12,
          childAspectRatio: tablet ? 5.2 : 4.8,
        ),
        itemCount: settings.length,
        itemBuilder: (_, i) {
          final data = settings[i];
          final disabled =
              data.title == 'Notifikasi' ||
              data.title == 'Pengaturan Anak' ||
              data.title == 'Bahasa';
          final action = switch (data.title) {
            'Profil Saya' => onProfileTap,
            'Keamanan' => onSecurityTap,
            'Orang Tua' => onParentTap,
            'Bahasa' => onLanguageTap,
            'Tema' => onThemeTap,
            'Bantuan & FAQ' => onFaqTap,
            _ => () => Feedback.forTap(context),
          };
          return Opacity(
            opacity: disabled ? .52 : 1,
            child: _SettingsTile(data: data, onTap: disabled ? () {} : action),
          );
        },
      ),
    );
  }
}

class _AccountMiniHeader extends StatelessWidget {
  const _AccountMiniHeader({required this.title, required this.onBack});
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AccountTapCard(
          compact: true,
          onTap: onBack,
          child: const Icon(Icons.arrow_back_rounded, color: Color(0xff343864)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xff343864),
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _AccountSubPage extends StatelessWidget {
  const _AccountSubPage({
    required this.title,
    required this.onBack,
    required this.children,
  });
  final String title;
  final VoidCallback onBack;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).width >= 700;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: tablet ? 980 : 520),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            tablet ? 28 : 18,
            14,
            tablet ? 28 : 18,
            126,
          ),
          children: [
            _AccountMiniHeader(title: title, onBack: onBack),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ProfileSettingsPage extends ConsumerStatefulWidget {
  const _ProfileSettingsPage({required this.app, required this.onBack});
  final AppState app;
  final VoidCallback onBack;

  @override
  ConsumerState<_ProfileSettingsPage> createState() =>
      _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends ConsumerState<_ProfileSettingsPage> {
  late final TextEditingController name;
  late Gender gender;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.app.childName);
    gender = widget.app.gender;
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AccountSubPage(
      title: 'Profil Saya',
      onBack: widget.onBack,
      children: [
        _AccountSectionCard(
          title: 'Data Profil',
          child: Column(
            children: [
              AppField(
                controller: name,
                label: 'Nama Anak',
                icon: Icons.badge_rounded,
              ),
              Row(
                children: [
                  Expanded(
                    child: _ChoicePill(
                      label: 'Laki-laki',
                      active: gender == Gender.boy,
                      onTap: () => setState(() => gender = Gender.boy),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ChoicePill(
                      label: 'Perempuan',
                      active: gender == Gender.girl,
                      onTap: () => setState(() => gender = Gender.girl),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () async {
                  await ref
                      .read(appStateProvider)
                      .updateProfile(name: name.text, gender: gender);
                  if (context.mounted) widget.onBack();
                },
                icon: const Icon(Icons.save_rounded),
                label: const Text('Simpan Profil'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecuritySettingsPage extends ConsumerStatefulWidget {
  const _SecuritySettingsPage({required this.app, required this.onBack});
  final AppState app;
  final VoidCallback onBack;

  @override
  ConsumerState<_SecuritySettingsPage> createState() =>
      _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends ConsumerState<_SecuritySettingsPage> {
  final pass = TextEditingController();
  final confirm = TextEditingController();
  String? error;
  bool loading = false;

  @override
  void dispose() {
    pass.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AccountSubPage(
      title: 'Keamanan',
      onBack: widget.onBack,
      children: [
        _AccountSectionCard(
          title: 'Ubah Password',
          child: Column(
            children: [
              AppField(
                controller: pass,
                label: 'Password Baru',
                icon: Icons.lock_rounded,
                obscure: true,
              ),
              AppField(
                controller: confirm,
                label: 'Konfirmasi Password',
                icon: Icons.verified_user_rounded,
                obscure: true,
              ),
              if (error != null)
                _AccountInfoBox(text: error!, color: const Color(0xffEF4444)),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: loading ? null : _submit,
                icon: loading
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.password_rounded),
                label: const Text('Ubah Password'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (pass.text.length < 6) {
      return setState(() => error = 'Password minimal 6 karakter');
    }
    if (pass.text != confirm.text) {
      return setState(() => error = 'Konfirmasi password belum sama');
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await ref
          .read(appStateProvider)
          .resetPassword(
            username: widget.app.email ?? '',
            newPassword: pass.text,
          );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierColor: Colors.black.withValues(alpha: .22),
        builder: (_) => const _PasswordChangedDialog(),
      );
      if (mounted) widget.onBack();
    } catch (e) {
      setState(() => error = ApiErrorMapper.toMessage(e));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
}

class _ParentSettingsPage extends StatelessWidget {
  const _ParentSettingsPage({required this.app, required this.onBack});
  final AppState app;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final total = _accountTotalProgress(app.progress);
    return _AccountSubPage(
      title: 'Orang Tua',
      onBack: onBack,
      children: [
        _AccountSectionCard(
          title: 'Ringkasan Anak',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AccountInfoBox(
                text: 'Progress total: $total%',
                color: const Color(0xff36A3FF),
              ),
              _AccountInfoBox(
                text: 'Bintang: ${app.stars}',
                color: const Color(0xffFFB020),
              ),
              _AccountInfoBox(
                text: 'Favorit tersimpan: ${app.favorites.length}',
                color: const Color(0xffFF6DA8),
              ),
              _AccountInfoBox(
                text: 'Streak Iqra: ${app.iqraStreak}',
                color: const Color(0xff8B55F6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LanguageSettingsPage extends ConsumerWidget {
  const _LanguageSettingsPage({required this.app, required this.onBack});
  final AppState app;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _AccountSubPage(
      title: 'Bahasa',
      onBack: onBack,
      children: [
        _AccountSectionCard(
          title: 'Pilih Bahasa',
          child: Column(
            children: [
              _ChoicePill(
                label: 'Bahasa Indonesia',
                active: app.languageCode == 'id',
                onTap: () => ref.read(appStateProvider).setLanguage('id'),
              ),
              const SizedBox(height: 10),
              _ChoicePill(
                label: 'English',
                active: app.languageCode == 'en',
                onTap: () => ref.read(appStateProvider).setLanguage('en'),
              ),
              const SizedBox(height: 12),
              const _AccountInfoBox(
                text:
                    'Bahasa disimpan di SharedPreferences. Bagian pembelajaran otomatis menyesuaikan.',
                color: Color(0xff8B55F6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FaqSettingsPage extends StatelessWidget {
  const _FaqSettingsPage({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        'Apa itu aplikasi belajar PAUD ini?',
        'Aplikasi ini adalah media belajar interaktif untuk anak usia PAUD yang berisi materi dasar seperti huruf, angka, benda dan iqra.',
      ),
      (
        'Untuk usia berapa aplikasi ini digunakan?',
        'Aplikasi ini ditujukan untuk anak usia 3–6 tahun.',
      ),
      (
        'Bagaimana cara memulai belajar?',
        'Pilih menu belajar pada halaman utama, lalu pilih materi yang ingin dipelajari.',
      ),
      (
        'Bagaimana cara melihat progress anak?',
        'Buka menu Progress Anak untuk melihat materi yang sudah dipelajari dan hasil latihan anak.',
      ),
      (
        'Apakah level belajar bisa diubah?',
        'Ya, level belajar dapat diubah melalui menu Pengaturan Anak.',
      ),
      (
        'Bagaimana cara mengganti tema?',
        'Masuk ke menu Tema, lalu pilih tampilan yang diinginkan.',
      ),
      (
        'Bagaimana cara mengganti bahasa?',
        'Masuk ke menu Bahasa, lalu pilih bahasa yang tersedia.',
      ),
      (
        'Bagaimana jika suara tidak muncul?',
        'Pastikan volume perangkat aktif dan browser mengizinkan pemutaran audio.',
      ),
      (
        'Apakah aplikasi bisa digunakan di HP?',
        'Ya, aplikasi bisa digunakan melalui browser di HP, tablet, laptop, atau komputer.',
      ),
      (
        'Apa yang harus dilakukan jika lupa password?',
        'Gunakan fitur Lupa Password pada halaman login untuk mengatur ulang password.',
      ),
      (
        'Apakah data anak aman?',
        'Data anak digunakan hanya untuk kebutuhan pembelajaran dan pemantauan progress di dalam aplikasi.',
      ),
    ];
    return _AccountSubPage(
      title: 'Bantuan & FAQ',
      onBack: onBack,
      children: [
        _AccountSectionCard(
          title: 'Pertanyaan Umum',
          child: Column(
            children: items
                .map((item) => _FaqItem(question: item.$1, answer: item.$2))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(active ? Icons.check_circle_rounded : Icons.circle_outlined),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        foregroundColor: active
            ? const Color(0xff6C36EF)
            : const Color(0xff5A5F7D),
        side: BorderSide(
          color: active ? const Color(0xff6C36EF) : const Color(0xffD8D7F5),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}

class _AccountInfoBox extends StatelessWidget {
  const _AccountInfoBox({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: .24)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.question, required this.answer});
  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: Color(0xff343864),
        ),
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(answer),
          ),
        ),
      ],
    );
  }
}

class _PasswordChangedDialog extends StatelessWidget {
  const _PasswordChangedDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(22),
        decoration: _accountCardDecoration(context, radius: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xff25C06D),
              size: 76,
            ),
            const SizedBox(height: 14),
            const Text(
              'Password berhasil diganti!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff343864),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Gunakan password baru saat login berikutnya.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Oke'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSettingsPage extends ConsumerWidget {
  const _ThemeSettingsPage({required this.app, required this.onBack});
  final AppState app;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablet = MediaQuery.sizeOf(context).width >= 700;
    final current = app.theme;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: tablet ? 980 : 520),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            tablet ? 28 : 18,
            14,
            tablet ? 28 : 18,
            126,
          ),
          children: [
            Row(
              children: [
                _AccountTapCard(
                  onTap: onBack,
                  compact: true,
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: Color(0xff8B55F6),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ganti Tema',
                    style: sectionTitle(context).copyWith(
                      color: current.night
                          ? NightPalette.text
                          : const Color(0xff303163),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: current.night
                  ? nightGlassDecoration(
                      borderColor: current.primary,
                      radius: 30,
                    )
                  : _accountCardDecoration(
                      context,
                      shadow: current.primary,
                      radius: 30,
                    ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      current.backgroundAsset ?? current.asset,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          current.name,
                          style: TextStyle(
                            color: current.night
                                ? NightPalette.text
                                : const Color(0xff303163),
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tema sedang aktif',
                          style: TextStyle(
                            color: current.night
                                ? NightPalette.muted
                                : const Color(0xff8185A1),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.check_circle_rounded,
                    color: current.accent,
                    size: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _AccountSectionCard(
              title: 'Pilih Tema',
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appThemes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: tablet ? 3 : 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: tablet ? .94 : .82,
                ),
                itemBuilder: (context, i) {
                  final theme = appThemes[i];
                  final picked = theme.id == app.themeId;
                  return _SimpleThemeCard(
                    theme: theme,
                    picked: picked,
                    onTap: () {
                      Feedback.forTap(context);
                      ref.read(appStateProvider).setTheme(theme.id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleThemeCard extends StatelessWidget {
  const _SimpleThemeCard({
    required this.theme,
    required this.picked,
    required this.onTap,
  });
  final AppThemeData theme;
  final bool picked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isNight = theme.night;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isNight
                ? NightPalette.surface.withValues(alpha: .78)
                : Colors.white.withValues(alpha: .94),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: picked
                  ? theme.accent
                  : theme.primary.withValues(alpha: .25),
              width: picked ? 3 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: picked ? 22 : 12,
                offset: const Offset(0, 8),
                color: theme.primary.withValues(alpha: picked ? .28 : .10),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        theme.backgroundAsset ?? theme.asset,
                        fit: BoxFit.cover,
                      ),
                      if (picked)
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.accent,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                theme.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isNight ? NightPalette.text : const Color(0xff303163),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 220.ms).slideY(begin: .04);
  }
}

// ignore: unused_element
class _PremiumBanner extends StatelessWidget {
  const _PremiumBanner({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xff7B55FF), Color(0xffF779BD)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 22,
              offset: const Offset(0, 12),
              color: const Color(0xffA45CFF).withValues(alpha: .25),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: .20),
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: Color(0xffFFD84D),
                size: 32,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppIdentity.appName} Premium 👑',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Akses semua fitur premium dan materi eksklusif!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lihat Benefit',
                    style: TextStyle(
                      color: Color(0xffE34DA0),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xffE34DA0),
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 320.ms).slideY(begin: .06),
    );
  }
}

class _OverallProgressCard extends StatelessWidget {
  const _OverallProgressCard({required this.progress, required this.app});
  final int progress;
  final AppState app;

  @override
  Widget build(BuildContext context) {
    final mascot = app.gender == Gender.girl
        ? 'assets/images/Anak_Perempuan_Menu.png'
        : 'assets/images/Anak_LakiLaki_Menu.png';
    return Container(
      constraints: const BoxConstraints(minHeight: 176),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xffDCF4FF), Color(0xffF1E8FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 12),
            color: const Color(0xff6AAFE6).withValues(alpha: .20),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            height: 92,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 88,
                  height: 88,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress / 100),
                    duration: 800.ms,
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) =>
                        CircularProgressIndicator(
                          value: value,
                          strokeWidth: 9,
                          strokeCap: StrokeCap.round,
                          color: const Color(0xff1E95F2),
                          backgroundColor: Colors.white.withValues(alpha: .75),
                        ),
                  ),
                ),
                Text(
                  '$progress%',
                  style: const TextStyle(
                    color: Color(0xff1E95F2),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Progress Keseluruhan',
                  style: TextStyle(
                    color: Color(0xff27306E),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Hebat! Kamu sudah menyelesaikan banyak materi.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xff59607E),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 12),
                _DetailButton(),
              ],
            ),
          ),
          Image.asset(mascot, width: 92, fit: BoxFit.contain),
        ],
      ),
    );
  }
}

class _BadgeShowcase extends ConsumerWidget {
  const _BadgeShowcase();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    final svc = BadgeService.instance;
    final badges = svc.allBadges;
    final unlocked = svc.unlockedCount(app.progress);

    return _AccountSectionCard(
      title: 'Koleksi Badge',
      trailing: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BadgeCollectionScreen()),
        ),
        child: const Text(
          'Lihat Semua',
          style: TextStyle(
            color: Color(0xff8B55F6),
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 94,
            child: Row(
              children: badges.take(4).map((badge) {
                final isOpen = svc.isUnlocked(badge, app.progress);
                return Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BadgeCollectionScreen(),
                      ),
                    ),
                    child:
                        Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: isOpen
                                    ? LinearGradient(
                                        colors: [
                                          badge.glowColor.withValues(
                                            alpha: .72,
                                          ),
                                          badge.glowColor,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                    color: isOpen
                                        ? badge.glowColor.withValues(alpha: .28)
                                        : Colors.grey.withValues(alpha: .15),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(
                                  isOpen
                                      ? badge.assetUnlocked
                                      : badge.assetLocked,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .moveY(
                              begin: isOpen ? -3 : 0,
                              end: isOpen ? 3 : 0,
                              duration: 1300.ms,
                            ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          // Progress summary
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: Color(0xffFFB020),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                '$unlocked / ${badges.length} Badge Terbuka',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff7A7E9B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogoutCard extends StatelessWidget {
  const _LogoutCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _AccountTapCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xffFF4D6D).withValues(alpha: .12),
            ),
            child: const Icon(Icons.logout_rounded, color: Color(0xffFF4D6D)),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keluar',
                  style: TextStyle(
                    color: Color(0xff343864),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Keluar dari akun ini',
                  style: TextStyle(
                    color: Color(0xff7A7E9B),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xffA8ADC8)),
        ],
      ),
    );
  }
}

class _AccountLogoutDialog extends StatelessWidget {
  const _AccountLogoutDialog();

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(22),
        decoration: _accountCardDecoration(context, radius: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xffFF8FA3).withValues(alpha: .95),
                    const Color(0xffFF4D6D),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                    color: const Color(0xffFF4D6D).withValues(alpha: .28),
                  ),
                ],
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Keluar dari akun?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff343864),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Progress dan pengaturan tetap aman. Kamu bisa login lagi kapan saja.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: t.night
                    ? const Color(0xffB8C0D8)
                    : const Color(0xff6E7391),
                fontSize: 13,
                fontWeight: FontWeight.w800,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      side: const BorderSide(color: Color(0xffD8D7F5)),
                      foregroundColor: const Color(0xff5A5F7D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: const Color(0xffFF4D6D),
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
    );
  }
}

class _TeacherDashboardCard extends StatelessWidget {
  const _TeacherDashboardCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _AccountTapCard(
      onTap: onTap,
      child: const Row(
        children: [
          _SettingIcon(icon: Icons.dashboard_rounded, color: Colors.deepPurple),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Dashboard Pengajar',
              style: TextStyle(
                color: Color(0xff343864),
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Color(0xffA8ADC8)),
        ],
      ),
    );
  }
}

class _AccountSectionCard extends StatelessWidget {
  const _AccountSectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _accountCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: t.night
                        ? NightPalette.text
                        : const Color(0xff303163),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              ...?trailing == null ? null : <Widget>[trailing!],
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.data, required this.onTap});
  final _SettingData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return _AccountTapCard(
      onTap: onTap,
      compact: true,
      child: Row(
        children: [
          _SettingIcon(icon: data.icon, color: data.color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: t.night
                        ? NightPalette.text
                        : const Color(0xff343864),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: t.night
                        ? NightPalette.muted
                        : const Color(0xff8185A1),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xffA8ADC8),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data, required this.delay});
  final _StatData data;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _accountCardDecoration(
        context,
        radius: 24,
        shadow: data.color,
      ),
      child: Row(
        children: [
          _SettingIcon(icon: data.icon, color: data.color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: t.night
                        ? NightPalette.muted
                        : const Color(0xff44496D),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: data.value),
                      duration: 620.ms,
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) => Text(
                        '$value',
                        style: TextStyle(
                          color: data.color,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      data.unit,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: t.night
                            ? NightPalette.muted
                            : const Color(0xff7E829E),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: .06);
  }
}

class _AccountTapCard extends StatelessWidget {
  const _AccountTapCard({
    required this.child,
    required this.onTap,
    this.compact = false,
  });
  final Widget child;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: EdgeInsets.all(compact ? 10 : 14),
          decoration: _accountCardDecoration(context, radius: 22),
          child: child,
        ),
      ),
    );
  }
}

class _SettingIcon extends StatelessWidget {
  const _SettingIcon({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withValues(alpha: .13),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _AccountRoundButton extends StatelessWidget {
  const _AccountRoundButton({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .78),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                blurRadius: 14,
                offset: const Offset(0, 8),
                color: const Color(0xff6AAFE6).withValues(alpha: .18),
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xff8B55F6), size: 23),
        ),
      ),
    );
  }
}

class _AccountNotifyButton extends StatelessWidget {
  const _AccountNotifyButton();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const _AccountRoundButton(icon: Icons.notifications_rounded),
        Positioned(
          right: -3,
          top: -5,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Color(0xffFF334B),
              shape: BoxShape.circle,
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RewardTrophy extends StatelessWidget {
  const _RewardTrophy({required this.stars, this.compact = false});
  final int stars;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? 72 : 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/Badge.png', height: compact ? 52 : 82),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xffFFC928),
                size: 20,
              ),
              Text(
                '$stars',
                style: const TextStyle(
                  color: Color(0xff25305E),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const Text(
            'Poin Kamu',
            style: TextStyle(
              color: Color(0xff6D718E),
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountPill extends StatelessWidget {
  const _AccountPill({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 380;
    return Container(
      constraints: BoxConstraints(maxWidth: compact ? 160 : 220),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailButton extends StatelessWidget {
  const _DetailButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff8B55F6), Color(0xff38A7FF)],
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'Lihat Detail',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SettingData {
  const _SettingData(this.icon, this.title, this.subtitle, this.color);
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
}

class _StatData {
  const _StatData(this.icon, this.title, this.value, this.unit, this.color);
  final IconData icon;
  final String title;
  final int value;
  final String unit;
  final Color color;
}

BoxDecoration _accountCardDecoration(
  BuildContext context, {
  double radius = 28,
  Color shadow = const Color(0xff7AAED3),
}) {
  final t = _themeOf(context);
  if (t.night) {
    return nightGlassDecoration(borderColor: shadow, radius: radius);
  }
  return BoxDecoration(
    color: Colors.white.withValues(alpha: .94),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: Colors.white, width: 1.6),
    boxShadow: [
      BoxShadow(
        blurRadius: 22,
        offset: const Offset(0, 12),
        color: shadow.withValues(alpha: .16),
      ),
    ],
  );
}

class ThemeWheel extends ConsumerWidget {
  const ThemeWheel({required this.app, super.key});
  final AppState app;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = max(
      0,
      appThemes.indexWhere((e) => e.id == app.themeId),
    );
    final selected = appThemes[selectedIndex];
    final wide = MediaQuery.sizeOf(context).width > 520;
    final radius = wide ? 142.0 : 116.0;
    final size = radius * 2 + 86;

    return Column(
      children: [
        SizedBox(
          height: size,
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: -selectedIndex * 2 * pi / appThemes.length,
              ),
              duration: 520.ms,
              curve: Curves.easeOutBack,
              builder: (context, spin, child) {
                return SizedBox(
                  width: size,
                  height: size,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: radius * 2.02,
                        height: radius * 2.02,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: .78),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 28,
                              offset: const Offset(0, 14),
                              color: selected.primary.withValues(alpha: .22),
                            ),
                          ],
                        ),
                      ),
                      Transform.rotate(
                        angle: spin,
                        child: Container(
                          width: radius * 1.86,
                          height: radius * 1.86,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: appThemes.map((e) => e.primary).toList(),
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: .85),
                              width: 8,
                            ),
                          ),
                        ),
                      ),
                      ...List.generate(18, (i) {
                        final a = (2 * pi * i / 18) - pi / 2;
                        return Transform.translate(
                          offset: Offset(
                            cos(a) * radius * .68,
                            sin(a) * radius * .68,
                          ),
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xfffff1a8),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.amber.withValues(alpha: .55),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      ...List.generate(appThemes.length, (i) {
                        final theme = appThemes[i];
                        final angle =
                            (2 * pi * i / appThemes.length) - pi / 2 + spin;
                        final picked = theme.id == app.themeId;
                        return Transform.translate(
                          offset: Offset(
                            cos(angle) * radius,
                            sin(angle) * radius,
                          ),
                          child: _WheelThemeBadge(
                            theme: theme,
                            picked: picked,
                            onTap: () {
                              Feedback.forTap(context);
                              ref.read(appStateProvider).setTheme(theme.id);
                            },
                          ),
                        );
                      }),
                      if (selected.night)
                        ...List.generate(16, (i) {
                          final a = (2 * pi * i / 16) - pi / 2;
                          return Transform.translate(
                            offset: Offset(
                              cos(a) * radius * .47,
                              sin(a) * radius * .47,
                            ),
                            child: Icon(
                              i.isEven
                                  ? Icons.star_rounded
                                  : Icons.auto_awesome_rounded,
                              size: i.isEven ? 14 : 10,
                              color: NightPalette.gold.withValues(alpha: .70),
                              shadows: [
                                Shadow(
                                  blurRadius: 12,
                                  color: NightPalette.gold.withValues(
                                    alpha: .65,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      Container(
                        width: radius * .98,
                        height: radius * .98,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected.dark
                              ? const Color(0xff212433)
                              : Colors.white.withValues(alpha: .94),
                          border: Border.all(
                            color: selected.accent.withValues(alpha: .9),
                            width: 5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 26,
                              color: selected.primary.withValues(alpha: .28),
                            ),
                            BoxShadow(
                              blurRadius: 0,
                              spreadRadius: 8,
                              color: selected.primary.withValues(alpha: .09),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                selected.asset,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Text(
                              selected.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: selected.dark
                                    ? Colors.white
                                    : const Color(0xff42309a),
                              ),
                            ),
                            Text(
                              'Pratinjau aktif',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: selected.dark
                                    ? Colors.white60
                                    : const Color(0xff6c59ba),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 28,
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [selected.primary, selected.accent],
                            ),
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 16,
                                color: selected.primary.withValues(alpha: .35),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _WheelThemeBadge extends StatelessWidget {
  const _WheelThemeBadge({
    required this.theme,
    required this.picked,
    required this.onTap,
  });
  final AppThemeData theme;
  final bool picked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isNight = theme.night;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: 220.ms,
        scale: picked ? 1.12 : 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: picked ? 82 : 70,
              height: picked ? 82 : 70,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: picked
                      ? theme.accent
                      : (isNight ? NightPalette.lavender : theme.primary),
                  width: picked ? 5 : 3,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: picked || isNight ? 24 : 10,
                    offset: const Offset(0, 8),
                    color: (isNight ? NightPalette.cyan : theme.primary)
                        .withValues(alpha: picked ? .42 : .22),
                  ),
                ],
              ),
              child: ClipOval(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(theme.asset, fit: BoxFit.cover),
                    if (isNight)
                      Align(
                        alignment: Alignment.topRight,
                        child:
                            Icon(
                                  Icons.nightlight_round,
                                  color: NightPalette.gold.withValues(
                                    alpha: .95,
                                  ),
                                  size: 24,
                                )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .scale(
                                  begin: const Offset(.88, .88),
                                  end: const Offset(1.12, 1.12),
                                  duration: 1100.ms,
                                ),
                      ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isNight ? NightPalette.surface : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: (isNight ? NightPalette.cyan : theme.primary)
                        .withValues(alpha: .55),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: theme.primary.withValues(alpha: .18),
                    ),
                  ],
                ),
                child: Text(
                  theme.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: isNight ? NightPalette.text : theme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
class _ThemeCardStrip extends ConsumerWidget {
  const _ThemeCardStrip({required this.app});
  final AppState app;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .72),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: .8), width: 2),
        boxShadow: softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xff6c5ce7).withValues(alpha: .14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.palette_rounded,
                  color: Color(0xff6c5ce7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Pilih Tema',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff42309a),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 142,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: appThemes.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final theme = appThemes[i];
                final picked = app.themeId == theme.id;
                return GestureDetector(
                  onTap: () {
                    Feedback.forTap(context);
                    ref.read(appStateProvider).setTheme(theme.id);
                  },
                  child: AnimatedContainer(
                    duration: 220.ms,
                    width: 104,
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: picked ? 1 : .82),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: picked ? theme.primary : Colors.white,
                        width: picked ? 3 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: picked ? 18 : 8,
                          offset: const Offset(0, 8),
                          color: theme.primary.withValues(
                            alpha: picked ? .3 : .08,
                          ),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              color: theme.primary.withValues(alpha: .12),
                              child: Image.asset(
                                theme.asset,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          theme.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: picked
                                ? theme.primary
                                : const Color(0xff172554),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Icon(
                          picked
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          size: 20,
                          color: picked ? theme.primary : Colors.grey.shade400,
                        ),
                      ],
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
