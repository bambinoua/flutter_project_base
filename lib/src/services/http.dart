import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_project_base/flutter_project_base.dart';

enum HttpMethod { head, get, post, put, patch, delete }

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

/// Representss an HTTP client working with JSON based on `dio` package.
class JsonHttpClient implements BaseHttpClient {
  JsonHttpClient({
    required this.baseUrl,
    Map<String, dynamic>? headers,
    this.autoclose = true,
    int? connectTimeout = 15000,
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
      assert(
          response.data is String ||
              response.data is List ||
              response.data is Map,
          'Response body type mismatched with JSON allowed format');
      final responseBody = json.decode(response.data as String);
      return HttpClientResponse<T>(
        data: responseBody,
        headers: response.headers.map
            .map((key, value) => MapEntry(key, value.join(','))),
        statusCode: response.statusCode!,
        statusMessage: response.statusMessage!,
        uri: response.realUri,
      );
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
            code: '${e.response!.statusCode}',
          );
        case DioErrorType.cancel:
          break;
        case DioErrorType.other:
          final innerError = e.error;
          if (innerError is SocketException) {
            throw Emergency(
              message: innerError.message,
              code: 'SocketException',
            );
          }
          if (innerError is HandshakeException) {
            throw Emergency(
              message: innerError.message,
              code: 'HandshakeException',
            );
          }
          if (innerError is String) {
            if (innerError.contains(
                'Dio can\'t establish new connection after closed.')) {
              throw Emergency(
                message: e.message,
                code: 'ClosedConnectionException',
              );
            }
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
class HttpClientResponse<T> {
  const HttpClientResponse({
    this.data,
    this.headers = const <String, String>{},
    required this.statusCode,
    required this.statusMessage,
    this.uri,
  });

  /// Response body.
  final T? data;

  /// Response headers.
  final Map<String, String> headers;

  /// Http status code.
  final int statusCode;

  /// Returns the reason phrase associated with the status code.
  /// The reason phrase must be set before the body is written
  /// to. Setting the reason phrase after writing to the body.
  final String statusMessage;

  /// Return the final real request uri (maybe redirect).
  final Uri? uri;

  /// Response is a [Map].
  bool get isMap => data is Map;

  /// Response is a [List].
  bool get isList => data is List;

  /// Response is a [String].
  bool get isString => !(isMap || isList);
}
