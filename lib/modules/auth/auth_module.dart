import 'package:get_it/get_it.dart';
import 'package:zidasp_app/core/sesssion/session_controller.dart';
import 'package:zidasp_app/modules/auth/controllers/login_controller.dart';
import '../../core/repositories/user_repository.dart';
import '../../../modules/auth/controllers/profile_controller.dart';

final getIt = GetIt.instance;

// auth_module.dart
class AuthModule {
  static void init() {
    getIt.registerFactory<ProfileController>(
      () => ProfileController(getIt<UserRepository>()),
    );

    getIt.registerFactory<LoginController>(
      () => LoginController(
        getIt<UserRepository>(), 
        getIt<SessionController>(),
      ),
    );
  }
}