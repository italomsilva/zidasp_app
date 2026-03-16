enum DeviceType {
  aerator('Aerador'),
  pump('Bomba'),
  feeder('Alimentador'),
  sensor('Sensor'),
  automatic('Automático');

  final String value;
  const DeviceType(this.value);

  factory DeviceType.fromString(String type) {
    return DeviceType.values.firstWhere(
      (e) => e.value.toLowerCase() == type.toLowerCase(),
      orElse: () => DeviceType.sensor,
    );
  }
}
