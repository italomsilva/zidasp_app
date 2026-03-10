// lib/widgets/shared/device_controller.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class DeviceController extends StatefulWidget {
  final String deviceName;
  final String deviceType;
  final bool isOn;
  final String? power;
  final String? status;
  final Function(bool)? onChanged;

  const DeviceController({
    Key? key,
    required this.deviceName,
    required this.deviceType,
    required this.isOn,
    this.power,
    this.status,
    this.onChanged,
  }) : super(key: key);

  @override
  _DeviceControllerState createState() => _DeviceControllerState();
}

class _DeviceControllerState extends State<DeviceController> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.isOn;
  }

  IconData _getDeviceIcon() {
    switch (widget.deviceType.toLowerCase()) {
      case 'aerador':
        return Icons.air;
      case 'bomba':
        return Icons.invert_colors;
      case 'alimentador':
        return Icons.fastfood;
      case 'sensor':
        return Icons.sensors;
      default:
        return Icons.device_hub;
    }
  }

  Color _getDeviceColor() {
    if (!_isOn) return Colors.grey;

    switch (widget.deviceType.toLowerCase()) {
      case 'aerador':
        return AppColors.shrimpAlert;
      case 'bomba':
        return AppColors.neutralBlue;
      case 'alimentador':
        return AppColors.healthGreen;
      case 'sensor':
        return AppColors.neutralYellow;
      default:
        return AppColors.shrimpAlert;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _getDeviceColor();
    final icon = _getDeviceIcon();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isOn ? color.withValues(alpha: .3) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _isOn
                ? color.withValues(alpha: .1)
                : Colors.black.withValues(alpha: .03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() => _isOn = !_isOn);
            widget.onChanged?.call(_isOn);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.deviceName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: isDark ? Colors.white : AppColors.lightText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.deviceType,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.neutralGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isOn,
                  onChanged: (value) {
                    setState(() => _isOn = value);
                    widget.onChanged?.call(value);
                  },
                  activeThumbColor: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
