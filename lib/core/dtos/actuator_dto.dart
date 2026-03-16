import '../enums/device_type.dart';

class ActuatorDTO {
  final String id;
  final DeviceType type;
  final String name;
  final bool active;
  final String pondId;

  ActuatorDTO({
    required this.id,
    required this.type,
    required this.name,
    required this.active,
    required this.pondId,
  });

  factory ActuatorDTO.fromJson(Map<String, dynamic> json) {
    return ActuatorDTO(
      id: json['id'] ?? '',
      type: DeviceType.fromString(json['type'] ?? ''),
      pondId: json['pondId'] ?? '',
      name: json['name'] ?? '',
      active: json['active'] ?? false,
    );
  }
}
