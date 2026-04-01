import 'package:dio/dio.dart';
import 'i_user_datasource.dart';

class UserDataSource implements IUserDataSource {
  final Dio _dio;

  UserDataSource(this._dio);

  @override
  Future<Map<String, dynamic>> getUserById(String id) async {
    final response = await _dio.get('/user/$id');
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> getUsers() async {
    final response = await _dio.get('/user');
    return response.data as List<dynamic>;
  }

  @override
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> data) async {
    final response = await _dio.post('/user', data: data);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> updateUser(String id, Map<String, dynamic> data) async {
    final response = await _dio.patch('/user/$id', data: data);
    return response.data as Map<String, dynamic>;
  }
}
