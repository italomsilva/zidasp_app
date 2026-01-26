// lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zidasp_app/models/pond_model.dart';
import 'package:zidasp_app/providers/company_provider.dart';
import 'package:zidasp_app/theme/app_theme.dart';
import 'package:zidasp_app/widgets/shared/custom_card.dart';
import 'package:zidasp_app/widgets/shared/status_Indicator.dart';
import 'package:zidasp_app/screens/viveiro/viveiro_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _selectedCompanyId;
  
  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);
    
    return RefreshIndicator(
      onRefresh: () async {
        await companyProvider.loadData();
      },
      child: CustomScrollView(
        slivers: [
          // Cabeçalho com seleção de empresa
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildCompanySelector(companyProvider),
            ),
          ),
          
          // Lista de viveiros
          if (_selectedCompanyId != null)
            _buildPondsList(companyProvider)
          else
            const SliverFillRemaining(
              child: Center(
                child: Text('Selecione uma empresa para ver os viveiros'),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildCompanySelector(CompanyProvider provider) {
    final currentCompany = _selectedCompanyId != null 
        ? provider.getCompanyById(_selectedCompanyId!) 
        : null;
    
    return CustomCard(
      onTap: () {
        _showCompanySelectionDialog(provider);
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.shrimpAlert.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.business,
              color: AppColors.shrimpAlert,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentCompany?.name ?? 'Selecionar Empresa',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentCompany != null
                      ? '${currentCompany.totalPonds} viveiros • ${currentCompany.activePonds} ativos'
                      : 'Toque para selecionar',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_drop_down, size: 24),
        ],
      ),
    );
  }
  
  void _showCompanySelectionDialog(CompanyProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selecionar Empresa',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // Lista de empresas
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.userCompanies.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final company = provider.userCompanies[index];
                    return ListTile(
                      onTap: () {
                        setState(() {
                          _selectedCompanyId = company.id;
                        });
                        Navigator.pop(context);
                      },
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.shrimpAlert.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.business,
                          color: AppColors.shrimpAlert,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        company.name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        '${company.totalPonds} viveiros',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: _selectedCompanyId == company.id
                          ? Icon(
                              Icons.check_circle,
                              color: AppColors.shrimpAlert,
                            )
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: Theme.of(context).cardColor,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildPondsList(CompanyProvider provider) {
    final ponds = _selectedCompanyId != null
        ? provider.getPondsByCompany(_selectedCompanyId!)
        : [];
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final pond = ponds[index];
          return Padding(
            padding: EdgeInsets.fromLTRB(16, index == 0 ? 0 : 8, 16, 8),
            child: PondCard(pond: pond),
          );
        },
        childCount: ponds.length,
      ),
    );
  }
}

// Widget do Card do Viveiro
class PondCard extends StatelessWidget {
  final Pond pond;
  
  const PondCard({Key? key, required this.pond}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(pond.id),
      background: Container(
        decoration: BoxDecoration(
          color: AppColors.healthGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Icon(Icons.favorite, color: AppColors.healthGreen),
          ),
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: AppColors.shrimpAlert.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.notifications, color: AppColors.shrimpAlert),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Favoritar
          return true;
        } else {
          // Configurar alertas
          return true;
        }
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViveiroDetailScreen(pond: pond),
            ),
          );
        },
        child: CustomCard(
          hasBorder: pond.hasAlert,
          borderColor: pond.hasAlert ? AppColors.shrimpAlert : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      pond.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (pond.isFavorite)
                    const Icon(Icons.favorite, color: Colors.red, size: 16),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Status rápido
              Row(
                children: [
                  StatusIndicator(
                    label: 'O₂',
                    value: pond.oxygen,
                    unit: 'mg/L',
                    isCritical: pond.oxygen < 5.0,
                  ),
                  const SizedBox(width: 12),
                  StatusIndicator(
                    label: 'Temp',
                    value: pond.temperature,
                    unit: '°C',
                    isWarning: pond.temperature < 28 || pond.temperature > 32,
                  ),
                  const SizedBox(width: 12),
                  StatusIndicator(
                    label: 'Sal',
                    value: pond.salinity,
                    unit: 'ppt',
                    isWarning: pond.salinity < 25 || pond.salinity > 35,
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Dispositivos ativos
              Row(
                children: [
                  _buildDeviceStatus('Aeradores', pond.aeratorsOn, pond.aeratorsTotal),
                  const SizedBox(width: 16),
                  _buildDeviceStatus('Bombas', pond.pumpsOn, pond.pumpsTotal),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Última atualização
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Atualizado: ${_formatTimeAgo(pond.lastUpdate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDeviceStatus(String label, int active, int total) {
    final isAllActive = active == total;
    
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isAllActive ? AppColors.healthGreen : AppColors.neutralYellow,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: $active/$total',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
  
  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inMinutes < 1) return 'Agora';
    if (diff.inMinutes < 60) return 'Há ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Há ${diff.inHours} h';
    return 'Há ${diff.inDays} dias';
  }
}