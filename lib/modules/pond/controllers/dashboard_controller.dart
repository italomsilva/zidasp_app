// lib/modules/pond/controllers/dashboard_controller.dart
import 'package:signals/signals.dart';
import 'package:zidasp_app/modules/pond/dtos/pond_dto.dart';
import '../repositories/pond_repository.dart';

class DashboardController {
  final PondRepository _repository;

  // Signals
  final ponds = signal<List<PondDTO>>([]);
  final isLoading = signal<bool>(false);
  final error = signal<String?>(null);
  final selectedCompanyId = signal<String?>(null);

  // Computed
  late final filteredPonds = computed(() {
    if (selectedCompanyId.value == null) return <PondDTO>[];
    return ponds.value
        .where((p) => p.companyId == selectedCompanyId.value)
        .toList();
  });

  // Computed para estatísticas
  late final totalPonds = computed(() => filteredPonds.value.length);
  late final activePonds = computed(
    () => filteredPonds.value.where((p) => !p.hasAlert).length,
  );
  late final alertPonds = computed(
    () => filteredPonds.value.where((p) => p.hasAlert).length,
  );

  DashboardController(this._repository);

  final isSwitchingCompany = signal<bool>(false);


  Future<void> initialize() async {
    //todo implement
  }

  Future<void> selectCompany(String companyId) async {
    if (selectedCompanyId.value == companyId) return;

    isSwitchingCompany.value = true; 

    selectedCompanyId.value = companyId;
    await loadPonds(companyId);

    isSwitchingCompany.value = false;
  }

  Future<void> loadPonds(String companyId) async {
    isLoading.value = true;
    error.value = null;

    try {
      final simplePonds = await _repository.getPondsByCompany(companyId);

      final List<PondDTO> pondsDetails = [];
      for (var pond in simplePonds) {
        final details = await _repository.getPondDetails(pond.id);
        pondsDetails.add(details);
      }

      ponds.value = pondsDetails;
      selectedCompanyId.value = companyId;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Versão com loading por item (mostra conforme carrega)
  Future<void> loadPondsProgressive(String companyId) async {
    isLoading.value = true;
    error.value = null;

    try {
      final simplePonds = await _repository.getPondsByCompany(companyId);

      // Limpa a lista antes de começar
      ponds.value = [];

      // Carrega um por um e já vai mostrando
      for (var pond in simplePonds) {
        final details = await _repository.getPondDetails(pond.id);
        ponds.value = [...ponds.value, details];
      }

      selectedCompanyId.value = companyId;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Alternar favorito (atualização otimista)
  void toggleFavorite(String pondId) {
    final index = ponds.value.indexWhere((p) => p.id == pondId);
    if (index != -1) {
      final pond = ponds.value[index];
      final updatedPond = PondDTO(
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
        devices: pond.devices,
      );

      final updatedList = [...ponds.value];
      updatedList[index] = updatedPond;
      ponds.value = updatedList;
    }
  }
}
