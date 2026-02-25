// lib/modules/pond/models/pond_model.dart
class Pond {
  final String id;
  final String name;
  final String companyId;
  
  Pond({
    required this.id,
    required this.name,
    required this.companyId,
  });
  
  // Se quiser criar a partir de JSON (quando API estiver pronta)
  factory Pond.fromJson(Map<String, dynamic> json) {
    return Pond(
      id: json['id'],
      name: json['name'],
      companyId: json['companyId'],
    );
  }
}