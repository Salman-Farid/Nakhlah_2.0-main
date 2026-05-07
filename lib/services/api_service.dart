import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_endpoints.dart';
import '../models/models.dart';
import 'storage_service.dart';

class ApiService {
  ApiService(this._storage);

  final StorageService _storage;
  final http.Client _client = http.Client();

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final clean = path.startsWith('/api')
        ? path
        : '${ApiEndpoints.apiPrefix}$path';
    final qp = <String, String>{};
    query?.forEach((k, v) {
      if (v != null && '$v'.isNotEmpty) qp[k] = '$v';
    });
    return Uri.parse(
      '${ApiEndpoints.baseUrl}$clean',
    ).replace(queryParameters: qp.isEmpty ? null : qp);
  }

  Map<String, String> _headers({bool auth = true}) => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (auth && _storage.token != null)
      'Authorization': 'Bearer ${_storage.token}',
  };

  Future<dynamic> get(
    String p, {
    Map<String, dynamic>? query,
    bool auth = true,
  }) => _send(() => _client.get(_uri(p, query), headers: _headers(auth: auth)));

  Future<dynamic> post(
    String p, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) => _send(
    () => _client.post(
      _uri(p),
      headers: _headers(auth: auth),
      body: jsonEncode(body ?? {}),
    ),
  );

  Future<dynamic> patch(
    String p, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) => _send(
    () => _client.patch(
      _uri(p),
      headers: _headers(auth: auth),
      body: jsonEncode(body ?? {}),
    ),
  );

  Future<dynamic> delete(
    String p, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) => _send(
    () => _client.delete(
      _uri(p),
      headers: _headers(auth: auth),
      body: body == null ? null : jsonEncode(body),
    ),
  );

  Future<dynamic> multipartPatch(
    String p, {
    Map<String, String> fields = const {},
    File? file,
    String fileField = 'profilePicture',
  }) async {
    final req = http.MultipartRequest('PATCH', _uri(p));
    req.headers.addAll({
      'Accept': 'application/json',
      if (_storage.token != null) 'Authorization': 'Bearer ${_storage.token}',
    });
    req.fields.addAll(fields);
    if (file != null) {
      req.files.add(await http.MultipartFile.fromPath(fileField, file.path));
    }
    return _decode(await http.Response.fromStream(await req.send()));
  }

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    try {
      return _decode(await request());
    } on SocketException {
      throw ApiException('No internet connection.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Unexpected network error: $e');
    }
  }

  dynamic _decode(http.Response r) {
    dynamic body;
    if (r.body.isNotEmpty) {
      try {
        body = jsonDecode(r.body);
      } catch (_) {
        body = r.body;
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

      collectMessages(value['errors']);
      collectMessages(value['data']);
      collectMessages(value['collection']);

      final message = value['message'] ?? value['detail'] ?? value['msg'];
      if (message != null && message.toString().trim().isNotEmpty) {
        nestedMessages.add(message.toString().trim());
      }
    }

    collectMessages(body['errors']);
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
