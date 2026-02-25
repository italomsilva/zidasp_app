// lib/core/di/core_module.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:zidasp_app/core/theme/theme_controller.dart';

final getIt = GetIt.instance;

class CoreModule {
  static Future<void> init() async {
    // SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(prefs);
    
    // Dio (para futuras chamadas API)
    getIt.registerLazySingleton<Dio>(() => Dio(
      BaseOptions(
        baseUrl: 'https://api.zidasp.com',
        connectTimeout: const Duration(seconds: 30),
      ),
    ));
    
    // ThemeController (global)
    getIt.registerSingleton<ThemeController>(ThemeController());
  }
}