import 'package:get_it/get_it.dart';
import '../../core/repositories/tide_repository.dart';
import '../../../modules/tide/controllers/tide_controller.dart';

final getIt = GetIt.instance;

class TideModule {
  static void init() {
    final tideRepository = getIt<TideRepository>();

    getIt.registerFactory<TideController>(
      () => TideController(tideRepository),
    );
  }
}