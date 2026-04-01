import 'package:dio/dio.dart';
import 'i_pond_datasource.dart';

class PondDataSource implements IPondDataSource {
  final Dio _dio;

  PondDataSource(this._dio);

  @override
  Future<List<dynamic>> getPonds() async {
    final response = await _dio.get('/pond');
    return response.data as List<dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getPondById(String id) async {
    final response = await _dio.get('/pond/$id');
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> createPond(Map<String, dynamic> data) async {
    final response = await _dio.post('/pond', data: data);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> toggleActuator(String pondId, String type, String power) async {
    // Endpoints: /iot/pond/:pondId/oxygen/actuator?power=ON|OFF
    // 'type' deve ser 'oxygen' ou 'salinity' baseado no api_spec.md
    final response = await _dio.post(
      '/iot/pond/$pondId/$type/actuator',
      queryParameters: {'power': power},
    );
    return response.data as Map<String, dynamic>;
  }
}
