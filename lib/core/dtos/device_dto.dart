import '../enums/device_type.dart';

class DeviceDTO {
  final String id;
  final String name;
  final DeviceType type; // 'Aerador', 'Bomba', 'Alimentador', 'Sensor'
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

  factory DeviceDTO.fromJson(Map<String, dynamic> json) {
    return DeviceDTO(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: DeviceType.fromString(json['type']?.toString() ?? ''),
      isOn: json['status'] ?? json['isOn'] ?? false,
      power: json['power']?.toString(),
      batteryLevel: json['batteryLevel'] ?? (json['battery'] != null ? int.tryParse(json['battery'].toString().replaceAll('%', '')) : null),
      lastActive: json['lastActive'] != null 
          ? DateTime.parse(json['lastActive'].toString()) 
          : DateTime.now(),
    );
  }
  
  static List<DeviceDTO> mockList() {
    return [
      DeviceDTO(
        id: '1',
        name: 'Aerador Principal',
        type: DeviceType.aerator,
        isOn: true,
        power: '2.5 kW',
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '2',
        name: 'Bomba de Água',
        type: DeviceType.pump,
        isOn: true,
        power: '5.0 kW',
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '3',
        name: 'Aerador Secundário',
        type: DeviceType.aerator,
        isOn: false,
        power: '2.0 kW',
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      DeviceDTO(
        id: '4',
        name: 'Alimentador',
        type: DeviceType.automatic,
        isOn: true,
        power: '0.5 kW',
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '5',
        name: 'Sensor O₂ - Zona A',
        type: DeviceType.sensor,
        isOn: true,
        batteryLevel: 85,
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '6',
        name: 'Sensor O₂ - Zona B',
        type: DeviceType.sensor,
        isOn: true,
        batteryLevel: 72,
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '7',
        name: 'Sensor Temperatura',
        type: DeviceType.sensor,
        isOn: true,
        batteryLevel: 92,
        lastActive: DateTime.now(),
      ),
      DeviceDTO(
        id: '8',
        name: 'Sensor Salinidade',
        type: DeviceType.sensor,
        isOn: false,
        batteryLevel: 45,
        lastActive: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}