// lib/modules/pond/dtos/device_dto.dart
class DeviceDTO {
  final String id;
  final String name;
  final String type; // 'Aerador', 'Bomba', 'Alimentador', 'Sensor'
  final bool isOn;
  final String? power;
  final int? batteryLevel;
  final DateTime lastActive;
  
  DeviceDTO({
    required this.id,
    required this.name,
    required this.type,
    required this.isOn,
    this.power,
    this.batteryLevel,
    required this.lastActive,
  });
  
  static List<DeviceDTO> mockList() {
    return [
      DeviceDTO(
        id: '1',
        name: 'Aerador Principal',
        type: 'Aerador',
        isOn: true,
        power: '2.5 kW',
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '2',
        name: 'Bomba de Água',
        type: 'Bomba',
        isOn: true,
        power: '5.0 kW',
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '3',
        name: 'Aerador Secundário',
        type: 'Aerador',
        isOn: false,
        power: '2.0 kW',
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      DeviceDTO(
        id: '4',
        name: 'Alimentador',
        type: 'Automático',
        isOn: true,
        power: '0.5 kW',
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '5',
        name: 'Sensor O₂ - Zona A',
        type: 'Sensor',
        isOn: true,
        batteryLevel: 85,
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '6',
        name: 'Sensor O₂ - Zona B',
        type: 'Sensor',
        isOn: true,
        batteryLevel: 72,
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '7',
        name: 'Sensor Temperatura',
        type: 'Sensor',
        isOn: true,
        batteryLevel: 92,
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '8',
        name: 'Sensor Salinidade',
        type: 'Sensor',
        isOn: false,
        batteryLevel: 45,
        lastActive: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}