// lib/modules/pond/repositories/pond_repository.dart
import 'package:zidasp_app/modules/pond/models/pond.dart';

import '../dtos/pond_dto.dart';

class PondRepository {
  // Busca detalhes de um viveiro
  Future<PondDTO> getPondDetails(String pondId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return PondDTO.mock(pondId);
  }
  
  // Atualiza status de um dispositivo
  Future<void> toggleDevice(String pondId, String deviceId, bool isOn) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Device $deviceId do viveiro $pondId alterado para $isOn');
  }
  
  // Atualiza configurações do viveiro
  Future<void> updateSettings(String pondId, Map<String, dynamic> settings) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('Configurações do viveiro $pondId atualizadas: $settings');
  }

    final List<Pond> _mockPonds = [
    Pond(id: '1', name: 'Viveiro Principal', companyId: '1'),
    Pond(id: '2', name: 'Viveiro Norte', companyId: '1'),
    Pond(id: '3', name: 'Viveiro Sul', companyId: '1'),
    Pond(id: '4', name: 'Viveiro Leste', companyId: '2'),
    Pond(id: '5', name: 'Viveiro Oeste', companyId: '2'),
    Pond(id: '6', name: 'Viveiro Central', companyId: '3'),
  ];
  
  // Busca viveiros por empresa
  Future<List<Pond>> getPondsByCompany(String companyId) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Filtra os viveiros da empresa
    return _mockPonds.where((pond) => pond.companyId == companyId).toList();
  }
  
  // Busca um viveiro específico
  Future<Pond?> getPondById(String pondId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      return _mockPonds.firstWhere((pond) => pond.id == pondId);
    } catch (e) {
      return null;
    }
  }

}