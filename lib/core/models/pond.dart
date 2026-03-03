class Pond {
  final String id;
  final String name;
  final String companyId;
  
  Pond({
    required this.id,
    required this.name,
    required this.companyId,
  });
  
  factory Pond.fromJson(Map<String, dynamic> json) {
    return Pond(
      id: json['id'],
      name: json['name'],
      companyId: json['companyId'],
    );
  }
}