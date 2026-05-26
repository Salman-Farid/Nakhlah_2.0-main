import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_motion.dart';
import '../../common/nakhlah_mascot.dart';
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

                  // Mascot — matches web SVG
                  const PageEnter(
                    delay: Duration(milliseconds: 300),
                    child: NakhlahMascot(size: 160),
                  ),

                  const Spacer(flex: 2),

                  // Logo — real website asset
                  PageEnter(
                    delay: const Duration(milliseconds: 400),
                    child: Image.asset(
                      'assets/nakhlah_web/Nakhlah_Logo.webp',
                      width: 180,
                      fit: BoxFit.contain,
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
                        Get.offAllNamed(Routes.onboardingForm);
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
