import 'package:zidasp_app/data/mock_data.dart';
import 'package:zidasp_app/core/models/pond.dart';
import '../dtos/pond_dto.dart';

class PondRepository {
  // Busca detalhes de um viveiro
  Future<PondDTO> getPondDetails(String pondId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final result = MockData.ponds.firstWhere((p) => p['id'] == pondId);
      final dto = PondDTO.fromJson(result);
      return dto;
    } catch (e) {
      rethrow;
    }
  }

  // Atualiza status de um dispositivo
  Future<void> toggleDevice(String pondId, String deviceId, bool isOn) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Atualiza configurações do viveiro
  Future<void> updateSettings(
    String pondId,
    Map<String, dynamic> settings,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Busca viveiros por empresa
  Future<List<PondDTO>> getPondsByCompany(String companyId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      for (var pond in MockData.ponds) {}

      // Filtra os viveiros da empresa
      final pondsJson = MockData.ponds
          .where((pond) => pond['companyId'] == companyId)
          .toList();

      final result = pondsJson
          .map(
            (pJ) => PondDTO.fromJson(pJ)
          )
          .toList();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Busca um viveiro específico
  Future<Pond?> getPondById(String pondId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final pondJson = MockData.ponds.firstWhere(
        (pond) => pond['id'] == pondId,
      );

      return Pond(
        id: pondJson['id'],
        name: pondJson['name'],
        companyId: pondJson['companyId'],
      );
    } catch (e) {
      return null;
    }
  }
}
