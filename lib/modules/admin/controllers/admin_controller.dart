import 'package:signals/signals.dart';
import '../../../data/mock_data.dart';
import '../../../core/enums/sensor_type.dart';
import '../../../core/enums/device_type.dart';

class AdminController {
  final isLoading = signal<bool>(false);
  final error = signal<String?>(null);
  final success = signal<String?>(null);

  Future<void> createPond({
    required String name,
    required String companyId,
  }) async {
    isLoading.value = true;
    error.value = null;
    success.value = null;

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final id = (MockData.ponds.length + 1).toString();
      final newPond = {
        'id': id,
        'name': name,
        'companyId': companyId,
        'oxygen': 0.0,
        'temperature': 0.0,
        'salinity': 0.0,
        'ph': 0.0,
        'transparency': 0.0,
        'aeratorsOn': 0,
        'aeratorsTotal': 0,
        'pumpsOn': 0,
        'pumpsTotal': 0,
        'hasAlert': false,
        'isFavorite': false,
        'isAutomatic': false,
        'lastUpdate': DateTime.now().toIso8601String(),
        'devices': [],
        'sensors': [],
        'actuators': [],
      };
      
      MockData.ponds.add(newPond);
      success.value = 'Viveiro "$name" criado com sucesso!';
    } catch (e) {
      error.value = 'Erro ao criar viveiro: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createSensor({
    required String pondId,
    required SensorType type,
    required String unity,
  }) async {
    isLoading.value = true;
    error.value = null;
    success.value = null;

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final pondIndex = MockData.ponds.indexWhere((p) => p['id'] == pondId);
      if (pondIndex == -1) throw Exception('Viveiro não encontrado');

      final sensorsList = MockData.ponds[pondIndex]['sensors'] as List;
      final id = 's${sensorsList.length + 1}';
      
      final newSensor = {
        'id': id,
        'type': type.value,
        'value': 0.0,
        'unity': unity,
      };
      
      sensorsList.add(newSensor);
      success.value = 'Sensor de ${type.value} criado com sucesso!';
    } catch (e) {
      error.value = 'Erro ao criar sensor: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createActuator({
    required String pondId,
    required String name,
    required DeviceType type,
  }) async {
    isLoading.value = true;
    error.value = null;
    success.value = null;

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final pondIndex = MockData.ponds.indexWhere((p) => p['id'] == pondId);
      if (pondIndex == -1) throw Exception('Viveiro não encontrado');

      final actuatorsList = MockData.ponds[pondIndex]['actuators'] as List;
      final id = 'a${actuatorsList.length + 1}';
      
      final newActuator = {
        'id': id,
        'type': type.value,
        'name': name,
        'active': false,
      };
      
      actuatorsList.add(newActuator);
      
      // Update totals in pond
      if (type == DeviceType.aerator) {
        MockData.ponds[pondIndex]['aeratorsTotal'] = (MockData.ponds[pondIndex]['aeratorsTotal'] ?? 0) + 1;
      } else if (type == DeviceType.pump) {
        MockData.ponds[pondIndex]['pumpsTotal'] = (MockData.ponds[pondIndex]['pumpsTotal'] ?? 0) + 1;
      }

      success.value = 'Atuador "$name" criado com sucesso!';
    } catch (e) {
      error.value = 'Erro ao criar atuador: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
