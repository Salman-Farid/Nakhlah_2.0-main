import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _box = GetStorage();
  static const _token = 'auth.token',
      _refreshToken = 'auth.refreshToken',
      _exp = 'auth.exp',
      _cookies = 'auth.cookies',
      _onboarded = 'app.onboarded';
  String? get token => _box.read<String>(_token);
  String? get refreshToken => _box.read<String>(_refreshToken);
  int? get exp => _box.read<int>(_exp);
  bool get isLoggedIn => token != null && token!.isNotEmpty;
  bool get isOnboarded => _box.read<bool>(_onboarded) ?? false;
  bool get isTokenExpired {
    final expiry = exp;
    if (expiry == null) return false;
    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return expiry <= nowSeconds + 30;
  }

  /// Stored cookies sent back on every request (mimics credentials: "include").
  String? get cookies => _box.read<String>(_cookies);

  Future<void> saveCookies(String cookieHeader) async {
    await _box.write(_cookies, cookieHeader);
  }

  Future<void> saveToken(String token, {int? exp, String? refreshToken}) async {
    await _box.write(_token, token);
    if (exp != null) await _box.write(_exp, exp);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _box.write(_refreshToken, refreshToken);
    }
  }

  Future<void> setOnboarded(bool v) => _box.write(_onboarded, v);
  Future<void> clearAuth() async {
    await _box.remove(_token);
    await _box.remove(_refreshToken);
    await _box.remove(_exp);
    await _box.remove(_cookies);
  }
}
