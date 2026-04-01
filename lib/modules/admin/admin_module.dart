import 'package:get_it/get_it.dart';
import 'controllers/admin_controller.dart';

final getIt = GetIt.instance;

class AdminModule {
  static void init() {
    getIt.registerFactory<AdminController>(() => AdminController());
  }
}
