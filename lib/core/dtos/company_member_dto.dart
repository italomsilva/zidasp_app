import 'package:zidasp_app/core/dtos/company_dto.dart';
import 'package:zidasp_app/core/dtos/user_dto.dart';
import 'package:zidasp_app/core/enums/user_role_enum.dart';
import 'package:zidasp_app/core/models/company_member.dart';

class CompanyMemberDTO {
  final String id;
  final String role;
  final UserDTO? user;
  final CompanyDTO? company;
  final DateTime joinedAt;

  CompanyMemberDTO({
    required this.id,
    required this.role,
    this.user,
    this.company,
    required this.joinedAt,
  });

  CompanyMember toModel() {
    return CompanyMember(
      id: id,
      role: UserRoleEnum.fromString(role),
      user: user?.toModel(),
      company: company?.toModel(),
      joinedAt: joinedAt,
    );
  }

  factory CompanyMemberDTO.fromJson(Map<String, dynamic> json) {
    return CompanyMemberDTO(
      id: json['id']?.toString() ?? '',
      role: json['role']?.toString() ?? 'employee',
      user: json['user'] != null ? UserDTO.fromJson(json['user']) : null,
      company: json['company'] != null
          ? CompanyDTO.fromJson(json['company'])
          : null,
      joinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'user': user, // Assume that UserDTO needs a toJson too for properly mapping it, though omit here for simplicity if not used
      'company': company,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}
