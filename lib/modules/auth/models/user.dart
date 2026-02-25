// lib/modules/auth/models/user_model.dart
class User {
  final String id;
  final String name;
  final String email;
  final String document;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.document,
  });
  
  String get initials => name
      .split(' ')
      .where((word) => word.isNotEmpty)
      .map((word) => word[0])
      .take(2)
      .join()
      .toUpperCase();
}