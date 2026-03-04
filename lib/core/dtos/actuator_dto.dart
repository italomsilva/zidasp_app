class ActuatorDTO {
  final String name;
  final bool active;

  ActuatorDTO({required this.name, required this.active});

  factory ActuatorDTO.fromJson(Map<String, dynamic> json) {
    return ActuatorDTO(
      name: json['name'] ?? '',
      active: json['active'] ?? false,
    );
  }
}
