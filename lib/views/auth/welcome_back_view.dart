import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_motion.dart';
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

                  // Mascot
                  const PageEnter(
                    delay: Duration(milliseconds: 300),
                    child: _DropMascot(size: 140),
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

                  // Continue button
                  PageEnter(
                    delay: const Duration(milliseconds: 600),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => Get.offAllNamed(Routes.login),
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

// ─── Drop mascot ─────────────────────────────────────────────────────────────

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

    final bodyPaint = Paint()..color = const Color(0xFF7B5CE5);
    final bodyPath = Path()
      ..moveTo(w * .50, 0)
      ..cubicTo(w * .95, h * .30, w * .95, h * .62, w * .50, h * .95)
      ..cubicTo(w * .05, h * .62, w * .05, h * .30, w * .50, 0)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    final bellyPaint = Paint()..color = const Color(0xFF5A3FC0);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .50, h * .64),
        width: w * .58,
        height: h * .40,
      ),
      bellyPaint,
    );

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

    final pupilPaint = Paint()..color = const Color(0xFF1A1A2E);
    canvas.drawCircle(Offset(w * .37, h * .535), w * .065, pupilPaint);
    canvas.drawCircle(Offset(w * .65, h * .535), w * .065, pupilPaint);

    final pShinePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * .385, h * .515), w * .022, pShinePaint);
    canvas.drawCircle(Offset(w * .665, h * .515), w * .022, pShinePaint);

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

    final mouthPaint = Paint()
      ..color = const Color(0xFFD94F6A)
      ..style = PaintingStyle.fill;
    final mouthPath = Path()
      ..moveTo(w * .38, h * .64)
      ..quadraticBezierTo(w * .50, h * .73, w * .62, h * .64)
      ..close();
    canvas.drawPath(mouthPath, mouthPaint);

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
