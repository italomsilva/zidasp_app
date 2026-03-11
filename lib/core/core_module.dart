// core_module.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:zidasp_app/core/repositories/company_repository.dart';
import 'package:zidasp_app/core/repositories/pond_repository.dart';
import 'package:zidasp_app/core/repositories/tide_repository.dart';
import 'package:zidasp_app/core/repositories/i_user_repository.dart';
import 'package:zidasp_app/core/repositories/user_repository.dart';
import 'package:zidasp_app/core/sesssion/session_controller.dart';
import 'package:zidasp_app/core/theme/theme_controller.dart';

final getIt = GetIt.instance;

class CoreModule {
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(prefs);

    getIt.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: 'https://api.zidasp.com',
          connectTimeout: const Duration(seconds: 30),
        ),
      ),
    );

    // 2. Repositórios
    getIt.registerLazySingleton<IUserRepository>(() => UserRepository());

    getIt.registerLazySingleton<CompanyRepository>(() => CompanyRepository());

    getIt.registerLazySingleton<PondRepository>(() => PondRepository());

    getIt.registerLazySingleton<TideRepository>(() => TideRepository());

    // 3. Controllers
    getIt.registerSingleton<SessionController>(SessionController());

    getIt.registerSingleton<ThemeController>(ThemeController());
  }
}
