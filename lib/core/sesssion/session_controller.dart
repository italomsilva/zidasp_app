import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zidasp_app/core/sesssion/models/user_session.dart';

class SessionController {
  final SharedPreferences _prefs;
  SessionController(this._prefs);

  Future<UserSession> saveUser(String id, String name, String token) async {
    final UserSession user = UserSession(id: id, name: name, token: token);
    await _prefs.setString(
      'user_session',
      jsonEncode(user.toPersistenceJson()),
    );
    return user;
  }

  Future<UserSession?> loadUser() async {
    final userString = await _prefs.getString('user_session');
    if (userString == null) {
      return null;
    }
    final userJson = jsonDecode(userString) as Map<String, dynamic>;
    return UserSession(
      id: userJson['id'],
      name: userJson['name'],
      token: userJson['token'],
    );
  }
}
