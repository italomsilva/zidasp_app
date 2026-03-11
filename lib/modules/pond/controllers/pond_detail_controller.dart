import 'package:signals/signals.dart';
import 'package:zidasp_app/core/sesssion/session_controller.dart';
import '../../../core/repositories/pond_repository.dart';
import '../../../core/dtos/pond_dto.dart';
import '../../../core/dtos/device_dto.dart';

class PondDetailController {
  final PondRepository _repository;
  final SessionController _sessionController;
  PondDetailController(this._repository, this._sessionController);

  final pond = asyncSignal<PondDTO?>(AsyncState.data(null));
  final pondId = signal<String>('');
  final companyName = signal<String>('');

  // Controle de permissão e loading
  final currentUserRole = signal<String>('employee');
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

  late final sensors = pond.value.value?.sensors.toList() ?? [];
  late final actuators = pond.value.value?.actuators.toList() ?? [];

  Future<void> initialize(String id) async {
    pond.set(AsyncState.loading());
    final userSession = await _sessionController.loadUser();
    pondId.value = id;
    await loadPondDetails();
    final companPond = userSession?.companies.firstWhere(
      (company) => company.id == pond.value.value?.companyId,
    );
    companyName.value = companPond?.name ?? companyName.value;
    currentUserRole.value = companPond?.role ?? 'employee';
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
    return currentUserRole.value == 'owner' || currentUserRole.value == 'admin';
  }

  Future<void> toggleDevice(String deviceId, bool isOn) async {
    if (!canManageDevices) {
      pond.set(
        AsyncState.error('Você não tem permissão para alterar dispositivos.'),
      );
      // Aqui a UI deve idealmente receber o feedback num Signal separado de erro não-fatal,
      // mas vamos deixar propagar o AsyncError para fins deste MVP ou Snackbar na View.
      return;
    }

    if (togglingDeviceId.value != null) return; // Trava contra múltiplos clicks

    togglingDeviceId.value = deviceId;

    // Atualização otimista
    _updateDeviceLocally(deviceId, isOn);

    try {
      await _repository.toggleDevice(pondId.value, deviceId, isOn);

      // Busca status fresco para confirmar a transação do "DB" após o delay
      await loadPondDetails();
    } catch (e) {
      // Reverter em caso de erro
      _updateDeviceLocally(deviceId, !isOn);
      pond.set(AsyncState.error(e));
    } finally {
      togglingDeviceId.value = null;
    }
  }

  void _updateDeviceLocally(String deviceId, bool isOn) {
    if (pond.value.value == null) return;

    final updatedDevices = pond.value.value!.devices.map((device) {
      if (device.id == deviceId) {
        return DeviceDTO(
          id: device.id,
          name: device.name,
          type: device.type,
          isOn: isOn,
          power: device.power,
          batteryLevel: device.batteryLevel,
          lastActive: DateTime.now(),
        );
      }
      return device;
    }).toList();

    // Recalcula totais
    final aeratorsCount = updatedDevices
        .where((d) => d.type == 'Aerador' && d.isOn)
        .length;
    final pumpsCount = updatedDevices
        .where((d) => d.type == 'Bomba' && d.isOn)
        .length;

    pond.set(
      AsyncState.data(
        PondDTO(
          id: pond.value.value!.id,
          name: pond.value.value!.name,
          companyId: pond.value.value!.companyId,
          oxygen: pond.value.value!.oxygen,
          temperature: pond.value.value!.temperature,
          salinity: pond.value.value!.salinity,
          ph: pond.value.value!.ph,
          transparency: pond.value.value!.transparency,
          aeratorsOn: aeratorsCount,
          aeratorsTotal: pond.value.value!.aeratorsTotal,
          pumpsOn: pumpsCount,
          pumpsTotal: pond.value.value!.pumpsTotal,
          hasAlert: pond.value.value!.hasAlert,
          isFavorite: pond.value.value!.isFavorite,
          isAutomatic: pond.value.value!.isAutomatic,
          lastUpdate: DateTime.now(),
          devices: updatedDevices,
          sensors: pond.value.value!.sensors,
          actuators: pond.value.value!.actuators,
        ),
      ),
    );
  }

  Future<void> toggleFavorite() async {
    if (pond.value.value == null) return;

    final newValue = !pond.value.value!.isFavorite;

    // Atualização otimista
    pond.set(
      AsyncState.data(
        PondDTO(
          id: pond.value.value!.id,
          name: pond.value.value!.name,
          companyId: pond.value.value!.companyId,
          oxygen: pond.value.value!.oxygen,
          temperature: pond.value.value!.temperature,
          salinity: pond.value.value!.salinity,
          ph: pond.value.value!.ph,
          transparency: pond.value.value!.transparency,
          aeratorsOn: pond.value.value!.aeratorsOn,
          aeratorsTotal: pond.value.value!.aeratorsTotal,
          pumpsOn: pond.value.value!.pumpsOn,
          pumpsTotal: pond.value.value!.pumpsTotal,
          hasAlert: pond.value.value!.hasAlert,
          isFavorite: newValue,
          isAutomatic: pond.value.value!.isAutomatic,
          lastUpdate: DateTime.now(),
          devices: pond.value.value!.devices,
          sensors: pond.value.value!.sensors,
          actuators: pond.value.value!.actuators,
        ),
      ),
    );

    // Aqui você chamaria a API para favoritar
    // await _repository.toggleFavorite(pondId);
  }

  Future<void> toggleAutomaticMode() async {
    if (pond.value.value == null) return;

    final newValue = !pond.value.value!.isAutomatic;

    pond.set(
      AsyncState.data(
        PondDTO(
          id: pond.value.value!.id,
          name: pond.value.value!.name,
          companyId: pond.value.value!.companyId,
          oxygen: pond.value.value!.oxygen,
          temperature: pond.value.value!.temperature,
          salinity: pond.value.value!.salinity,
          ph: pond.value.value!.ph,
          transparency: pond.value.value!.transparency,
          aeratorsOn: pond.value.value!.aeratorsOn,
          aeratorsTotal: pond.value.value!.aeratorsTotal,
          pumpsOn: pond.value.value!.pumpsOn,
          pumpsTotal: pond.value.value!.pumpsTotal,
          hasAlert: pond.value.value!.hasAlert,
          isFavorite: pond.value.value!.isFavorite,
          isAutomatic: newValue,
          lastUpdate: DateTime.now(),
          devices: pond.value.value!.devices,
          sensors: pond.value.value!.sensors,
          actuators: pond.value.value!.actuators,
        ),
      ),
    );

    await _repository.updateSettings(pondId.value, {'isAutomatic': newValue});
  }
}
