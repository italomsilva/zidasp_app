// lib/modules/auth/dtos/user_dto.dart
import 'package:zidasp_app/modules/auth/models/user.dart';

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
    return User(
      id: id,
      name: name,
      email: email,
      document: document,
    );
  }
  
  // Cria DTO a partir de JSON (mock da API)
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      document: json['document'],
      role: json['role'],
      totalPonds: json['totalPonds'],
      companiesCount: json['companiesCount'],
      joinDate: DateTime.parse(json['joinDate']),
      token: json['token'],
    );
  }
  
  // Para mock
  static UserDTO mock() {
    return UserDTO(
      id: '1',
      name: 'Carlos Silva',
      email: 'carlos@zidasp.com',
      document: '123.456.789-00',
      role: 'owner',
      totalPonds: 15,
      companiesCount: 2,
      joinDate: DateTime(2023, 1, 15),
      token: 'mock_token_123',
    );
  }
}