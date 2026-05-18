import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../services/storage_service.dart';

// ─── Entry point ────────────────────────────────────────────────────────────

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _ctrl = PageController();
  int _page = 0;
  String _selectedLang = 'English';

  static const _langs = [
    _Lang('🇺🇸', 'English'),
    _Lang('🇨🇳', 'Mandarin'),
    _Lang('🇪🇸', 'Spanish'),
    _Lang('🇮🇳', 'Hindi'),
    _Lang('🇫🇷', 'French'),
  ];

  Future<void> _finish(String route) async {
    await Get.find<StorageService>().setOnboarded(true);
    Get.offAllNamed(route);
  }

  void _next() {
    if (_page == 0) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish(Routes.signup);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _ctrl,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (v) => setState(() => _page = v),
        children: [
          // ── Page 0: Landing ──────────────────────────────────────────
          _LandingPage(
            onGetStarted: _next,
            onLogin: () => _finish(Routes.login),
          ),
          // ── Page 1: Language selection ───────────────────────────────
          _LanguageSelectionPage(
            langs: _langs,
            selected: _selectedLang,
            onBack: () => _ctrl.previousPage(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
            ),
            onChanged: (v) => setState(() => _selectedLang = v),
            onContinue: _next,
          ),
        ],
      ),
    );
  }
}

// ─── Data ────────────────────────────────────────────────────────────────────

class _Lang {
  const _Lang(this.flag, this.name);
  final String flag;
  final String name;
}

// ─── Colors ──────────────────────────────────────────────────────────────────

const _purple = Color(0xFF6C4FE0);
const _purpleLight = Color(0xFFEDE8FF);
const _purpleBorder = Color(0xFF7B5CE5);
const _textDark = Color(0xFF1A1A2E);
const _textGrey = Color(0xFF9E9EB0);

// ═══════════════════════════════════════════════════════════════════════════════
// PAGE 0 — Landing  (matches Image 1)
// ═══════════════════════════════════════════════════════════════════════════════

class _LandingPage extends StatelessWidget {
  const _LandingPage({required this.onGetStarted, required this.onLogin});

  final VoidCallback onGetStarted;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const Spacer(flex: 2),

            // ── Speech bubble ────────────────────────────────────────
            Align(
              alignment: Alignment.center,
              child: _SpeechBubble(text: "Hi there! I'm El!"),
            ),
            const SizedBox(height: 12),

            // ── Mascot ───────────────────────────────────────────────
            const _DropMascot(size: 160),

            const Spacer(flex: 2),

            // ── App name ─────────────────────────────────────────────
            Text(
              'Nakhlah',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: _purple,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 10),

            // ── Tagline ──────────────────────────────────────────────
            const Text(
              "Learn Arabic whenever and\nwherever you want. It's free and forever.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: _textGrey,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),

            const Spacer(flex: 3),

            // ── Buttons ──────────────────────────────────────────────
            _BigButton(label: 'GET STARTED', filled: true, onTap: onGetStarted),
            const SizedBox(height: 14),
            _BigButton(
              label: 'I ALREADY HAVE AN ACCOUNT',
              filled: false,
              onTap: onLogin,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─── Speech bubble ───────────────────────────────────────────────────────────

class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .10),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
        ),
        // Tail
        CustomPaint(size: const Size(18, 10), painter: _BubbleTailPainter()),
      ],
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Drop mascot (drawn in code — no asset needed) ───────────────────────────

class _DropMascot extends StatelessWidget {
  const _DropMascot({this.size = 120});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _DropPainter()),
    );
  }
}

class _DropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Body (outer drop) ────────────────────────────────────────────
    final bodyPaint = Paint()..color = const Color(0xFF7B5CE5);
    final bodyPath = Path()
      ..moveTo(w * .50, 0)
      ..cubicTo(w * .95, h * .30, w * .95, h * .62, w * .50, h * .95)
      ..cubicTo(w * .05, h * .62, w * .05, h * .30, w * .50, 0)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    // ── Belly (darker inner circle) ──────────────────────────────────
    final bellyPaint = Paint()..color = const Color(0xFF5A3FC0);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .50, h * .64),
        width: w * .58,
        height: h * .40,
      ),
      bellyPaint,
    );

    // ── Shine streak ─────────────────────────────────────────────────
    final shinePaint = Paint()
      ..color = Colors.white.withValues(alpha: .55)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = w * .045
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * .42, h * .14),
      Offset(w * .40, h * .36),
      shinePaint,
    );
    // Small dot above
    canvas.drawCircle(
      Offset(w * .42, h * .10),
      w * .028,
      Paint()..color = Colors.white.withValues(alpha: .55),
    );

    // ── Eyes (white sclera) ──────────────────────────────────────────
    final whitePaint = Paint()..color = Colors.white;
    // Left eye
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .36, h * .53),
        width: w * .22,
        height: h * .22,
      ),
      whitePaint,
    );
    // Right eye
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .64, h * .53),
        width: w * .22,
        height: h * .22,
      ),
      whitePaint,
    );

    // ── Pupils ───────────────────────────────────────────────────────
    final pupilPaint = Paint()..color = const Color(0xFF1A1A2E);
    canvas.drawCircle(Offset(w * .37, h * .535), w * .065, pupilPaint);
    canvas.drawCircle(Offset(w * .65, h * .535), w * .065, pupilPaint);

    // ── Pupil shine ──────────────────────────────────────────────────
    final pShinePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * .385, h * .515), w * .022, pShinePaint);
    canvas.drawCircle(Offset(w * .665, h * .515), w * .022, pShinePaint);

    // ── Eyebrows (dark oval/shadow above each eye) ───────────────────
    final browPaint = Paint()..color = const Color(0xFF2E1B6E);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .36, h * .43),
        width: w * .18,
        height: h * .06,
      ),
      browPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .64, h * .43),
        width: w * .18,
        height: h * .06,
      ),
      browPaint,
    );

    // ── Cheeks (blush) ───────────────────────────────────────────────
    final blushPaint = Paint()
      ..color = const Color(0xFFB48BF5).withValues(alpha: .45);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .26, h * .60),
        width: w * .14,
        height: h * .07,
      ),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .74, h * .60),
        width: w * .14,
        height: h * .07,
      ),
      blushPaint,
    );

    // ── Mouth (smile) ────────────────────────────────────────────────
    final mouthPaint = Paint()
      ..color = const Color(0xFFD94F6A)
      ..style = PaintingStyle.fill;
    final mouthPath = Path()
      ..moveTo(w * .38, h * .64)
      ..quadraticBezierTo(w * .50, h * .73, w * .62, h * .64)
      ..close();
    canvas.drawPath(mouthPath, mouthPaint);

    // ── Arms ─────────────────────────────────────────────────────────
    final armPaint = Paint()
      ..color = const Color(0xFF6C4FE0)
      ..strokeWidth = w * .07
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    // Left arm
    canvas.drawLine(
      Offset(w * .14, h * .64),
      Offset(w * .06, h * .58),
      armPaint,
    );
    // Right arm (waving — two segments)
    canvas.drawLine(
      Offset(w * .86, h * .62),
      Offset(w * .94, h * .52),
      armPaint,
    );
    canvas.drawLine(
      Offset(w * .94, h * .52),
      Offset(w * .90, h * .42),
      armPaint,
    );

    // Hand fingers (right waving hand)
    final fingerPaint = Paint()
      ..color = const Color(0xFF6C4FE0)
      ..strokeWidth = w * .04
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * .90, h * .42),
      Offset(w * .88, h * .36),
      fingerPaint,
    );
    canvas.drawLine(
      Offset(w * .90, h * .42),
      Offset(w * .95, h * .36),
      fingerPaint,
    );
    canvas.drawLine(
      Offset(w * .90, h * .42),
      Offset(w * .99, h * .40),
      fingerPaint,
    );

    // ── Legs ─────────────────────────────────────────────────────────
    final legPaint = Paint()
      ..color = const Color(0xFF2E1B6E)
      ..strokeWidth = w * .065
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    // Left leg
    canvas.drawLine(
      Offset(w * .40, h * .90),
      Offset(w * .36, h * 1.02),
      legPaint,
    );
    // Right leg
    canvas.drawLine(
      Offset(w * .60, h * .90),
      Offset(w * .64, h * 1.02),
      legPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Big button ──────────────────────────────────────────────────────────────

class _BigButton extends StatelessWidget {
  const _BigButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: filled
          ? ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: _purple,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  letterSpacing: .6,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: _purple,
                side: const BorderSide(color: Color(0xFFDDD6F8), width: 1.5),
                backgroundColor: _purpleLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13.5,
                  letterSpacing: .4,
                ),
              ),
            ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PAGE 1 — Language Selection  (matches Image 2)
// ═══════════════════════════════════════════════════════════════════════════════

class _LanguageSelectionPage extends StatelessWidget {
  const _LanguageSelectionPage({
    required this.langs,
    required this.selected,
    required this.onBack,
    required this.onChanged,
    required this.onContinue,
  });

  final List<_Lang> langs;
  final String selected;
  final VoidCallback onBack;
  final ValueChanged<String> onChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ── Top bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: _textDark),
                  onPressed: onBack,
                ),
                const SizedBox(width: 4),
                // Progress bar (2 segments, first filled)
                Expanded(child: _ProgressBar(filled: 1, total: 3)),
              ],
            ),
          ),

          // ── Mascot + bubble ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const _DropMascot(size: 72),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .08),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'What would you\nlike to learn?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // ── Language list ────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              itemCount: langs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final lang = langs[i];
                final isSelected = lang.name == selected;
                return _LangTile(
                  lang: lang,
                  selected: isSelected,
                  onTap: () => onChanged(lang.name),
                );
              },
            ),
          ),

          // ── Continue button ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: _BigButton(
              label: 'Continue',
              filled: true,
              onTap: onContinue,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Progress bar ────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.filled, required this.total});
  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
            height: 7,
            decoration: BoxDecoration(
              color: i < filled ? _purple : const Color(0xFFE2E2E2),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        );
      }),
    );
  }
}

// ─── Language tile ───────────────────────────────────────────────────────────

class _LangTile extends StatelessWidget {
  const _LangTile({
    required this.lang,
    required this.selected,
    required this.onTap,
  });

  final _Lang lang;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? _purpleLight : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? _purpleBorder : const Color(0xFFEEEEEE),
            width: selected ? 2 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: selected ? .06 : .03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(lang.flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                lang.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
