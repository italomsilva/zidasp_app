import 'package:zidasp_app/core/models/user.dart';

class UserDTO {
  final String id;
  final String name;
  final String email;
  final String document;
  final int totalCompanies;
  final int totalPonds;
  final String role;
  final DateTime joinDate;
  final String token;

  UserDTO({
    required this.id,
    required this.name,
    required this.email,
    required this.document,
    required this.totalCompanies,
    required this.totalPonds,
    required this.role,
    required this.joinDate,
    required this.token,
  });

  // Converte DTO para Model (simples)
  User toModel() {
    return User(id: id, name: name, email: email, document: document);
  }

  // Cria DTO a partir de JSON (mock da API)
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      document: json['document']?.toString() ?? '',
      joinDate: json['joinDate'] is DateTime 
          ? json['joinDate'] 
          : DateTime.tryParse(json['joinDate']?.toString() ?? '') ?? DateTime.now(),
      totalCompanies: (json['totalCompanies'] ?? json['companiesCount'] ?? 0) as int,
      totalPonds: (json['totalPonds'] ?? 0) as int,
      role: json['role']?.toString() ?? 'user',
      token: json['token']?.toString() ?? '',
    );
  }
}
