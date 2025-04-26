/// A custom exception class to handle network-related errors.
class NetworkException implements Exception {
  /// Error message to be displayed or logged.
  final String message;

  NetworkException(this.message);

  @override
  String toString() => message;

  /// Factory method to create [NetworkException] based on HTTP status codes
  /// or custom error messages.
  static NetworkException fromStatusCode(
    int? statusCode, {
    String? errorMessage,
  }) {
    switch (statusCode) {
      case 400:
        return NetworkException(errorMessage ?? "Bad request");
      case 401:
        return NetworkException(errorMessage ?? "Unauthorized access");
      case 403:
        return NetworkException(errorMessage ?? "Forbidden request");
      case 404:
        return NetworkException(errorMessage ?? "Resource not found");
      case 429:
        return NetworkException(
          errorMessage ?? "Too many requests. Please try again later.",
        );
      case 500:
        return NetworkException(errorMessage ?? "Internal server error");
      case 502:
        return NetworkException(errorMessage ?? "Bad gateway");
      case 503:
        return NetworkException(errorMessage ?? "Service unavailable");
      default:
        return NetworkException(
          errorMessage ?? "Something went wrong. Please try again",
        );
    }
  }

  /// Factory method to create [NetworkException] from socket-related errors.
  static NetworkException fromSocketException() {
    return NetworkException(
      "No Internet connection. Please check your network.",
    );
  }
}
