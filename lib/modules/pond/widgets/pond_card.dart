// lib/modules/pond/widgets/pond_card.dart
import 'package:flutter/material.dart';
import 'package:zidasp_app/widgets/shared/custom_card.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/dtos/pond_dto.dart';

class PondCard extends StatelessWidget {
  final PondDTO pond;
  final VoidCallback onTap;

  const PondCard({
    Key? key,
    required this.pond,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      hasBorder: pond.hasAlert,
      onTap: onTap,
      borderColor: pond.hasAlert ? AppColors.shrimpAlert.withAlpha(120) : null,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              pond.name,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                ...pond.sensors.map((sensor) {
                  final Color color = sensor.value < 15
                      ? AppColors.danger
                      : AppColors.healthGreen;
                  return Container(
                    width: 70, // Largura fixa em vez de Expanded
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(sensor.type.value, style: const TextStyle(fontSize: 10)),
                        Text(
                          '${sensor.value.toStringAsFixed(1)}${sensor.unity}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 12,
              children: [
                ...pond.actuators.map((actuator) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: actuator.active
                              ? AppColors.healthGreen
                              : AppColors.neutralGray,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${actuator.name}: ${actuator.active ? 'on' : 'off'}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                }),
              ],
            ),

            const SizedBox(height: 8),
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
