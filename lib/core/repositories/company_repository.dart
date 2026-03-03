import 'package:zidasp_app/core/models/company.dart';
import 'package:zidasp_app/data/mock_data.dart';

class CompanyRepository {
  Future<List<Company>> getUserCompanies(String userId) async {
    await Future.delayed(Duration(seconds: 3));
    final companiesJson = MockData.companies;
    return companiesJson.map((c) => Company.fromJson(c)).toList();
  }
}
