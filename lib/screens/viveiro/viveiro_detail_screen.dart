// lib/screens/viveiro/viveiro_detail_screen.dart - VERSÃO CORRIGIDA
import 'package:flutter/material.dart';
import 'package:zidasp_app/theme/app_theme.dart';
import 'package:zidasp_app/widgets/shared/custom_card.dart';
import 'package:zidasp_app/widgets/shared/device_controller.dart';

// Adicione esta importação ou crie o modelo
import 'package:zidasp_app/models/pond_model.dart'; // Supondo que você tenha esse arquivo

class ViveiroDetailScreen extends StatelessWidget {
  final Pond pond;
  
  const ViveiroDetailScreen({Key? key, required this.pond}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pond.name),
        actions: [
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
      body: SingleChildScrollView(
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
                value: '${pond.oxygen} mg/L',
                isCritical: pond.oxygen < 5.0,
              ),
              _buildStatusItem(
                context,
                label: 'Temperatura',
                value: '${pond.temperature}°C',
                isWarning: pond.temperature < 28 || pond.temperature > 32,
              ),
              _buildStatusItem(
                context,
                label: 'Salinidade',
                value: '${pond.salinity} ppt',
                isWarning: pond.salinity < 25 || pond.salinity > 35,
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'pH: ${pond.ph}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Transparência: ${pond.transparency} cm',
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
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            DeviceController(
              deviceName: 'Aerador Principal',
              deviceType: 'Aerador',
              isOn: pond.aeratorsOn > 0,
              power: '2.5 kW',
              onChanged: (value) {
                // Atualizar estado do aerador
              },
            ),
            DeviceController(
              deviceName: 'Bomba de Água',
              deviceType: 'Bomba',
              isOn: pond.pumpsOn > 0,
              power: '5.0 kW',
              onChanged: (value) {
                // Atualizar estado da bomba
              },
            ),
            DeviceController(
              deviceName: 'Aerador Secundário',
              deviceType: 'Aerador',
              isOn: pond.aeratorsOn > 1,
              power: '2.0 kW',
              onChanged: (value) {
                // Atualizar estado do aerador
              },
            ),
            DeviceController(
              deviceName: 'Alimentador',
              deviceType: 'Automático',
              isOn: true,
              power: '0.5 kW',
              onChanged: (value) {
                // Atualizar estado do alimentador
              },
            ),
          ],
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
          _buildSensorItem(
            context,
            name: 'Sensor O₂ - Zona A',
            battery: '85%',
            isConnected: true,
          ),
          _buildSensorItem(
            context,
            name: 'Sensor O₂ - Zona B',
            battery: '72%',
            isConnected: true,
          ),
          _buildSensorItem(
            context,
            name: 'Sensor Temperatura',
            battery: '92%',
            isConnected: true,
          ),
          _buildSensorItem(
            context,
            name: 'Sensor Salinidade',
            battery: '45%',
            isConnected: false,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSensorItem(
    BuildContext context, {
    required String name,
    required String battery,
    required bool isConnected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isConnected ? Icons.check_circle : Icons.error,
            color: isConnected ? AppColors.healthGreen : AppColors.shrimpAlert,
            size: 16,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name),
          ),
          Text(
            battery,
            style: TextStyle(
              color: battery == '45%' 
                  ? AppColors.shrimpAlert 
                  : Theme.of(context).textTheme.bodySmall?.color,
            ),
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
          SwitchListTile(
            title: const Text('Notificações de Alerta'),
            subtitle: const Text('Receber alertas quando houver problemas'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('Modo Automático'),
            subtitle: const Text('Controlar dispositivos automaticamente'),
            value: pond.isAutomatic,
            onChanged: (value) {},
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