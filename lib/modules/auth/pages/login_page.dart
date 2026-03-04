import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/widgets/shared/custom_button.dart';
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false, 
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // icon e titulo
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.shrimpAlert.withAlpha(100),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FontAwesomeIcons.shrimp,
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
                      // form
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
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
                            Watch(
                              (context) => TextField(
                                onChanged: controller.setDocumentInput,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
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

                            Watch(
                              (context) => TextField(
                                onChanged: controller.setPasswordInput,
                                obscureText:
                                    !controller.isPasswordVisible.value,
                                textInputAction: TextInputAction.done,
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
                                    onPressed:
                                        controller.togglePasswordVisibility,
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
                                Watch(
                                  (context) => Row(
                                    children: [
                                      Checkbox(
                                        value: controller.rememberMe.value,
                                        onChanged: (_) =>
                                            controller.toggleRememberMe(),
                                        activeColor: AppColors.shrimpAlert,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      const Text('Lembrar-me'),
                                    ],
                                  ),
                                ),
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

                            Watch((context) {
                              if (controller.errorMessage.value != null &&
                                  controller.errorMessage.value != "") {
                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.shrimpAlert.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.shrimpAlert.withValues(
                                        alpha: 0.3,
                                      ),
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
                            }),

                            const SizedBox(height: 16),

                            Watch(
                              (context) => CustomButton(
                                onClick: _handleLogin,
                                text: 'Entrar',
                                isLoading:
                                    controller.status.value ==
                                    LoginStatus.loading,
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
                    ],
                  ),
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
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
