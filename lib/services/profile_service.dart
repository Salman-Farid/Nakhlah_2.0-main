import 'dart:convert';
import 'dart:io';

import '../constants/api_endpoints.dart';
import '../models/models.dart';
import 'api_service.dart';

class ProfileService {
  ProfileService(this._api);

  final ApiService _api;

  Future<UserProfileModel> getProfile() async {
    return UserProfileModel.fromJson(await _api.get(ApiEndpoints.userProfile));
  }

  Future<UserProfileModel> createProfile(OnboardInfo info) async {
    return UserProfileModel.fromJson(
      await _api.post(
        ApiEndpoints.userProfile,
        body: {'onboardInfo': info.toJson()},
      ),
    );
  }

  Future<UserProfileModel> updateProfile({
    String? fullName,
    String? contactNumber,
    OnboardInfo? onboardInfo,
    File? picture,
  }) async {
    final data = <String, dynamic>{};
    if (fullName != null) data['fullName'] = fullName;
    if (contactNumber != null) data['contactNumber'] = contactNumber;
    if (onboardInfo != null) data['onboardInfo'] = onboardInfo.toJson();

    return UserProfileModel.fromJson(
      await _api.multipartPatch(
        ApiEndpoints.updateProfile,
        fields: {'data': jsonEncode(data)},
        file: picture,
        fileField: 'profilePicture',
      ),
    );
  }

  Future<void> deleteProfile() => _api.delete(ApiEndpoints.deleteProfile);

  Future<ProgressModel> learnerProgress() async {
    return ProgressModel.fromJson(await _api.get(ApiEndpoints.learnerProgress));
  }

  Future<List<QuestStatus>> dailyQuest({String? quest}) async {
    return parseQuestStatuses(
      await _api.get(
        ApiEndpoints.profileDailyQuest,
        query: quest == null ? null : {'quest': quest},
      ),
    );
  }

  Future<dynamic> palmRefill() => _api.get(ApiEndpoints.palmRefill);

  Future<StreakModel> learnerStreak() async {
    return StreakModel.fromJson(await _api.get(ApiEndpoints.learnerStreak));
  }

  Future<GamificationStock> stocks() async {
    return GamificationStock.fromJson(
      await _api.get(ApiEndpoints.gamificationStocks),
    );
  }

  Future<List<LeaderboardEntryModel>> leaderboard({String? period}) async {
    return parseLeaderboard(
      await _api.get(
        ApiEndpoints.leaderboard,
        query: period == null ? null : {'period': period, 'filter': period},
      ),
    );
  }
}
