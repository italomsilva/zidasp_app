enum SensorType {
  oxygen('Oxygen'),
  salinity('Salinity'),
  temperature('Temperature'),
  ph('PH'),
  transparency('Transparency');

  final String value;
  const SensorType(this.value);

  factory SensorType.fromString(String type) {
    return SensorType.values.firstWhere(
      (e) => e.value.toLowerCase() == type.toLowerCase(),
      orElse: () => SensorType.oxygen,
    );
  }
}
