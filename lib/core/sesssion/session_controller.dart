import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zidasp_app/core/sesssion/models/company_session.dart';
import 'package:zidasp_app/core/sesssion/models/user_session.dart';

class SessionController {
  final SharedPreferences _prefs;
  SessionController(this._prefs);

  Future<UserSession> saveUser(String id, String name, String token) async {
    final UserSession user = UserSession(
      id: id,
      name: name,
      token: token,
      companies: [],
    );
    await _prefs.setString(
      'user_session',
      jsonEncode(user.toPersistenceJson()),
    );
    return user;
  }

  Future<UserSession?> loadUser() async {
    final userString = _prefs.getString('user_session'); // getString não é Future
    if (userString == null) {
      return null;
    }
    
    final userJson = jsonDecode(userString) as Map<String, dynamic>;

    // CORREÇÃO: Mapeando a lista dinâmica para List<CompanySession>
    final List<dynamic> companiesRaw = userJson['companies'] ?? [];
    final companies = companiesRaw
        .map((item) => CompanySession.fromJson(item as Map<String, dynamic>))
        .toList();

    return UserSession(
      id: userJson['id'],
      name: userJson['name'],
      token: userJson['token'],
      companies: companies, // Agora o tipo List<CompanySession> está correto
    );
  }

  Future<UserSession?> saveCompanies(List<CompanySession> companies) async {
    final userString = _prefs.getString('user_session');
    if (userString == null) {
      return null;
    }
    
    final userJson = jsonDecode(userString) as Map<String, dynamic>;
    
    // CORREÇÃO: Converter a lista de objetos para lista de Maps antes do Encode
    userJson['companies'] = companies.map((c) => c.toJson()).toList();
    
    await _prefs.setString('user_session', jsonEncode(userJson));
    return loadUser();
  }

  Future<void> logout() async {
    await _prefs.remove('user_session');
  }
}