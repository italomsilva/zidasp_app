// lib/modules/pond/controllers/pond_detail_controller.dart
import 'package:signals/signals.dart';
import '../repositories/pond_repository.dart';
import '../dtos/pond_dto.dart';
import '../dtos/device_dto.dart';

class PondDetailController {
  final PondRepository _repository;
  final String pondId;
  
  // Signal com o DTO completo
  final pondDTO = signal<PondDTO?>(null);
  
  // Signals de UI
  final isLoading = signal<bool>(false);
  final isSaving = signal<bool>(false);
  final error = signal<String?>(null);
  
  // Computed para dados específicos
  late final oxygen = computed(() => pondDTO.value?.oxygen ?? 0);
  late final temperature = computed(() => pondDTO.value?.temperature ?? 0);
  late final salinity = computed(() => pondDTO.value?.salinity ?? 0);
  late final ph = computed(() => pondDTO.value?.ph ?? 0);
  late final transparency = computed(() => pondDTO.value?.transparency ?? 0);
  late final aeratorsOn = computed(() => pondDTO.value?.aeratorsOn ?? 0);
  late final aeratorsTotal = computed(() => pondDTO.value?.aeratorsTotal ?? 0);
  late final pumpsOn = computed(() => pondDTO.value?.pumpsOn ?? 0);
  late final pumpsTotal = computed(() => pondDTO.value?.pumpsTotal ?? 0);
  late final hasAlert = computed(() => pondDTO.value?.hasAlert ?? false);
  late final isAutomatic = computed(() => pondDTO.value?.isAutomatic ?? false);
  late final isFavorite = computed(() => pondDTO.value?.isFavorite ?? false);
  
  // Lista de dispositivos
  late final devices = computed(() => pondDTO.value?.devices ?? []);
  
  // Sensores (filtrados por tipo)
  late final sensors = computed(() {
    return devices.value.where((d) => d.type == 'Sensor').toList();
  });
  
  // Aeradores (filtrados por tipo)
  late final aeradores = computed(() {
    return devices.value.where((d) => d.type == 'Aerador').toList();
  });
  
  // Bombas (filtradas por tipo)
  late final bombas = computed(() {
    return devices.value.where((d) => d.type == 'Bomba').toList();
  });
  
  PondDetailController({
    required this.pondId,
    required PondRepository repository,
  }) : _repository = repository {
    loadPondDetails();
  }
  
  Future<void> loadPondDetails() async {
    isLoading.value = true;
    error.value = null;
    
    try {
      final result = await _repository.getPondDetails(pondId);
      pondDTO.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> toggleDevice(String deviceId, bool isOn) async {
    // Atualização otimista
    _updateDeviceLocally(deviceId, isOn);
    
    try {
      await _repository.toggleDevice(pondId, deviceId, isOn);
    } catch (e) {
      // Reverter em caso de erro
      _updateDeviceLocally(deviceId, !isOn);
      error.value = e.toString();
    }
  }
  
  void _updateDeviceLocally(String deviceId, bool isOn) {
    if (pondDTO.value == null) return;
    
    final updatedDevices = pondDTO.value!.devices.map((device) {
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
    
    pondDTO.value = PondDTO(
      id: pondDTO.value!.id,
      name: pondDTO.value!.name,
      companyId: pondDTO.value!.companyId,
      oxygen: pondDTO.value!.oxygen,
      temperature: pondDTO.value!.temperature,
      salinity: pondDTO.value!.salinity,
      ph: pondDTO.value!.ph,
      transparency: pondDTO.value!.transparency,
      aeratorsOn: aeratorsCount,
      aeratorsTotal: pondDTO.value!.aeratorsTotal,
      pumpsOn: pumpsCount,
      pumpsTotal: pondDTO.value!.pumpsTotal,
      hasAlert: pondDTO.value!.hasAlert,
      isFavorite: pondDTO.value!.isFavorite,
      isAutomatic: pondDTO.value!.isAutomatic,
      lastUpdate: DateTime.now(),
      devices: updatedDevices,
    );
  }
  
  Future<void> toggleFavorite() async {
    if (pondDTO.value == null) return;
    
    final newValue = !pondDTO.value!.isFavorite;
    
    // Atualização otimista
    pondDTO.value = PondDTO(
      id: pondDTO.value!.id,
      name: pondDTO.value!.name,
      companyId: pondDTO.value!.companyId,
      oxygen: pondDTO.value!.oxygen,
      temperature: pondDTO.value!.temperature,
      salinity: pondDTO.value!.salinity,
      ph: pondDTO.value!.ph,
      transparency: pondDTO.value!.transparency,
      aeratorsOn: pondDTO.value!.aeratorsOn,
      aeratorsTotal: pondDTO.value!.aeratorsTotal,
      pumpsOn: pondDTO.value!.pumpsOn,
      pumpsTotal: pondDTO.value!.pumpsTotal,
      hasAlert: pondDTO.value!.hasAlert,
      isFavorite: newValue,
      isAutomatic: pondDTO.value!.isAutomatic,
      lastUpdate: DateTime.now(),
      devices: pondDTO.value!.devices,
    );
    
    // Aqui você chamaria a API para favoritar
    // await _repository.toggleFavorite(pondId);
  }
  
  Future<void> toggleAutomaticMode() async {
    if (pondDTO.value == null) return;
    
    final newValue = !pondDTO.value!.isAutomatic;
    
    pondDTO.value = PondDTO(
      id: pondDTO.value!.id,
      name: pondDTO.value!.name,
      companyId: pondDTO.value!.companyId,
      oxygen: pondDTO.value!.oxygen,
      temperature: pondDTO.value!.temperature,
      salinity: pondDTO.value!.salinity,
      ph: pondDTO.value!.ph,
      transparency: pondDTO.value!.transparency,
      aeratorsOn: pondDTO.value!.aeratorsOn,
      aeratorsTotal: pondDTO.value!.aeratorsTotal,
      pumpsOn: pondDTO.value!.pumpsOn,
      pumpsTotal: pondDTO.value!.pumpsTotal,
      hasAlert: pondDTO.value!.hasAlert,
      isFavorite: pondDTO.value!.isFavorite,
      isAutomatic: newValue,
      lastUpdate: DateTime.now(),
      devices: pondDTO.value!.devices,
    );
    
    await _repository.updateSettings(pondId, {'isAutomatic': newValue});
  }
}