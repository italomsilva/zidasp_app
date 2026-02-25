import 'package:get_it/get_it.dart';
import '../../../modules/auth/repositories/user_repository.dart';
import '../../../modules/auth/controllers/profile_controller.dart';

final getIt = GetIt.instance;

class AuthModule {
  static void init() {
    getIt.registerLazySingleton<UserRepository>(() => UserRepository());
    
    getIt.registerFactory<ProfileController>(
      () => ProfileController(getIt<UserRepository>()),
    );
  }
}