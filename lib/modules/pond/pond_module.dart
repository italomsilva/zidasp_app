// pond_module.dart
import 'package:get_it/get_it.dart';
import 'package:zidasp_app/core/repositories/company_repository.dart';
import 'package:zidasp_app/core/repositories/pond_repository.dart';
import 'package:zidasp_app/core/sesssion/session_controller.dart';
import 'package:zidasp_app/modules/pond/controllers/dashboard_controller.dart';
import 'package:zidasp_app/modules/pond/controllers/pond_detail_controller.dart';

final getIt = GetIt.instance;

class PondModule {
  static void init() {
    print('🏭 Inicializando PondModule...');
    
    // Verificação das dependências
    try {
      print('🔍 Verificando PondRepository...');
      final pondRepo = getIt<PondRepository>();
      print('   ✅ PondRepository encontrado: $pondRepo');
      
      print('🔍 Verificando CompanyRepository...');
      final companyRepo = getIt<CompanyRepository>();
      print('   ✅ CompanyRepository encontrado: $companyRepo');
      
      print('🔍 Verificando SessionController...');
      final sessionCtrl = getIt<SessionController>();
      print('   ✅ SessionController encontrado: $sessionCtrl');
      
      print('✅ Todas as dependências verificadas com sucesso!');
      
    } catch (e) {
      print('❌ ERRO: Dependência não encontrada no PondModule');
      print('   Erro: $e');
      print('   Verifique se o CoreModule.init() foi chamado antes');
      rethrow;
    }

    // Registra os Controllers
    print('📦 Registrando DashboardController...');
    getIt.registerFactory<DashboardController>(
      () => DashboardController(
        getIt<PondRepository>(),
        getIt<CompanyRepository>(),
        getIt<SessionController>(),
      ),
    );
    print('✅ DashboardController registrado');

    print('📦 Registrando PondDetailController...');
    getIt.registerFactoryParam<PondDetailController, String, void>(
      (pondId, _) => PondDetailController(
        pondId: pondId,
        repository: getIt<PondRepository>(),
      ),
    );
    print('✅ PondDetailController registrado');
    
    print('✅ PondModule inicializado com sucesso');
  }
}