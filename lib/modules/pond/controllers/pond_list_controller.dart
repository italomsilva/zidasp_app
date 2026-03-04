import 'package:signals/signals.dart';
import 'package:zidasp_app/core/models/company.dart';
import 'package:zidasp_app/core/repositories/company_repository.dart';
import 'package:zidasp_app/core/sesssion/models/company_session.dart';
import 'package:zidasp_app/core/sesssion/session_controller.dart';
import 'package:zidasp_app/core/dtos/pond_dto.dart';
import '../../../core/repositories/pond_repository.dart';

class PondListController {
  final PondRepository _pondRepository;
  final CompanyRepository _companyRepository;
  final SessionController _sessionController;

  PondListController(
    this._pondRepository,
    this._companyRepository,
    this._sessionController,
  );

  // Signals
  final companies = signal<List<CompanySession?>>([]);
  final ponds = asyncSignal<List<PondDTO>>(AsyncState.data([]));
  final selectedCompanyId = signal<String?>(null);
  final isSwitchingCompany = signal<bool>(false);

  // contadores
  late final totalPonds = computed(() => ponds.value.value?.length ?? 0);
  late final activePonds = computed(
    () => ponds.value.value?.where((p) => !p.hasAlert).length ?? 0,
  );
  late final alertPonds = computed(
    () => ponds.value.value?.where((p) => p.hasAlert).length ?? 0,
  );

  // Initialize
  Future<void> initialize() async {
    ponds.set(AsyncState.loading());
    final user = await _sessionController.loadUser();
    if (user == null) {
      ponds.set(AsyncState.error('Problema de Usuário, faça login novamente'));
      return;
    }

    List<CompanySession> userCompanies = user.companies;
    if (user.companies.isEmpty) {
      userCompanies = await _companyRepository.getUserCompaniesSession(user.id);
      await _sessionController.saveCompanies(userCompanies);
    }
    companies.value = userCompanies;
    if (userCompanies.isEmpty) {
      ponds.set(AsyncState.error('Nenhuma empresa vinculada'));
      return;
    }

    selectedCompanyId.value = userCompanies.first?.id;

    if (selectedCompanyId.value != null) {
      await loadPonds();
    }
  }

  Future<void> selectCompany(String companyId) async {
    if (selectedCompanyId.value == companyId) {
      return;
    }

    isSwitchingCompany.value = true;
    selectedCompanyId.value = companyId;

    await loadPonds();

    isSwitchingCompany.value = false;
  }

  Future<void> loadPonds() async {
    if (selectedCompanyId.value == null) {
      return;
    }

    ponds.set(AsyncState.loading());

    try {
      final simplePonds = await _pondRepository.getPondsByCompany(
        selectedCompanyId.value!,
      );

      if (simplePonds.isEmpty) {
        ponds.set(AsyncState.data([]));
        return;
      }

      final pondsDetails = <PondDTO>[];

      for (var simplePond in simplePonds) {
        final details = await _pondRepository.getPondDetails(simplePond.id);
        pondsDetails.add(details);
      }

      if (pondsDetails.isEmpty && simplePonds.isNotEmpty) {
        throw Exception('Não foi possível carregar detalhes de nenhum viveiro');
      }

      ponds.set(AsyncState.data(pondsDetails));
    } catch (e) {
      ponds.set(AsyncState.error('Ocorreu um problema, tente novamente'));
    }
  }

  // Alternar favorito (atualização otimista)
  void toggleFavorite(String pondId) {
    final pondList = ponds.value.value;
    final index = pondList?.indexWhere((p) => p.id == pondId);

    if (index != -1 && index != null) {
      final pond = pondList![index];

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
        sensors: pond.sensors,
        actuators: pond.actuators,
      );

      final updatedList = [...?ponds.value.value];
      updatedList[index] = updatedPond;
      ponds.set(AsyncState.data(updatedList));
    }
  }
}
