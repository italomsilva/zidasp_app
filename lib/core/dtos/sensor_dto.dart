import '../enums/sensor_type.dart';

class SensorDTO {
  final String id;
  final SensorType type;
  final double value;
  final String unity;

  SensorDTO({
    required this.id,
    required this.type,
    required this.value,
    required this.unity,
  });

  factory SensorDTO.fromJson(Map<String, dynamic> json) {
    return SensorDTO(
      id: json['id'] ?? '',
      type: SensorType.fromString(json['type'] ?? ''),
      value: json['value'] is String
          ? double.parse(json['value'])
          : (json['value'] ?? 0.0).toDouble(),
      unity: json['unity'] ?? '',
    );
  }
}