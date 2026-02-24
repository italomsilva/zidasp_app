// lib/core/di.dart
import 'package:zidasp_app/controllers/pond_controller.dart';
import 'package:zidasp_app/theme/theme_controller.dart';

// Classe simples para segurar as instâncias
class DI {
  static final DI _instance = DI._internal();
  factory DI() => _instance;
  DI._internal();

  // Map para armazenar os controllers
  final Map<Type, dynamic> _instances = {};

  // Registra um controller (cria se não existir)
  T get<T>() {
    if (!_instances.containsKey(T)) {
      if (T == ThemeController) {
        _instances[T] = ThemeController();
      } else if (T == PondController) {
        _instances[T] = PondController();
      }
      // Adicione outros controllers aqui depois
    }
    return _instances[T] as T;
  }

  // Limpa tudo (útil para logout)
  void disposeAll() {
    _instances.clear();
  }
}

// Singleton global
final di = DI();
