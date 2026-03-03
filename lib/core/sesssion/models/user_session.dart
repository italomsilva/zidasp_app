import 'package:zidasp_app/core/sesssion/models/company_session.dart';

class UserSession {
  final String id;
  final String name;
  final String token;
  final List<CompanySession> companies;
  
  UserSession({
    required this.id,
    required this.name,
    required this.token,
    required this.companies,
  });
  
  Map<String, dynamic> toPersistenceJson() {
    return {
      'id': id,
      'name': name,
      'token': token,
      'companies': companies
    };
  }
}
