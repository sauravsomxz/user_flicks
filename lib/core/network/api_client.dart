import "dart:convert";
import "package:http/http.dart" as http;
import "package:user_flicks/core/network/network_exceptions.dart";
import "package:user_flicks/core/network/network_response.dart";

/// A lightweight API client using `http` package for making network requests.
class ApiClient {
  /// Default timeout duration for all requests.
  static const Duration _timeoutDuration = Duration(seconds: 20);

  final http.Client _client;
  final String baseUrl;

  /// Creates an instance of [ApiClient] with custom [baseUrl].
  ApiClient({required this.baseUrl}) : _client = http.Client();

  /// Generic GET request.
  Future<NetworkResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(dynamic data)? parser,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .get(uri, headers: headers)
          .timeout(_timeoutDuration);

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }

  /// Generic POST request.
  Future<NetworkResponse<T>> post<T>(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
    T Function(dynamic data)? parser,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .post(uri, headers: headers, body: body)
          .timeout(_timeoutDuration);

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return Failure('Network error: ${e.toString()}');
    }
  }

  /// Handle the HTTP response.
  NetworkResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic data)? parser,
  ) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      if (parser != null) {
        return Success(parser(body));
      } else {
        return Success(body as T);
      }
    } else {
      final error =
          body != null && body is Map<String, dynamic> && body['error'] != null
              ? body['error'].toString()
              : null;
      return Failure(
        NetworkException.fromStatusCode(
          statusCode,
          errorMessage: error,
        ).toString(),
      );
    }
  }
}
