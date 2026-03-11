import '../../modules/auth/dtos/company_dto.dart';
import '../../modules/auth/dtos/user_dto.dart';

abstract class IUserRepository {
  Future<UserDTO> getUserById(String id);
  Future<List<CompanyDTO>> getUserCompanies();
  Future<UserDTO> updateProfile({
    required String name,
    required String email,
    required String document,
  });
  Future<UserDTO> login(String document, String password);
  Future<void> logout();
}
