import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_motion.dart';
import '../../constants/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/storage_service.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Speech bubble
                  PageEnter(
                    delay: const Duration(milliseconds: 200),
                    child: _SpeechBubble(text: "Hi there! I'm El!"),
                  ),
                  const SizedBox(height: 12),

                  // Mascot
                  const PageEnter(
                    delay: Duration(milliseconds: 300),
                    child: _DropMascot(size: 160),
                  ),

                  const Spacer(flex: 2),

                  // App name
                  PageEnter(
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      'Nakhlah',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: AppColors.accent,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tagline
                  const PageEnter(
                    delay: Duration(milliseconds: 500),
                    child: Text(
                      "Learn languages whenever and\nwherever you want. It's free and forever.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // GET STARTED button
                  PageEnter(
                    delay: const Duration(milliseconds: 600),
                    child: _BigButton(
                      label: 'GET STARTED',
                      filled: true,
                      onTap: () async {
                        await Get.find<StorageService>().setOnboarded(true);
                        Get.offAllNamed(Routes.onboarding);
                      },
                    ),
                  ),
                  const SizedBox(height: 14),

                  // I ALREADY HAVE AN ACCOUNT
                  PageEnter(
                    delay: const Duration(milliseconds: 700),
                    child: _BigButton(
                      label: 'I ALREADY HAVE AN ACCOUNT',
                      filled: false,
                      onTap: () => Get.offAllNamed(Routes.login),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
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
              color: AppColors.ink,
            ),
          ),
        ),
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

// ─── Drop mascot (drawn in code) ─────────────────────────────────────────────

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

    // Body (outer drop)
    final bodyPaint = Paint()..color = const Color(0xFF7B5CE5);
    final bodyPath = Path()
      ..moveTo(w * .50, 0)
      ..cubicTo(w * .95, h * .30, w * .95, h * .62, w * .50, h * .95)
      ..cubicTo(w * .05, h * .62, w * .05, h * .30, w * .50, 0)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Belly (darker inner circle)
    final bellyPaint = Paint()..color = const Color(0xFF5A3FC0);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .50, h * .64),
        width: w * .58,
        height: h * .40,
      ),
      bellyPaint,
    );

    // Shine streak
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
    canvas.drawCircle(
      Offset(w * .42, h * .10),
      w * .028,
      Paint()..color = Colors.white.withValues(alpha: .55),
    );

    // Eyes (white sclera)
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .36, h * .53),
        width: w * .22,
        height: h * .22,
      ),
      whitePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .64, h * .53),
        width: w * .22,
        height: h * .22,
      ),
      whitePaint,
    );

    // Pupils
    final pupilPaint = Paint()..color = const Color(0xFF1A1A2E);
    canvas.drawCircle(Offset(w * .37, h * .535), w * .065, pupilPaint);
    canvas.drawCircle(Offset(w * .65, h * .535), w * .065, pupilPaint);

    // Pupil shine
    final pShinePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * .385, h * .515), w * .022, pShinePaint);
    canvas.drawCircle(Offset(w * .665, h * .515), w * .022, pShinePaint);

    // Eyebrows
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

    // Cheeks (blush)
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

    // Mouth (smile)
    final mouthPaint = Paint()
      ..color = const Color(0xFFD94F6A)
      ..style = PaintingStyle.fill;
    final mouthPath = Path()
      ..moveTo(w * .38, h * .64)
      ..quadraticBezierTo(w * .50, h * .73, w * .62, h * .64)
      ..close();
    canvas.drawPath(mouthPath, mouthPaint);

    // Arms
    final armPaint = Paint()
      ..color = const Color(0xFF6C4FE0)
      ..strokeWidth = w * .07
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * .14, h * .64),
      Offset(w * .06, h * .58),
      armPaint,
    );
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

    // Legs
    final legPaint = Paint()
      ..color = const Color(0xFF2E1B6E)
      ..strokeWidth = w * .065
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * .40, h * .90),
      Offset(w * .36, h * 1.02),
      legPaint,
    );
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
                backgroundColor: AppColors.accent,
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
                foregroundColor: AppColors.accent,
                side: BorderSide(
                  color: AppColors.accent.withValues(alpha: .25),
                  width: 1.5,
                ),
                backgroundColor: AppColors.accent.withValues(alpha: .08),
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
