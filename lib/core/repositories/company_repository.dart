import 'package:zidasp_app/core/sesssion/models/company_session.dart';
import 'package:zidasp_app/data/mock_data.dart';

import 'package:zidasp_app/data/datasources/i_company_datasource.dart';

class CompanyRepository {
  final ICompanyDataSource _dataSource;

  CompanyRepository(this._dataSource);

  Future<List<CompanySession>> getUserCompaniesSession(String userId) async {
    try {
      final companiesAPI = await _dataSource.getCompanies();
      
      final List<CompanySession> result = [];

      for (var compData in companiesAPI) {
        // Busca a relação no MockData para obter o nível de acesso (role)
        final rel = MockData.userCompanies.firstWhere(
          (uc) => uc['userId'] == userId && uc['companyId'] == compData['id'],
          orElse: () => {'role': 'viewer'},
        );

        result.add(
          CompanySession(
            id: compData['id'],
            name: compData['name'],
            role: rel['role'],
          ),
        );
      }

      // Se a API retornar vazio, podemos manter o mock como fallback para não quebrar a navegação
      if (result.isEmpty) {
        return _getMockSession(userId);
      }

      return result;
    } catch (e) {
      return _getMockSession(userId);
    }
  }

  Future<List<CompanySession>> _getMockSession(String userId) async {
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
