import 'package:dio/dio.dart';
import 'i_company_datasource.dart';

class CompanyDataSource implements ICompanyDataSource {
  final Dio _dio;

  CompanyDataSource(this._dio);

  @override
  Future<List<dynamic>> getCompanies() async {
    final response = await _dio.get('/company');
    return response.data as List<dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getCompanyById(String id) async {
    final response = await _dio.get('/company/$id');
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> createCompany(Map<String, dynamic> data) async {
    final response = await _dio.post('/company', data: data);
    return response.data as Map<String, dynamic>;
  }
}
