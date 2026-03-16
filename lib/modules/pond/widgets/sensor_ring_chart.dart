import 'package:flutter/material.dart';
import 'package:zidasp_app/core/dtos/sensor_dto.dart';
import 'package:zidasp_app/core/enums/sensor_type.dart';
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
          sensor.type.value,
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

  double _calculatePercentage(SensorType type, double value) {
    switch (type) {
      case SensorType.oxygen:
        return (value / 15.0).clamp(0.0, 1.0);
      case SensorType.temperature:
        return (value / 45.0).clamp(0.0, 1.0);
      case SensorType.salinity:
        return (value / 40.0).clamp(0.0, 1.0);
      case SensorType.ph:
        return (value / 14.0).clamp(0.0, 1.0);
      case SensorType.transparency:
        return (value / 2.0).clamp(0.0, 1.0);
    }
  }

  IconData _getSensorIcon(SensorType type) {
    switch (type) {
      case SensorType.oxygen:
        return Icons.water_drop_rounded;
      case SensorType.temperature:
        return Icons.thermostat_rounded;
      case SensorType.salinity:
        return Icons.waves_rounded;
      case SensorType.ph:
        return Icons.science_rounded;
      case SensorType.transparency:
        return Icons.visibility_rounded;
    }
  }

  Color _getSensorColor(SensorType type) {
    switch (type) {
      case SensorType.oxygen:
        return AppColors.neutralBlue;
      case SensorType.temperature:
        return AppColors.shrimpAlert;
      case SensorType.salinity:
        return AppColors.healthGreen;
      case SensorType.ph:
        return AppColors.neutralYellow;
      case SensorType.transparency:
        return AppColors.neutralGray;
    }
  }
}
