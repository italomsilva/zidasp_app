// lib/widgets/shared/status_indicator.dart
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class StatusIndicator extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final bool isCritical;
  final bool isWarning;
  
  const StatusIndicator({
    Key? key,
    required this.label,
    required this.value,
    required this.unit,
    this.isCritical = false,
    this.isWarning = false,
  }) : super(key: key);
  
  Color _getColor() {
    if (isCritical) return AppColors.shrimpAlert;
    if (isWarning) return AppColors.neutralYellow;
    return AppColors.healthGreen;
  }
  
  IconData _getIcon() {
    switch (label.toLowerCase()) {
      case 'o₂':
      case 'oxigênio':
        return Icons.water_drop;
      case 'temp':
      case 'temperatura':
        return Icons.thermostat;
      case 'sal':
      case 'salinidade':
        return Icons.water;
      case 'ph':
        return Icons.science;
      default:
        return Icons.monitor_heart;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final icon = _getIcon();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
        ],
      ),
    );
  }
}

// Versão alternativa simplificada
class SimpleStatusIndicator extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData? icon;
  
  const SimpleStatusIndicator({
    Key? key,
    required this.label,
    required this.value,
    required this.color,
    this.icon,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}