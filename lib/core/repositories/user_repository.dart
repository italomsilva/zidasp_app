import 'package:zidasp_app/core/enums/user_role_enum.dart';
import 'package:zidasp_app/data/mock_data.dart';
import '../dtos/user_dto.dart';
import '../dtos/company_dto.dart';
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

    // Injeta campos esperados pelo DTO vindos de relatórios (Simulação Server-Side)
    final enrichedJSON = Map<String, dynamic>.from(userJSON);
    enrichedJSON['role'] = UserRoleEnum.admin.value; // default temporario só para o dto nao quebrar
    enrichedJSON['joinDate'] = DateTime.now();
    enrichedJSON['totalPonds'] = 0;
    enrichedJSON['companiesCount'] = 0;

    return UserDTO.fromJson(enrichedJSON);
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
      role: UserRoleEnum.admin,
      totalPonds: 15,
      totalCompanies: 2,
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
        (element) => element['document'] == cleanDocument,
        orElse: () => throw Exception('User not found'),
      );

      // Validação de senha simples para o mock (aceitando qlqr senha >= 6 chars por enquanto, ou podemos impor uma)
      if (password.length < 6) {
        throw Exception('Password constraint');
      }

      final enrichedJSON = Map<String, dynamic>.from(userJSON);
      enrichedJSON['role'] = UserRoleEnum.admin.value; // mock fallback
      enrichedJSON['joinDate'] = DateTime.now();
      enrichedJSON['totalPonds'] = 0;
      enrichedJSON['companiesCount'] = 0;

      final result = UserDTO.fromJson(enrichedJSON);
      return result;
    } catch (e) {
      print(e);
      throw InvalidCredentialsException('CPF ou senha inválidos.');
    }
  }
}
