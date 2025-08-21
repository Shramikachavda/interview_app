abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class ServerException extends AppException {
  const ServerException(super.message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException() : super("Unauthorized access.");
}

class UnexpectedException extends AppException {
  const UnexpectedException([super.message = "Something went wrong."]);
}
