import 'package:zidasp_app/core/models/company.dart';
import 'package:zidasp_app/core/enums/user_role_enum.dart';


class CompanyDTO {
  final String id;
  final String name;
  final String document;
  final int totalPonds;
  final int activePonds;
  final UserRoleEnum userRole;
  
  CompanyDTO({
    required this.id,
    required this.name,
    required this.document,
    required this.totalPonds,
    required this.activePonds,
    required this.userRole,
  });
  
  // Converte para Model (se tiver um Company model simples)
  Company toModel() {
    return Company(
      id: id,
      name: name,
      document: document,
    );
  }
  
  factory CompanyDTO.fromJson(Map<String, dynamic> json) {
    return CompanyDTO(
      id: json['id'],
      name: json['name'],
      document: json['document'],
      totalPonds: json['totalPonds'],
      activePonds: json['activePonds'],
      userRole: UserRoleEnum.fromString(json['userRole'] ?? ''),
    );
  }
  
  static List<CompanyDTO> mockList() {
    return [
      CompanyDTO(
        id: '1',
        name: 'Camarão do Vale',
        document: '12.345.678/0001-90',
        totalPonds: 8,
        activePonds: 6,
        userRole: UserRoleEnum.admin, // mock fallback
      ),
      CompanyDTO(
        id: '2',
        name: 'Pescados Nordeste',
        document: '98.765.432/0001-10',
        totalPonds: 5,
        activePonds: 4,
        userRole: UserRoleEnum.admin,
      ),
    ];
  }
}