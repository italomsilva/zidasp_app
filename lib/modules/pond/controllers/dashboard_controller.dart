import 'package:signals/signals.dart';
import 'package:zidasp_app/core/models/company.dart';
import 'package:zidasp_app/core/repositories/company_repository.dart';
import 'package:zidasp_app/core/sesssion/session_controller.dart';
import 'package:zidasp_app/modules/pond/dtos/pond_dto.dart';
import '../../../core/repositories/pond_repository.dart';

class DashboardController {
  final PondRepository _pondRepository;
  final CompanyRepository _companyRepository;
  final SessionController _sessionController;

  DashboardController(
    this._pondRepository,
    this._companyRepository,
    this._sessionController,
  ) {
    print('🏗️ DashboardController criado');
  }

  // Signals
  final companies = signal<List<Company?>>([]);
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
    print('🔄 Inicializando DashboardController...');
    
    print('📡 Carregando usuário...');
    final user = await _sessionController.loadUser();
    if (user == null) {
      print('❌ Usuário não encontrado');
      ponds.set(AsyncState.error('Problema de Usuário, faça login novamente'));
      return;
    }
    print('✅ Usuário carregado: ${user.id}');

    print('📡 Carregando empresas do usuário...');
    final userCompanies = await _companyRepository.getUserCompanies(user.id);
    print('✅ Empresas carregadas: ${userCompanies.length}');
    
    companies.value = userCompanies;

    if (userCompanies.isEmpty) {
      print('❌ Nenhuma empresa vinculada');
      ponds.set(AsyncState.error('Nenhuma empresa vinculada'));
      return;
    }

    // Acesso seguro ao ID da primeira empresa
    selectedCompanyId.value = userCompanies.first?.id;
    print('✅ Empresa selecionada: ${selectedCompanyId.value}');

    if (selectedCompanyId.value != null) {
      await loadPonds();
    }
  }

  Future<void> selectCompany(String companyId) async {
    print('🔄 Selecionando empresa: $companyId');
    
    if (selectedCompanyId.value == companyId) {
      print('⚠️ Empresa já selecionada');
      return;
    }

    isSwitchingCompany.value = true;
    selectedCompanyId.value = companyId;
    
    await loadPonds();
    
    isSwitchingCompany.value = false;
    print('✅ Troca de empresa concluída');
  }

Future<void> loadPonds() async {
  print('📡 Carregando viveiros...');
  
  if (selectedCompanyId.value == null) {
    print('❌ Nenhuma empresa selecionada');
    return;
  }

  ponds.set(AsyncState.loading());
  print('⏳ Estado: loading');
  
  try {
    print('📡 Buscando lista simples de viveiros...');
    final simplePonds = await _pondRepository.getPondsByCompany(
      selectedCompanyId.value!,
    );
    print('✅ Lista simples carregada: ${simplePonds.length} viveiros');

    if (simplePonds.isEmpty) {
      print('⚠️ Nenhum viveiro encontrado');
      ponds.set(AsyncState.data([]));
      return;
    }

    // Busca detalhes em paralelo, mas trata erros individuais
    print('📡 Buscando detalhes dos viveiros...');
    
    final pondsDetails = <PondDTO>[];
    
    for (var simplePond in simplePonds) {
      try {
        print('🔍 Buscando detalhes do viveiro ${simplePond.id}...');
        final details = await _pondRepository.getPondDetails(simplePond.id);
        pondsDetails.add(details);
        print('✅ Detalhes carregados para ${simplePond.id}');
      } catch (e) {
        print('❌ Erro ao carregar detalhes do viveiro ${simplePond.id}: $e');
        // Continua com os próximos
      }
    }
    
    print('✅ Detalhes carregados: ${pondsDetails.length} de ${simplePonds.length} viveiros');

    if (pondsDetails.isEmpty && simplePonds.isNotEmpty) {
      throw Exception('Não foi possível carregar detalhes de nenhum viveiro');
    }

    ponds.set(AsyncState.data(pondsDetails));
    print('✅ Estado atualizado com dados');
    
  } catch (e, stackTrace) {
    print('❌ ERRO ao carregar viveiros: $e');
    print('📚 StackTrace: $stackTrace');
    ponds.set(AsyncState.error('Ocorreu um problema, tente novamente'));
  }
}
  // Alternar favorito (atualização otimista)
  void toggleFavorite(String pondId) {
    print('🔄 Toggle favorite: $pondId');
    
    final pondList = ponds.value.value;
    final index = pondList?.indexWhere((p) => p.id == pondId);
    
    if (index != -1 && index != null) {
      final pond = pondList![index];
      print('✅ Pond encontrado: ${pond.name}');
      
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

      final updatedList = [...?ponds.value.value];
      updatedList[index] = updatedPond;
      ponds.set(AsyncState.data(updatedList));
      print('✅ Favorite toggled: ${!pond.isFavorite}');
    } else {
      print('❌ Pond não encontrado: $pondId');
    }
  }
}