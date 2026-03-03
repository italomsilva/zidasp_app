// di.dart
import 'package:get_it/get_it.dart';
import 'package:zidasp_app/modules/auth/auth_module.dart';
import 'package:zidasp_app/modules/pond/pond_module.dart';
import 'package:zidasp_app/modules/tide/tide_module.dart';
import 'core_module.dart';

final getIt = GetIt.instance;

class DI {
  static Future<void> init() async {
    print('🔷 INICIANDO DI 🔷');
    
    // Core primeiro (dependências globais)
    print('📌 Passo 1: Inicializando CoreModule...');
    await CoreModule.init();
    print('✅ CoreModule finalizado\n');
    
    // Módulos
    print('📌 Passo 2: Inicializando AuthModule...');
    AuthModule.init();
    print('✅ AuthModule finalizado\n');
    
    print('📌 Passo 3: Inicializando PondModule...');
    PondModule.init();
    print('✅ PondModule finalizado\n');
    
    print('📌 Passo 4: Inicializando TideModule...');
    TideModule.init();
    print('✅ TideModule finalizado\n');
    
    print('🔷 DI FINALIZADO COM SUCESSO 🔷');
  }
}

T inject<T extends Object>() => getIt<T>();

T injectParam<T extends Object, P extends Object>(P param) => 
    getIt<T>(param1: param);