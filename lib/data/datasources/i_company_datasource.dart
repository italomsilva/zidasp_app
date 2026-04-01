abstract class ICompanyDataSource {
  Future<List<dynamic>> getCompanies();
  Future<Map<String, dynamic>> getCompanyById(String id);
  Future<Map<String, dynamic>> createCompany(Map<String, dynamic> data);
}
