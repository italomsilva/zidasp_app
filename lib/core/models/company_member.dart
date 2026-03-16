import 'package:zidasp_app/core/enums/user_role_enum.dart';
import 'package:zidasp_app/core/models/company.dart';
import 'package:zidasp_app/core/models/user.dart';

class CompanyMember {
  final String id;
  final UserRoleEnum role;
  final User? user;
  final Company? company;
  final DateTime? joinedAt;

  CompanyMember({
    required this.id,
    required this.role,
    this.user,
    this.company,
    this.joinedAt,
  });
}
