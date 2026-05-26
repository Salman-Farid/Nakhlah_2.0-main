import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _box = GetStorage();
  static const _token = 'auth.token',
      _refreshToken = 'auth.refreshToken',
      _exp = 'auth.exp',
      _cookies = 'auth.cookies',
      _onboarded = 'app.onboarded';
  String? get token {
    final raw = _box.read<dynamic>(_token);
    final token = raw?.toString();
    return token == null || token.isEmpty || token == 'null' ? null : token;
  }

  String? get refreshToken {
    final raw = _box.read<dynamic>(_refreshToken);
    final token = raw?.toString();
    return token == null || token.isEmpty || token == 'null' ? null : token;
  }

  int? get exp {
    final value = _box.read<dynamic>(_exp);
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  bool get isLoggedIn => token != null && token!.isNotEmpty;
  bool get isOnboarded => _box.read<bool>(_onboarded) ?? false;
  bool get isTokenExpired {
    final expiry = exp;
    if (expiry == null) return false;
    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Backend refresh requires the current local JWT in the Authorization
    // header. If we wait until it is already expired the API returns 403, so
    // refresh while it is still valid, matching the web app's 5 minute buffer.
    return expiry <= nowSeconds + const Duration(minutes: 5).inSeconds;
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
