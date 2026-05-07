import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../common/app_snackbar.dart';
import '../../common/nakhlah_intro_widgets.dart';
import '../../constants/app_colors.dart';
import '../../common/app_motion.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle(AuthController c) async {
    try {
      final account = await GoogleSignIn(scopes: ['email', 'profile']).signIn();
      if (account == null) return;

      final auth = await account.authentication;
      await c.googleLogin(
        email: account.email,
        idToken: auth.idToken,
        accessToken: auth.accessToken,
        name: account.displayName,
        photoUrl: account.photoUrl,
      );
    } catch (e) {
      AppSnackbar.error('Google sign-in failed: $e');
    }
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
            const IntroHeroImage(
              asset: IntroAssets.leafBook,
              height: 200,
              blobColor: AppColors.palm,
            ),
            const SizedBox(height: 12),

            // ── titles ─────────────────────────────────
            const IntroTitleBlock(
              title: 'Welcome\nBack!',
              body:
                  'Enter your details below to continue your Arabic learning journey.',
              titleSize: 36,
              highlight: 'Arabic',
            ),
            const SizedBox(height: 26),

            // ── form panel ─────────────────────────────
            PageEnter(
              delay: const Duration(milliseconds: 160),
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
                  // forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.toNamed(Routes.forgotPassword),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.palmDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => IntroPrimaryButton(
                      label: 'Sign In',
                      loading: c.loading.value,
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () => c.login(email.text.trim(), pass.text),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.muted.withValues(alpha: .20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'or',
                          style: TextStyle(
                            color: AppColors.muted.withValues(alpha: .60),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.muted.withValues(alpha: .20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => _SocialButton(
                      label: 'Continue with Google',
                      icon: Icons.g_mobiledata_rounded,
                      loading: c.loading.value,
                      onTap: c.loading.value
                          ? null
                          : () => _signInWithGoogle(c),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // ── sign up link ───────────────────────────
            TextButton(
              onPressed: () => Get.offNamed(Routes.signup),
              child: const Text.rich(
                TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
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

// ─────────────────────────────────────────────
//  Social button (Google etc.)
// ─────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.loading = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      scale: .97,
      child: InkWell(
        onTap: loading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.muted.withValues(alpha: .22)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(icon, size: 26, color: const Color(0xFF4285F4)),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
