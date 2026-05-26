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
  final questConfig = <String, dynamic>{}.obs;
  final badgeConfig = <String, dynamic>{}.obs;
  final streak = const StreakModel().obs;
  final stock = const GamificationStock().obs;

  /// Alias mapping matching web's questAliases in useDailyQuestStore.js
  static const _questAliases = {
    'lessonWithNoMistake': ['lessonWithNoMistake', 'noMistakes'],
    'scoreHighPoints': ['scoreHighPoints', 'highScore', 'scoreEightyPlus'],
    'shareTheApp': ['shareTheApp', 'shareApp'],
    'spendMinutes': ['spendMinutes', 'practiceTime'],
    'spendDatesForLives': ['spendDatesForLives', 'spendDates'],
    'completeLessonsToday': ['completeLessonsToday', 'completeLessons'],
    'earnInjazToday': ['earnInjazToday', 'earnInjaz'],
  };

  static List<String> _resolveAliases(String questId) {
    if (questId.isEmpty) return [];
    final explicit = _questAliases[questId] ?? [];
    final fromGroup = _questAliases.values
        .firstWhere((aliases) => aliases.contains(questId), orElse: () => []);
    return {questId, ...explicit, ...fromGroup}.toList();
  }

  /// Find a matching QuestStatus for a given config key, using alias matching.
  QuestStatus? findQuestStatus(String configKey) {
    final aliases = _resolveAliases(configKey);
    for (final q in quests) {
      if (aliases.contains(q.challengeId)) return q;
    }
    return null;
  }

  Map<String, dynamic> _configMap(dynamic value) {
    dynamic current = value;
    for (var i = 0; i < 4; i++) {
      if (current is Map && current['data'] is Map) {
        current = current['data'];
      } else {
        break;
      }
    }
    if (current is Map) {
      return current.map((key, val) => MapEntry(key.toString(), val));
    }
    return const {};
  }

  Future<void> load() async {
    try {
      loading.value = true;
      final results = await Future.wait<dynamic>([
        service.profileDailyQuest(),
        service.achievements(),
        service.learnerStreak(),
        service.stocks(),
        service.dailyQuestConfig(),
        service.badgesConfig(),
      ]);
      quests.assignAll(results[0] as List<QuestStatus>);
      achievements.assignAll(results[1] as List<AchievementModel>);
      streak.value = results[2] as StreakModel;
      stock.value = results[3] as GamificationStock;
      questConfig.assignAll(_configMap(results[4]));
      badgeConfig.assignAll(_configMap(results[5]));
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
