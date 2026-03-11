class CompanySession {
  final String id;
  final String name;
  final String role; // Novo campo para gerenciar acesso

  CompanySession({required this.id, required this.name, required this.role});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'role': role};
  }

  factory CompanySession.fromJson(Map<String, dynamic> json) {
    return CompanySession(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'employee', // Fallback seguro
    );
  }
}
