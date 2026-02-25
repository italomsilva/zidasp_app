// lib/modules/auth/controllers/login_controller.dart
import 'package:signals/signals.dart';
import 'package:zidasp_app/modules/auth/repositories/user_repository.dart';

enum LoginStatus { initial, loading, success, error }

class LoginController {
  final UserRepository _repository;

  // Signals para campos do formulário
  final documentInput = signal<String>('');
  final passwordInput = signal<String>('');
  final isPasswordVisible = signal<bool>(false);
  final rememberMe = signal<bool>(false);

  // Signals para validação
  final documentError = signal<String?>(null);
  final passwordError = signal<String?>(null);

  // Signals para status do login
  final status = signal<LoginStatus>(LoginStatus.initial);
  final errorMessage = signal<String?>('');

  // Computed para validar formulário
  late final isFormValid = computed(() {
    return documentInput.value.isNotEmpty &&
        passwordInput.value.isNotEmpty;
  });

  LoginController(this._repository);

  void setDocumentInput(String value) {
    documentInput.value = value;
    _validateDocument();
  }

  void setPasswordInput(String value) {
    passwordInput.value = value;
    _validatePassword();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void _validateDocument() {
    if (documentInput.value.isEmpty) {
      documentError.value = 'Documento é obrigatório';
    } else {
      documentError.value = null;
    }
  }

  void _validatePassword() {
    if (passwordInput.value.isEmpty) {
      passwordError.value = 'Senha é obrigatória';
    } else if (passwordInput.value.length < 6) {
      passwordError.value = 'Senha deve ter pelo menos 6 caracteres';
    } else {
      passwordError.value = null;
    }
  }
  Future<bool> login() async {
    _validateDocument();
    _validatePassword();

    if (documentError.value != null || passwordError.value != null) {
      return false;
    }

    status.value = LoginStatus.loading;
    errorMessage.value = null;

    try {
      // Usar mockLogin por enquanto
      final response = await _repository.login(documentInput.value, passwordInput.value);

      // Se "lembrar-me" estiver marcado, salvar credenciais (apenas token!)
      if (rememberMe.value) {
        // Salvar token no SharedPreferences
        // await _saveToken(response.token);
      }

      status.value = LoginStatus.success;
      return true;
    } catch (e) {
      status.value = LoginStatus.error;
      errorMessage.value = 'Erro inesperado. Tente novamente.';
      return false;
    }
  }

  void reset() {
    status.value = LoginStatus.initial;
    errorMessage.value = null;
  }
}
