import 'package:zidasp_app/core/sesssion/models/company_session.dart';
import 'package:zidasp_app/data/mock_data.dart';

class CompanyRepository {
  Future<List<CompanySession>> getUserCompaniesSession(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Filtra as relações do usuário
    final userRels = MockData.userCompanies
        .where((uc) => uc['userId'] == userId)
        .toList();

    final List<CompanySession> result = [];

    for (var rel in userRels) {
      final compData = MockData.companies.firstWhere(
        (c) => c['id'] == rel['companyId'],
        orElse: () => {},
      );

      if (compData.isNotEmpty) {
        result.add(
          CompanySession(
            id: compData['id'],
            name: compData['name'],
            role: rel['role'],
          ),
        );
      }
    }

    return result;
  }
}
