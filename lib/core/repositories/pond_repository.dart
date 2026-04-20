import 'package:zidasp_app/data/mock_data.dart';
import 'package:zidasp_app/core/models/pond.dart';
import '../dtos/pond_dto.dart';

import 'package:zidasp_app/data/datasources/i_pond_datasource.dart';

class PondRepository {
  final IPondDataSource _dataSource;

  PondRepository(this._dataSource);

  Future<PondDTO> getPondDetails(String pondId) async {
    try {
      final pondAPI = await _dataSource.getPondById(pondId);
      
      final mockPond = MockData.ponds.firstWhere(
        (p) => p['id'] == pondId,
        orElse: () => {},
      );

      final Map<String, dynamic> enrichedJSON = {
        ...mockPond,
        ...pondAPI,
      };

      return PondDTO.fromJson(enrichedJSON);
    } catch (e) {
      // Fallback
      final result = MockData.ponds.firstWhere((p) => p['id'] == pondId);
      return PondDTO.fromJson(result);
    }
  }

  Future<void> toggleDevice(String pondId, String deviceId, bool isOn) async {
    try {
      final pond = MockData.ponds.firstWhere((p) => p['id'] == pondId);
      final actuators = pond['actuators'] as List;
      final dev = actuators.firstWhere((d) => d['id'] == deviceId);
      
      final type = dev['type'].toString().toLowerCase().contains('oxygen') || 
                   dev['type'].toString().toLowerCase().contains('aerador') 
                   ? 'oxygen' : 'salinity';
      
      final power = isOn ? 'ON' : 'OFF';

      await _dataSource.toggleActuator(pondId, type, power);

      final pondIndex = MockData.ponds.indexWhere((p) => p['id'] == pondId);
      final deviceIndex = (MockData.ponds[pondIndex]['actuators'] as List).indexWhere((d) => d['id'] == deviceId);
      MockData.ponds[pondIndex]['actuators'][deviceIndex]['active'] = isOn;
      MockData.ponds[pondIndex]['lastUpdate'] = DateTime.now().toIso8601String();

    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSettings(
    String pondId,
    Map<String, dynamic> settings,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<List<PondDTO>> getPondsByCompany(String companyId) async {
    try {
      final pondsAPI = await _dataSource.getPonds();
      
      final companyPonds = pondsAPI.where((p) => p['companyId'] == companyId || (p['company'] != null && p['company']['id'] == companyId)).toList();

      final List<PondDTO> result = [];
      for (var pAPI in companyPonds) {
        final mockPond = MockData.ponds.firstWhere(
          (mp) => mp['id'] == pAPI['id'],
          orElse: () => {},
        );
        result.add(PondDTO.fromJson({...mockPond, ...pAPI}));
      }

      if (result.isEmpty) return _getMockPonds(companyId);

      return result;
    } catch (e) {
      return _getMockPonds(companyId);
    }
  }

  List<PondDTO> _getMockPonds(String companyId) {
    final pondsJson = MockData.ponds
        .where((pond) => pond['companyId'] == companyId)
        .toList();
    return pondsJson.map((pJ) => PondDTO.fromJson(pJ)).toList();
  }

  Future<Pond?> getPondById(String pondId) async {
    try {
      final pondJson = await _dataSource.getPondById(pondId);
      return Pond(
        id: pondJson['id'],
        name: pondJson['name'],
        companyId: pondJson['companyId'] ?? pondJson['company']?['id'] ?? '',
      );
    } catch (e) {
      final List<Map<String, dynamic>> matches = MockData.ponds.where((p) => p['id'] == pondId).toList();
      if (matches.isEmpty) return null;
      final pondMock = matches.first;
      return Pond(id: pondMock['id'], name: pondMock['name'], companyId: pondMock['companyId']);
    }
  }
}
