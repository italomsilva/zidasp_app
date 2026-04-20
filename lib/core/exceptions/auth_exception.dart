class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException([super.message = 'CPF ou senha incorretos.']);
}

class NetworkException extends AuthException {
  NetworkException([
    super.message = 'Erro de conexão. Verifique sua internet.',
  ]);
}

class ValidationException extends AuthException {
  ValidationException(super.message);
}
