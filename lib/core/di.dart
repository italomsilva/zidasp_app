// lib/core/di/di.dart
import 'package:get_it/get_it.dart';
import 'package:zidasp_app/modules/auth/auth_module.dart';
import 'package:zidasp_app/modules/pond/pond_module.dart';
import 'package:zidasp_app/modules/tide/tide_module.dart';
import 'core_module.dart';

final getIt = GetIt.instance;

class DI {
  static Future<void> init() async {
    // Core primeiro (dependências globais)
    await CoreModule.init();
    
    // Módulos
    AuthModule.init();
    PondModule.init();
    TideModule.init();
  }
}

// Helper CORRIGIDO - especifica que T deve ser não-nullable
T inject<T extends Object>() => getIt<T>();

// Para parâmetros
T injectParam<T extends Object, P extends Object>(P param) => 
    getIt<T>(param1: param);