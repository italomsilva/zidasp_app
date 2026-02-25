// lib/core/di/modules/pond_module.dart
import 'package:get_it/get_it.dart';
import '../../../modules/pond/repositories/pond_repository.dart';
import '../../../modules/pond/controllers/dashboard_controller.dart';
import '../../../modules/pond/controllers/pond_detail_controller.dart';

final getIt = GetIt.instance;

class PondModule {
  static void init() {
    // Repository
    getIt.registerLazySingleton<PondRepository>(() => PondRepository());
    
    // Controllers (factory para cada tela)
    getIt.registerFactory<DashboardController>(
      () => DashboardController(getIt<PondRepository>()),
    );
    
    getIt.registerFactoryParam<PondDetailController, String, void>(
      (pondId, _) => PondDetailController(
        pondId: pondId,
        repository: getIt<PondRepository>(),
      ),
    );
  }
}