import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_project_base/flutter_project_base.dart';
import 'package:flutter_project_base/src/services/http/base_types.dart';

/// An HTTP response where the entire response body is known in advance.
class HttpClientResponse<T extends Object?> {
  const HttpClientResponse(this.data);

  final T? data;

  bool get isMap => data is Map;
  bool get isList => data is List;
  bool get isString => data is String;
}

/// The interface for HTTP clients that take care of maintaining persistent
/// connections across multiple requests to the same server.
abstract class HttpClient {
  /// Sends an HTTP HEAD request with the given headers to the given URL.
  Future<HttpClientResponse> head(Uri uri, {Map<String, String>? headers});

  /// Sends an HTTP GET request with the given headers to the given URL.
  Future<HttpClientResponse> get(Uri uri, {Map<String, String>? headers});

  /// Sends an HTTP POST request with the given headers and body to the given
  /// URL.
  Future<HttpClientResponse> post(Uri uri,
      {Map<String, String>? headers, Object? body});

  /// Sends an HTTP PUT request with the given headers and body to the given
  /// URL.
  Future<HttpClientResponse> put(Uri uri,
      {Map<String, String>? headers, Object? body});

  /// Sends an HTTP PATCH request with the given headers and body to the given
  /// URL.
  Future<HttpClientResponse> patch(Uri uri,
      {Map<String, String>? headers, Object? body});

  /// Sends an HTTP DELETE request with the given headers to the given URL.
  Future<HttpClientResponse> delete(Uri uri,
      {Map<String, String>? headers, Object? body});

  /// Closes the client and cleans up any resources associated with it.
  void close();
}

abstract class BaseHttpClient extends HttpClient {
  /// Defines the `user-agent` HTTP header.
  String get userAgent;
}

class DioHttpClient implements BaseHttpClient {
  DioHttpClient({
    required String baseUrl,
    Map<String, dynamic>? headers,
    this.autoclose = true,
  }) : _httpClient = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: headers,
          contentType: ContentType.json.value,
          listFormat: ListFormat.csv,
        ));

  final Dio _httpClient;
  final bool autoclose;

  @override
  void close() {
    _httpClient.close();
  }

  @override
  Future<HttpClientResponse<Object?>> head(Uri uri,
          {Map<String, String>? headers}) =>
      _execute(uri, HttpMethod.head, headers: headers);

  @override
  Future<HttpClientResponse<Object?>> get(Uri uri,
          {Map<String, String>? headers}) =>
      _execute(uri, HttpMethod.get, headers: headers);

  @override
  Future<HttpClientResponse<Object?>> patch(Uri uri,
          {Map<String, String>? headers, Object? body}) =>
      _execute(uri, HttpMethod.patch, headers: headers);

  @override
  Future<HttpClientResponse<Object?>> post(Uri uri,
          {Map<String, String>? headers, Object? body}) =>
      _execute(uri, HttpMethod.post, headers: headers);

  @override
  Future<HttpClientResponse<Object?>> put(Uri uri,
          {Map<String, String>? headers, Object? body}) =>
      _execute(uri, HttpMethod.put, headers: headers);

  @override
  Future<HttpClientResponse> delete(Uri uri,
          {Map<String, String>? headers, Object? body}) =>
      _execute(uri, HttpMethod.delete);

  Future<HttpClientResponse> _execute(Uri uri, HttpMethod method,
      {Map<String, String>? headers, Object? body}) async {
    Response<Object?> response;
    final options = Options(headers: headers);
    try {
      switch (method) {
        case HttpMethod.head:
          response =
              await _httpClient.headUri(uri, data: body, options: options);
          break;
        case HttpMethod.get:
          response = await _httpClient.getUri(uri, options: options);
          break;
        case HttpMethod.post:
          response =
              await _httpClient.postUri(uri, data: body, options: options);
          break;
        case HttpMethod.put:
          response =
              await _httpClient.putUri(uri, data: body, options: options);
          break;
        case HttpMethod.patch:
          response =
              await _httpClient.patchUri(uri, data: body, options: options);
          break;
        case HttpMethod.delete:
          response =
              await _httpClient.deleteUri(uri, data: body, options: options);
          break;
      }
      return HttpClientResponse(response);
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          break;
        case DioErrorType.sendTimeout:
          break;
        case DioErrorType.receiveTimeout:
          break;
        case DioErrorType.response:
          break;
        case DioErrorType.cancel:
          break;
        case DioErrorType.other:
          break;
      }
      throw Emergency(message: e.message, code: e.type.name);
    } finally {
      if (autoclose) {
        close();
      }
    }
  }

  @override
  String get userAgent => 'Dart/1.0';
}
