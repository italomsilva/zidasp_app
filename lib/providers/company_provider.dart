import 'package:flutter/material.dart';
import 'package:zidasp_app/models/company_model.dart';
import 'package:zidasp_app/models/pond_model.dart';
import 'package:zidasp_app/models/user_model.dart';

class CompanyProvider extends ChangeNotifier {

  List<Company> _userCompanies = [];
  List<Pond> _ponds = [];
  User _currentUser = User(
    id: '1',
    name: 'Carlos Silva',
    email: 'carlos@fazenda.com',
    role: 'owner',
    totalPonds: 15,
    companiesCount: 2,
    joinDate: DateTime(2023, 1, 15),
  );
  
  List<Company> get userCompanies => _userCompanies;
  User get currentUser => _currentUser;
  
  CompanyProvider() {
    _loadMockData();
  }
  
  void _loadMockData() {
    // Mock de empresas
    _userCompanies = [
      Company(
        id: '1',
        name: 'Camarão do Vale',
        cnpj: '12.345.678/0001-90',
        totalPonds: 8,
        activePonds: 6,
        userRole: 'owner',
      ),
      Company(
        id: '2',
        name: 'Pescados Nordeste',
        cnpj: '98.765.432/0001-10',
        totalPonds: 5,
        activePonds: 4,
        userRole: 'admin',
      ),
      Company(
        id: '3',
        name: 'AquaCultura Brasil',
        cnpj: '23.456.789/0001-20',
        totalPonds: 12,
        activePonds: 10,
        userRole: 'employee',
      ),
    ];
    
    // Mock de viveiros
    _ponds = [
      Pond(
        id: '1',
        name: 'Viveiro Principal',
        companyId: '1',
        oxygen: 6.8,
        temperature: 29.0,
        salinity: 28.5,
        ph: 7.2,
        transparency: 45.0,
        aeratorsOn: 3,
        aeratorsTotal: 3,
        pumpsOn: 2,
        pumpsTotal: 3,
        hasAlert: false,
        isFavorite: true,
        isAutomatic: true,
        lastUpdate: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Pond(
        id: '2',
        name: 'Viveiro Norte',
        companyId: '1',
        oxygen: 4.2,
        temperature: 30.5,
        salinity: 31.2,
        ph: 7.0,
        transparency: 35.0,
        aeratorsOn: 1,
        aeratorsTotal: 2,
        pumpsOn: 1,
        pumpsTotal: 2,
        hasAlert: true,
        isFavorite: false,
        isAutomatic: false,
        lastUpdate: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      Pond(
        id: '3',
        name: 'Viveiro Sul',
        companyId: '1',
        oxygen: 7.1,
        temperature: 28.5,
        salinity: 27.8,
        ph: 7.5,
        transparency: 50.0,
        aeratorsOn: 2,
        aeratorsTotal: 2,
        pumpsOn: 2,
        pumpsTotal: 2,
        hasAlert: false,
        isFavorite: true,
        isAutomatic: true,
        lastUpdate: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      Pond(
        id: '4',
        name: 'Viveiro Lagoa Azul',
        companyId: '2',
        oxygen: 5.9,
        temperature: 31.2,
        salinity: 29.3,
        ph: 7.1,
        transparency: 40.0,
        aeratorsOn: 2,
        aeratorsTotal: 3,
        pumpsOn: 2,
        pumpsTotal: 3,
        hasAlert: false,
        isFavorite: false,
        isAutomatic: true,
        lastUpdate: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
    
    notifyListeners();
  }
  
  List<Pond> getPondsByCompany(String companyId) {
    return _ponds.where((pond) => pond.companyId == companyId).toList();
  }
  
  Company? getCompanyById(String id) {
    try {
      return _userCompanies.firstWhere((company) => company.id == id);
    } catch (e) {
      return null;
    }
  }
  
  Pond? getPondById(String id) {
    try {
      return _ponds.firstWhere((pond) => pond.id == id);
    } catch (e) {
      return null;
    }
  }
  
  void toggleFavorite(String pondId) {
    final index = _ponds.indexWhere((pond) => pond.id == pondId);
    if (index != -1) {
      // Em um cenário real, você atualizaria o modelo
      notifyListeners();
    }
  }
  
  void toggleDeviceStatus(String pondId, String deviceType, bool isOn) {
    // Lógica para atualizar status do dispositivo
    notifyListeners();
  }
  
  Future<void> loadData() async {
    // Simular carregamento de dados
    await Future.delayed(const Duration(seconds: 1));
    _loadMockData();
  }
}