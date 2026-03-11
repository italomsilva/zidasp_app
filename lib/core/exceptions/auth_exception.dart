class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException([String message = 'CPF ou senha incorretos.'])
    : super(message);
}

class NetworkException extends AuthException {
  NetworkException([
    String message = 'Erro de conexão. Verifique sua internet.',
  ]) : super(message);
}

class ValidationException extends AuthException {
  ValidationException(String message) : super(message);
}
