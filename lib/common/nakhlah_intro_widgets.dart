import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import 'app_button.dart';
import 'app_motion.dart';

// ─────────────────────────────────────────────
//  Asset paths
// ─────────────────────────────────────────────

class IntroAssets {
  IntroAssets._();

  static const leafBook = 'assets/nakhlah_design/icon_leaf_book.png';
  static const readingMascot = 'assets/nakhlah_design/icon_leaf_book.png';
  static const journeyMarker = 'assets/nakhlah_design/icon_journey_marker.png';
  static const lessonCards = 'assets/nakhlah_design/icon_lesson_cards.png';
  static const learningKid = 'assets/nakhlah_design/icon_learning_kid.png';
}

// ─────────────────────────────────────────────
//  Root scaffold used by all intro/auth screens
// ─────────────────────────────────────────────

class IntroScaffold extends StatelessWidget {
  const IntroScaffold({
    super.key,
    required this.child,
    this.showBack = false,
    this.bottom,
    this.horizontalPadding = 24,
    this.backgroundColor,
    this.showWordmark = true,
  });

  final Widget child;
  final bool showBack;
  final Widget? bottom;
  final double horizontalPadding;
  final Color? backgroundColor;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      body: Stack(
        children: [
          // ── subtle decorative blobs ──────────────────
          Positioned(
            top: -64,
            right: -54,
            child: _DecorativeBlob(
              size: 150,
              color: AppColors.accent.withValues(alpha: .05),
            ),
          ),
          Positioned(
            bottom: 60,
            left: -80,
            child: _DecorativeBlob(
              size: 220,
              color: AppColors.date.withValues(alpha: .07),
            ),
          ),
          // ── main content ────────────────────────────
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    10,
                    horizontalPadding,
                    18,
                  ),
                  child: Column(
                    children: [
                      // top bar
                      SizedBox(
                        height: 46,
                        child: Row(
                          children: [
                            if (showBack)
                              _CircleIconButton(
                                icon: Icons.arrow_back_ios_new_rounded,
                                onTap: Get.back,
                              )
                            else
                              const SizedBox(width: 44),
                            const Spacer(),
                            if (showWordmark)
                              const NakhlahWordmark(compact: true),
                            const Spacer(),
                            const SizedBox(width: 44),
                          ],
                        ),
                      ),
                      Expanded(child: child),
                      ?bottom,
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

// ─────────────────────────────────────────────
//  Wordmark
// ─────────────────────────────────────────────

class NakhlahWordmark extends StatelessWidget {
  const NakhlahWordmark({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/nakhlah_web/Nakhlah_Logo.webp',
      width: compact ? 120 : 160,
      fit: BoxFit.contain,
    );
  }
}

// ─────────────────────────────────────────────
//  Hero image without any background shape
// ─────────────────────────────────────────────

class IntroHeroImage extends StatelessWidget {
  const IntroHeroImage({
    super.key,
    required this.asset,
    this.height = 260,
    this.delay = Duration.zero,
    this.showBlob = false,
    this.blobColor,
  });

  final String asset;
  final double height;
  final Duration delay;
  final bool showBlob;
  final Color? blobColor;

  @override
  Widget build(BuildContext context) {
    return PageEnter(
      delay: delay,
      beginScale: .94,
      slide: const Offset(0, .04),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Center(
          child: Image.asset(asset, height: height * .90, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Title + body copy block
// ─────────────────────────────────────────────

class IntroTitleBlock extends StatelessWidget {
  const IntroTitleBlock({
    super.key,
    required this.title,
    required this.body,
    this.align = TextAlign.center,
    this.titleSize = 36,
    this.highlight, // optional word to colour in purple
  });

  final String title;
  final String body;
  final TextAlign align;
  final double titleSize;
  final String? highlight;

  @override
  Widget build(BuildContext context) {
    Widget titleWidget;

    if (highlight != null && title.contains(highlight!)) {
      final parts = title.split(highlight!);
      titleWidget = Text.rich(
        TextSpan(
          style: _titleStyle(titleSize),
          children: [
            TextSpan(text: parts.first),
            TextSpan(
              text: highlight,
              style: const TextStyle(color: AppColors.accent),
            ),
            TextSpan(text: parts.last),
          ],
        ),
        textAlign: align,
      );
    } else {
      titleWidget = Text(
        title,
        textAlign: align,
        style: _titleStyle(titleSize),
      );
    }

    return PageEnter(
      delay: const Duration(milliseconds: 90),
      child: Column(
        crossAxisAlignment: align == TextAlign.center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          titleWidget,
          const SizedBox(height: 14),
          Text(
            body,
            textAlign: align,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _titleStyle(double size) => TextStyle(
    color: AppColors.ink,
    fontSize: size,
    height: 1.05,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.3,
  );
}

// ─────────────────────────────────────────────
//  Primary CTA button (full-width, pill style)
// ─────────────────────────────────────────────

class IntroPrimaryButton extends StatelessWidget {
  const IntroPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: AppButton(
        label: label,
        onPressed: onPressed,
        loading: loading,
        icon: icon,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Secondary outline button (full-width)
// ─────────────────────────────────────────────

class IntroSecondaryButton extends StatelessWidget {
  const IntroSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: PressableScale(
        scale: .985,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.accent,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: AppColors.accent.withValues(alpha: .22),
              width: 1.4,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Styled text field
// ─────────────────────────────────────────────

class IntroTextField extends StatelessWidget {
  const IntroTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.onToggleObscure,
    this.isObscured,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final bool? isObscured;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isObscured ?? obscureText,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.muted,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Icon(icon, color: AppColors.accent, size: 20),
        ),
        suffixIcon: onToggleObscure != null
            ? IconButton(
                icon: Icon(
                  (isObscured ?? true)
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: AppColors.muted,
                  size: 20,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF5F0FA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.accent.withValues(alpha: .10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.accent.withValues(alpha: .10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.8),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Floating card panel for auth forms
// ─────────────────────────────────────────────

class AuthPanel extends StatelessWidget {
  const AuthPanel({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.accent.withValues(alpha: .09)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A2A).withValues(alpha: .08),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: const Color(0xFF1E3A2A).withValues(alpha: .04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

// ─────────────────────────────────────────────
//  Numbered step card (onboarding form)
// ─────────────────────────────────────────────

class ProcessStepCard extends StatelessWidget {
  const ProcessStepCard({
    super.key,
    required this.number,
    required this.title,
    required this.body,
    required this.icon,
  });

  final String number;
  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0FA),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.accent.withValues(alpha: .09)),
      ),
      child: Row(
        children: [
          // icon badge
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.premiumGradientStart, AppColors.premiumGradientEnd],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: .30),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        number,
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          letterSpacing: .4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.ink,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Stat badge row (streak / hearts / gems)
// ─────────────────────────────────────────────

class IntroStatBadges extends StatelessWidget {
  const IntroStatBadges({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatBadge(
          icon: Icons.local_fire_department_rounded,
          color: const Color(0xFFFF6B35),
          label: '5 day',
        ),
        const SizedBox(width: 10),
        _StatBadge(
          icon: Icons.favorite_rounded,
          color: const Color(0xFFE53935),
          label: '5 lives',
        ),
        const SizedBox(width: 10),
        _StatBadge(
          icon: Icons.diamond_rounded,
          color: const Color(0xFF1E88E5),
          label: '0 gems',
        ),
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withValues(alpha: .20)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Decorative background blob
// ─────────────────────────────────────────────

class _DecorativeBlob extends StatelessWidget {
  const _DecorativeBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// ─────────────────────────────────────────────
//  Feature pill chip
// ─────────────────────────────────────────────

class FeaturePill extends StatelessWidget {
  const FeaturePill({
    super.key,
    required this.icon,
    required this.label,
    this.color = AppColors.accent,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withValues(alpha: .18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Animated Arabic letter showcase
// ─────────────────────────────────────────────

class ArabicLetterShowcase extends StatefulWidget {
  const ArabicLetterShowcase({super.key});

  @override
  State<ArabicLetterShowcase> createState() => _ArabicLetterShowcaseState();
}

class _ArabicLetterShowcaseState extends State<ArabicLetterShowcase>
    with SingleTickerProviderStateMixin {
  static const _letters = [
    ('ا', 'Alif'),
    ('ب', 'Ba'),
    ('ت', 'Ta'),
    ('ث', 'Tha'),
    ('ج', 'Jim'),
  ];

  late AnimationController _controller;
  late Animation<double> _fade;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    _startCycle();
  }

  void _startCycle() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _controller.reverse().then((_) {
        if (!mounted) return;
        setState(() => _current = (_current + 1) % _letters.length);
        _controller.forward().then((_) => _startCycle());
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (letter, name) = _letters[_current];
    return FadeTransition(
      opacity: _fade,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            letter,
            style: const TextStyle(
              fontSize: 64,
              color: AppColors.accent,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Floating progress pill
// ─────────────────────────────────────────────

class FloatingProgressPill extends StatelessWidget {
  const FloatingProgressPill({
    super.key,
    required this.label,
    required this.progress,
  });

  final String label;
  final double progress; // 0.0 – 1.0

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: .18),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: AppColors.accent.withValues(alpha: .12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, color: AppColors.date, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.accent.withValues(alpha: .15),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Small circular icon button (back arrow etc.)
// ─────────────────────────────────────────────

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      scale: .92,
      child: Material(
        color: const Color(0xFFF4F9F6),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: AppColors.ink, size: 18),
          ),
        ),
      ),
    );
  }
}
