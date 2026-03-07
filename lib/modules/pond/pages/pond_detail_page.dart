import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/core/di.dart';
import 'package:zidasp_app/core/dtos/device_dto.dart';
import 'package:zidasp_app/core/dtos/sensor_dto.dart';
import 'package:zidasp_app/core/theme/app_theme.dart';
import 'package:zidasp_app/modules/pond/controllers/pond_detail_controller.dart';
import 'package:zidasp_app/widgets/shared/custom_card.dart';
import 'package:zidasp_app/modules/pond/widgets/device_controller.dart';

class PondDetailPage extends StatefulWidget {
  final String pondId;
  final String pondName;

  const PondDetailPage({Key? key, required this.pondId, required this.pondName})
    : super(key: key);

  @override
  State<PondDetailPage> createState() => _PondDetailPageState();
}

class _PondDetailPageState extends State<PondDetailPage> {
  late final PondDetailController controller = inject<PondDetailController>();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _initialize();

    _scrollController.addListener(() {
      if (_scrollController.offset > 400 && !_showScrollToTop) {
        setState(() => _showScrollToTop = true);
      } else if (_scrollController.offset <= 400 && _showScrollToTop) {
        setState(() => _showScrollToTop = false);
      }
    });
  }

  Future<void> _initialize() async {
    await controller.initialize(widget.pondId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: controller.loadPondDetails,
            color: AppColors.shrimpAlert,
            backgroundColor: Theme.of(context).cardColor,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.bar_chart),
                      onPressed: () {
                        // Navegar para gráficos
                      },
                      tooltip: 'Gráficos',
                    ),
                    IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: () {
                        // Navegar para histórico
                      },
                      tooltip: 'Histórico',
                    ),
                  ],
                ),

                // Conteúdo principal
                Watch(
                  (context) => controller.pond.get().map(
                    error: (err) => SliverFillRemaining(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.shrimpAlert.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.error_outline,
                                  size: 40,
                                  color: AppColors.shrimpAlert,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Ops! Algo deu errado',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                err,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () => controller.loadPondDetails(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.shrimpAlert,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    loading: () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    data: (value) => SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Card de sensores
                          _buildSensorsCard(context),

                          const SizedBox(height: 16),

                          // Card com informações do viveiro
                          _buildInfoCard(context),

                          const SizedBox(height: 16),

                          // Controles de Dispositivos
                          _buildDeviceControls(context),

                          const SizedBox(height: 16),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Botão flutuante de scroll to top
          if (_showScrollToTop)
            Positioned(
              bottom: 20,
              right: 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _showScrollToTop ? 1 : 0,
                child: FloatingActionButton.small(
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  backgroundColor: AppColors.shrimpAlert,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.arrow_upward),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Card com informações básicas do viveiro
  Widget _buildInfoCard(BuildContext context) {
    return _buildExpandableCard(
      context,
      title: 'Informações do Viveiro',
      icon: Icons.info_outline,
      iconColor: AppColors.shrimpAlert,
      initiallyExpanded: false, 
      children: [
        _buildInfoItem(
          context,
          label: 'ID',
          value: widget.pondId,
          icon: Icons.tag,
        ),
        _buildInfoItem(
          context,
          label: 'Nome',
          value: widget.pondName,
          icon: FontAwesomeIcons.tarpDroplet,
        ),
        _buildInfoItem(
          context,
          label: 'Empresa',
          value: controller.companyName.value,
          icon: Icons.business,
        ),
      ],
    );
  }

  // Card de sensores
  Widget _buildSensorsCard(BuildContext context) {
    return _buildExpandableCard(
      context,
      title: 'Sensores',
      icon: Icons.sensors,
      iconColor: AppColors.neutralBlue,
      initiallyExpanded: true,
      children: [
        Watch((context) {
          final sensors = controller.sensors;
          if (sensors.isEmpty)
            return const Center(child: Text('Nenhum sensor encontrado'));
          return Column(
            children: sensors
                .map(
                  (sensor) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildSensorTile(sensor),
                  ),
                )
                .toList(),
          );
        }),
      ],
    );
  }

  Widget _buildSensorTile(SensorDTO sensor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getSensorIconColor(sensor.type).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getSensorIcon(sensor.type),
              color: _getSensorIconColor(sensor.type),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sensor.type,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  "${sensor.value} ${sensor.unity}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getSensorValueColor(sensor.type, 1.12),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: Colors.green, size: 16),
        ],
      ),
    );
  }

  Widget _buildDeviceControls(BuildContext context) {
    return _buildExpandableCard(
      context,
      title: 'Controle de Dispositivos',
      icon: Icons.power_settings_new,
      iconColor: AppColors.shrimpAlert,
      children: [
        // Aqui vai o conteúdo atual de aeradores e bombas que você já tem
        Watch((context) {
          final aeradores = controller.actuators.where(
            (act) => act.type == 'Aerador',
          );
          if (aeradores.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.shrimpAlert,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Aeradores',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Watch(
                      (context) => Text(
                        '${controller.aeratorsOn.value}/${controller.aeratorsTotal.value} ativos',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                    isOn: device.active,
                    onChanged: (value) {
                      //////impl
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          );
        }),

        // Bombas
        Watch((context) {
          final bombas = controller.actuators.where(
            (act) => act.type == 'Bomba',
          );
          if (bombas.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.neutralBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Bombas',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Watch(
                      (context) => Text(
                        '${controller.pumpsOn.value}/${controller.pumpsTotal.value} ativos',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                    isOn: device.active,
                    onChanged: (value) {
                      //////impl
                    },
                  );
                }).toList(),
              ),
            ],
          );
        }),
      ],
    );
  }

  // Card de configurações
  // Widgets auxiliares
  Widget _buildInfoItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  // Funções auxiliares para cores
  Color _getOxygenColor(double value) {
    if (value < 5.0) return AppColors.shrimpAlert;
    if (value < 6.0) return AppColors.neutralYellow;
    return AppColors.healthGreen;
  }

  Color _getTemperatureColor(double value) {
    if (value < 28 || value > 32) return AppColors.shrimpAlert;
    if (value < 29 || value > 31) return AppColors.neutralYellow;
    return AppColors.healthGreen;
  }

  Color _getSalinityColor(double value) {
    if (value < 25 || value > 35) return AppColors.shrimpAlert;
    if (value < 27 || value > 33) return AppColors.neutralYellow;
    return AppColors.healthGreen;
  }

  IconData _getSensorIcon(String type) {
    switch (type.toLowerCase()) {
      case 'oxigênio':
      case 'oxigenio':
        return Icons.water_drop;
      case 'temperatura':
        return Icons.thermostat;
      case 'salinidade':
        return Icons.water;
      case 'ph':
        return Icons.science;
      default:
        return Icons.sensors;
    }
  }

  Color _getSensorIconColor(String type) {
    switch (type.toLowerCase()) {
      case 'oxigênio':
      case 'oxigenio':
        return AppColors.neutralBlue;
      case 'temperatura':
        return AppColors.shrimpAlert;
      case 'salinidade':
        return AppColors.healthGreen;
      case 'ph':
        return AppColors.neutralYellow;
      default:
        return Colors.grey;
    }
  }

  Color _getSensorValueColor(String type, double value) {
    switch (type.toLowerCase()) {
      case 'oxigênio':
      case 'oxigenio':
        return _getOxygenColor(value);
      case 'temperatura':
        return _getTemperatureColor(value);
      case 'salinidade':
        return _getSalinityColor(value);
      default:
        return Colors.black87;
    }
  }

  Widget _buildExpandableCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return CustomCard(
      padding: EdgeInsets
          .zero, // Remove o padding interno do card para o Tile ocupar tudo
      child: Theme(
        // Remove as linhas que o ExpansionTile coloca automaticamente
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          maintainState: true,
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          childrenPadding: const EdgeInsets.all(16),
          expandedAlignment: Alignment.topLeft,
          children: children,
        ),
      ),
    );
  }
}
