import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_endpoints.dart';
import '../models/models.dart';
import 'storage_service.dart';

class ApiService {
  ApiService(this._storage);

  static const Duration _timeout = Duration(seconds: 30);

  final StorageService _storage;
  final http.Client _client = http.Client();

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final normalizedPath = path.startsWith('/api/')
        ? path.replaceFirst('/api', '')
        : path;
    final clean = '${ApiEndpoints.apiPrefix}$normalizedPath';
    final qp = <String, String>{};
    query?.forEach((k, v) {
      if (v != null && '$v'.isNotEmpty) qp[k] = '$v';
    });
    return Uri.parse(
      '${ApiEndpoints.baseUrl}$clean',
    ).replace(queryParameters: qp.isEmpty ? null : qp);
  }

  Map<String, String> _headers({bool auth = true, bool json = true}) => {
    'Accept': 'application/json',
    if (json) 'Content-Type': 'application/json',
    if (auth && _storage.token != null)
      'Authorization': 'Bearer ${_storage.token}',
    if (_storage.cookies != null) 'Cookie': _storage.cookies!,
  };

  Future<dynamic> get(
    String p, {
    Map<String, dynamic>? query,
    bool auth = true,
  }) => _send(
    () => _client.get(_uri(p, query), headers: _headers(auth: auth)),
    auth: auth,
    path: p,
  );

  Future<dynamic> post(String p, {dynamic body, bool auth = true}) => _send(
    () => _client.post(
      _uri(p),
      headers: _headers(auth: auth),
      body: jsonEncode(body ?? {}),
    ),
    auth: auth,
    path: p,
  );

  Future<dynamic> patch(String p, {dynamic body, bool auth = true}) => _send(
    () => _client.patch(
      _uri(p),
      headers: _headers(auth: auth),
      body: jsonEncode(body ?? {}),
    ),
    auth: auth,
    path: p,
  );

  Future<dynamic> delete(String p, {dynamic body, bool auth = true}) => _send(
    () => _client.delete(
      _uri(p),
      headers: _headers(auth: auth),
      body: body == null ? null : jsonEncode(body),
    ),
    auth: auth,
    path: p,
  );

  Future<dynamic> multipartPost(
    String p, {
    Map<String, String> fields = const {},
    File? file,
    String fileField = 'file',
    bool auth = true,
  }) => multipart(
    'POST',
    p,
    fields: fields,
    file: file,
    fileField: fileField,
    auth: auth,
  );

  Future<dynamic> multipartPatch(
    String p, {
    Map<String, String> fields = const {},
    File? file,
    String fileField = 'profilePicture',
    bool auth = true,
  }) => multipart(
    'PATCH',
    p,
    fields: fields,
    file: file,
    fileField: fileField,
    auth: auth,
  );

  Future<dynamic> multipart(
    String method,
    String p, {
    Map<String, String> fields = const {},
    File? file,
    String fileField = 'file',
    bool auth = true,
  }) async {
    Future<http.Response> request() async {
      final req = http.MultipartRequest(method.toUpperCase(), _uri(p));
      req.headers.addAll(_headers(auth: auth, json: false));
      req.fields.addAll(fields);
      if (file != null) {
        req.files.add(await http.MultipartFile.fromPath(fileField, file.path));
      }
      final streamed = await req.send().timeout(_timeout);
      return http.Response.fromStream(streamed);
    }

    return _send(request, auth: auth, path: p);
  }

  Future<dynamic> _send(
    Future<http.Response> Function() request, {
    bool auth = true,
    String? path,
  }) async {
    try {
      if (auth &&
          path != ApiEndpoints.refreshToken &&
          _storage.isTokenExpired) {
        await _refreshAccessToken();
      }

      final response = await request().timeout(_timeout);
      await _captureCookies(response);
      if (_shouldRefresh(response, auth: auth, path: path)) {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          final retryResponse = await request().timeout(_timeout);
          await _captureCookies(retryResponse);
          return _decode(retryResponse);
        }
      }

      return _decode(response);
    } on SocketException {
      throw ApiException('No internet connection.');
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Unexpected network error: $e');
    }
  }

  bool _shouldRefresh(
    http.Response response, {
    required bool auth,
    String? path,
  }) {
    return auth &&
        response.statusCode == 401 &&
        path != ApiEndpoints.refreshToken &&
        _storage.token != null &&
        _storage.token!.isNotEmpty;
  }

  /// Persist Set-Cookie headers so the refresh-token cookie is replayed on
  /// subsequent requests (mimics the browser's credentials: "include" behaviour).
  Future<void> _captureCookies(http.Response response) async {
    final setCookies = response.headers['set-cookie'];
    if (setCookies == null || setCookies.isEmpty) return;

    final cookieHeader = _cookieHeaderFromSetCookie(setCookies);
    if (cookieHeader.isEmpty) return;

    await _storage.saveCookies(cookieHeader);
  }

  String _cookieHeaderFromSetCookie(String setCookieHeader) {
    return setCookieHeader
        .split(RegExp(r',(?=\s*[^;,=\s]+=)'))
        .map((cookie) => cookie.trim().split(';').first.trim())
        .where((cookie) => cookie.isNotEmpty)
        .join('; ');
  }

  Future<bool>? _refreshRequest;

  Future<bool> _refreshAccessToken() {
    final pending = _refreshRequest;
    if (pending != null) return pending;

    final future = _refreshAccessTokenNow();
    _refreshRequest = future;
    future.whenComplete(() => _refreshRequest = null);
    return future;
  }

  Future<bool> _refreshAccessTokenNow() async {
    final currentToken = _storage.token;
    if (currentToken == null || currentToken.isEmpty) return false;

    try {
      final response = await _client
          .post(
            _uri(ApiEndpoints.refreshToken),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $currentToken',
              if (_storage.cookies != null) 'Cookie': _storage.cookies!,
            },
            body: jsonEncode({}),
          )
          .timeout(_timeout);

      await _captureCookies(response);
      if (response.statusCode != 200) return false;

      final decoded = _decode(response);
      final session = AuthSession.fromJson(decoded);

      // Web calls /me after refresh to validate the token and handle rotation.
      String? finalToken = session.token;
      int? finalExp = session.exp;

      if (finalToken != null && finalToken.isNotEmpty) {
        try {
          final meResp = await _client
              .get(
                _uri(ApiEndpoints.me),
                headers: {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $finalToken',
                  if (_storage.cookies != null) 'Cookie': _storage.cookies!,
                },
              )
              .timeout(_timeout);

          await _captureCookies(meResp);

          if (meResp.statusCode == 200) {
            final meData = _decode(meResp);
            if (meData is Map) {
              final meToken = (meData['token'] ?? meData['refreshedToken'])
                  ?.toString();
              if (meToken != null && meToken.isNotEmpty) {
                finalToken = meToken;
              }
              if (meData['exp'] is int) {
                finalExp = meData['exp'] as int;
              }
            }
          }
        } catch (_) {
          // /me failed but refresh token is still valid — use it.
        }
      }

      if (finalToken == null || finalToken.isEmpty) return false;

      await _storage.saveToken(finalToken, exp: finalExp);
      return true;
    } catch (_) {
      // Don't clear auth on transient failures — let the caller decide.
      return false;
    }
  }

  dynamic _decode(http.Response r) {
    dynamic body;
    final raw = r.body.trim();
    if (raw.isNotEmpty) {
      try {
        body = jsonDecode(raw);
      } catch (_) {
        body = raw;
      }
    }

    if (r.statusCode >= 200 && r.statusCode < 300) return body;

    throw ApiException(
      _extractErrorMessage(body),
      statusCode: r.statusCode,
      payload: body,
    );
  }

  String _extractErrorMessage(dynamic body) {
    if (body is String && body.trim().isNotEmpty) return body.trim();
    if (body is! Map) return 'Request failed';

    final nestedMessages = <String>[];
    void collectMessages(dynamic value) {
      if (value is List) {
        for (final item in value) {
          collectMessages(item);
        }
        return;
      }
      if (value is! Map) return;

      final message = value['message'] ?? value['detail'] ?? value['msg'];
      if (message != null && message.toString().trim().isNotEmpty) {
        nestedMessages.add(message.toString().trim());
      }

      collectMessages(value['errors']);
      collectMessages(value['data']);
      collectMessages(value['collection']);
    }

    collectMessages(body['errors']);
    collectMessages(body['data']);
    if (nestedMessages.isNotEmpty) {
      return nestedMessages.toSet().join('\n');
    }

    final direct = body['message'] ?? body['error'];
    if (direct != null && direct.toString().trim().isNotEmpty) {
      return direct.toString().trim();
    }

    return 'Request failed';
  }
}
