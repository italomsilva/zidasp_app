import 'package:get_it/get_it.dart';
import 'package:zidasp_app/core/repositories/company_repository.dart';
import 'package:zidasp_app/core/repositories/pond_repository.dart';
import 'package:zidasp_app/core/sesssion/session_controller.dart';
import 'package:zidasp_app/modules/pond/controllers/pond_list_controller.dart';
import 'package:zidasp_app/modules/pond/controllers/pond_detail_controller.dart';

final getIt = GetIt.instance;

class PondModule {
  static void init() {
    final pondRepository = getIt<PondRepository>();
    final companyRepository = getIt<CompanyRepository>();
    final sessionController = getIt<SessionController>();

    getIt.registerFactory<PondListController>(
      () => PondListController(
        pondRepository,
        companyRepository,
        sessionController,
      ),
    );

    getIt.registerFactory<PondDetailController>(
      () => PondDetailController(pondRepository, sessionController),
    );
  }
}
