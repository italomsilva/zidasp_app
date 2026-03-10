import 'package:flutter/material.dart';
import 'package:zidasp_app/core/dtos/sensor_dto.dart';
import 'package:zidasp_app/core/theme/app_theme.dart';

class SensorRingChart extends StatelessWidget {
  final SensorDTO sensor;
  final double size;

  const SensorRingChart({super.key, required this.sensor, this.size = 100});

  @override
  Widget build(BuildContext context) {
    final color = _getSensorColor(sensor.type);
    final percentage = _calculatePercentage(sensor.type, sensor.value);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 8,
                color: color.withValues(alpha: 0.1),
              ),
              CircularProgressIndicator(
                value: percentage,
                strokeWidth: 8,
                strokeCap: StrokeCap.round,
                color: color,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getSensorIcon(sensor.type),
                      color: color,
                      size: size * 0.2,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sensor.value.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: size * 0.18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.lightText,
                      ),
                    ),
                    Text(
                      sensor.unity,
                      style: TextStyle(
                        fontSize: size * 0.1,
                        color: AppColors.neutralGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          sensor.type,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.neutralGray,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  double _calculatePercentage(String type, double value) {
    // Definindo limites máximos razoáveis para a visualização do anel
    switch (type) {
      case 'Oxygen':
        return (value / 15.0).clamp(0.0, 1.0);
      case 'Temperature':
        return (value / 45.0).clamp(0.0, 1.0);
      case 'Salinity':
        return (value / 40.0).clamp(0.0, 1.0);
      case 'ph':
        return (value / 14.0).clamp(0.0, 1.0);
      default:
        return (value / 100.0).clamp(0.0, 1.0);
    }
  }

  IconData _getSensorIcon(String type) {
    switch (type) {
      case 'Oxygen':
        return Icons.water_drop_rounded;
      case 'Temperature':
        return Icons.thermostat_rounded;
      case 'Salinity':
        return Icons.waves_rounded;
      case 'ph':
        return Icons.science_rounded;
      default:
        return Icons.sensors_rounded;
    }
  }

  Color _getSensorColor(String type) {
    switch (type) {
      case 'Oxygen':
        return AppColors.neutralBlue;
      case 'Temperature':
        return AppColors.shrimpAlert;
      case 'Salinity':
        return AppColors.healthGreen;
      case 'ph':
        return AppColors.neutralYellow;
      default:
        return AppColors.neutralGray;
    }
  }
}
