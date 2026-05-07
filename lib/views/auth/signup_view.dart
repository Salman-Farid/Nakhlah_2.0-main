import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/nakhlah_intro_widgets.dart';
import '../../constants/app_colors.dart';
import '../../common/app_motion.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthController>();

    return IntroScaffold(
      showBack: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── hero ───────────────────────────────────
            const IntroHeroImage(asset: IntroAssets.learningKid, height: 200),
            const SizedBox(height: 12),

            // ── titles ─────────────────────────────────
            const IntroTitleBlock(
              title: 'Create\nAccount',
              body:
                  'Join Nakhlah and begin your Arabic learning adventure today.',
              titleSize: 36,
              highlight: 'Arabic',
            ),
            const SizedBox(height: 20),

            // ── trust signals ──────────────────────────
            const IntroStatBadges(),
            const SizedBox(height: 22),

            // ── form panel ─────────────────────────────
            PageEnter(
              delay: const Duration(milliseconds: 150),
              child: AuthPanel(
                children: [
                  IntroTextField(
                    controller: email,
                    label: 'Email Address',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  StatefulBuilder(
                    builder: (context, setSub) => IntroTextField(
                      controller: pass,
                      label: 'Password',
                      icon: Icons.lock_outline_rounded,
                      obscureText: true,
                      isObscured: _obscure,
                      onToggleObscure: () =>
                          setState(() => _obscure = !_obscure),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // terms note
                  Text(
                    'By signing up you agree to our Terms of Service and Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.muted.withValues(alpha: .80),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => IntroPrimaryButton(
                      label: 'Create Account',
                      loading: c.loading.value,
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () => c.signUp(email.text.trim(), pass.text),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // ── login link ─────────────────────────────
            TextButton(
              onPressed: () => Get.offNamed(Routes.login),
              child: const Text.rich(
                TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      style: TextStyle(
                        color: AppColors.palmDark,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
