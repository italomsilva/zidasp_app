import 'package:zidasp_app/core/enums/user_role_enum.dart';
import 'package:zidasp_app/data/mock_data.dart';
import '../dtos/user_dto.dart';
import '../dtos/company_dto.dart';
import '../exceptions/auth_exception.dart';
import 'i_user_repository.dart';

import 'package:zidasp_app/data/datasources/i_user_datasource.dart';

class UserRepository implements IUserRepository {
  final IUserDataSource _dataSource;

  UserRepository(this._dataSource);

  // Retorna DTO com dados completos - Enriquecimento (API + Mock) para compatibilidade
  @override
  Future<UserDTO> getUserById(String id) async {
    try {
      final userAPI = await _dataSource.getUserById(id);
      
      // Busca no MockData para enriquecer os campos ausentes na API
      final mockUser = MockData.users.firstWhere(
        (u) => u['id'] == id,
        orElse: () => {},
      );

      final Map<String, dynamic> enrichedJSON = {
        ...mockUser, // Dados mockados (metrics, role, etc)
        ...userAPI,  // Dados reais da API (sobrescreve o que vier)
      };

      // Garantir campos padrão se não existirem
      enrichedJSON['role'] ??= UserRoleEnum.employee.value;
      enrichedJSON['joinDate'] ??= DateTime.now();
      enrichedJSON['totalPonds'] ??= 0;
      enrichedJSON['companiesCount'] ??= 0;

      return UserDTO.fromJson(enrichedJSON);
    } catch (e) {
      // Fallback para mock se a API falhar ou não encontrar
      final mockUser = MockData.users.firstWhere(
        (u) => u['id'] == id,
        orElse: () => throw Exception('User not found'),
      );
      return UserDTO.fromJson(mockUser);
    }
  }

  // Retorna lista de DTOs das empresas enriquecida com dados do Mock
  @override
  Future<List<CompanyDTO>> getUserCompanies(String userId) async {
    // Busca as relações usuário-empresa no MockData
    final userRelations = MockData.userCompanies.where((uc) => uc['userId'] == userId).toList();
    
    final List<CompanyDTO> dtos = [];

    for (var relation in userRelations) {
      final companyId = relation['companyId'];
      final roleStr = relation['role'] as String;
      
      // Busca os dados da empresa
      final companyMap = MockData.companies.firstWhere((c) => c['id'] == companyId, orElse: () => {});
      if (companyMap.isEmpty) continue;

      // Calcula métricas da empresa
      final companyPonds = MockData.ponds.where((p) => p['companyId'] == companyId).toList();
      final totalPonds = companyPonds.length;
      // Simulação: viveiros ativos são aqueles que não têm alerta grave (exemplo)
      final activePonds = companyPonds.where((p) => p['hasAlert'] == false).length;

      dtos.add(CompanyDTO(
        id: companyId,
        name: companyMap['name'],
        document: companyMap['document'],
        totalPonds: totalPonds,
        activePonds: activePonds,
        userRole: UserRoleEnum.fromString(roleStr),
      ));
    }

    return dtos;
  }

  // Atualizar perfil (recebe model, retorna DTO)
  @override
  Future<UserDTO> updateProfile({
    required String name,
    required String email,
    required String document,
  }) async {
    // Obtém o ID do usuário (simulação simplificada, em prod viria da Sessão)
    const userId = 'uuid-user'; 
    
    final updatedData = await _dataSource.updateUser(userId, {
      'name': name,
      'email': email,
      'document': document,
    });

    return UserDTO.fromJson({
      'role': UserRoleEnum.admin.value,
      'totalPonds': 0,
      'companiesCount': 0,
      'joinDate': DateTime.now(),
      ...updatedData,
    });
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<UserDTO> login(String document, String password) async {
    // Simulação de delay de rede
    await Future.delayed(const Duration(seconds: 1));

    try {
      final cleanDocument = document.replaceAll(RegExp(r'[^0-9]'), '');
      
      // Busca no MockData diretamente conforme solicitado
      final userJSON = MockData.users.firstWhere(
        (u) => u['document'] == cleanDocument,
        orElse: () => throw InvalidCredentialsException('Usuário não encontrado (Mock).'),
      );

      // Validação de senha simples
      if (password.length < 6) {
        throw InvalidCredentialsException('Senha muito curta.');
      }

      final enrichedJSON = {
        'role': UserRoleEnum.admin.value,
        'joinDate': DateTime.now(),
        'totalPonds': 0,
        'companiesCount': 0,
        'token': 'mock_token_${userJSON['id']}',
        ...userJSON,
      };

      return UserDTO.fromJson(enrichedJSON);
    } catch (e) {
      if (e is InvalidCredentialsException) rethrow;
      throw InvalidCredentialsException('Erro ao realizar login mockado.');
    }
  }
}
