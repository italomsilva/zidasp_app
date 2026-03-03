class CompanySession {
  final String id;
  final String name;

  CompanySession({
    required this.id,
    required this.name,
  });

  // Alterado para toJson para manter o padrão usado no SessionController
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory CompanySession.fromJson(Map<String, dynamic> json) {
    return CompanySession(
      // Uso de null-coalescing para evitar erros de tipo se o JSON vier incompleto
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}