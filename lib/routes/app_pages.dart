import 'package:get/get.dart';

import '../common/app_motion.dart';
import '../views/auth/forgot_password_view.dart';
import '../views/auth/login_view.dart';
import '../views/auth/signup_view.dart';
import '../views/exercises/exercise_view.dart';
import '../views/home/app_shell_view.dart';
import '../views/lessons/lessons_view.dart';
import '../views/onboarding/onboarding_form_view.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/settings/settings_view.dart';
import '../views/splash/splash_view.dart';
import 'app_routes.dart';
import 'game_page_transition.dart';

class AppPages {
  static final _transition = GamePageTransition();

  static GetPage _page(String name, GetPageBuilder page) => GetPage(
    name: name,
    page: page,
    customTransition: _transition,
    transitionDuration: AppMotion.page,
  );

  static final pages = <GetPage>[
    _page(Routes.splash, () => const SplashView()),
    _page(Routes.onboarding, () => const OnboardingView()),
    _page(Routes.onboardingForm, () => const OnboardingFormView()),
    _page(Routes.login, () => const LoginView()),
    _page(Routes.signup, () => const SignupView()),
    _page(Routes.forgotPassword, () => const ForgotPasswordView()),
    _page(Routes.shell, () => const AppShellView()),
    _page(Routes.lessons, () => const LessonsView()),
    _page(Routes.exercise, () => const ExerciseView()),
    _page(Routes.settings, () => const SettingsView()),
  ];
}
