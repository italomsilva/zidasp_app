import 'package:zidasp_app/data/mock_data.dart';
import '../../modules/auth/dtos/user_dto.dart';
import '../../modules/auth/dtos/company_dto.dart';
import '../exceptions/auth_exception.dart';
import 'i_user_repository.dart';

class UserRepository implements IUserRepository {
  // Retorna DTO com dados completos do MockData
  Future<UserDTO> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final userJSON = MockData.users.firstWhere(
      (u) => u['id'] == id,
      orElse: () => throw Exception('User not found'),
    );
    return UserDTO.fromJson(userJSON);
  }

  // Retorna lista de DTOs das empresas
  Future<List<CompanyDTO>> getUserCompanies() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return CompanyDTO.mockList();
  }

  // Atualizar perfil (recebe model, retorna DTO)
  Future<UserDTO> updateProfile({
    required String name,
    required String email,
    required String document,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock - retorna DTO atualizado
    return UserDTO(
      id: '1',
      name: name,
      email: email,
      document: document,
      role: 'owner',
      totalPonds: 15,
      companiesCount: 2,
      joinDate: DateTime(2023, 1, 15),
      token: 'mock_token_123',
    );
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<UserDTO> login(String document, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      // Remover a formatação do CPF para comparar com o banco de dados
      final cleanDocument = document.replaceAll(RegExp(r'[^0-9]'), '');

      final userJSON = MockData.users.firstWhere(
        (u) => u['document'] == cleanDocument,
        orElse: () => throw Exception('User not found'),
      );

      // Validação de senha simples para o mock (aceitando qlqr senha >= 6 chars por enquanto, ou podemos impor uma)
      if (password.length < 6) {
        throw Exception('Password constraint');
      }

      final result = UserDTO.fromJson(userJSON);
      return result;
    } catch (e) {
      throw InvalidCredentialsException('CPF ou senha inválidos.');
    }
  }
}
