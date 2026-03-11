import 'package:zidasp_app/core/models/user.dart';

class UserDTO {
  final String id;
  final String name;
  final String email;
  final String document;

  // Dados extras que só existem no DTO
  final String role;
  final int totalPonds;
  final int companiesCount;
  final DateTime joinDate;
  final String token;

  UserDTO({
    required this.id,
    required this.name,
    required this.email,
    required this.document,
    required this.role,
    required this.totalPonds,
    required this.companiesCount,
    required this.joinDate,
    required this.token,
  });

  // Converte DTO para Model (simples)
  User toModel() {
    return User(id: id, name: name, email: email, document: document);
  }

  // Cria DTO a partir de JSON (mock da API)
  // Se você tem isso no DTO:
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'] as String, // OK
      name: json['name'] as String, // OK
      email: json['email'] as String, // OK
      document: json['document'] as String, // OK
      role: json['role'] as String, // OK
      joinDate: json['joinDate'] as DateTime, // PROBLEMA!
      // O json['joinDate'] pode estar vindo como String, não DateTime
      totalPonds: json['totalPonds'] as int, // OK
      companiesCount: json['companiesCount'] as int, // OK
      token: json['token'] as String, // OK
    );
  }
}
