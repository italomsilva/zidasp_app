class ActuatorDTO {
  final String id;
  final String type;
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
      type: json['type'] ?? '',
      pondId: json['pondId'] ?? '',
      name: json['name'] ?? '',
      active: json['active'] ?? false,
    );
  }
}
