import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/exceptions.dart';

enum HttpMethod { head, get, post, put, patch, delete }

enum HttpBodyType { json, plain, stream, bytes }

extension on HttpBodyType {
  ResponseType asResponseType() => _map[this]!;

  static const _map = <HttpBodyType, ResponseType>{
    HttpBodyType.json: ResponseType.json,
    HttpBodyType.plain: ResponseType.plain,
    HttpBodyType.stream: ResponseType.stream,
    HttpBodyType.bytes: ResponseType.bytes,
  };
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

/// Representss an HTTP client based on `dio` package.
class DioHttpClient implements BaseHttpClient {
  DioHttpClient({
    required this.baseUrl,
    Map<String, dynamic>? headers,
    this.autoclose = false,
    int? connectTimeout = 30000,
    int? sendTimeout = 30000,
    int? receiveTimeout = 30000,
    HttpBodyType bodyType = HttpBodyType.json,
  }) : _httpClient = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: headers,
          contentType: ContentType.json.value,
          responseType: bodyType.asResponseType(),
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout,
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

  @protected
  HttpClientResponse<T> transformResponse<T>(Response<Object?> response) {
    assert(
        response.data is String ||
            response.data is List ||
            response.data is Map,
        'Response data type mismatched with JSON allowed format');
    final responseContentType = ContentType.parse(
        response.headers.value(HttpHeaders.contentTypeHeader) ??
            ContentType.json.value);
    final responseBody =
        (responseContentType.mimeType == ContentType.json.mimeType &&
                response.data is String
            ? json.decode(response.data as String)
            : response.data) as T;
    return HttpClientResponse<T>(
      data: responseBody,
      headers: response.headers.map
          .map((key, value) => MapEntry(key, value.join(','))),
      statusCode: response.statusCode!,
      statusMessage: response.statusMessage!,
      uri: response.realUri,
    );
  }

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
      return transformResponse(response);
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          break;
        case DioErrorType.sendTimeout:
          break;
        case DioErrorType.receiveTimeout:
          break;
        case DioErrorType.cancel:
          break;
        case DioErrorType.response:
          final contentTypeHeader =
              e.response!.headers.value(HttpHeaders.contentTypeHeader);
          assert(contentTypeHeader != null, 'Content-type header is missing');
          final contentType = ContentType.parse(contentTypeHeader!);
          if (contentType.value == ContentType.html.value) {
            // Usually states are 404, 503...
          } else if (contentType.value == ContentType.json.value) {
            //
          }
          throw HttpClientException(
            message: e.message,
            code: e.response!.statusCode.toString(),
          );
        case DioErrorType.other:
          final innerError = e.error;
          if (innerError is SocketException) {
            throw HttpClientException(
              message: e.message,
              code: HttpStatus.networkConnectTimeoutError.toString(),
              path: e.requestOptions.uri,
            );
          }
          if (innerError is TlsException) {
            throw HttpClientException(
              message: e.message,
              code: HttpStatus.connectionClosedWithoutResponse.toString(),
              path: e.requestOptions.uri,
            );
          }
          if (innerError is String) {
            if (innerError.contains(
                'Dio can\'t establish new connection after closed.')) {
              throw HttpClientException(
                message: e.message,
                code: HttpStatus.clientClosedRequest.toString(),
                path: e.requestOptions.uri,
              );
            }
          }
          break;
      }
      throw HttpClientException(message: e.message, code: e.type.name);
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

class HttpClientException extends ApplicationException {
  const HttpClientException({super.message, super.code, this.path});

  final Uri? path;
}
