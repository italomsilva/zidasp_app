// lib/core/di/modules/tide_module.dart
import 'package:get_it/get_it.dart';
import '../../../modules/tide/repositories/tide_repository.dart';
import '../../../modules/tide/controllers/tide_controller.dart';

final getIt = GetIt.instance;

class TideModule {
  static void init() {
    // Repository
    getIt.registerLazySingleton<TideRepository>(() => TideRepository());
    
    // Controller
    getIt.registerFactory<TideController>(
      () => TideController(getIt<TideRepository>()),
    );
  }
}