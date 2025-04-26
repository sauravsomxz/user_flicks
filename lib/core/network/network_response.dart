/// Represents the base class for network responses.
/// It can either be a [Success] or a [Failure].
sealed class NetworkResponse<T> {
  const NetworkResponse();
}

/// Represents a successful network response containing data of type [T].
class Success<T> extends NetworkResponse<T> {
  final T data;

  const Success(this.data);
}

/// Represents a failed network response containing an error [message].
class Failure<T> extends NetworkResponse<T> {
  final String message;

  const Failure(this.message);
}
