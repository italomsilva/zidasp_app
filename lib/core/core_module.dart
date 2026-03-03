// core_module.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:zidasp_app/core/repositories/company_repository.dart';
import 'package:zidasp_app/core/repositories/pond_repository.dart';
import 'package:zidasp_app/core/repositories/tide_repository.dart';
import 'package:zidasp_app/core/repositories/user_repository.dart';
import 'package:zidasp_app/core/sesssion/session_controller.dart';
import 'package:zidasp_app/core/theme/theme_controller.dart';

final getIt = GetIt.instance;

class CoreModule {
  static Future<void> init() async {
    print('🚀 Iniciando CoreModule...');
    
    // 1. Infraestrutura
    print('📦 Registrando SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(prefs);
    print('✅ SharedPreferences registrado');

    print('📦 Registrando Dio...');
    getIt.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: 'https://api.zidasp.com',
          connectTimeout: const Duration(seconds: 30),
        ),
      ),
    );
    print('✅ Dio registrado');

    // 2. Repositórios
    print('📦 Registrando UserRepository...');
    getIt.registerLazySingleton<UserRepository>(() => UserRepository());
    print('✅ UserRepository registrado');

    print('📦 Registrando CompanyRepository...');
    getIt.registerLazySingleton<CompanyRepository>(() => CompanyRepository());
    print('✅ CompanyRepository registrado');

    print('📦 Registrando PondRepository...');
    getIt.registerLazySingleton<PondRepository>(() => PondRepository());
    print('✅ PondRepository registrado');

    print('📦 Registrando TideRepository...');
    getIt.registerLazySingleton<TideRepository>(() => TideRepository());
    print('✅ TideRepository registrado');

    // 3. Controllers
    print('📦 Registrando SessionController...');
    getIt.registerSingleton<SessionController>(SessionController(prefs));
    print('✅ SessionController registrado');

    print('📦 Registrando ThemeController...');
    getIt.registerSingleton<ThemeController>(ThemeController());
    print('✅ ThemeController registrado');

    print('✅ CoreModule inicializado com sucesso!');
  }
}