import '../constants/api_endpoints.dart';
import '../models/models.dart';
import 'api_service.dart';

class GamificationService {
  GamificationService(this._api);

  final ApiService _api;

  Future<dynamic> dailyQuestConfig() =>
      _api.get(ApiEndpoints.dailyQuestsConfig);
  Future<dynamic> badgesConfig() => _api.get(ApiEndpoints.badgesConfig);

  Future<List<AchievementModel>> achievements() async {
    return parseAchievements(
      await _api.get(ApiEndpoints.achievements, query: {'depth': 2}),
    );
  }

  Future<List<QuestStatus>> profileDailyQuest({String? quest}) async {
    return parseQuestStatuses(
      await _api.get(
        ApiEndpoints.profileDailyQuest,
        query: quest == null ? null : {'quest': quest},
      ),
    );
  }

  Future<dynamic> palmRefill() => _api.get(ApiEndpoints.palmRefill);
  Future<StreakModel> learnerStreak() async =>
      StreakModel.fromJson(await _api.get(ApiEndpoints.learnerStreak));
  Future<dynamic> restoreStreak(int days) =>
      _api.get(ApiEndpoints.restoreStreak(days));
  Future<GamificationStock> stocks() async => GamificationStock.fromJson(
    await _api.get(ApiEndpoints.gamificationStocks),
  );
}
