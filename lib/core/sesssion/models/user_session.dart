class UserSession {
  final String id;
  final String name;
  final String token;
  
  UserSession({
    required this.id,
    required this.name,
    required this.token,
  });
  
  Map<String, dynamic> toPersistenceJson() {
    return {
      'id': id,
      'name': name,
      'token': token,
    };
  }
}
