import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/core/di.dart';
import 'package:zidasp_app/core/theme/app_theme.dart';
import 'package:zidasp_app/modules/pond/controllers/pond_detail_controller.dart';
import 'package:zidasp_app/modules/pond/widgets/device_controller.dart';
import 'package:zidasp_app/widgets/error/error_container.dart';
import '../widgets/pond_info_card.dart';
import '../widgets/sensor_ring_chart.dart';
import '../../../widgets/shared/section_header.dart';

class PondDetailPage extends StatefulWidget {
  final String pondId;
  final String pondName;

  const PondDetailPage({
    super.key,
    required this.pondId,
    required this.pondName,
  });

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
                  pinned: true,
                  elevation: 0,
                  centerTitle: false,
                  title: Text(
                    widget.pondName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.bar_chart_outlined, size: 24),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.history_outlined, size: 24),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),

                // Main Content
                Watch(
                  (context) => controller.pond.get().map(
                    error: (err) => SliverFillRemaining(
                      child: ErrorContainer(
                        errorMessage: err,
                        handleRefresh: controller.loadPondDetails,
                      ),
                    ),
                    loading: () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    data: (value) => SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          const SectionHeader(
                            title: 'Sensores',
                            icon: Icons.analytics_outlined,
                          ),
                          const SizedBox(height: 12),
                          Watch(
                            (context) => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.none,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                children: controller.sensors.map((sensor) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 24),
                                    child: SensorRingChart(
                                      sensor: sensor,
                                      size: 100,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          const SectionHeader(
                            title: 'Controle de Dispositivos',
                            icon: Icons.settings_remote_outlined,
                          ),
                          const SizedBox(height: 12),
                          Watch(
                            (context) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        '${controller.actuators.where((d) => d.active).length}/${controller.actuators.length} ON',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.shrimpAlert,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller.actuators.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 8),
                                    itemBuilder: (context, index) {
                                      final device =
                                          controller.actuators[index];
                                      return SizedBox(
                                        height: 56,
                                        child: DeviceController(
                                          deviceName: device.name,
                                          deviceType: device.type,
                                          isOn: device.active,
                                          onChanged: (value) {
                                            // Implement toggle logic via controller if needed
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          const SectionHeader(
                            title: 'Informações do Viveiro',
                            icon: Icons.info_outline,
                          ),
                          const SizedBox(height: 12),
                          PondInfoCard(
                            pondId: widget.pondId,
                            pondName: widget.pondName,
                            companyName: controller.companyName,
                          ),

                          const SizedBox(height: 40),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_showScrollToTop)
            Positioned(
              bottom: 20,
              right: 20,
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
        ],
      ),
    );
  }
}
