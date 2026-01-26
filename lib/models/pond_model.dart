
// lib/models/pond_model.dart
class Pond {
  final String id;
  final String name;
  final String companyId;
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
  
  Pond({
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
  });
}

