import 'package:flutter/material.dart';
import 'package:zidasp_app/theme/app_theme.dart';
import 'package:zidasp_app/widgets/shared/custom_card.dart';
import 'package:zidasp_app/widgets/shared/staus_badge.dart';

class PondCard extends StatelessWidget {
  final String pondName;
  final String oxygen;
  final String salinity;
  final String temperature;
  final bool hasAlert;
  final int aeratorsOn;
  final int aeratorsTotal;
  final DateTime lastUpdate;
  
  const PondCard({
    Key? key,
    required this.pondName,
    required this.oxygen,
    required this.salinity,
    required this.temperature,
    required this.hasAlert,
    required this.aeratorsOn,
    required this.aeratorsTotal,
    required this.lastUpdate,
  }) : super(key: key);
  
  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Agora mesmo';
    } else if (difference.inMinutes < 60) {
      return 'Há ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Há ${difference.inHours} h';
    } else {
      return 'Há ${difference.inDays} dias';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      hasBorder: hasAlert,
      borderColor: AppColors.shrimpAlert,
      onTap: () {
        // Navegar para detalhes do viveiro
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  pondName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasAlert)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.shrimpAlert.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 14,
                        color: AppColors.shrimpAlert,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Baixo O₂',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.shrimpAlert,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Atualizado: ${_formatTimeAgo(lastUpdate)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusBadge(
                label: 'Oxigênio',
                value: oxygen,
                unit: 'mg/L',
                color: _getOxygenColor(),
                icon: Icons.water_drop,
              ),
              StatusBadge(
                label: 'Salinidade',
                value: salinity,
                unit: 'ppt',
                color: _getSalinityColor(),
                icon: Icons.water, // Ícone alternativo
              ),
              StatusBadge(
                label: 'Temperatura',
                value: temperature,
                unit: '°C',
                color: _getTemperatureColor(),
                icon: Icons.thermostat,
              ),
            ],
          ),
          const Spacer(),
          Divider(color: Theme.of(context).dividerColor.withOpacity(0.3)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aeradores',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '$aeratorsOn/$aeratorsTotal ON',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: aeratorsOn == aeratorsTotal 
                          ? AppColors.healthGreen 
                          : AppColors.neutralYellow,
                    ),
                  ),
                ],
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: aeratorsOn == aeratorsTotal 
                      ? AppColors.healthGreen 
                      : AppColors.neutralYellow,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Color _getOxygenColor() {
    final level = double.tryParse(oxygen) ?? 0;
    if (level < 5.0) return AppColors.shrimpAlert;
    return AppColors.healthGreen;
  }
  
  Color _getSalinityColor() {
    final level = double.tryParse(salinity) ?? 0;
    if (level < 25 || level > 35) return AppColors.neutralYellow;
    return AppColors.healthGreen;
  }
  
  Color _getTemperatureColor() {
    final level = double.tryParse(temperature) ?? 0;
    if (level < 28 || level > 32) return AppColors.neutralYellow;
    return AppColors.healthGreen;
  }
}