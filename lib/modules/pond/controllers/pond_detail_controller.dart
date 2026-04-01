import 'package:signals/signals.dart';
import 'package:zidasp_app/core/sesssion/session_controller.dart';
import 'package:zidasp_app/core/enums/user_role_enum.dart';
import 'package:zidasp_app/core/enums/device_type.dart';
import '../../../core/repositories/pond_repository.dart';
import '../../../core/dtos/pond_dto.dart';
import '../../../core/dtos/actuator_dto.dart';

class PondDetailController {
  final PondRepository _repository;
  final SessionController _sessionController;
  PondDetailController(this._repository, this._sessionController);

  final pond = asyncSignal<PondDTO?>(AsyncState.data(null));
  final pondId = signal<String>('');
  final companyName = signal<String>('');

  // Controle de permissão e loading
  final currentUserRole = signal<UserRoleEnum>(UserRoleEnum.employee);
  final togglingDeviceId = signal<String?>(null);

  // Computed para dados específicos
  late final oxygen = computed(() => pond.value.value?.oxygen ?? 0);
  late final temperature = computed(() => pond.value.value?.temperature ?? 0);
  late final salinity = computed(() => pond.value.value?.salinity ?? 0);
  late final ph = computed(() => pond.value.value?.ph ?? 0);
  late final transparency = computed(() => pond.value.value?.transparency ?? 0);
  late final aeratorsOn = computed(() => pond.value.value?.aeratorsOn ?? 0);
  late final aeratorsTotal = computed(
    () => pond.value.value?.aeratorsTotal ?? 0,
  );
  late final pumpsOn = computed(() => pond.value.value?.pumpsOn ?? 0);
  late final pumpsTotal = computed(() => pond.value.value?.pumpsTotal ?? 0);
  late final hasAlert = computed(() => pond.value.value?.hasAlert ?? false);
  late final isAutomatic = computed(
    () => pond.value.value?.isAutomatic ?? false,
  );
  late final isFavorite = computed(() => pond.value.value?.isFavorite ?? false);

  late final sensors = computed(() => pond.value.value?.sensors.toList() ?? []);
  late final actuators = computed(() => pond.value.value?.actuators.toList() ?? []);

  Future<void> initialize(String id) async {
    pond.set(AsyncState.loading());
    final userSession = await _sessionController.loadUser();
    pondId.value = id;
    await loadPondDetails();
    final companPond = userSession?.companies.firstWhere(
      (company) => company.id == pond.value.value?.companyId,
    );
    companyName.value = companPond?.name ?? companyName.value;
    currentUserRole.value = UserRoleEnum.fromString(companPond?.role ?? 'employee');
  }

  Future<void> loadPondDetails() async {
    pond.set(AsyncState.loading());

    try {
      final result = await _repository.getPondDetails(pondId.value);
      pond.set(AsyncState.data(result));
    } catch (e) {
      pond.set(AsyncState.error(e));
    }
  }

  // Helper de permissão
  bool get canManageDevices {
    return currentUserRole.value == UserRoleEnum.admin;
  }

}
