class Company {
  final String id;
  final String name;
  final String document;

  Company({
    required this.id, 
    required this.name, 
    required this.document,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      // Garantimos que, se o valor for nulo, ele assuma uma String vazia
      id: json['id']?.toString() ?? '', 
      name: json['name']?.toString() ?? '',
      document: json['document']?.toString() ?? '',
    );
  }
}