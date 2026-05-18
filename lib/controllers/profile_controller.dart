import 'package:get/get.dart';

import '../common/app_snackbar.dart';
import '../models/models.dart';
import '../services/profile_service.dart';

class ProfileController extends GetxController {
  ProfileController(this.service);

  final ProfileService service;
  final loading = false.obs;
  final profile = Rxn<UserProfileModel>();
  final progress = const ProgressModel().obs;
  final stock = const GamificationStock().obs;
  final leaderboard = <LeaderboardEntryModel>[].obs;

  Future<void> load() async {
    try {
      loading.value = true;
      profile.value = await service.getProfile();
      progress.value = await service.learnerProgress();
      stock.value = await service.stocks();
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadLeaderboard() async {
    try {
      loading.value = true;
      leaderboard.assignAll(await service.leaderboard());
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<bool> createOnboarding(OnboardInfo info) async {
    try {
      loading.value = true;
      profile.value = await service.createProfile(info);
      AppSnackbar.success('Profile created.');
      return true;
    } catch (e) {
      AppSnackbar.error(e.toString());
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> updateProfile({
    String? fullName,
    String? contactNumber,
    OnboardInfo? onboardInfo,
  }) async {
    try {
      loading.value = true;
      profile.value = await service.updateProfile(
        fullName: fullName,
        contactNumber: contactNumber,
        onboardInfo: onboardInfo,
      );
      await load();
      AppSnackbar.success('Profile updated.');
      return true;
    } catch (e) {
      AppSnackbar.error(e.toString());
      return false;
    } finally {
      loading.value = false;
    }
  }
}
