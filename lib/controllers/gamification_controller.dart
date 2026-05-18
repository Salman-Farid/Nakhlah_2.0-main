import 'package:get/get.dart';
import '../common/app_snackbar.dart';
import '../models/models.dart';
import '../services/gamification_service.dart';

class GamificationController extends GetxController {
  GamificationController(this.service);
  final GamificationService service;
  final loading = false.obs;
  final quests = <QuestStatus>[].obs;
  final achievements = <AchievementModel>[].obs;
  final streak = const StreakModel().obs;
  final stock = const GamificationStock().obs;
  Future<void> load() async {
    try {
      loading.value = true;
      quests.assignAll(await service.profileDailyQuest());
      achievements.assignAll(await service.achievements());
      streak.value = await service.learnerStreak();
      stock.value = await service.stocks();
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> refillPalm() async {
    try {
      await service.palmRefill();
      await load();
      AppSnackbar.success('Palm refill checked.');
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }
}
