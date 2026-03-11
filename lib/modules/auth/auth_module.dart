import 'package:get_it/get_it.dart';
import 'package:zidasp_app/core/sesssion/session_controller.dart';
import 'package:zidasp_app/modules/auth/controllers/login_controller.dart';
import 'package:zidasp_app/core/repositories/i_user_repository.dart';
import '../../../modules/auth/controllers/profile_controller.dart';

final getIt = GetIt.instance;

// auth_module.dart
class AuthModule {
  static void init() {
    final userRepository = getIt<IUserRepository>();
    final sessionController = getIt<SessionController>();

    getIt.registerFactory<ProfileController>(
      () => ProfileController(userRepository, sessionController),
    );

    getIt.registerFactory<LoginController>(
      () => LoginController(userRepository, sessionController),
    );
  }
}
