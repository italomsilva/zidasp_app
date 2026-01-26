// lib/models/company_model.dart
class Company {
  final String id;
  final String name;
  final String cnpj;
  final int totalPonds;
  final int activePonds;
  final String userRole; // 'owner', 'admin', 'employee'
  
  Company({
    required this.id,
    required this.name,
    required this.cnpj,
    required this.totalPonds,
    required this.activePonds,
    required this.userRole,
  });
}
