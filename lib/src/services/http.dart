import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_project_base/flutter_project_base.dart';

enum HttpMethod { head, get, post, put, patch, delete }

/// The interface for HTTP clients that take care of maintaining persistent
/// connections across multiple requests to the same server.
abstract class HttpClient {
  /// Sends an HTTP HEAD request with the given headers to the given URL.
  Future<BaseHttpResponse<T>> head<T>(Uri uri, {Map<String, String>? headers});

  /// Sends an HTTP GET request with the given headers to the given URL.
  Future<BaseHttpResponse<T>> get<T>(Uri uri, {Map<String, String>? headers});

  /// Sends an HTTP POST request with the given headers and body to the given
  /// URL.
  Future<BaseHttpResponse<T>> post<T>(Uri uri,
      {Map<String, String>? headers, Object? body});

  /// Sends an HTTP PUT request with the given headers and body to the given
  /// URL.
  Future<BaseHttpResponse<T>> put<T>(Uri uri,
      {Map<String, String>? headers, Object? body});

  /// Sends an HTTP PATCH request with the given headers and body to the given
  /// URL.
  Future<BaseHttpResponse<T>> patch<T>(Uri uri,
      {Map<String, String>? headers, Object? body});

  /// Sends an HTTP DELETE request with the given headers to the given URL.
  Future<BaseHttpResponse<T>> delete<T>(Uri uri,
      {Map<String, String>? headers, Object? body});

  /// Closes the client and cleans up any resources associated with it.
  void close();
}

abstract class BaseHttpClient extends HttpClient {
  /// Defines the `user-agent` HTTP header.
  String get userAgent;
}

/// Representss an HTTP client base on `dio` package.
class DioHttpClient implements BaseHttpClient {
  DioHttpClient({
    required this.baseUrl,
    Map<String, dynamic>? headers,
    this.autoclose = true,
    int? connectTimeout = 1200,
  }) : _httpClient = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: headers,
          contentType: ContentType.json.value,
          connectTimeout: connectTimeout,
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
  Future<BaseHttpResponse<T>> head<T>(Uri uri,
          {Map<String, String>? headers}) =>
      _execute(uri, HttpMethod.head, headers: headers);

  @override
  Future<BaseHttpResponse<T>> get<T>(Uri uri, {Map<String, String>? headers}) =>
      _execute(uri, HttpMethod.get, headers: headers);

  @override
  Future<BaseHttpResponse<T>> patch<T>(Uri uri,
          {Map<String, String>? headers, Object? body}) =>
      _execute(uri, HttpMethod.patch, headers: headers);

  @override
  Future<BaseHttpResponse<T>> post<T>(Uri uri,
          {Map<String, String>? headers, Object? body}) =>
      _execute(uri, HttpMethod.post, headers: headers);

  @override
  Future<BaseHttpResponse<T>> put<T>(Uri uri,
          {Map<String, String>? headers, Object? body}) =>
      _execute(uri, HttpMethod.put, headers: headers);

  @override
  Future<BaseHttpResponse<T>> delete<T>(Uri uri,
          {Map<String, String>? headers, Object? body}) =>
      _execute(uri, HttpMethod.delete);

  Future<BaseHttpResponse<T>> _execute<T>(Uri uri, HttpMethod method,
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
      return DioHttpResponse<T>(response) as BaseHttpResponse<T>;
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

/// An HTTP response where the entire response body is known in advance.
abstract class BaseHttpResponse<T> {
  const BaseHttpResponse(this.data);

  /// Underlying response data.
  final T data;
}

class DioHttpResponse<T> extends BaseHttpResponse<Response<T>> {
  const DioHttpResponse(Response<T> data) : super(data);

  /// Response is a [Map].
  bool get isMap => data.data is Map;

  /// Response is a [List].
  bool get isList => data.data is List;

  /// Response is a [String].
  bool get isString => !(isMap || isList);
}
