abstract class IUserDataSource {
  Future<Map<String, dynamic>> getUserById(String id);
  Future<List<dynamic>> getUsers();
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> data);
  Future<Map<String, dynamic>> updateUser(String id, Map<String, dynamic> data);
}
