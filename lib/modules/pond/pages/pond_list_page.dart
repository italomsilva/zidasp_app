import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/core/di.dart';
import 'package:zidasp_app/core/theme/app_theme.dart';
import 'package:zidasp_app/modules/pond/controllers/pond_list_controller.dart';
import 'package:zidasp_app/modules/pond/pages/pond_detail_page.dart';
import 'package:zidasp_app/modules/pond/widgets/company_dropdown.dart';
import 'package:zidasp_app/modules/pond/widgets/pond_card.dart';
import 'package:zidasp_app/widgets/error/error_container.dart';
import 'package:zidasp_app/widgets/shared/stats_count.dart';

class PondListPage extends StatefulWidget {
  const PondListPage({Key? key}) : super(key: key);

  @override
  State<PondListPage> createState() => _PondListPageState();
}

class _PondListPageState extends State<PondListPage> {
  late final controller = inject<PondListController>();
  final ScrollController _scrollController = ScrollController();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await controller.initialize();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    _refreshIndicatorKey.currentState?.show();
    await controller.loadPonds();
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
            SliverToBoxAdapter(
              child: CompanyDropdown(
                companies: controller.companies,
                selectedCompanyId: controller.selectedCompanyId,
                selectCompany: controller.selectCompany,
              ),
            ),
            SliverToBoxAdapter(
              child: StatsCount(
                statsItems: [
                  StatItem(
                    label: 'Total',
                    value: controller.totalPonds,
                    color: AppColors.neutralBlue,
                  ),
                  StatItem(
                    label: 'Ativos',
                    value: controller.activePonds,
                    color: AppColors.healthGreen,
                  ),
                  StatItem(
                    label: 'Alertas',
                    value: controller.alertPonds,
                    color: AppColors.shrimpAlert,
                  ),
                ],
              ),
            ),

            Watch((context) {
              return controller.ponds.get().map(
                // erro 
                error: (error) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: ErrorContainer(
                      errorMessage: error.toString(),
                      handleRefresh: _handleRefresh,
                    ),
                  ),
                ),
                // loading
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
                data: (pondlist) {
                  //lista vazia
                  if (pondlist.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum viveiro encontrado',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Selecione outra empresa ou adicione um novo viveiro',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  // lista
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final pond = pondlist[index];
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
                          ),
                        );
                      }, childCount: pondlist.length),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
