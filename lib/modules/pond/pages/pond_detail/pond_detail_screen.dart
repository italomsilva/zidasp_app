// lib/modules/pond/pages/pond_detail_page.dart
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/core/theme/app_theme.dart';
import 'package:zidasp_app/modules/pond/controllers/pond_detail_controller.dart';
import 'package:zidasp_app/modules/pond/repositories/pond_repository.dart';
import 'package:zidasp_app/widgets/shared/custom_card.dart';
import 'package:zidasp_app/modules/pond/widgets/device_controller.dart';

class PondDetailPage extends StatefulWidget {
  final String pondId;
  final String pondName;
  
  const PondDetailPage({
    Key? key,
    required this.pondId,
    required this.pondName,
  }) : super(key: key);
  
  @override
  State<PondDetailPage> createState() => _PondDetailPageState();
}

class _PondDetailPageState extends State<PondDetailPage> {
  late final controller = PondDetailController(
    pondId: widget.pondId,
    repository: PondRepository(),
  );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pondName),
        actions: [
          // Botão de favoritar
          Watch(
            (context) => IconButton(
              icon: Icon(
                controller.isFavorite.value 
                    ? Icons.favorite 
                    : Icons.favorite_border,
                color: controller.isFavorite.value 
                    ? Colors.red 
                    : null,
              ),
              onPressed: controller.toggleFavorite,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              // Navegar para gráficos
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navegar para histórico
            },
          ),
        ],
      ),
      body: Watch(
        (context) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (controller.error.value != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erro: ${controller.error.value}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.loadPondDetails,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Status Principal
                _buildMainStatusCard(context),
                
                const SizedBox(height: 16),
                
                // Controles de Dispositivos
                _buildDeviceControls(context),
                
                const SizedBox(height: 16),
                
                // Sensores
                _buildSensorsCard(context),
                
                const SizedBox(height: 16),
                
                // Configurações
                _buildSettingsCard(context),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildMainStatusCard(BuildContext context) {
    return CustomCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusItem(
                context,
                label: 'Oxigênio',
                value: '${controller.oxygen.value.toStringAsFixed(1)} mg/L',
                isCritical: controller.oxygen.value < 5.0,
              ),
              _buildStatusItem(
                context,
                label: 'Temperatura',
                value: '${controller.temperature.value.toStringAsFixed(1)}°C',
                isWarning: controller.temperature.value < 28 || 
                           controller.temperature.value > 32,
              ),
              _buildStatusItem(
                context,
                label: 'Salinidade',
                value: '${controller.salinity.value.toStringAsFixed(1)} ppt',
                isWarning: controller.salinity.value < 25 || 
                           controller.salinity.value > 35,
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'pH: ${controller.ph.value.toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Transparência: ${controller.transparency.value.toStringAsFixed(0)} cm',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusItem(
    BuildContext context, {
    required String label,
    required String value,
    bool isCritical = false,
    bool isWarning = false,
  }) {
    Color color = AppColors.healthGreen;
    if (isCritical) color = AppColors.shrimpAlert;
    if (isWarning) color = AppColors.neutralYellow;
    
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDeviceControls(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'Controle de Dispositivos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Aeradores
        Watch(
          (context) {
            final aeradores = controller.aeradores.value;
            if (aeradores.isEmpty) return const SizedBox.shrink();
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Aeradores', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: aeradores.map((device) {
                    return DeviceController(
                      deviceName: device.name,
                      deviceType: device.type,
                      isOn: device.isOn,
                      power: device.power,
                      onChanged: (value) {
                        controller.toggleDevice(device.id, value);
                      },
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        // Bombas
        Watch(
          (context) {
            final bombas = controller.bombas.value;
            if (bombas.isEmpty) return const SizedBox.shrink();
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bombas', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: bombas.map((device) {
                    return DeviceController(
                      deviceName: device.name,
                      deviceType: device.type,
                      isOn: device.isOn,
                      power: device.power,
                      onChanged: (value) {
                        controller.toggleDevice(device.id, value);
                      },
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildSensorsCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sensores Conectados',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Watch(
            (context) {
              final sensors = controller.sensors.value;
              
              return Column(
                children: sensors.map((sensor) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          sensor.isOn ? Icons.check_circle : Icons.error,
                          color: sensor.isOn 
                              ? AppColors.healthGreen 
                              : AppColors.shrimpAlert,
                          size: 16,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(sensor.name),
                        ),
                        if (sensor.batteryLevel != null)
                          Text(
                            '${sensor.batteryLevel}%',
                            style: TextStyle(
                              color: sensor.batteryLevel! < 50 
                                  ? AppColors.shrimpAlert 
                                  : null,
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingsCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurações',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Watch(
            (context) => SwitchListTile(
              title: const Text('Notificações de Alerta'),
              subtitle: const Text('Receber alertas quando houver problemas'),
              value: true,
              onChanged: (value) {},
            ),
          ),
          
          Watch(
            (context) => SwitchListTile(
              title: const Text('Modo Automático'),
              subtitle: const Text('Controlar dispositivos automaticamente'),
              value: controller.isAutomatic.value,
              onChanged: (value) {
                controller.toggleAutomaticMode();
              },
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Programar Alimentação'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navegar para programação
            },
          ),
        ],
      ),
    );
  }
}