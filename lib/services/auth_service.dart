import '../constants/api_endpoints.dart';
import '../models/models.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  AuthService(this._api, this._storage);
  final ApiService _api;
  final StorageService _storage;
  Future<AuthSession> signUp(String email, String password) async =>
      _auth(ApiEndpoints.signUp, {'email': email, 'password': password});
  Future<AuthSession> login(String email, String password) async =>
      _auth(ApiEndpoints.login, {'email': email, 'password': password});
  Future<AuthSession> socialLogin(Map<String, dynamic> body) async =>
      _auth(ApiEndpoints.socialLogin, body);
  Future<AuthSession> _auth(String path, Map<String, dynamic> body) async {
    final s = AuthSession.fromJson(
      await _api.post(path, body: body, auth: false),
    );
    if (s.token != null) await _storage.saveToken(s.token!, exp: s.exp);
    return s;
  }

  Future<void> logout() async {
    try {
      await _api.post(ApiEndpoints.logout, body: {});
    } finally {
      await _storage.clearAuth();
    }
  }

  Future<void> forgotPassword(String email) => _api.post(
    ApiEndpoints.forgotPassword,
    body: {'email': email},
    auth: false,
  );
  Future<void> resetPassword(String token, String password) => _api.post(
    ApiEndpoints.resetPassword,
    body: {'token': token, 'password': password},
    auth: false,
  );
  Future<void> changePassword(String currentPassword, String newPassword) =>
      _api.post(
        ApiEndpoints.changePassword,
        body: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
  Future<AuthSession> refreshToken() async {
    final s = AuthSession.fromJson(
      await _api.post(ApiEndpoints.refreshToken, body: {}),
    );
    if (s.token != null) await _storage.saveToken(s.token!, exp: s.exp);
    return s;
  }

  Future<UserModel> me() async {
    final r = await _api.get(ApiEndpoints.me);
    if (r is Map && r['token'] != null) {
      await _storage.saveToken(
        r['token'].toString(),
        exp: r['exp'] is int ? r['exp'] : null,
      );
    }
    return UserModel.fromJson(r is Map ? r['user'] : null);
  }
}
