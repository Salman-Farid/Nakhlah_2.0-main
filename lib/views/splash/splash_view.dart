import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_motion.dart';
import '../../common/nakhlah_intro_widgets.dart';
import '../../constants/app_colors.dart';
import '../../controllers/app_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 0.96,
      end: 1.04,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOutSine));

    Get.find<AppController>().decideStart();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── decorative blobs ──────────────────────
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.palm.withValues(alpha: .06),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.date.withValues(alpha: .07),
              ),
            ),
          ),
          // ── main content ──────────────────────────
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: PageEnter(
                  beginScale: .90,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // animated wordmark
                      AnimatedBuilder(
                        animation: _scale,
                        builder: (context, child) => Transform.scale(
                          scale: AppMotion.reduceMotion(context)
                              ? 1
                              : _scale.value,
                          child: child,
                        ),
                        child: Image.asset(
                          'assets/nakhlah_web/Nakhlah_Logo.webp',
                          width: 320,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // hero image
                      const IntroHeroImage(
                        asset: IntroAssets.lessonCards,
                        height: 240,
                      ),
                      const SizedBox(height: 32),
                      // headline
                      const Text(
                        'Start your Arabic\njourney',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Loading your Nakhlah path…',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 36),
                      // loading indicator
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: AppColors.palm,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
