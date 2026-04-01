import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/core/di.dart';
import 'package:zidasp_app/core/enums/sensor_type.dart';
import 'package:zidasp_app/core/enums/device_type.dart';
import 'package:zidasp_app/core/theme/app_theme.dart';
import 'package:zidasp_app/data/mock_data.dart';
import 'package:zidasp_app/widgets/shared/custom_card.dart';
import '../controllers/admin_controller.dart';

class AdminPanelPage extends StatefulWidget {
  final String? companyId;
  const AdminPanelPage({Key? key, this.companyId}) : super(key: key);

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> with SingleTickerProviderStateMixin {
  late final AdminController controller;
  late final TabController _tabController;

  final _pondNameController = TextEditingController();
  final _actuatorNameController = TextEditingController();
  final _sensorUnityController = TextEditingController(text: 'mg/L');
  
  String? _selectedCompanyId;
  String? _selectedPondId;
  SensorType _selectedSensorType = SensorType.oxygen;
  DeviceType _selectedActuatorType = DeviceType.aerator;

  @override
  void initState() {
    super.initState();
    controller = inject<AdminController>();
    _tabController = TabController(length: 3, vsync: this);
    
    _selectedCompanyId = widget.companyId;
    if (_selectedCompanyId == null && MockData.companies.isNotEmpty) {
      _selectedCompanyId = MockData.companies.first['id'];
    }
    
    _updatePondSelection();
  }

  void _updatePondSelection() {
    if (MockData.ponds.isNotEmpty) {
      final ponds = MockData.ponds.where((p) => p['companyId'] == _selectedCompanyId).toList();
      if (ponds.isNotEmpty) {
        _selectedPondId = ponds.first['id'];
      } else {
        _selectedPondId = null;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pondNameController.dispose();
    _actuatorNameController.dispose();
    _sensorUnityController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: isError ? AppColors.shrimpAlert : AppColors.healthGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String companyName = MockData.companies.firstWhere(
      (c) => c['id'] == _selectedCompanyId, 
      orElse: () => {'name': 'Painel Administrativo'}
    )['name'];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Configurações da Empresa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(companyName, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.shrimpAlert,
          labelColor: AppColors.shrimpAlert,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Viveiro'),
            Tab(text: 'Sensor'),
            Tab(text: 'Atuador'),
          ],
        ),
      ),
      body: Watch((context) {
        if (controller.success.value != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSnackBar(controller.success.value!);
            controller.success.value = null;
          });
        }
        if (controller.error.value != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSnackBar(controller.error.value!, isError: true);
            controller.error.value = null;
          });
        }

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPondForm(),
              _buildSensorForm(),
              _buildActuatorForm(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFormContainer({required String title, required String subtitle, required List<Widget> children}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          CustomCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                ...children,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPondForm() {
    return _buildFormContainer(
      title: 'Novo Viveiro',
      subtitle: 'Cadastre um novo viveiro para monitoramento.',
      children: [
        _buildTextField(
          controller: _pondNameController,
          label: 'Nome do Viveiro',
          icon: Icons.waves_outlined,
          hint: 'Ex: Viveiro Sul A1',
        ),
        const SizedBox(height: 16),
        _buildDropdown<String>(
          label: 'Empresa',
          value: _selectedCompanyId,
          icon: Icons.business_outlined,
          items: MockData.companies.map((e) => DropdownMenuItem(value: e['id'].toString(), child: Text(e['name']))).toList(),
          onChanged: (val) => setState(() {
            _selectedCompanyId = val;
            _updatePondSelection();
          }),
        ),
        const SizedBox(height: 32),
        _buildSubmitButton(
          label: 'CRIAR VIVEIRO',
          onPressed: () async {
            if (_pondNameController.text.isEmpty || _selectedCompanyId == null) {
              _showSnackBar('Preencha todos os campos', isError: true);
              return;
            }
            await controller.createPond(name: _pondNameController.text, companyId: _selectedCompanyId!);
            _pondNameController.clear();
          },
        ),
      ],
    );
  }

  Widget _buildSensorForm() {
    return _buildFormContainer(
      title: 'Novo Sensor',
      subtitle: 'Aloque um sensor de monitoramento a um viveiro.',
      children: [
        _buildDropdown<String>(
          label: 'Vincular ao Viveiro',
          value: _selectedPondId,
          icon: Icons.waves_outlined,
          items: MockData.ponds
              .where((p) => p['companyId'] == _selectedCompanyId)
              .map((e) => DropdownMenuItem(value: e['id'].toString(), child: Text(e['name'])))
              .toList(),
          onChanged: (val) => setState(() => _selectedPondId = val),
        ),
        const SizedBox(height: 16),
        _buildDropdown<SensorType>(
          label: 'Tipo de Sensor',
          value: _selectedSensorType,
          icon: Icons.category_outlined,
          items: SensorType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.value))).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedSensorType = val;
                switch (val) {
                  case SensorType.oxygen: _sensorUnityController.text = 'mg/L'; break;
                  case SensorType.salinity: _sensorUnityController.text = 'ppt'; break;
                  case SensorType.temperature: _sensorUnityController.text = '°C'; break;
                  case SensorType.ph: _sensorUnityController.text = 'pH'; break;
                  case SensorType.transparency: _sensorUnityController.text = 'm'; break;
                }
              });
            }
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _sensorUnityController,
          label: 'Unidade de Medida',
          icon: Icons.straighten_outlined,
        ),
        const SizedBox(height: 32),
        _buildSubmitButton(
          label: 'ADICIONAR SENSOR',
          onPressed: () async {
            if (_selectedPondId == null) {
              _showSnackBar('Selecione um viveiro', isError: true);
              return;
            }
            await controller.createSensor(pondId: _selectedPondId!, type: _selectedSensorType, unity: _sensorUnityController.text);
          },
        ),
      ],
    );
  }

  Widget _buildActuatorForm() {
    return _buildFormContainer(
      title: 'Novo Atuador',
      subtitle: 'Instale um novo dispositivo de controle.',
      children: [
        _buildDropdown<String>(
          label: 'Vincular ao Viveiro',
          value: _selectedPondId,
          icon: Icons.waves_outlined,
          items: MockData.ponds
              .where((p) => p['companyId'] == _selectedCompanyId)
              .map((e) => DropdownMenuItem(value: e['id'].toString(), child: Text(e['name'])))
              .toList(),
          onChanged: (val) => setState(() => _selectedPondId = val),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _actuatorNameController,
          label: 'Nome do Dispositivo',
          icon: Icons.edit_outlined,
          hint: 'Ex: Aerador Leste 01',
        ),
        const SizedBox(height: 16),
        _buildDropdown<DeviceType>(
          label: 'Tipo de Atuador',
          value: _selectedActuatorType,
          icon: Icons.settings_outlined,
          items: [DeviceType.aerator, DeviceType.pump, DeviceType.feeder].map((e) => DropdownMenuItem(value: e, child: Text(e.value))).toList(),
          onChanged: (val) => setState(() => _selectedActuatorType = val!),
        ),
        const SizedBox(height: 32),
        _buildSubmitButton(
          label: 'ADICIONAR ATUADOR',
          onPressed: () async {
            if (_actuatorNameController.text.isEmpty || _selectedPondId == null) {
              _showSnackBar('Preencha os dados corretamente', isError: true);
              return;
            }
            await controller.createActuator(pondId: _selectedPondId!, name: _actuatorNameController.text, type: _selectedActuatorType);
            _actuatorNameController.clear();
          },
        ),
      ],
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, String? hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: AppColors.shrimpAlert, size: 22),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
    );
  }

  Widget _buildDropdown<T>({required String label, required T? value, required IconData icon, required List<DropdownMenuItem<T>> items, required ValueChanged<T?> onChanged}) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: AppColors.shrimpAlert, size: 22),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildSubmitButton({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.shrimpAlert,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: controller.isLoading.value ? null : onPressed,
        child: controller.isLoading.value
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(label, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }
}
