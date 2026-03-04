import 'package:zidasp_app/core/sesssion/models/company_session.dart';
import 'package:zidasp_app/data/mock_data.dart';

class CompanyRepository {
  Future<List<CompanySession>> getUserCompaniesSession(String userId) async {
    await Future.delayed(Duration(seconds: 5));
    final companiesJson = MockData.companies;
    return companiesJson.map((c) => CompanySession.fromJson(c)).toList();
  }
}
