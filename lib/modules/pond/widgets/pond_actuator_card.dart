import 'package:flutter/material.dart';
import 'package:zidasp_app/core/dtos/actuator_dto.dart';
import 'package:zidasp_app/core/theme/app_theme.dart';
import 'package:zidasp_app/modules/pond/widgets/device_controller.dart';


class PondDeviceGroup extends StatelessWidget {
  final String title;
  final List<ActuatorDTO> devices;
  final Color accentColor;

  const PondDeviceGroup({
    super.key,
    required this.title,
    required this.devices,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                '${devices.where((d) => d.active).length}/${devices.length} ON',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: devices.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final device = devices[index];
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
    );
  }
}
