part of '../main.dart';

enum _AuthMode { login, register }

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final page = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appStateProvider).theme;
    final slides = [
      (
        'Selamat datang di ${AppIdentity.appName}!',
        'Belajar sambil bermain setiap hari.',
        Icons.waving_hand_rounded,
        'assets/images/Anak_hebat.png',
      ),
      (
        'Mode Seru dengan suara',
        'Ucapkan jawaban, dapatkan reward.',
        Icons.mic_rounded,
        'assets/images/Logo_membaca.png',
      ),
      (
        'Lagu anak interaktif',
        'Bernyanyi, bergerak, dan tetap fokus.',
        Icons.music_note_rounded,
        'assets/images/Bernyanyi.png',
      ),
      (
        'Tracking progress belajar',
        'Ayah, Bunda, dan Pengajar mudah memantau.',
        Icons.insights_rounded,
        'assets/images/Logo_123.png',
      ),
    ];

    return Scaffold(
      body: ThemedBackground(
        child: Stack(
          children: [
            const _FloatingShapes(),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: page,
                      onPageChanged: (v) => setState(() => index = v),
                      itemCount: slides.length,
                      itemBuilder: (_, i) {
                        final s = slides[i];
                        return Padding(
                          padding: const EdgeInsets.all(26),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _GlassCard(
                                child: Column(
                                  children: [
                                    Icon(s.$3, color: t.primary, size: 42),
                                    const SizedBox(height: 14),
                                    Image.asset(
                                          s.$4,
                                          height: 210,
                                          fit: BoxFit.contain,
                                        )
                                        .animate(
                                          onPlay: (c) =>
                                              c.repeat(reverse: true),
                                        )
                                        .moveY(
                                          begin: -8,
                                          end: 8,
                                          duration: 1800.ms,
                                        ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                s.$1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                  color: t.dark
                                      ? Colors.white
                                      : const Color(0xff143447),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                s.$2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: muted(context),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(slides.length, (i) {
                      final active = i == index;
                      return AnimatedContainer(
                        duration: 220.ms,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 26 : 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: active
                              ? t.primary
                              : t.primary.withValues(alpha: .25),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: FilledButton.icon(
                      onPressed: () =>
                          ref.read(appStateProvider).completeOnboarding(),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Mulai Belajar'),
                      style: bigButton(t.primary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final username = TextEditingController();
  final pass = TextEditingController();
  _AuthMode mode = _AuthMode.login;
  Gender gender = Gender.boy;
  bool showPass = false;
  bool loading = false;
  String? error;

  @override
  void dispose() {
    username.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final register = mode == _AuthMode.register;
    final size = MediaQuery.sizeOf(context);
    final tablet = size.width >= 900;
    final panel = _AuthPanelCard(
      register: register,
      username: username,
      password: pass,
      gender: gender,
      showPass: showPass,
      loading: loading,
      error: error,
      onTogglePassword: () => setState(() => showPass = !showPass),
      onSelectGender: (value) => setState(() => gender = value),
      onSubmit: loading ? null : _submit,
      onToggleMode: () => setState(() {
        mode = register ? _AuthMode.login : _AuthMode.register;
        error = null;
      }),
      onForgotPassword: _showForgotPasswordHint,
    );
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff7FD8FF), Color(0xffB4EBFF), Color(0xffF3FFD8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/Background_image.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: .08),
                      const Color(0xff7A3FF3).withValues(alpha: .10),
                      Colors.white.withValues(alpha: .12),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            const _FloatingShapes(),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: tablet ? 1120 : 560,
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          tablet ? 28 : 14,
                          tablet ? 24 : 12,
                          tablet ? 28 : 14,
                          20,
                        ),
                        child: tablet
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 24),
                                      child: _LoginHero(
                                        register: register,
                                        tablet: true,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: min(470, constraints.maxWidth * .42),
                                    child: panel,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  _LoginHero(register: register, tablet: false),
                                  Transform.translate(
                                    offset: const Offset(0, -26),
                                    child: panel,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (username.text.trim().length < 3) {
      return setState(() => error = 'Username minimal 3 karakter');
    }
    if (pass.text.length < 6) {
      return setState(() => error = 'Password minimal 6 karakter');
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await ref
          .read(appStateProvider)
          .login(
            nextEmail: username.text,
            password: pass.text,
            register: mode == _AuthMode.register,
            name: mode == _AuthMode.register ? username.text : null,
            nextGender: gender,
          );
    } catch (e) {
      setState(() => error = ApiErrorMapper.toMessage(e));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _showForgotPasswordHint() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Silakan hubungi pengajar atau orang tua untuk reset akun.',
        ),
      ),
    );
  }
}

class _LoginHero extends StatelessWidget {
  const _LoginHero({required this.register, required this.tablet});
  final bool register;
  final bool tablet;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tablet ? 420 : 260,
      child: Center(
        child: Image.asset(
          'assets/images/Logo_Aplikasi.png',
          width: tablet ? 520 : 300,
          fit: BoxFit.contain,
        ),
      ),
    ).animate().fadeIn(duration: 360.ms).slideY(begin: .04);
  }
}

class _AuthPanelCard extends StatelessWidget {
  const _AuthPanelCard({
    required this.register,
    required this.username,
    required this.password,
    required this.gender,
    required this.showPass,
    required this.loading,
    required this.error,
    required this.onTogglePassword,
    required this.onSelectGender,
    required this.onSubmit,
    required this.onToggleMode,
    required this.onForgotPassword,
  });

  final bool register;
  final TextEditingController username;
  final TextEditingController password;
  final Gender gender;
  final bool showPass;
  final bool loading;
  final String? error;
  final VoidCallback onTogglePassword;
  final ValueChanged<Gender> onSelectGender;
  final VoidCallback? onSubmit;
  final VoidCallback onToggleMode;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).width >= 900;
    return Container(
      padding: EdgeInsets.fromLTRB(
        tablet ? 30 : 22,
        tablet ? 30 : 24,
        tablet ? 30 : 22,
        tablet ? 28 : 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(42),
        boxShadow: [
          BoxShadow(
            blurRadius: 40,
            offset: const Offset(0, 18),
            color: const Color(0xff6942E9).withValues(alpha: .18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 6,
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xffFFC629),
                size: 28,
              ),
              Text(
                register ? 'Buat Akun Baru!' : 'Selamat Datang!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xff3E318E),
                  fontSize: tablet ? 28 : 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Icon(
                Icons.star_rounded,
                color: Color(0xffFFC629),
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            register
                ? 'Daftar untuk memulai petualangan belajar bersama Khoir Quest'
                : 'Masuk untuk melanjutkan petualangan belajar bersama Khoir Quest',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff6B6E86),
              fontSize: 15,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 26),
          _AuthInput(
            controller: username,
            hint: 'Username',
            icon: Icons.person_rounded,
          ),
          const SizedBox(height: 16),
          _AuthInput(
            controller: password,
            hint: 'Password',
            icon: Icons.lock_rounded,
            obscure: !showPass,
            suffix: IconButton(
              onPressed: onTogglePassword,
              icon: Icon(
                showPass
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: const Color(0xff9B5CF6),
              ),
            ),
          ),
          if (!register) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onForgotPassword,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xff6A42E8),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Lupa Password?',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                ),
              ),
            ),
          ],
          if (register) ...[
            const SizedBox(height: 18),
            const Text(
              'Pilih profil anak',
              style: TextStyle(
                color: Color(0xff4F5475),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _GenderCard(
                    label: 'Laki-laki',
                    gender: Gender.boy,
                    selected: gender == Gender.boy,
                    onTap: () => onSelectGender(Gender.boy),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GenderCard(
                    label: 'Perempuan',
                    gender: Gender.girl,
                    selected: gender == Gender.girl,
                    onTap: () => onSelectGender(Gender.girl),
                  ),
                ),
              ],
            ),
          ],
          if (error != null) ...[const SizedBox(height: 16), _ErrorBox(error!)],
          const SizedBox(height: 22),
          _PrimaryAuthButton(
            label: register ? 'Buat Akun' : 'Login',
            loading: loading,
            onTap: onSubmit,
          ),
          const SizedBox(height: 22),
          _DividerLabel(
            label: register ? 'Sudah punya akun?' : 'Belum punya akun?',
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onToggleMode,
            icon: Icon(
              register ? Icons.login_rounded : Icons.person_add_alt_1_rounded,
              color: const Color(0xff7A3FF3),
            ),
            label: Text(
              register ? 'Masuk ke Login' : 'Buat Akun Baru',
              style: const TextStyle(
                color: Color(0xff7A3FF3),
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xff9D6DFF), width: 1.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              minimumSize: const Size.fromHeight(58),
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_rounded, color: Color(0xff4CAF50)),
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  'Aman, terpercaya, dan ramah anak',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff6B6E86),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.label,
    required this.gender,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final Gender gender;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = gender == Gender.boy
        ? const Color(0xff1D9BF0)
        : const Color(0xffF15BB5);
    return InkWell(
          onTap: () {
            Feedback.forTap(context);
            onTap();
          },
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: 220.ms,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: selected ? color.withValues(alpha: .12) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? color : const Color(0xffE7DEF8),
                width: selected ? 2.2 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                  color: (selected ? color : const Color(0xff8A6DE9))
                      .withValues(alpha: selected ? .18 : .08),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  gender == Gender.boy
                      ? Icons.face_5_rounded
                      : Icons.face_3_rounded,
                  color: color,
                  size: 32,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: selected ? color : const Color(0xff6B6E86),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(target: selected ? 1 : 0)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.03, 1.03),
          duration: 180.ms,
        );
  }
}

class _AuthInput extends StatelessWidget {
  const _AuthInput({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xffE8E1F8), width: 1.6),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 10),
            color: const Color(0xff8D73E6).withValues(alpha: .08),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xff9B9DB3),
            fontWeight: FontWeight.w800,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xff7D45F7), Color(0xffA45DFF)],
                ),
              ),
              child: Icon(icon, color: Colors.white),
            ),
          ),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 22,
          ),
        ),
      ),
    );
  }
}

class _PrimaryAuthButton extends StatelessWidget {
  const _PrimaryAuthButton({
    required this.label,
    required this.loading,
    required this.onTap,
  });

  final String label;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffB15DFF), Color(0xff6C36EF)],
        ),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: const Color(0xff7E48F7).withValues(alpha: .28),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: SizedBox(
            height: 62,
            child: Row(
              children: [
                const SizedBox(width: 18),
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xffFFD34D),
                ),
                Expanded(
                  child: Center(
                    child: loading
                        ? const SizedBox.square(
                            dimension: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.6,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                  ),
                ),
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xffFFD34D),
                ),
                const SizedBox(width: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .78),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withValues(alpha: .70),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 28,
                offset: const Offset(0, 14),
                color: const Color(0xff6E49E9).withValues(alpha: .12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xffE5D8FB))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xff6B6E86),
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xffE5D8FB))),
      ],
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffFFF1F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffFFCCD2)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xffB42318),
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _FloatingShapes extends StatelessWidget {
  const _FloatingShapes();

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: List.generate(12, (i) {
            final left = (i * 67) % 360;
            final top = 30.0 + ((i * 91) % 720);
            final size = 18.0 + (i % 4) * 10;
            return Positioned(
              left: left.toDouble(),
              top: top,
              child:
                  Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: [
                            t.primary,
                            t.secondary,
                            t.accent,
                          ][i % 3].withValues(alpha: .12),
                          shape: i.isEven
                              ? BoxShape.circle
                              : BoxShape.rectangle,
                          borderRadius: i.isEven
                              ? null
                              : BorderRadius.circular(10),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(begin: -8, end: 8, duration: (1600 + i * 140).ms),
            );
          }),
        ),
      ),
    );
  }
}
