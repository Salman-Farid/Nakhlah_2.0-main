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
    final fields = <String, String>{};
    if (fullName != null) fields['fullName'] = fullName;
    if (contactNumber != null) fields['contactNumber'] = contactNumber;
    if (onboardInfo != null) {
      fields['onboardInfo'] = onboardInfo.toJson().toString();
    }

    return UserProfileModel.fromJson(
      await _api.multipartPatch(
        ApiEndpoints.updateProfile,
        fields: fields,
        file: picture,
      ),
    );
  }

  Future<void> deleteProfile() => _api.delete(ApiEndpoints.deleteProfile);

  Future<ProgressModel> learnerProgress() async {
    return ProgressModel.fromJson(await _api.get(ApiEndpoints.learnerProgress));
  }

  Future<GamificationStock> stocks() async {
    return GamificationStock.fromJson(
      await _api.get(ApiEndpoints.gamificationStocks),
    );
  }
}
