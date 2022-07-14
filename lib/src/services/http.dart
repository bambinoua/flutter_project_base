/// An HTTP response where the entire response body is known in advance.
abstract class Response<T> {
  Response(this.data);

  final T data;
}

class MapResponse extends Response<Map> {
  MapResponse(Map data) : super(data);
}

class ListResponse extends Response<List> {
  ListResponse(List data) : super(data);
}

class StringResponse extends Response<String> {
  StringResponse(String data) : super(data);
}

/// The interface for HTTP clients that take care of maintaining persistent
/// connections across multiple requests to the same server.
abstract class HttpClient {
  /// Sends an HTTP HEAD request with the given headers to the given URL.
  Future<Response> head(Uri uri, {Map<String, String>? headers});

  /// Sends an HTTP GET request with the given headers to the given URL.
  Future<Response> get(Uri uri, {Map<String, String>? headers});

  /// Sends an HTTP POST request with the given headers and body to the given
  /// URL.
  Future<Response> post(Uri url, {Map<String, String>? headers, Object? body});

  /// Sends an HTTP PUT request with the given headers and body to the given
  /// URL.
  Future<Response> put(Uri url, {Map<String, String>? headers, Object? body});

  /// Sends an HTTP PATCH request with the given headers and body to the given
  /// URL.
  Future<Response> patch(Uri url, {Map<String, String>? headers, Object? body});

  /// Sends an HTTP DELETE request with the given headers to the given URL.
  Future<Response> delete(Uri url,
      {Map<String, String>? headers, Object? body});

  /// Closes the client and cleans up any resources associated with it.
  void close();
}

abstract class BaseHttpClient extends HttpClient {
  /// Defines the `user-agent` HTTP header.
  String? get userAgent => null;
}
