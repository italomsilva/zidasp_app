import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zidasp_app/core/sesssion/models/company_session.dart';
import 'package:zidasp_app/core/sesssion/models/user_session.dart';

class SessionController {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  SessionController();

  Future<UserSession> saveUser(String id, String name, String token) async {
    final UserSession user = UserSession(
      id: id,
      name: name,
      token: token,
      companies: [],
    );
    await _secureStorage.write(
      key: 'user_session',
      value: jsonEncode(user.toPersistenceJson()),
    );
    return user;
  }

  Future<UserSession?> loadUser() async {
    final userString = await _secureStorage.read(key: 'user_session');
    if (userString == null) {
      return null;
    }

    final userJson = jsonDecode(userString) as Map<String, dynamic>;

    final List<dynamic> companiesRaw = userJson['companies'] ?? [];
    final companies = companiesRaw
        .map((item) => CompanySession.fromJson(item as Map<String, dynamic>))
        .toList();

    return UserSession(
      id: userJson['id'],
      name: userJson['name'],
      token: userJson['token'],
      companies: companies,
    );
  }

  Future<UserSession?> saveCompanies(List<CompanySession> companies) async {
    final userString = await _secureStorage.read(key: 'user_session');
    if (userString == null) {
      return null;
    }

    final userJson = jsonDecode(userString) as Map<String, dynamic>;

    userJson['companies'] = companies.map((c) => c.toJson()).toList();

    await _secureStorage.write(
      key: 'user_session',
      value: jsonEncode(userJson),
    );
    return loadUser();
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'user_session');
  }
}
