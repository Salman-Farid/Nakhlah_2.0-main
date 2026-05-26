import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_motion.dart';
import '../../common/nakhlah_mascot.dart';
import '../../constants/app_colors.dart';
import '../../routes/app_routes.dart';

class WelcomeBackView extends StatelessWidget {
  const WelcomeBackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Mascot — matches web SVG
                  const PageEnter(
                    delay: Duration(milliseconds: 300),
                    child: NakhlahMascot(size: 140),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  const PageEnter(
                    delay: Duration(milliseconds: 400),
                    child: Text(
                      'Welcome back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  const PageEnter(
                    delay: Duration(milliseconds: 500),
                    child: Text(
                      'You have successfully reset and\ncreated a new password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Continue button — go to Shell (home), not Login
                  PageEnter(
                    delay: const Duration(milliseconds: 600),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => Get.offAllNamed(Routes.shell),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'CONTINUE TO HOME',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Decorative dots
                  PageEnter(
                    delay: const Duration(milliseconds: 700),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Dot(color: AppColors.accent, delay: 0),
                        const SizedBox(width: 8),
                        _Dot(
                          color: AppColors.accent.withValues(alpha: .7),
                          delay: 200,
                        ),
                        const SizedBox(width: 8),
                        _Dot(color: AppColors.accent, delay: 400),
                      ],
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

// ─── Animated dot ────────────────────────────────────────────────────────────

class _Dot extends StatefulWidget {
  const _Dot({required this.color, required this.delay});
  final Color color;
  final int delay;

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1.0 + 0.2 * ((_controller.value * 2 - 1).abs());
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
