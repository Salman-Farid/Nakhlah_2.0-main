import 'package:get/get.dart';

import '../common/app_snackbar.dart';
import '../models/models.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  AuthController(this.auth, this.storage);

  final AuthService auth;
  final StorageService storage;

  final loading = false.obs;
  final user = Rxn<UserModel>();

  Future<bool> login(String email, String password) => _run(() async {
    if (!_validateCredentials(email, password)) return false;

    final s = await auth.login(email, password);
    user.value = s.user;
    AppSnackbar.success(s.message ?? 'Welcome back');
    Get.offAllNamed(Routes.shell);
    return true;
  });

  Future<bool> signUp(String email, String password) => _run(() async {
    if (!_validateCredentials(email, password)) return false;

    final s = await auth.signUp(email, password);
    user.value = s.user;
    AppSnackbar.success(s.message ?? 'Account created');
    Get.offAllNamed(Routes.onboardingForm);
    return true;
  });

  Future<bool> googleLogin({
    String? email,
    String? idToken,
    String? accessToken,
    String? name,
    String? photoUrl,
  }) => _run(() async {
    final body = <String, dynamic>{
      'provider': 'google',
      if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
      if (idToken != null && idToken.trim().isNotEmpty)
        'idToken': idToken.trim(),
      if (accessToken != null && accessToken.trim().isNotEmpty)
        'accessToken': accessToken.trim(),
      if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      if (photoUrl != null && photoUrl.trim().isNotEmpty)
        'socialMediaPictureUrl': photoUrl.trim(),
    };

    if (body.length == 1) {
      AppSnackbar.error('Google sign-in did not return account details.');
      return false;
    }

    final s = await auth.socialLogin(body);
    user.value = s.user;
    AppSnackbar.success(s.message ?? 'Signed in with Google');
    Get.offAllNamed(Routes.shell);
    return true;
  });

  Future<bool> forgotPassword(String email) => _run(() async {
    final cleanEmail = email.trim();
    if (!_isValidEmail(cleanEmail)) {
      AppSnackbar.error('Enter a valid email address.');
      return false;
    }

    await auth.forgotPassword(cleanEmail);
    AppSnackbar.success(
      'Password reset instructions sent if the email exists.',
    );
    return true;
  });

  Future<bool> changePassword(String oldPass, String newPass) => _run(() async {
    if (oldPass.isEmpty || newPass.isEmpty) {
      AppSnackbar.error('Enter both current and new password.');
      return false;
    }

    await auth.changePassword(oldPass, newPass);
    AppSnackbar.success('Password changed.');
    return true;
  });

  Future<void> loadMe() async {
    if (storage.isLoggedIn) {
      try {
        user.value = await auth.me();
      } catch (_) {}
    }
  }

  Future<bool> logout() => _run(() async {
    await auth.logout();
    Get.offAllNamed(Routes.login);
    return true;
  });

  bool _validateCredentials(String email, String password) {
    final cleanEmail = email.trim();
    if (!_isValidEmail(cleanEmail)) {
      AppSnackbar.error('Enter a valid email address.');
      return false;
    }
    if (password.isEmpty) {
      AppSnackbar.error('Enter your password.');
      return false;
    }
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }

  Future<bool> _run(Future<bool> Function() job) async {
    if (loading.value) return false;

    try {
      loading.value = true;
      return await job();
    } catch (e) {
      AppSnackbar.error(e.toString());
      return false;
    } finally {
      loading.value = false;
    }
  }
}
