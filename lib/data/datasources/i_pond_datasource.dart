abstract class IPondDataSource {
  Future<List<dynamic>> getPonds();
  Future<Map<String, dynamic>> getPondById(String id);
  Future<Map<String, dynamic>> createPond(Map<String, dynamic> data);
  Future<Map<String, dynamic>> toggleActuator(String pondId, String type, String power);
}
