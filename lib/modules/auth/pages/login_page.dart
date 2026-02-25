// lib/modules/auth/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../../../core/di.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final controller = inject<LoginController>();
  
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  
  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header com ilustração
            SliverToBoxAdapter(
              child: Container(
                height: 240,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.shrimpAlert.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.waves_rounded,
                          size: 50,
                          color: AppColors.shrimpAlert,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Zidasp',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.shrimpAlert,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Plataforma para Aquicultura',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.shrimpAlert,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Formulário de login
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Título do formulário
                    const Text(
                      'Bem-vindo de volta!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Faça login para acessar sua conta',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Campo de documento
                    Watch(
                      (context) => TextField(
                        onChanged: controller.setDocumentInput,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {
                          _emailFocus.unfocus();
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                        decoration: InputDecoration(
                          labelText: 'CPF (Somente números)',
                          hintText: '12345678900',
                          prefixIcon: const Icon(Icons.email_outlined),
                          errorText: controller.documentError.value,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.shrimpAlert,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Campo de senha
                    Watch(
                      (context) => TextField(
                        onChanged: controller.setPasswordInput,
                        focusNode: _passwordFocus,
                        obscureText: !controller.isPasswordVisible.value,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () async {
                          _passwordFocus.unfocus();
                          if (controller.isFormValid.value) {
                            await _handleLogin();
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          hintText: '',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          errorText: controller.passwordError.value,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.shrimpAlert,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Lembrar-me e Esqueci senha
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Checkbox "Lembrar-me"
                        Watch(
                          (context) => Row(
                            children: [
                              Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: (_) => controller.toggleRememberMe(),
                                activeColor: AppColors.shrimpAlert,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const Text('Lembrar-me'),
                            ],
                          ),
                        ),
                        
                        // Link "Esqueci senha"
                        TextButton(
                          onPressed: controller.login,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.shrimpAlert,
                          ),
                          child: const Text('Esqueci minha senha'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Mensagem de erro
                    Watch(
                      (context) {
                        if (controller.errorMessage.value != null && controller.errorMessage.value != "") {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.shrimpAlert.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.shrimpAlert.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppColors.shrimpAlert,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    controller.errorMessage.value!,
                                    style: TextStyle(
                                      color: AppColors.shrimpAlert,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Botão de login
                    Watch(
                      (context) => ElevatedButton(
                        onPressed: controller.status.value == LoginStatus.loading
                            ? null
                            : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.shrimpAlert,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: controller.status.value == LoginStatus.loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Entrar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Link para cadastro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Não tem uma conta? ',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navegar para cadastro
                          },
                          child: Text(
                            'Cadastre-se',
                            style: TextStyle(
                              color: AppColors.shrimpAlert,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _handleLogin() async {
    final success = await controller.login();
    
    if (success && mounted) {
    print("----------login sucesso");
      // Login bem-sucedido - navegar para a home
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}