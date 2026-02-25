// lib/modules/pond/dtos/pond_dto.dart
import 'package:zidasp_app/modules/pond/models/pond.dart';

import 'device_dto.dart';

class PondDTO {
  final String id;
  final String name;
  final String companyId;

  // Dados extras do DTO
  final double oxygen;
  final double temperature;
  final double salinity;
  final double ph;
  final double transparency;
  final int aeratorsOn;
  final int aeratorsTotal;
  final int pumpsOn;
  final int pumpsTotal;
  final bool hasAlert;
  final bool isFavorite;
  final bool isAutomatic;
  final DateTime lastUpdate;
  final List<DeviceDTO> devices;

  PondDTO({
    required this.id,
    required this.name,
    required this.companyId,
    required this.oxygen,
    required this.temperature,
    required this.salinity,
    required this.ph,
    required this.transparency,
    required this.aeratorsOn,
    required this.aeratorsTotal,
    required this.pumpsOn,
    required this.pumpsTotal,
    required this.hasAlert,
    required this.isFavorite,
    required this.isAutomatic,
    required this.lastUpdate,
    required this.devices,
  });

  // Converte para Model (simples)
  Pond toModel() {
    return Pond(id: id, name: name, companyId: companyId);
  }

  static PondDTO mock(String pondId) {
    // Dados diferentes baseados no ID
    final index = int.tryParse(pondId) ?? 1;
    final hasAlert = index == 2; // Viveiro 2 tem alerta
    final isFavorite = index == 1; // Viveiro 1 é favorito

    // Valores simulados
    final oxygenValues = [6.8, 4.2, 7.1, 5.9, 6.2, 6.5];
    final tempValues = [29.0, 30.5, 28.5, 31.2, 29.5, 28.8];
    final salValues = [28.5, 31.2, 27.8, 29.3, 30.1, 28.9];
    final phValues = [7.2, 7.0, 7.5, 7.1, 7.3, 7.4];
    final transValues = [45.0, 35.0, 50.0, 40.0, 42.0, 47.0];
    final aeratorsOnValues = [3, 1, 2, 2, 3, 2];
    final pumpsOnValues = [2, 1, 2, 2, 2, 3];

    final safeIndex = (index - 1) % oxygenValues.length;

    return PondDTO(
      id: pondId,
      name:
          'Viveiro ${index == 1
              ? 'Principal'
              : index == 2
              ? 'Norte'
              : index == 3
              ? 'Sul'
              : index == 4
              ? 'Leste'
              : index == 5
              ? 'Oeste'
              : 'Central'}',
      companyId: index <= 3
          ? '1'
          : index <= 5
          ? '2'
          : '3',
      oxygen: oxygenValues[safeIndex],
      temperature: tempValues[safeIndex],
      salinity: salValues[safeIndex],
      ph: phValues[safeIndex],
      transparency: transValues[safeIndex],
      aeratorsOn: aeratorsOnValues[safeIndex],
      aeratorsTotal: 3,
      pumpsOn: pumpsOnValues[safeIndex],
      pumpsTotal: 3,
      hasAlert: hasAlert,
      isFavorite: isFavorite,
      isAutomatic: true,
      lastUpdate: DateTime.now().subtract(
        Duration(minutes: [5, 2, 15, 30, 10, 8][safeIndex]),
      ),
      devices: _mockDevices(pondId),
    );
  }

  static List<DeviceDTO> _mockDevices(String pondId) {
    return [
      DeviceDTO(
        id: '${pondId}_a1',
        name: 'Aerador Principal',
        type: 'Aerador',
        isOn: true,
        power: '2.5 kW',
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '${pondId}_a2',
        name: 'Aerador Secundário',
        type: 'Aerador',
        isOn: false,
        power: '2.0 kW',
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      DeviceDTO(
        id: '${pondId}_b1',
        name: 'Bomba de Água',
        type: 'Bomba',
        isOn: true,
        power: '5.0 kW',
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '${pondId}_s1',
        name: 'Sensor O₂',
        type: 'Sensor',
        isOn: true,
        batteryLevel: 85,
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '${pondId}_s2',
        name: 'Sensor Temperatura',
        type: 'Sensor',
        isOn: true,
        batteryLevel: 92,
        lastActive: DateTime.now(),
      ),
    ];
  }
}
