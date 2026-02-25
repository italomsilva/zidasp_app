// lib/modules/auth/repositories/user_repository.dart
import '../dtos/user_dto.dart';
import '../dtos/company_dto.dart';

class UserRepository {
  // Retorna DTO com dados completos
  Future<UserDTO> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserDTO.mock();
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
}