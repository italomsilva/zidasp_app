// lib/shared/widgets/theme_switcher.dart
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/core/di.dart';
import '../../core/theme/theme_controller.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final themeController = inject<ThemeController>();
    
    return Watch(
      (context) {
        final isDark = themeController.isDarkMode.value;
        final themeName = themeController.themeName.value;
        
        return IconButton(
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          onPressed: themeController.toggleTheme,
          tooltip: 'Tema: $themeName',
        );
      },
    );
  }
}