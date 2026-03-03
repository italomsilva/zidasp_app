import 'package:zidasp_app/data/mock_data.dart';
import 'package:zidasp_app/core/models/pond.dart';
import '../../modules/pond/dtos/pond_dto.dart';

class PondRepository {
  // Busca detalhes de um viveiro
  Future<PondDTO> getPondDetails(String pondId) async {
    print('📡 Repository: getPondDetails($pondId)');
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      print('🔍 Buscando pond $pondId no MockData...');
      final result = MockData.ponds.firstWhere((p) => p['id'] == pondId);
      print('✅ Pond encontrado: ${result['name']}');
      
      final dto = PondDTO.fromJson(result);
      print('✅ DTO criado com sucesso');
      
      return dto;
    } catch (e) {
      print('❌ Erro ao buscar pond $pondId: $e');
      print('📊 MockData.ponds disponíveis: ${MockData.ponds.map((p) => p['id']).toList()}');
      rethrow;
    }
  }

  // Atualiza status de um dispositivo
  Future<void> toggleDevice(String pondId, String deviceId, bool isOn) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Device $deviceId do viveiro $pondId alterado para $isOn');
  }

  // Atualiza configurações do viveiro
  Future<void> updateSettings(
    String pondId,
    Map<String, dynamic> settings,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('Configurações do viveiro $pondId atualizadas: $settings');
  }

  // Busca viveiros por empresa
  Future<List<Pond>> getPondsByCompany(String companyId) async {
    print('📡 Repository: getPondsByCompany($companyId)');
    
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      print('🔍 Filtrando ponds da empresa $companyId...');
      
      // Log de todos os ponds disponíveis
      print('📊 Todos os ponds disponíveis:');
      for (var pond in MockData.ponds) {
        print('   - ID: ${pond['id']}, Empresa: ${pond['companyId']}, Nome: ${pond['name']}');
      }

      // Filtra os viveiros da empresa
      final pondsJson = MockData.ponds
          .where((pond) => pond['companyId'] == companyId)
          .toList();
      
      print('✅ Ponds encontrados: ${pondsJson.length}');
      
      final result = pondsJson
          .map(
            (pJ) => Pond(
              id: pJ['id'], 
              name: pJ['name'], 
              companyId: pJ['companyId']
            ),
          )
          .toList();
      
      print('📋 IDs dos ponds retornados: ${result.map((p) => p.id).toList()}');
      
      return result;
      
    } catch (e) {
      print('❌ Erro em getPondsByCompany: $e');
      rethrow;
    }
  }

  // Busca um viveiro específico
  Future<Pond?> getPondById(String pondId) async {
    print('📡 Repository: getPondById($pondId)');
    
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final pondJson = MockData.ponds.firstWhere(
        (pond) => pond['id'] == pondId,
      );
      
      print('✅ Pond encontrado: ${pondJson['name']}');
      
      return Pond(
        id: pondJson['id'],
        name: pondJson['name'],
        companyId: pondJson['companyId'],
      );
    } catch (e) {
      print('❌ Pond não encontrado: $pondId');
      return null;
    }
  }
}