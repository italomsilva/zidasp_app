import 'package:get_it/get_it.dart';
import 'package:zidasp_app/core/repositories/company_repository.dart';
import 'package:zidasp_app/core/repositories/pond_repository.dart';
import 'package:zidasp_app/core/sesssion/session_controller.dart';
import 'package:zidasp_app/modules/pond/controllers/dashboard_controller.dart';
import 'package:zidasp_app/modules/pond/controllers/pond_detail_controller.dart';

final getIt = GetIt.instance;

class PondModule {
  static void init() {
      final pondRepo = getIt<PondRepository>();
      final companyRepo = getIt<CompanyRepository>();
      final sessionCtrl = getIt<SessionController>();

    getIt.registerFactory<DashboardController>(
      () => DashboardController(
        getIt<PondRepository>(),
        getIt<CompanyRepository>(),
        getIt<SessionController>(),
      ),
    );
    getIt.registerFactoryParam<PondDetailController, String, void>(
      (pondId, _) => PondDetailController(
        pondId: pondId,
        repository: getIt<PondRepository>(),
      ),
    );
  }
}
