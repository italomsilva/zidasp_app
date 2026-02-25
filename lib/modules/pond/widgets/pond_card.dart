// lib/modules/pond/widgets/pond_card.dart
import 'package:flutter/material.dart';
import 'package:zidasp_app/widgets/shared/custom_card.dart';
import '../../../core/theme/app_theme.dart';
import '../dtos/pond_dto.dart';

class PondCard extends StatelessWidget {
  final PondDTO pond;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onRefresh;
  
  const PondCard({
    Key? key,
    required this.pond,
    required this.onTap,
    this.onFavoriteToggle,
    this.onRefresh,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(pond.id),
      direction: DismissDirection.horizontal,
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
            child: Icon(Icons.refresh, color: AppColors.shrimpAlert),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onFavoriteToggle?.call();
          return false;
        } else {
          onRefresh?.call();
          return false;
        }
      },
      child: GestureDetector(
        onTap: onTap,
        child: CustomCard(
          hasBorder: pond.hasAlert,
          borderColor: pond.hasAlert ? AppColors.shrimpAlert : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // IMPORTANTE: impede que a Column tente expandir
              children: [
                // Linha do título
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
                      const Icon(Icons.favorite, color: Colors.red, size: 20),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Status em linha (sem Expanded)
                Row(
                  children: [
                    _buildStatusIndicator(
                      context,
                      label: 'O₂',
                      value: pond.oxygen,
                      unit: 'mg/L',
                      color: pond.oxygen < 5.0 
                          ? AppColors.shrimpAlert 
                          : AppColors.healthGreen,
                    ),
                    const SizedBox(width: 8),
                    _buildStatusIndicator(
                      context,
                      label: 'Temp',
                      value: pond.temperature,
                      unit: '°C',
                      color: pond.temperature < 28 || pond.temperature > 32
                          ? AppColors.neutralYellow
                          : AppColors.healthGreen,
                    ),
                    const SizedBox(width: 8),
                    _buildStatusIndicator(
                      context,
                      label: 'Sal',
                      value: pond.salinity,
                      unit: 'ppt',
                      color: pond.salinity < 25 || pond.salinity > 35
                          ? AppColors.neutralYellow
                          : AppColors.healthGreen,
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Status dos dispositivos
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
      ),
    );
  }
  
  // Versão sem Expanded dentro do Row
  Widget _buildStatusIndicator(
    BuildContext context, {
    required String label,
    required double value,
    required String unit,
    required Color color,
  }) {
    return Container(
      width: 70, // Largura fixa em vez de Expanded
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 10)),
          Text(
            '${value.toStringAsFixed(1)}$unit',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
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
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'há ${diff.inHours} h';
    return 'há ${diff.inDays} dias';
  }
}