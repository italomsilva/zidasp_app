// lib/modules/pond/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/core/di.dart';
import 'package:zidasp_app/core/theme/app_theme.dart';
import 'package:zidasp_app/modules/pond/controllers/dashboard_controller.dart';
import 'package:zidasp_app/modules/pond/pages/pond_detail/pond_detail_screen.dart';
import 'package:zidasp_app/modules/pond/widgets/pond_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final controller = inject<DashboardController>();
  final ScrollController _scrollController = ScrollController();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final List<Map<String, dynamic>> _companies = [
    {'id': '1', 'name': 'Camarão do Vale'},
    {'id': '2', 'name': 'Pescados Nordeste'},
    {'id': '3', 'name': 'AquaCultura Brasil'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPonds('1');
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    _refreshIndicatorKey.currentState?.show();

    if (controller.selectedCompanyId.value != null) {
      await controller.loadPonds(controller.selectedCompanyId.value!);
    } else {
      await controller.loadPonds('1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: AppColors.shrimpAlert,
        backgroundColor: Theme.of(context).cardColor,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar simplificada
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Viveiros',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
              ],
            ),

            // Dropdown de empresas
            SliverToBoxAdapter(child: _buildCompanyDropdown()),

            // Estatísticas minimalistas
            SliverToBoxAdapter(child: _buildStatsRow()),

            // Lista de viveiros
            Watch(
              (context) {
                // Loading inicial
                if (controller.isLoading.value && controller.ponds.value.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // Erro
                if (controller.error.value != null) {
                  return SliverFillRemaining(child: _buildErrorState());
                }

                // Lista vazia
                if (controller.filteredPonds.value.isEmpty) {
                  return SliverFillRemaining(child: _buildEmptyState());
                }

                // Loading ao trocar empresa (com barra de progresso no topo)
                if (controller.isSwitchingCompany.value) {
                  return SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const LinearProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.shrimpAlert),
                        ),
                        const SizedBox(height: 8),
                        _buildPondsList(), // Lista existente
                      ],
                    ),
                  );
                }

                // Lista normal
                return _buildPondsList();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPondsList() {
    final ponds = controller.filteredPonds.value;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final pond = ponds[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PondCard(
                pond: pond,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PondDetailPage(
                        pondId: pond.id,
                        pondName: pond.name,
                      ),
                    ),
                  );
                },
                onFavoriteToggle: () => controller.toggleFavorite(pond.id),
                onRefresh: () => _handleRefresh(),
              ),
            );
          },
          childCount: ponds.length,
        ),
      ),
    );
  }

  Widget _buildCompanyDropdown() {
    return Watch(
      (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.business, color: AppColors.shrimpAlert, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButton<String>(
                  value: controller.selectedCompanyId.value,
                  hint: Text(
                    'Selecionar empresa',
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  icon: Icon(Icons.arrow_drop_down, color: AppColors.shrimpAlert),
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: Theme.of(context).cardColor,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  items: _companies.map((company) {
                    return DropdownMenuItem<String>(
                      value: company['id'],
                      child: Text(company['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectCompany(value);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return Watch(
      (context) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                label: 'Total',
                value: '${controller.totalPonds.value}',
                color: AppColors.neutralBlue,
              ),
              Container(
                height: 20,
                width: 1,
                color: Colors.grey.withOpacity(0.3),
              ),
              _buildStatItem(
                label: 'Ativos',
                value: '${controller.activePonds.value}',
                color: AppColors.healthGreen,
              ),
              Container(
                height: 20,
                width: 1,
                color: Colors.grey.withOpacity(0.3),
              ),
              _buildStatItem(
                label: 'Alertas',
                value: '${controller.alertPonds.value}',
                color: AppColors.shrimpAlert,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.shrimpAlert.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              controller.error.value ?? 'Tente novamente mais tarde',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleRefresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.shrimpAlert,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Nenhum viveiro encontrado',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Selecione outra empresa ou adicione um novo viveiro',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}