class ActuatorDTO {
  final String type;
  final String name;
  final bool active;
  final String pondId;

  ActuatorDTO({required this.type, required this.name, required this.active, required this.pondId});

  factory ActuatorDTO.fromJson(Map<String, dynamic> json) {
    return ActuatorDTO(
      type: json['type'] ?? '',
      pondId: json['pondId'] ?? '',
      name: json['name'] ?? '',
      active: json['active'] ?? false,
    );
  }
}
