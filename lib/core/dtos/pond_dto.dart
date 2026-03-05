import 'package:zidasp_app/core/dtos/actuator_dto.dart';
import 'package:zidasp_app/core/dtos/sensor_dto.dart';
import 'package:zidasp_app/core/models/pond.dart';
import 'package:zidasp_app/data/mock_data.dart';

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
  final List<SensorDTO> sensors;
  final List<ActuatorDTO> actuators;

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
    required this.sensors,
    required this.actuators,
  });

  // Converte para Model (simples)
  Pond toModel() {
    return Pond(id: id, name: name, companyId: companyId);
  }

factory PondDTO.fromJson(Map<String, dynamic> json) {
  return PondDTO(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    companyId: json['companyId'] ?? '',
    
    // Conversão segura para double
    oxygen: json['oxygen'] is String 
        ? double.parse(json['oxygen']) 
        : (json['oxygen'] ?? 0.0).toDouble(),
    temperature: json['temperature'] is String 
        ? double.parse(json['temperature']) 
        : (json['temperature'] ?? 0.0).toDouble(),
    salinity: json['salinity'] is String 
        ? double.parse(json['salinity']) 
        : (json['salinity'] ?? 0.0).toDouble(),
    ph: json['ph'] is String 
        ? double.parse(json['ph']) 
        : (json['ph'] ?? 0.0).toDouble(),
    transparency: json['transparency'] is String 
        ? double.parse(json['transparency']) 
        : (json['transparency'] ?? 0.0).toDouble(),
    
    aeratorsOn: json['aeratorsOn'] ?? 0,
    aeratorsTotal: json['aeratorsTotal'] ?? 0,
    pumpsOn: json['pumpsOn'] ?? 0,
    pumpsTotal: json['pumpsTotal'] ?? 0,
    
    hasAlert: json['hasAlert'] ?? false,
    isFavorite: json['isFavorite'] ?? false,
    isAutomatic: json['isAutomatic'] ?? false,
    
    // Tratamento especial para DateTime
    lastUpdate: json['lastUpdate'] is DateTime 
        ? json['lastUpdate']  // ← Se já for DateTime, usa direto
        : (json['lastUpdate'] != null 
            ? DateTime.parse(json['lastUpdate'].toString()) 
            : DateTime.now()),
        
    devices: _mockDevices(json['id']),
    sensors: MockData.sensors.map((e) => SensorDTO.fromJson(e)).toList(),
    actuators: MockData.actuators.map((e) => ActuatorDTO.fromJson(e)).toList(),
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
