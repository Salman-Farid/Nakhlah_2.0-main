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
  };

  Future<dynamic> get(
    String p, {
    Map<String, dynamic>? query,
    bool auth = true,
  }) => _send(() => _client.get(_uri(p, query), headers: _headers(auth: auth)));

  Future<dynamic> post(String p, {dynamic body, bool auth = true}) => _send(
    () => _client.post(
      _uri(p),
      headers: _headers(auth: auth),
      body: jsonEncode(body ?? {}),
    ),
  );

  Future<dynamic> patch(String p, {dynamic body, bool auth = true}) => _send(
    () => _client.patch(
      _uri(p),
      headers: _headers(auth: auth),
      body: jsonEncode(body ?? {}),
    ),
  );

  Future<dynamic> delete(String p, {dynamic body, bool auth = true}) => _send(
    () => _client.delete(
      _uri(p),
      headers: _headers(auth: auth),
      body: body == null ? null : jsonEncode(body),
    ),
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
    try {
      final req = http.MultipartRequest(method.toUpperCase(), _uri(p));
      req.headers.addAll(_headers(auth: auth, json: false));
      req.fields.addAll(fields);
      if (file != null) {
        req.files.add(await http.MultipartFile.fromPath(fileField, file.path));
      }
      final streamed = await req.send().timeout(_timeout);
      return _decode(await http.Response.fromStream(streamed));
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

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    try {
      return _decode(await request().timeout(_timeout));
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
