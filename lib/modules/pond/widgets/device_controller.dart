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
    final color = _getDeviceColor();
    final icon = _getDeviceIcon();
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const Spacer(),
                _buildToggleSwitch(color),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              widget.deviceName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 4),
            
            Text(
              widget.deviceType,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            
            if (widget.power != null || widget.status != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  if (widget.power != null)
                    _buildInfoChip(
                      Icons.flash_on,
                      widget.power!,
                      color,
                    ),
                  if (widget.status != null) ...[
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      _isOn ? Icons.check_circle : Icons.error,
                      widget.status!,
                      _isOn ? AppColors.healthGreen : AppColors.shrimpAlert,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildToggleSwitch(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isOn = !_isOn;
        });
        widget.onChanged?.call(_isOn);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _isOn 
              ? color.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
          border: Border.all(
            color: _isOn ? color : Colors.grey,
            width: 2,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isOn ? color : Colors.grey,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Versão compacta para listas
class CompactDeviceController extends StatelessWidget {
  final String deviceName;
  final bool isOn;
  final Function(bool)? onChanged;
  
  const CompactDeviceController({
    Key? key,
    required this.deviceName,
    required this.isOn,
    this.onChanged,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOn 
              ? AppColors.shrimpAlert.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              Icons.power_settings_new,
              size: 16,
              color: isOn ? AppColors.shrimpAlert : Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                deviceName,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Switch(
              value: isOn,
              onChanged: onChanged,
              activeColor: AppColors.shrimpAlert,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}