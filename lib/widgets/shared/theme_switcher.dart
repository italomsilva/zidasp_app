// lib/widgets/shared/theme_switcher.dart
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/theme/theme_controller.dart';
import '../../core/di.dart';

class ThemeSwitcher extends StatelessWidget {
  final bool showLabel;
  final double iconSize;
  
  const ThemeSwitcher({
    Key? key,
    this.showLabel = false,
    this.iconSize = 24,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final themeController = di.get<ThemeController>();
    
    return Watch(
      (context) {
        final isDark = themeController.isDarkMode.value;
        final themeName = themeController.themeName.value;
        
        return IconButton(
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                size: iconSize,
              ),
              if (showLabel) ...[
                const SizedBox(width: 4),
                Text(
                  isDark ? 'Claro' : 'Escuro',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
          onPressed: () {
            themeController.toggleTheme();
          },
          tooltip: 'Alternar tema ($themeName)',
        );
      },
    );
  }
}