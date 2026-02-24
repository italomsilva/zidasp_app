// lib/controllers/pond_controller.dart
import 'package:signals/signals.dart';
import '../models/pond_model.dart';
import '../models/company_model.dart';
import '../models/user_model.dart';

class PondController {
  // Signals
  final companies = signal<List<Company>>([]);
  final ponds = signal<List<Pond>>([]);
  final selectedCompanyId = signal<String?>(null);
  final currentUser = signal<User>(
    User(
      id: '1',
      name: 'Carlos Silva',
      email: 'carlos@fazenda.com',
      role: 'owner',
      totalPonds: 15,
      companiesCount: 2,
      joinDate: DateTime(2023, 1, 15),
    ),
  );
  
  final isLoading = signal<bool>(false);
  final error = signal<String?>(null);
  
  // Computed
  late final selectedCompany = computed(() {
    final id = selectedCompanyId.value;
    if (id == null) return null;
    try {
      return companies.value.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  });
  
  late final filteredPonds = computed(() {
    final id = selectedCompanyId.value;
    if (id == null) return <Pond>[];
    return ponds.value.where((p) => p.companyId == id).toList();
  });
  
  late final activePondsCount = computed(() {
    return filteredPonds.value.where((p) => !p.hasAlert).length;
  });
  
  late final alertPondsCount = computed(() {
    return filteredPonds.value.where((p) => p.hasAlert).length;
  });
  
  PondController() {
    _loadMockData();
  }
  
  void _loadMockData() {
    // Mock de empresas
    companies.value = [
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
    ponds.value = [
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
  }
  
  void selectCompany(String companyId) {
    selectedCompanyId.value = companyId;
  }
  
  void toggleFavorite(String pondId) {
    final index = ponds.value.indexWhere((p) => p.id == pondId);
    if (index != -1) {
      final updatedPonds = [...ponds.value];
      final pond = updatedPonds[index];
      updatedPonds[index] = Pond(
        id: pond.id,
        name: pond.name,
        companyId: pond.companyId,
        oxygen: pond.oxygen,
        temperature: pond.temperature,
        salinity: pond.salinity,
        ph: pond.ph,
        transparency: pond.transparency,
        aeratorsOn: pond.aeratorsOn,
        aeratorsTotal: pond.aeratorsTotal,
        pumpsOn: pond.pumpsOn,
        pumpsTotal: pond.pumpsTotal,
        hasAlert: pond.hasAlert,
        isFavorite: !pond.isFavorite,
        isAutomatic: pond.isAutomatic,
        lastUpdate: pond.lastUpdate,
      );
      ponds.value = updatedPonds;
    }
  }
  
  Company? getCompanyById(String id) {
    try {
      return companies.value.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
  
  Pond? getPondById(String id) {
    try {
      return ponds.value.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
  
  Future<void> loadData() async {
    isLoading.value = true;
    error.value = null;
    
    try {
      // Simular carregamento
      await Future.delayed(const Duration(seconds: 1));
      _loadMockData();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  void clearError() {
    error.value = null;
  }
}