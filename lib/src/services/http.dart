import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_project_base/flutter_project_base.dart';
import 'package:flutter_project_base/src/services/http/base_types.dart';

/// An HTTP response where the entire response body is known in advance.
abstract class HttpClientResponse<T> {
  const HttpClientResponse(this.data);

  /// Underlying response data.
  final T data;
}

/// The interface for HTTP clients that take care of maintaining persistent
/// connections across multiple requests to the same server.
abstract class HttpClient {
  /// Sends an HTTP HEAD request with the given headers to the given URL.
  Future<HttpClientResponse<T>> head<T>(Uri uri,
      {Map<String, String>? headers});

  /// Sends an HTTP GET request with the given headers to the given URL.
  Future<HttpClientResponse<T>> get<T>(Uri uri, {Map<String, String>? headers});

  /// Sends an HTTP POST request with the given headers and body to the given
  /// URL.
  Future<HttpClientResponse<T>> post<T>(Uri uri,
      {Map<String, String>? headers, Object? body});

  /// Sends an HTTP PUT request with the given headers and body to the given
  /// URL.
  Future<HttpClientResponse<T>> put<T>(Uri uri,
      {Map<String, String>? headers, Object? body});

  /// Sends an HTTP PATCH request with the given headers and body to the given
  /// URL.
  Future<HttpClientResponse<T>> patch<T>(Uri uri,
      {Map<String, String>? headers, Object? body});

  /// Sends an HTTP DELETE request with the given headers to the given URL.
  Future<HttpClientResponse<T>> delete<T>(Uri uri,
      {Map<String, String>? headers, Object? body});

  /// Closes the client and cleans up any resources associated with it.
  void close();
}

abstract class BaseHttpClient extends HttpClient {
  /// Defines the `user-agent` HTTP header.
  String get userAgent;
}

class DioClientResponse<T> extends HttpClientResponse<Response<T>> {
  const DioClientResponse(Response<T> data) : super(data);

  /// Response is a [Map].
  bool get isMap => data.data is Map;

  /// Response is a [List].
  bool get isList => data.data is List;

  /// Response is a [String].
  bool get isString => !(isMap || isList);
}

/// Representss an HTTP client base on `dio` package.
class DioHttpClient implements BaseHttpClient {
  DioHttpClient({
    required this.baseUrl,
    Map<String, dynamic>? headers,
    this.autoclose = true,
  }) : _httpClient = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: headers,
          contentType: ContentType.json.value,
          connectTimeout: 2000,
          listFormat: ListFormat.csv,
        ));

  final Dio _httpClient;

  /// Base URL which this [HttpClient] serves.
  final String baseUrl;

  /// Whether this client will be closed after single request execution.
  final bool autoclose;

  @override
  void close() {
    _httpClient.close();
  }

  @override
  Future<HttpClientResponse<T>> head<T>(Uri uri,
          {Map<String, String>? headers}) =>
      _execute(uri, HttpMethod.head, headers: headers);

  @override
  Future<HttpClientResponse<T>> get<T>(Uri uri,
          {Map<String, String>? headers}) =>
      _execute(uri, HttpMethod.get, headers: headers);

  @override
  Future<HttpClientResponse<T>> patch<T>(Uri uri,
          {Map<String, String>? headers, Object? body}) =>
      _execute(uri, HttpMethod.patch, headers: headers);

  @override
  Future<HttpClientResponse<T>> post<T>(Uri uri,
          {Map<String, String>? headers, Object? body}) =>
      _execute(uri, HttpMethod.post, headers: headers);

  @override
  Future<HttpClientResponse<T>> put<T>(Uri uri,
          {Map<String, String>? headers, Object? body}) =>
      _execute(uri, HttpMethod.put, headers: headers);

  @override
  Future<HttpClientResponse<T>> delete<T>(Uri uri,
          {Map<String, String>? headers, Object? body}) =>
      _execute(uri, HttpMethod.delete);

  Future<HttpClientResponse<T>> _execute<T>(Uri uri, HttpMethod method,
      {Map<String, String>? headers, Object? body}) async {
    Response<T> response;
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
      return DioClientResponse(response) as HttpClientResponse<T>;
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          break;
        case DioErrorType.sendTimeout:
          break;
        case DioErrorType.receiveTimeout:
          break;
        case DioErrorType.response:
          throw Emergency(
              message: '${e.message}. ${e.response!.statusMessage}',
              code: e.type.name);
        case DioErrorType.cancel:
          break;
        case DioErrorType.other:
          final innerError = e.error;
          if (innerError is SocketException) {
            throw Emergency(
                message: innerError.message, code: 'SocketException');
          }
          if (innerError is HandshakeException) {
            throw Emergency(
                message: innerError.message, code: 'HandshakeException');
          }
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

  @override
  String toString() => 'DioHttpClient {baseUrl: $baseUrl}';
}
